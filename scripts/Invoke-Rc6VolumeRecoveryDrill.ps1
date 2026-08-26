[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9_.-]{0,127}$')]
    [string] $SourceVolume,

    [Parameter(Mandatory = $true)]
    [string] $BackupDirectory,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[^\s@]+@sha256:[0-9a-f]{64}$')]
    [string] $ToolImage,

    [Parameter(Mandatory = $true)]
    [string] $EvidencePath,

    [switch] $KeepRestoredVolume
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$backupRoot = [IO.Path]::GetFullPath($BackupDirectory)
$evidenceFile = [IO.Path]::GetFullPath($EvidencePath)
$restoreVolume = 'deep-rc6-restore-' + [Guid]::NewGuid().ToString('N')
$archiveLeaf = 'state-snapshot-' + [DateTimeOffset]::UtcNow.ToString('yyyyMMddTHHmmssZ') + '-' + [Guid]::NewGuid().ToString('N') + '.tar'
$archivePath = Join-Path $backupRoot $archiveLeaf
$restoreVolumeCreated = $false

function Test-IsWithinRepository([string] $Candidate) {
    $rootWithSeparator = $repositoryRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    $candidateWithSeparator = [IO.Path]::GetFullPath($Candidate).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    return $candidateWithSeparator.StartsWith($rootWithSeparator, [StringComparison]::OrdinalIgnoreCase)
}

function Invoke-Docker([string[]] $Arguments, [string] $FailureCode) {
    $output = @(& docker @Arguments 2>$null)
    if ($LASTEXITCODE -ne 0) {
        throw "RC6 recovery drill failed: $FailureCode."
    }

    return ($output -join "`n").Trim()
}

function Get-VolumeManifest([string] $VolumeName, [string] $MountTarget) {
    $command = @'
set -eu
cd /data
find . -xdev -mindepth 1 -printf '%P\0' \
  | LC_ALL=C sort -z \
  | tar --format=gnu --mtime=@0 --owner=0 --group=0 --numeric-owner --null --verbatim-files-from --no-recursion -cpf - --files-from=- \
  | sha256sum \
  | cut -d ' ' -f 1
'@
    $result = Invoke-Docker -Arguments @(
        'run', '--rm',
        '--network', 'none',
        '--read-only',
        '--cap-drop', 'ALL',
        '--security-opt', 'no-new-privileges:true',
        '--mount', "type=volume,src=$VolumeName,dst=/data,$MountTarget",
        $ToolImage,
        'sh', '-ec', $command
    ) -FailureCode 'content-manifest'

    if ($result -notmatch '^[0-9a-f]{64}$') {
        throw 'RC6 recovery drill failed: invalid-content-manifest.'
    }

    return $result
}

if (-not [IO.Path]::IsPathRooted($BackupDirectory) -or -not [IO.Path]::IsPathRooted($EvidencePath)) {
    throw 'BackupDirectory and EvidencePath must be absolute.'
}

if ($backupRoot.Contains(',')) {
    throw 'BackupDirectory cannot contain a comma because Docker mount syntax would be ambiguous.'
}

if (Test-IsWithinRepository $backupRoot) {
    throw 'BackupDirectory must be outside the source repository.'
}

if ([StringComparer]::OrdinalIgnoreCase.Equals($archivePath, $evidenceFile)) {
    throw 'EvidencePath must not refer to backup material.'
}

