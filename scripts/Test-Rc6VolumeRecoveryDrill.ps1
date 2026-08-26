[CmdletBinding()]
param(
    [string] $ToolImage = 'mcr.microsoft.com/dotnet/sdk@sha256:ea8bde36c11b6e7eec2656d0e59101d4462f6bd630730f2c8201ed0572b295d5'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceVolume = 'deep-rc6-selftest-' + [Guid]::NewGuid().ToString('N')
$writerContainer = 'deep-rc6-selftest-writer-' + [Guid]::NewGuid().ToString('N')
$temporaryBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$temporaryRoot = Join-Path $temporaryBase ('deep-rc6-drill-' + [Guid]::NewGuid().ToString('N'))
$backupRoot = Join-Path $temporaryRoot 'backup'
$evidenceFile = Join-Path $temporaryRoot 'evidence.json'
$sourceVolumeCreated = $false
$writerContainerCreated = $false

try {
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    & docker volume create --label deep.rc6.selftest=true $sourceVolume 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw 'Disposable recovery drill failed: source-volume-create.'
    }
    $sourceVolumeCreated = $true

    & docker run --rm --network none --cap-drop ALL --security-opt no-new-privileges:true `
        --mount "type=volume,src=$sourceVolume,dst=/data" `
        $ToolImage sh -ec "set -eu; mkdir -p /data/state/nested /data/empty; printf 'registry-state-v2' >/data/state/registry.bin; printf 'pending-call-signal' >/data/state/nested/calls-v2.bin; chmod 640 /data/state/registry.bin; ln -s state/registry.bin /data/current" `
        2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw 'Disposable recovery drill failed: seed.'
    }

    & docker run -d --name $writerContainer --network none --read-only `
        --cap-drop ALL --security-opt no-new-privileges:true `
        --mount "type=volume,src=$sourceVolume,dst=/data" `
        $ToolImage sh -ec 'sleep 120' 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw 'Disposable recovery drill failed: writer-start.'
    }
    $writerContainerCreated = $true

    $writerWasRejected = $false
    try {
        & (Join-Path $PSScriptRoot 'Invoke-Rc6VolumeRecoveryDrill.ps1') `
            -SourceVolume $sourceVolume `
            -BackupDirectory $backupRoot `
            -ToolImage $ToolImage `
            -EvidencePath $evidenceFile | Out-Null
    }
    catch {
        $writerWasRejected = $_.Exception.Message -eq 'RC6 recovery drill failed: source-volume-has-running-writers.'
    }
    if (-not $writerWasRejected) {
        throw 'Disposable recovery drill failed: live-writer-was-not-rejected.'
    }

    & docker rm --force $writerContainer 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw 'Disposable recovery drill failed: writer-cleanup.'
    }
    $writerContainerCreated = $false

    & (Join-Path $PSScriptRoot 'Invoke-Rc6VolumeRecoveryDrill.ps1') `
        -SourceVolume $sourceVolume `
        -BackupDirectory $backupRoot `
        -ToolImage $ToolImage `
        -EvidencePath $evidenceFile | Out-Null

    $evidence = Get-Content -Raw -Encoding UTF8 $evidenceFile | ConvertFrom-Json
    if ($evidence.status -ne 'passed' -or
        $evidence.scope -ne 'volume-snapshot-restore-only' -or
        $evidence.applicationContourValidated -ne $false -or
        $evidence.releaseDrillComplete -ne $false -or
        -not $evidence.state.exactMatch) {
        throw 'Disposable recovery drill failed: evidence-result.'
    }

    $properties = @($evidence.psobject.Properties.Name) +
        @($evidence.snapshot.psobject.Properties.Name) +
        @($evidence.state.psobject.Properties.Name)
    foreach ($forbidden in @('path', 'volume', 'container', 'project', 'hostname', 'identifier', 'stdout', 'stderr')) {
        if (($properties -join '|') -match $forbidden) {
            throw 'Disposable recovery drill failed: evidence-schema.'
        }
    }

    Write-Output 'Disposable RC-6 volume snapshot/restore self-test passed; this does not claim application-contour or release-drill completion.'
}
finally {
    if ($writerContainerCreated) {
        if ($writerContainer -notmatch '^deep-rc6-selftest-writer-[0-9a-f]{32}$') {
            throw 'Refusing to remove an unexpected self-test container.'
        }

        & docker rm --force $writerContainer 2>$null | Out-Null
    }

    if ($sourceVolumeCreated) {
        if ($sourceVolume -notmatch '^deep-rc6-selftest-[0-9a-f]{32}$') {
            throw 'Refusing to remove an unexpected self-test volume.'
        }

        & docker volume rm $sourceVolume 2>$null | Out-Null
    }

    $resolvedTemporaryRoot = [IO.Path]::GetFullPath($temporaryRoot)
    $expectedPrefix = $temporaryBase.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar + 'deep-rc6-drill-'
    if ((Test-Path -LiteralPath $resolvedTemporaryRoot) -and
        $resolvedTemporaryRoot.StartsWith($expectedPrefix, [StringComparison]::OrdinalIgnoreCase) -and
        (Split-Path -Leaf $resolvedTemporaryRoot) -match '^deep-rc6-drill-[0-9a-f]{32}$') {
        Remove-Item -LiteralPath $resolvedTemporaryRoot -Recurse -Force
    }
}