$backupPrefix = $backupRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
if ($evidenceFile.StartsWith($backupPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'EvidencePath must be outside BackupDirectory.'
}

New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
New-Item -ItemType Directory -Path (Split-Path -Parent $evidenceFile) -Force | Out-Null

try {
    Invoke-Docker -Arguments @('version', '--format', '{{.Server.Version}}') -FailureCode 'docker-unavailable' | Out-Null
    Invoke-Docker -Arguments @('volume', 'inspect', $SourceVolume, '--format', '{{.Name}}') -FailureCode 'source-volume-missing' | Out-Null

    $runningMounts = Invoke-Docker -Arguments @('ps', '--quiet', '--filter', "volume=$SourceVolume") -FailureCode 'volume-use-check'
    if (-not [string]::IsNullOrWhiteSpace($runningMounts)) {
        throw 'RC6 recovery drill failed: source-volume-has-running-writers.'
    }

    Invoke-Docker -Arguments @(
        'run', '--rm', '--network', 'none', '--read-only',
        '--cap-drop', 'ALL', '--security-opt', 'no-new-privileges:true',
        $ToolImage, 'sh', '-ec', "tar --version | grep -q '^tar (GNU tar)'"
    ) -FailureCode 'tool-image-must-provide-gnu-tar' | Out-Null

    $snapshotCommand = "set -eu; cd /source; tar --acls --xattrs --selinux --numeric-owner -cpf /backup/$archiveLeaf ."
    Invoke-Docker -Arguments @(
        'run', '--rm', '--network', 'none',
        '--cap-drop', 'ALL', '--security-opt', 'no-new-privileges:true',
        '--mount', "type=volume,src=$SourceVolume,dst=/source,readonly",
        '--mount', "type=bind,src=$backupRoot,dst=/backup",
        $ToolImage, 'sh', '-ec', $snapshotCommand
    ) -FailureCode 'snapshot-create' | Out-Null

    if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) {
        throw 'RC6 recovery drill failed: snapshot-not-published.'
    }

    Invoke-Docker -Arguments @(
        'volume', 'create',
        '--label', 'deep.rc6.recovery-drill=true',
        $restoreVolume
    ) -FailureCode 'restore-volume-create' | Out-Null
    $restoreVolumeCreated = $true

    $restoreCommand = "set -eu; cd /restore; tar --acls --xattrs --selinux --numeric-owner -xpf /backup/$archiveLeaf"
    Invoke-Docker -Arguments @(
        'run', '--rm', '--network', 'none',
        '--cap-drop', 'ALL', '--security-opt', 'no-new-privileges:true',
        '--mount', "type=volume,src=$restoreVolume,dst=/restore",
        '--mount', "type=bind,src=$backupRoot,dst=/backup,readonly",
        $ToolImage, 'sh', '-ec', $restoreCommand
    ) -FailureCode 'snapshot-restore' | Out-Null

    $compareCommand = "set -eu; cd /restore; tar --acls --xattrs --selinux --numeric-owner -dpf /backup/$archiveLeaf"
    Invoke-Docker -Arguments @(
        'run', '--rm', '--network', 'none', '--read-only',
        '--cap-drop', 'ALL', '--security-opt', 'no-new-privileges:true',
        '--mount', "type=volume,src=$restoreVolume,dst=/restore,readonly",
        '--mount', "type=bind,src=$backupRoot,dst=/backup,readonly",
        $ToolImage, 'sh', '-ec', $compareCommand
    ) -FailureCode 'snapshot-metadata-compare' | Out-Null

    $sourceManifest = Get-VolumeManifest -VolumeName $SourceVolume -MountTarget 'readonly'
    $restoredManifest = Get-VolumeManifest -VolumeName $restoreVolume -MountTarget 'readonly'
    if (-not [StringComparer]::Ordinal.Equals($sourceManifest, $restoredManifest)) {
        throw 'RC6 recovery drill failed: restored-state-mismatch.'
    }

    $archiveInfo = Get-Item -LiteralPath $archivePath
    $archiveSha256 = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
    $toolImageDigest = $ToolImage.Substring($ToolImage.LastIndexOf('@sha256:', [StringComparison]::Ordinal) + 8)
    $evidence = [ordered]@{
        schemaVersion = 'deep.rc6.volume-recovery.evidence.v1'
        status = 'passed'
        scope = 'volume-snapshot-restore-only'
        applicationContourValidated = $false
        releaseDrillComplete = $false
        generatedAtUtc = [DateTimeOffset]::UtcNow.ToString('O')
        snapshot = [ordered]@{
            byteLength = [long] $archiveInfo.Length
            sha256 = $archiveSha256
        }
        state = [ordered]@{
            sourceManifestSha256 = $sourceManifest
            restoredManifestSha256 = $restoredManifest
            exactMatch = $true
        }
        toolImageSha256 = $toolImageDigest
        runningWritersObserved = 0
        isolatedRestoreRetained = [bool] $KeepRestoredVolume
    }

    [IO.File]::WriteAllText(
        $evidenceFile,
        ($evidence | ConvertTo-Json -Depth 5) + "`n",
        [Text.UTF8Encoding]::new($false))

    Write-Output 'RC-6 volume snapshot/restore stage passed. The release drill remains incomplete until the retained volume boots in the isolated recovery contour and all application probes pass.'
}
finally {
    if ($restoreVolumeCreated -and -not $KeepRestoredVolume) {
        if (-not $restoreVolume.StartsWith('deep-rc6-restore-', [StringComparison]::Ordinal)) {
            throw 'Refusing to remove an unexpected Docker volume.'
        }

        Invoke-Docker -Arguments @('volume', 'rm', $restoreVolume) -FailureCode 'restore-volume-cleanup' | Out-Null
    }
}
