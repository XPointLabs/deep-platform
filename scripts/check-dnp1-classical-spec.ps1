[CmdletBinding()]
param(
    [ValidateSet('ClassificationOnly','ProtocolPackageGO','CutoverFinalReleaseGO')]
    [string]$RequiredEvidenceClaim = 'ClassificationOnly'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$specRoot = Join-Path $repoRoot 'docs\survival-program\releases\v3.0.0\specs'
$specPath = Join-Path $specRoot 'DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md'
$registryPath = Join-Path $specRoot 'dnp1-classical-v1.registry.json'
$registrySchemaPath = Join-Path $specRoot 'dnp1-classical-v1.registry.schema.json'
$vectorSchemaPath = Join-Path $specRoot 'dnp1-classical-v1.vectors.schema.json'
$vectorPath = Join-Path $specRoot 'dnp1-classical-v1.vectors.skeleton.json'
$ownershipPath = Join-Path $specRoot 'dnp1-classical-v1.evidence-ownership.json'
$ownershipSchemaPath = Join-Path $specRoot 'dnp1-classical-v1.evidence-ownership.schema.json'
$evidenceSchemaPath = Join-Path $specRoot 'dnp1-classical-v1.evidence-manifest.schema.json'
$attestationSchemaPath = Join-Path $specRoot 'dnp1-classical-v1.evidence-attestation.schema.json'
$programManifestPath = Join-Path $specRoot '..\program-manifest.json'

function Fail([string]$Message) {
    throw "DNP1 classical specification check failed: $Message"
}

foreach ($path in @($specPath, $registryPath, $registrySchemaPath, $vectorSchemaPath, $vectorPath, $ownershipPath, $ownershipSchemaPath, $evidenceSchemaPath, $attestationSchemaPath, $programManifestPath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Fail "missing artifact: $path" }
}

$spec = Get-Content -LiteralPath $specPath -Raw -Encoding UTF8
$registry = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
$registrySchema = Get-Content -LiteralPath $registrySchemaPath -Raw -Encoding UTF8 | ConvertFrom-Json
$vectorSchema = Get-Content -LiteralPath $vectorSchemaPath -Raw -Encoding UTF8 | ConvertFrom-Json
$vectors = Get-Content -LiteralPath $vectorPath -Raw -Encoding UTF8 | ConvertFrom-Json
$ownership = Get-Content -LiteralPath $ownershipPath -Raw -Encoding UTF8 | ConvertFrom-Json
$ownershipSchema = Get-Content -LiteralPath $ownershipSchemaPath -Raw -Encoding UTF8 | ConvertFrom-Json
$evidenceSchema = Get-Content -LiteralPath $evidenceSchemaPath -Raw -Encoding UTF8 | ConvertFrom-Json
$attestationSchema = Get-Content -LiteralPath $attestationSchemaPath -Raw -Encoding UTF8 | ConvertFrom-Json
$programManifest = Get-Content -LiteralPath $programManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json

if ($spec -notmatch '`DRM1`, `DRM2`, `DRM3`, `DRM4`, `DRM5`, `DRM6`, `DRM7`, `DRM8`, `DRM9`, `DRM10`, `DRM11`, `DRM12`, `DRM13`, `DRM14`, `DRM15`, `DRM16`, `DRM17`, `DRM18` and `DRM19` reject' -or
    $spec -notmatch 'structurally preflights DRM20, rejects DRM1/DRM2/DRM3/DRM4/DRM5/DRM6/DRM7/DRM8/DRM9/DRM10/DRM11/DRM12/DRM13/DRM14/DRM15/DRM16/DRM17/DRM18/DRM19' -or
    $spec -notmatch 'magic\[0\.\.4\)="DRMV"`, `wireVersion\[4\]=20' -or
    $spec -notmatch 'DRM2, DRM3, DRM4, DRM5, DRM6, DRM7, DRM8, DRM9, DRM10, DRM11, DRM12, DRM13, DRM14, DRM15, DRM16, DRM17, DRM18 and DRM19 are rejected and never reinterpreted' -or
    $spec -match 'structurally preflights DRM20, rejects DRM1/DRM2/DRM3,') {
    Fail 'DRM20 predecessor-version rejection prose drifted'
}
if ($spec -notmatch 'twenty-six immutable compile-time lines' -or
    $spec -notmatch 'exact payload is 72345 bytes' -or
    $spec -notmatch '0728ac6fd910831c935077012a9a90284f343ae8e3642ebced7072a45debac11' -or
    $spec -notmatch 'table, order, domain or cap change requires DRM21' -or
    $spec -match 'twenty-five immutable compile-time lines|66810 bytes|5b4078e8519e7b8dfa1371acd77615515fb791c905f479ea28b7872dc7cc1f1a|table, order, domain or cap change requires DRM20') {
    Fail 'DRM20 schema profile prose mirror drifted'
}
if ($spec -notmatch '`network16`, `manifestGeneration8`, `environmentResetId32`, `activationAt8`\s*and `componentMask8` each fixed-time equal their signed RRM counterpart' -or
    $spec -notmatch 'bootstrap transcript.*exact166' -or
    $spec -notmatch 'stable environment index.*derived only from that one verified\s*common RRM/DGO tuple' -or
    $spec -notmatch 'GMD1` is exact447.*branchKind1@8,\s*branchHash32@9, authorSetHash32@41' -or
    $spec -notmatch 'bootstrapSubject32.*fixed-time equals\s*`deploymentGovernanceBootstrapHash32`.*sourced only from the sealed\s*governance context' -or
    $spec -notmatch 'Signed GDI `branchKind` and `branchHash`, GMD `branchKind` and `branchHash`, and\s*the verified branch transcript are fixed-time byte-equal; the author-set\s*`branchKind` is the same GDI kind' -or
    $spec -notmatch 'GMD branchKind and branchHash equal the corresponding closed First197,\s*Same203 or Reset65 transcript kind and hash\.\s*GMD accountGeneration, accountHash, resetId, resetGeneration, DCMRef,\s*predecessorDCMRef and governanceHash equal the fields parsed from the frozen\s*signed DCM and verified branch' -or
    $spec -notmatch 'governance context is the sole source of the exact four DGO schema rows,\s*DGO `activationAt8` and `deploymentGovernanceBootstrapHash32`' -or
    $spec -match 'accepts only sealed current\s*DPA.*verified governed `ComponentSchemaSet`.*activation/creation times|immutable consumer deployment-authority fact|deploymentBootstrapSubject32') {
    Fail 'DRM20 DGO/GMD/authoring prose cross-mirror drifted'
}

$specPrefix = [regex]::Match($spec, 'magic\[0\.\.4\)="DRMV"`, `wireVersion\[4\]=(?<wire>[0-9]+)`, `componentProfile\[5\]=(?<profile>[0-9]+)`')
$registryPrefix = [regex]::Match([string]$registry.recovery.drmHeader, '^DRMV\[0\.\.4\]\|wire-version(?<wire>[0-9]+)@4\|component-profile(?<profile>[0-9]+)@5')
$profilePrefix = [regex]::Match([string]@($registry.recovery.schemaProfileSourceLines)[0], '^PROFILE\|DRM(?<drm>[0-9]+)\|magic=DRMV\|wireVersion=(?<wire>[0-9]+)\|componentProfile=(?<profile>[0-9]+)\|')
$ownershipVersionRows = @($ownership.rows | Where-Object { $_.id -eq 'recovery-drmv-version-pair-preflight' })
$ownershipPrefix = if ($ownershipVersionRows.Count -eq 1) { [regex]::Match([string]$ownershipVersionRows[0].reasonApiSeam, 'DRMV/version(?<wire>[0-9]+)/profile(?<profile>[0-9]+)/pin274') } else { [regex]::Match('', 'x') }
if (-not $specPrefix.Success -or -not $registryPrefix.Success -or -not $profilePrefix.Success -or -not $ownershipPrefix.Success -or
    $specPrefix.Groups['wire'].Value -ne $registryPrefix.Groups['wire'].Value -or
    $specPrefix.Groups['wire'].Value -ne $profilePrefix.Groups['wire'].Value -or
    $specPrefix.Groups['profile'].Value -ne $registryPrefix.Groups['profile'].Value -or
    $specPrefix.Groups['profile'].Value -ne $profilePrefix.Groups['profile'].Value -or
    $ownershipPrefix.Groups['wire'].Value -ne $profilePrefix.Groups['wire'].Value -or
    $ownershipPrefix.Groups['profile'].Value -ne $profilePrefix.Groups['profile'].Value -or
    $profilePrefix.Groups['drm'].Value -ne $profilePrefix.Groups['wire'].Value -or
    $profilePrefix.Groups['wire'].Value -ne '20' -or $profilePrefix.Groups['profile'].Value -ne '1') {
    Fail 'DRMV prose, registry header, schema profile and evidence ownership version tuple differ'
}
if ($spec -notmatch 'Its exact 122-byte scope is\s*`network16\|resetId32\|componentKind2\|componentSubject32\|accountGeneration8\|`\s*`reservationHash32`' -or
    $spec -match 'exact 130-byte scope') {
    Fail 'GenesisTransactionScope prose size or field arithmetic drifted'
}

function Assert-ExactProperties($Object, [string[]]$Required, [string[]]$Allowed, [string]$Name) {
    $names = @($Object.PSObject.Properties | ForEach-Object { [string]$_.Name })
    foreach ($requiredName in $Required) {
        if ($names -notcontains $requiredName) { Fail "$Name missing required property $requiredName" }
    }
    foreach ($name in $names) {
        if ($Allowed -notcontains $name) { Fail "$Name contains unknown property $name" }
    }
}

function Test-EvidenceOwnershipDocument($Document, [string[]]$VectorIds) {
    try {
        $top = @('$schema','schemaVersion','status','decision','workPackage','normativeCommit','normativeVectorSkeletonSha256','sourceSnapshot','sourceAudit','ownerEnum','gateEnum','rows')
        $actual = @($Document.PSObject.Properties | ForEach-Object { [string]$_.Name })
        if (($actual -join '|') -ne ($top -join '|') -or $Document.rows -isnot [System.Array]) { return $false }
        $owners = @('Protocol','Registry','XNode','Shared','DevOpsWitness','CrossRepoE2E','MAUI')
        $gates = @('ProtocolPackageBlocking','CutoverFinalRelease')
        if ((@($Document.ownerEnum) -join '|') -ne ($owners -join '|') -or
            (@($Document.gateEnum) -join '|') -ne ($gates -join '|') -or @($Document.rows).Count -ne 314) { return $false }
        $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
        foreach ($row in @($Document.rows)) {
            $rowNames = @($row.PSObject.Properties | ForEach-Object { [string]$_.Name })
            if (($rowNames -join '|') -ne 'id|executableOwner|reasonApiSeam|gate' -or
                $row.id -isnot [string] -or $row.executableOwner -isnot [string] -or
                $row.reasonApiSeam -isnot [string] -or $row.gate -isnot [string] -or
                [string]$row.id -notmatch '^[a-z0-9-]+$' -or
                ([string]$row.reasonApiSeam).Length -lt 32 -or ([string]$row.reasonApiSeam).Length -gt 256 -or
                $owners -notcontains [string]$row.executableOwner -or $gates -notcontains [string]$row.gate -or
                -not $seen.Add([string]$row.id)) { return $false }
            if ($row.gate -eq 'ProtocolPackageBlocking' -and @('Protocol','DevOpsWitness') -notcontains [string]$row.executableOwner) { return $false }
            if ($row.gate -eq 'CutoverFinalRelease' -and @('Registry','XNode','Shared','DevOpsWitness','CrossRepoE2E','MAUI') -notcontains [string]$row.executableOwner) { return $false }
        }
        return ((@($seen | Sort-Object) -join '|') -eq (@($VectorIds | Sort-Object) -join '|'))
    }
    catch { return $false }
}

function Test-EvidenceGateSatisfied([string]$Claim, $Rows, $Results) {
    if ($Claim -eq 'ClassificationOnly') { return $Results.Count -eq 0 }
    $required = if ($Claim -eq 'ProtocolPackageGO') {
        @($Rows | Where-Object { $_.gate -eq 'ProtocolPackageBlocking' })
    } elseif ($Claim -eq 'CutoverFinalReleaseGO') {
        @($Rows)
    } else { return $false }
    if ($Results.Count -ne $required.Count) { return $false }
    foreach ($row in $required) {
        if (-not $Results.ContainsKey([string]$row.id) -or $Results[[string]$row.id] -ne 'Passed') { return $false }
    }
    return $true
}

function Test-EvidencePathPolicy([string]$RelativePath, [bool]$HasReparsePoint) {
    return (-not $HasReparsePoint -and $RelativePath -match '^[a-zA-Z0-9][a-zA-Z0-9._/-]{0,511}$' -and
        $RelativePath -notmatch '(^|/)\.\.?(/|$)|//|\\|:')
}

function Read-OwnedEvidenceArtifact([string]$RepositoryRoot, [string]$RelativePath, [long]$ExpectedLength, [string]$ExpectedSha256) {
    if (-not (Test-EvidencePathPolicy $RelativePath $false)) { return $null }
    $root = [IO.Path]::GetFullPath($RepositoryRoot).TrimEnd('\')
    $candidate = [IO.Path]::GetFullPath((Join-Path $root $RelativePath.Replace('/', '\')))
    if (-not $candidate.StartsWith($root + '\', [StringComparison]::OrdinalIgnoreCase)) { return $null }
    $cursor = $root
    foreach ($segment in $RelativePath.Split('/')) {
        $cursor = Join-Path $cursor $segment
        if (-not (Test-Path -LiteralPath $cursor)) { return $null }
        $item = Get-Item -LiteralPath $cursor -Force
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { return $null }
    }
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) { return $null }
    $bytes = [IO.File]::ReadAllBytes($candidate)
    if ($bytes.LongLength -ne $ExpectedLength) { return $null }
    $sha = [Security.Cryptography.SHA256]::Create()
    try { $actual = ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-','').ToLowerInvariant() }
    finally { $sha.Dispose() }
    if ($actual -ne $ExpectedSha256) { return $null }
    return [pscustomobject]@{ Path=$candidate; Bytes=$bytes; Sha256=$actual }
}

function Test-EvidenceAttestationDocument($Document, $ClassificationRow, $VectorCase, $Manifest, $ArtifactByPath, $OwnedArtifactByPath, [bool]$VerifyToolchain, [string]$WorkspaceRoot) {
    try {
        $top = @('$schema','schemaVersion','caseId','executableOwner','gate','expectedOutcome','expectedCallbacks','observed','result','runner','configuration','toolchain','source','packageClosure','deployment','participants','output')
        if ((@($Document.PSObject.Properties | ForEach-Object { [string]$_.Name }) -join '|') -ne ($top -join '|') -or
            $Document.'$schema' -ne 'dnp1-classical-v1.evidence-attestation.schema.json' -or $Document.schemaVersion -ne '1.0.0' -or
            $Document.caseId -ne $ClassificationRow.id -or $Document.executableOwner -ne $ClassificationRow.executableOwner -or
            $Document.gate -ne $ClassificationRow.gate -or $Document.expectedOutcome -ne $VectorCase.outcome -or
            $Document.result -notin @('Passed','Pending','Failed') -or $Document.configuration -ne $Manifest.configuration) { return $false }
        foreach ($name in @('signature','agreement','network','mutation')) {
            if ([int]$Document.expectedCallbacks.$name -ne [int]$VectorCase.callbacks.$name -or
                [int]$Document.observed.callbacks.$name -ne [int]$VectorCase.callbacks.$name) { return $false }
        }
        if ($Document.observed.result -ne $Document.result -or $Document.observed.outcome -ne $VectorCase.outcome -or [int]$Document.observed.exitCode -ne 0 -or
            @($Document.observed.testIds).Count -ne 1 -or $Document.observed.testIds[0] -ne $Document.caseId -or
            -not $ArtifactByPath.ContainsKey([string]$Document.observed.runnerOutputPath) -or
            [string]$ArtifactByPath[[string]$Document.observed.runnerOutputPath].sha256 -ne [string]$Document.observed.runnerOutputSha256) { return $false }
        foreach ($binding in @($Document.runner,$Document.packageClosure,$Document.deployment,$Document.output)) {
            $path = if ($binding.PSObject.Properties.Name -contains 'artifactPath') { [string]$binding.artifactPath } else { return $false }
            if (-not $ArtifactByPath.ContainsKey($path) -or [string]$ArtifactByPath[$path].sha256 -ne [string]$binding.sha256) { return $false }
        }
        if ($Document.runner.sha256 -ne $ArtifactByPath[[string]$Document.runner.artifactPath].sha256 -or
            $Document.toolchain.executableName -ne $Manifest.toolchainExecutableName -or
            $Document.toolchain.version -ne $Manifest.toolchainVersion -or
            $Document.toolchain.executableSha256 -ne $Manifest.toolchainSha256 -or
            $Document.source.repository -ne $Manifest.repository -or $Document.source.revision -ne $Manifest.revision -or
            $Document.source.gitTree -ne $Manifest.gitTree -or -not $Document.source.clean) { return $false }
        if (-not $OwnedArtifactByPath.ContainsKey([string]$Document.observed.runnerOutputPath)) { return $false }
        try { $runnerResult = [Text.Encoding]::UTF8.GetString($OwnedArtifactByPath[[string]$Document.observed.runnerOutputPath].Bytes) | ConvertFrom-Json }
        catch { return $false }
        if ((@($runnerResult.PSObject.Properties | ForEach-Object { [string]$_.Name }) -join '|') -ne 'schemaVersion|caseId|testIds|result|observedOutcome|observedCallbacks|exitCode' -or
            $runnerResult.schemaVersion -ne '1.0.0' -or $runnerResult.caseId -ne $Document.caseId -or
            @($runnerResult.testIds).Count -ne 1 -or $runnerResult.testIds[0] -ne $Document.caseId -or
            $runnerResult.result -ne $Document.observed.result -or $runnerResult.observedOutcome -ne $Document.observed.outcome -or
            [int]$runnerResult.exitCode -ne [int]$Document.observed.exitCode) { return $false }
        foreach ($name in @('signature','agreement','network','mutation')) {
            if ([int]$runnerResult.observedCallbacks.$name -ne [int]$Document.observed.callbacks.$name) { return $false }
        }
        if ($Document.source.mode -eq 'CleanGit') {
            if ($null -ne $Document.source.archiveArtifactSetSha256) { return $false }
        } elseif ($Document.source.mode -eq 'FrozenArchive') {
            if ($VerifyToolchain -or [string]$Document.source.archiveArtifactSetSha256 -notmatch '^[0-9a-f]{64}$') { return $false }
        } else { return $false }
        if ($VerifyToolchain) {
            $command = Get-Command -Name ([string]$Manifest.toolchainExecutableName) -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($null -eq $command -or (Get-FileHash -LiteralPath $command.Source -Algorithm SHA256).Hash.ToLowerInvariant() -ne [string]$Manifest.toolchainSha256) { return $false }
            $arguments = @($Document.runner.arguments)
            if ($arguments.Count -lt 1 -or @($arguments | Where-Object { $_ -isnot [string] -or [string]$_ -notmatch '^[a-zA-Z0-9._/-][a-zA-Z0-9._/-]{0,511}$' }).Count -ne 0 -or
                @($arguments | Where-Object { $_ -eq [string]$Document.runner.artifactPath }).Count -ne 1) { return $false }
            $psi = [Diagnostics.ProcessStartInfo]::new()
            $psi.FileName = $command.Source; $psi.WorkingDirectory = $WorkspaceRoot; $psi.UseShellExecute = $false
            $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.CreateNoWindow = $true
            $psi.Arguments = (@($arguments | ForEach-Object { '"' + ([string]$_).Replace('"','\"') + '"' }) -join ' ')
            $process = [Diagnostics.Process]::new(); $process.StartInfo = $psi
            try {
                $started = $process.Start()
                if (-not $started) { return $false }
                $stdout = $process.StandardOutput.ReadToEnd(); $null = $process.StandardError.ReadToEnd(); $process.WaitForExit()
                if ($process.ExitCode -ne [int]$Document.observed.exitCode) { return $false }
                $stdoutBytes = [Text.Encoding]::UTF8.GetBytes($stdout)
                $expectedOutputBytes = $OwnedArtifactByPath[[string]$Document.observed.runnerOutputPath].Bytes
                if ($stdoutBytes.Length -ne $expectedOutputBytes.Length) { return $false }
                $outputDifference = 0
                for ($i=0; $i -lt $stdoutBytes.Length; $i++) { $outputDifference = $outputDifference -bor ($stdoutBytes[$i] -bxor $expectedOutputBytes[$i]) }
                if ($outputDifference -ne 0) { return $false }
            }
            finally { $process.Dispose() }
        }
        $participantProperty = $Document.PSObject.Properties['participants']
        $participants = [object[]]$Document.participants
        if ($null -eq $participantProperty -or $participants.Length -lt 1) { return $false }
        if ($Document.executableOwner -ne 'CrossRepoE2E') {
            if ($participants.Length -ne 1 -or [string]$participants[0].repository -ne [string]$Manifest.repository) { return $false }
        }
        $expectedRepos = if ($Document.executableOwner -eq 'CrossRepoE2E') {
            @('deep-client-maui','deep-client-shared','deep-devops','deep-protocol','deep-registry-api','deep-tests-e2e','xnode')
        } else { @([string]$Manifest.repository) }
        $actualParticipantRepos = @($participants | ForEach-Object { [string]$_.repository })
        if ($participants.Count -ne $expectedRepos.Count) { return $false }
        for ($participantIndex=0; $participantIndex -lt $expectedRepos.Count; $participantIndex++) {
            if ([string]$actualParticipantRepos[$participantIndex] -ne [string]$expectedRepos[$participantIndex]) { return $false }
        }
        $producerParticipant = @($participants | Where-Object { $_.repository -eq $Manifest.repository })
        if ($producerParticipant.Count -ne 1 -or $producerParticipant[0].revision -ne $Manifest.revision -or
            $producerParticipant[0].gitTree -ne $Manifest.gitTree -or
            $producerParticipant[0].packageSetSha256 -ne $Document.packageClosure.sha256 -or
            $producerParticipant[0].deploymentSha256 -ne $Document.deployment.sha256) { return $false }
        if ($VerifyToolchain -and $Document.source.mode -eq 'CleanGit') {
            foreach ($participant in $participants) {
                $participantRoot = Join-Path $WorkspaceRoot ([string]$participant.repository)
                if (-not (Test-Path -LiteralPath $participantRoot -PathType Container)) { return $false }
                $head = (& git -C $participantRoot rev-parse HEAD 2>$null).Trim()
                $tree = (& git -C $participantRoot rev-parse 'HEAD^{tree}' 2>$null).Trim()
                $dirty = @(& git -C $participantRoot status --porcelain=v1 --untracked-files=all 2>$null)
                if ($head -ne [string]$participant.revision -or $tree -ne [string]$participant.gitTree -or $dirty.Count -ne 0) { return $false }
                foreach ($binding in @(
                    [pscustomobject]@{ path=[string]$participant.packageArtifactPath; sha=[string]$participant.packageSetSha256 },
                    [pscustomobject]@{ path=[string]$participant.deploymentArtifactPath; sha=[string]$participant.deploymentSha256 }
                )) {
                    if (-not (Test-EvidencePathPolicy $binding.path $false)) { return $false }
                    $candidate = Join-Path $participantRoot $binding.path.Replace('/', '\')
                    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) { return $false }
                    $item = Get-Item -LiteralPath $candidate
                    if ($null -eq (Read-OwnedEvidenceArtifact $participantRoot $binding.path ([long]$item.Length) $binding.sha)) { return $false }
                }
            }
        }
        return $true
    }
    catch { return $false }
}

function Test-EvidenceAttestationAccepted($Document, $ClassificationRow, $VectorCase, $Manifest, $ArtifactByPath, $OwnedArtifactByPath, [bool]$VerifyToolchain, [string]$WorkspaceRoot) {
    $values = @(Test-EvidenceAttestationDocument $Document $ClassificationRow $VectorCase $Manifest $ArtifactByPath $OwnedArtifactByPath $VerifyToolchain $WorkspaceRoot)
    return [bool]$values[-1]
}

function Test-EvidenceManifestDocument($Document, $OwnershipById, $VectorById, [string]$ClassificationSha, $RepositoryBinding, [string]$RepositoryRoot, [bool]$VerifyToolchain) {
    try {
        $top = @('$schema','schemaVersion','status','decision','workPackage','classificationSha256','vectorSkeletonSha256','producer','repository','revision','gitTree','worktreeClean','configuration','toolchainExecutableName','toolchainVersion','toolchainSha256','testArtifactSetSha256','artifactInventory','cases')
        if ((@($Document.PSObject.Properties | ForEach-Object { [string]$_.Name }) -join '|') -ne ($top -join '|') -or
            $Document.cases -isnot [System.Array] -or @($Document.cases).Count -lt 1 -or @($Document.cases).Count -gt 314 -or
            $Document.artifactInventory -isnot [System.Array] -or @($Document.artifactInventory).Count -lt 1 -or @($Document.artifactInventory).Count -gt 4096 -or
            $Document.'$schema' -ne 'dnp1-classical-v1.evidence-manifest.schema.json' -or
            $Document.schemaVersion -ne '1.0.0' -or @('incomplete','complete') -notcontains [string]$Document.status -or
            $Document.decision -ne 'DR-0003' -or $Document.workPackage -ne 'DNP1-PROTO-classical-identity-reset-routing' -or
            $Document.classificationSha256 -ne $ClassificationSha -or
            $Document.vectorSkeletonSha256 -ne '449c84b2bfd754e44da11fcd69aa4d3917db95a2a410168cabc98d6d57959b25' -or
            [string]$Document.repository -ne [string]$RepositoryBinding.repository -or
            $null -eq $RepositoryBinding.expectedRevision -or [string]$Document.revision -ne [string]$RepositoryBinding.expectedRevision -or
            [string]$Document.revision -notmatch '^[0-9a-f]{40}$' -or
            [string]$Document.gitTree -notmatch '^[0-9a-f]{40}$' -or -not $Document.worktreeClean -or
            @('Debug','Release') -notcontains [string]$Document.configuration -or
            [string]$Document.toolchainExecutableName -notmatch '^[a-zA-Z0-9._-]{1,64}$' -or
            ([string]$Document.toolchainVersion).Length -lt 1 -or
            [string]$Document.toolchainSha256 -notmatch '^[0-9a-f]{64}$' -or
            [string]$Document.testArtifactSetSha256 -notmatch '^[0-9a-f]{64}$') { return $false }
        $artifactByPath = @{}
        $ownedArtifactByPath = @{}
        $artifactEntries = New-Object 'System.Collections.Generic.List[string]'
        $previousPath = $null
        foreach ($artifact in @($Document.artifactInventory)) {
            if ((@($artifact.PSObject.Properties | ForEach-Object { [string]$_.Name }) -join '|') -ne 'path|byteLength|sha256' -or
                $artifact.path -isnot [string] -or [string]$artifact.path -notmatch '^[a-zA-Z0-9][a-zA-Z0-9._/-]{0,511}$' -or
                [string]$artifact.path -match '(^|/)\.\.?(/|$)|//|\\' -or
                ($artifact.byteLength -isnot [int] -and $artifact.byteLength -isnot [long]) -or [long]$artifact.byteLength -lt 1 -or
                [string]$artifact.sha256 -notmatch '^[0-9a-f]{64}$' -or $artifactByPath.ContainsKey([string]$artifact.path) -or
                ($null -ne $previousPath -and [string]::CompareOrdinal($previousPath, [string]$artifact.path) -ge 0)) { return $false }
            $owned = Read-OwnedEvidenceArtifact $RepositoryRoot ([string]$artifact.path) ([long]$artifact.byteLength) ([string]$artifact.sha256)
            if ($null -eq $owned) { return $false }
            $artifactByPath[[string]$artifact.path] = $artifact
            $ownedArtifactByPath[[string]$artifact.path] = $owned
            $artifactEntries.Add("$($artifact.sha256)  $($artifact.byteLength)  $($artifact.path)")
            $previousPath = [string]$artifact.path
        }
        $artifactDigestInput = ($artifactEntries -join "`n") + "`n"
        $artifactSha = [System.Security.Cryptography.SHA256]::Create()
        try { $actualArtifactDigest = ([BitConverter]::ToString($artifactSha.ComputeHash([Text.Encoding]::UTF8.GetBytes($artifactDigestInput)))).Replace('-','').ToLowerInvariant() }
        finally { $artifactSha.Dispose() }
        if ($actualArtifactDigest -ne [string]$Document.testArtifactSetSha256) { return $false }
        $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
        foreach ($case in @($Document.cases)) {
            if ((@($case.PSObject.Properties | ForEach-Object { [string]$_.Name }) -join '|') -ne 'id|result|attestationPath|attestationSha256' -or
                -not $seen.Add([string]$case.id) -or -not $OwnershipById.ContainsKey([string]$case.id) -or -not $VectorById.ContainsKey([string]$case.id) -or
                $OwnershipById[[string]$case.id].executableOwner -ne [string]$Document.producer -or
                @('Passed','Pending','Failed') -notcontains [string]$case.result -or -not $artifactByPath.ContainsKey([string]$case.attestationPath) -or
                [string]$artifactByPath[[string]$case.attestationPath].sha256 -ne [string]$case.attestationSha256 -or
                [string]$case.attestationSha256 -notmatch '^[0-9a-f]{64}$' -or
                ($Document.status -eq 'complete' -and $case.result -ne 'Passed')) { return $false }
            try { $attestation = [Text.Encoding]::UTF8.GetString($ownedArtifactByPath[[string]$case.attestationPath].Bytes) | ConvertFrom-Json }
            catch { return $false }
            if ($attestation.result -ne $case.result -or
                -not (Test-EvidenceAttestationAccepted $attestation $OwnershipById[[string]$case.id] $VectorById[[string]$case.id] $Document $artifactByPath $ownedArtifactByPath $VerifyToolchain $repoRoot)) { return $false }
        }
        return $true
    }
    catch { return $false }
}

function Test-ClosedVectorDocumentAgainstSchema($Document, $Schema) {
    try {
        if ($Schema.'$schema' -ne 'https://json-schema.org/draft/2020-12/schema' -or
            $Schema.additionalProperties -ne $false) { return $false }
        $requiredTop = @($Schema.required | ForEach-Object { [string]$_ })
        $allowedTop = @($Schema.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
        $actualTop = @($Document.PSObject.Properties | ForEach-Object { [string]$_.Name })
        foreach ($name in $requiredTop) { if ($actualTop -notcontains $name) { return $false } }
        foreach ($name in $actualTop) { if ($allowedTop -notcontains $name) { return $false } }
        foreach ($name in @('$schema','schemaVersion','status','decision','workPackage')) {
            if ($Document.$name -isnot [string] -or
                [string]$Document.$name -cne [string]$Schema.properties.$name.const) { return $false }
        }
        if ($Document.cases -isnot [System.Array]) { return $false }
        $cases = @($Document.cases)
        if ($cases.Count -lt [int]$Schema.properties.cases.minItems -or
            $cases.Count -gt [int]$Schema.properties.cases.maxItems) { return $false }
        $caseSchema = $Schema.'$defs'.case
        if ($caseSchema.additionalProperties -ne $false) { return $false }
        $requiredCase = @($caseSchema.required | ForEach-Object { [string]$_ })
        $allowedCase = @($caseSchema.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
        $seenIds = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
        foreach ($case in $cases) {
            if ($null -eq $case -or $case -isnot [System.Management.Automation.PSCustomObject]) { return $false }
            $caseNames = @($case.PSObject.Properties | ForEach-Object { [string]$_.Name })
            foreach ($name in $requiredCase) { if ($caseNames -notcontains $name) { return $false } }
            foreach ($name in $caseNames) { if ($allowedCase -notcontains $name) { return $false } }
            if ($case.id -isnot [string] -or $case.area -isnot [string] -or
                $case.outcome -isnot [string] -or $case.purpose -isnot [string] -or
                [string]$case.id -notmatch [string]$caseSchema.properties.id.pattern -or
                -not $seenIds.Add([string]$case.id) -or
                @($caseSchema.properties.area.enum) -notcontains [string]$case.area -or
                @($caseSchema.properties.outcome.enum) -notcontains [string]$case.outcome -or
                ([string]$case.purpose).Length -lt [int]$caseSchema.properties.purpose.minLength -or
                ([string]$case.purpose).Length -gt [int]$caseSchema.properties.purpose.maxLength) { return $false }
            $callbackSchema = $caseSchema.properties.callbacks
            if ($callbackSchema.additionalProperties -ne $false -or $null -eq $case.callbacks -or
                $case.callbacks -isnot [System.Management.Automation.PSCustomObject]) { return $false }
            $requiredCallbacks = @($callbackSchema.required | ForEach-Object { [string]$_ })
            $allowedCallbacks = @($callbackSchema.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
            $callbackNames = @($case.callbacks.PSObject.Properties | ForEach-Object { [string]$_.Name })
            foreach ($name in $requiredCallbacks) { if ($callbackNames -notcontains $name) { return $false } }
            foreach ($name in $callbackNames) { if ($allowedCallbacks -notcontains $name) { return $false } }
            foreach ($name in $requiredCallbacks) {
                $value = $case.callbacks.$name
                if (($value -isnot [int] -and $value -isnot [long]) -or
                    [long]$value -lt [long]$callbackSchema.properties.$name.minimum) { return $false }
            }
        }
        return $true
    }
    catch { return $false }
}

if ($registrySchema.'$schema' -ne 'https://json-schema.org/draft/2020-12/schema' -or
    $registrySchema.'$id' -ne 'urn:deep:dnp1:classical:v1:registry' -or
    $registry.'$schema' -ne 'dnp1-classical-v1.registry.schema.json') {
    Fail 'registry schema identity or binding drifted'
}
$topLevel = @('$schema','schemaVersion','status','decision','workPackage','suite','grammar','recordClasses','artifactTypes','artifactHashDomains','retainedArtifactHashRules','domains','substructures','componentKinds','releaseRootTrust','wireEnums','records','membershipAuthority','membershipProof','witness','hashTranscripts','identifiers','recovery','apiInvariants','outerJournal','evidenceOwnership','http','packages','activationOrder','forbidden')
Assert-ExactProperties -Object $registry -Required $topLevel -Allowed $topLevel -Name 'registry'
$schemaRequired = @($registrySchema.required | ForEach-Object { [string]$_ })
if (($schemaRequired -join '|') -ne ($topLevel -join '|') -or $registrySchema.additionalProperties -ne $false) {
    Fail 'registry schema required-set/additionalProperties drifted'
}

if ($registry.schemaVersion -ne '1.0.0' -or
    $registry.status -ne 'normative-clean-break-not-implemented' -or
    $registry.decision -ne 'DR-0003' -or
    $registry.workPackage -ne 'DNP1-PROTO-classical-identity-reset-routing') {
    Fail 'registry governance binding changed'
}
if ([int]$registry.suite.id -ne 1 -or $registry.suite.hex -ne '0x0001' -or
    $registry.suite.name -ne 'IdentityAuthV1Ed25519' -or
    $registry.suite.pqWireSurface -or
    $registry.suite.messageConfidentiality -ne 'absent-blocked') {
    Fail 'Wave 1 must expose only Ed25519 identity authentication and no confidentiality claim'
}
if ([int]$registry.grammar.headerBytes -ne 12 -or
    [int]$registry.grammar.fieldOverheadBytes -ne 8 -or
    [int]$registry.grammar.artifactRefBytes -ne 38 -or
    [int]$registry.grammar.protectedIntegritySuite -ne 32769 -or
    $registry.grammar.protectedHmacInput -ne 'hmac-sha256(protected-state-key32,u16-domain-length|ascii-domain|u16be-0x8001|u32be-unsigned-length|canonical-record-omitting-final-HMAC-and-using-field-count-N-minus-1)') {
    Fail 'canonical grammar constants drifted'
}
$expectedHmacDomains = [ordered]@{
    DPL1='Deep/ProtectedState/V1/DPL1'; DBG1='Deep/ProtectedState/V1/DDBG1'; RIB1='Deep/ProtectedState/V1/DRIB1';
    XIB1='Deep/ProtectedState/V1/DXIB1'; DWL1='Deep/ProtectedState/V1/DWL1'; MRLC='Deep/ProtectedState/V1/MRLC1';
    DPJ1='Deep/ProtectedState/V1/DPJ1'; RRL1='Deep/ProtectedState/V1/RRL1'; DXR1='Deep/ProtectedState/V1/DXP1-verified-receipt';
    DWH1='Deep/ProtectedState/V1/DWH1'; WHL1='Deep/ProtectedState/V1/WHL1'; RAH1='Deep/ProtectedState/V1/RAH1';
    GRR1='Deep/ProtectedState/V1/GRR1'; GRI1='Deep/ProtectedState/V1/GRI1'; GAJ1='Deep/ProtectedState/V1/GAJ1'; GAS1='Deep/ProtectedState/V1/GAS1';
    GQP1='Deep/ProtectedState/V1/GQP1'; GQS1='Deep/ProtectedState/V1/GQS1'; GTI1='Deep/ProtectedState/V1/GTI1'; GFL1='Deep/ProtectedState/V1/GFL1';
    DGI1='Deep/ProtectedState/V1/DGI1'; GAR1='Deep/ProtectedState/V1/GAR1'; GDI1='Deep/ProtectedState/V1/GDI1'; GRA1='Deep/ProtectedState/V1/GRA1'; GMD1='Deep/ProtectedState/V1/GMD1'
}
$actualHmacDomainNames = @($registry.grammar.protectedHmacDomains.PSObject.Properties | ForEach-Object { [string]$_.Name })
if (($actualHmacDomainNames -join '|') -ne (($expectedHmacDomains.Keys) -join '|')) { Fail 'protected HMAC domain map inventory drifted' }
foreach ($name in $expectedHmacDomains.Keys) {
    if ([string]$registry.grammar.protectedHmacDomains.$name -ne [string]$expectedHmacDomains[$name]) { Fail "protected HMAC domain drifted: $name" }
}

$artifactIds = New-Object 'System.Collections.Generic.HashSet[int]'
$artifactMagics = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($artifact in @($registry.artifactTypes)) {
    $artifactAllowed = @('id','magic','retained')
    Assert-ExactProperties -Object $artifact -Required @('id','magic') -Allowed $artifactAllowed -Name "artifact type $($artifact.id)"
    if (-not $artifactIds.Add([int]$artifact.id)) { Fail "duplicate artifact id $($artifact.id)" }
    if (-not $artifactMagics.Add([string]$artifact.magic)) { Fail "duplicate artifact magic $($artifact.magic)" }
}
if ($artifactIds.Count -ne 44) { Fail "artifact type count must be 44, actual $($artifactIds.Count)" }
$expectedArtifactTypes = @(
    '1:DPA1','2:DPD1','3:DPM1','4:DRS1','5:DRT1','6:KRT1','7:KRF1','8:DCM1','9:DCP1','10:DRA1',
    '11:DNR1','12:MRL2','13:DPC1','14:MSM1','15:PRQ2','16:MRR2','17:PMA1','18:PMR1','19:D-G-SOURCE',
    '20:DPL1','21:DBG1','22:RIB1','23:XIB1','24:MRLC','25:DWD1','26:DCS1','27:DCT1','28:DCN1','29:DCQ1',
    '30:DHL1','31:DCL1','32:DWL1','33:DRC1','34:DPR1','35:DPS1','36:DPJ1','37:MNG1','38:MDG1','39:MRV1',
    '40:MMC1','41:RIP2','42:RRM1','43:RRL1','44:DWT1'
)
$actualArtifactTypes = @($registry.artifactTypes | ForEach-Object { "$([int]$_.id):$([string]$_.magic)" })
if (($actualArtifactTypes -join '|') -ne ($expectedArtifactTypes -join '|')) {
    Fail 'closed artifact type id/magic/order table drifted'
}
$artifactSchema = $registrySchema.properties.artifactTypes
if (@($artifactSchema.prefixItems).Count -ne 44 -or $artifactSchema.items -ne $false -or $artifactSchema.uniqueItems -ne $true) {
    Fail 'artifact type schema is not an exact closed ordered table'
}
for ($i = 0; $i -lt 44; $i++) {
    $actualJson = $registry.artifactTypes[$i] | ConvertTo-Json -Compress
    $schemaJson = $artifactSchema.prefixItems[$i].const | ConvertTo-Json -Compress
    if ($actualJson -ne $schemaJson) { Fail "artifact type schema mapping drifted at index $i" }
}
$mappedNames = @($registry.artifactHashDomains.PSObject.Properties | ForEach-Object { [string]$_.Name })
$expectedMappedNames = @($registry.artifactTypes | Where-Object { -not $_.retained } | ForEach-Object { [string]$_.magic })
if ($mappedNames.Count -ne $expectedMappedNames.Count) { Fail 'artifact hash domain mapping count drifted' }
foreach ($magic in $expectedMappedNames) {
    if ($mappedNames -notcontains $magic) { Fail "artifact hash domain missing for $magic" }
    $mappedDomain = [string]$registry.artifactHashDomains.$magic
    if ($mappedDomain -ne "Deep/Artifact/V1/$magic") { Fail "artifact hash domain mismatch for $magic" }
}
foreach ($name in $mappedNames) {
    if ($expectedMappedNames -notcontains $name) { Fail "artifact hash domain exists for retained/unknown type $name" }
}
$expectedRetainedNames = @('MSM1','PRQ2','MRR2','PMA1','PMR1','D-G-SOURCE','MNG1','MDG1','MRV1','MMC1')
$retainedNames = @($registry.retainedArtifactHashRules.PSObject.Properties | ForEach-Object { [string]$_.Name })
if (($retainedNames -join '|') -ne ($expectedRetainedNames -join '|')) { Fail 'retained ArtifactRef hash-rule inventory drifted' }
foreach ($name in $expectedRetainedNames) {
    if (@($registry.artifactTypes | Where-Object { $_.magic -eq $name -and $_.retained }).Count -ne 1) { Fail "retained artifact type missing: $name" }
    $rule = [string]$registry.retainedArtifactHashRules.$name
    if ($name -eq 'D-G-SOURCE') {
        if ($rule -ne 'unchanged-reviewed-source-hash') { Fail 'D-G source hash rule drifted' }
    }
    elseif ($rule -ne 'unchanged-reviewed-canonical-hash') { Fail "retained canonical hash rule drifted: $name" }
}

$domains = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($domain in @($registry.domains)) {
    $value = [string]$domain
    if ($value -notmatch '^Deep/[A-Za-z0-9/-]+$') { Fail "invalid domain: $value" }
    if (-not $domains.Add($value)) { Fail "duplicate domain: $value" }
    if ($spec.IndexOf($value, [System.StringComparison]::Ordinal) -lt 0) {
        Fail "domain absent from normative specification: $value"
    }
}
if ($domains.Count -ne [int]$registrySchema.properties.domains.minItems -or
    $domains.Count -ne [int]$registrySchema.properties.domains.maxItems) {
    Fail 'domain schema bounds do not equal the exact registry inventory'
}
$expectedV10Domains = @(
    'Deep/Cutover/V10/deployment-governance-origin',
    'Deep/Cutover/V10/deployment-governance-bootstrap',
    'Deep/Cutover/V10/deployment-governance-environment-index',
    'Deep/Cutover/V10/first-deployment-cutover-branch',
    'Deep/Cutover/V10/same-account-cutover-branch',
    'Deep/Cutover/V10/account-reset-cutover-branch',
    'Deep/Cutover/V10/account-reset-origin',
    'Deep/Cutover/V10/deployment-governance-index',
    'Deep/Cutover/V10/account-reset-origin-receipt',
    'Deep/Cutover/V10/genesis-dcm-authoring-record',
    'Deep/Cutover/V10/genesis-reset-authoring-record',
    'Deep/Cutover/V10/genesis-author-set'
)
$actualV10Domains = @($registry.domains | Where-Object { [string]$_ -like 'Deep/Cutover/V10/*' })
if (($actualV10Domains -join '|') -cne ($expectedV10Domains -join '|')) {
    Fail 'complete ordered V10 governance domain inventory drifted'
}

$expectedFixed = [ordered]@{
    DPA1 = 644; DPD1 = 776; DPM1 = 670; DRT1 = 179; KRT1 = 412; KRF1 = 300
    DCM1 = 812; DRA1 = 788; DWD1 = 1217; DCP1 = 706; DCS1 = 839; DCT1 = 414
    DWL1 = 708; DPL1 = 576; DBG1 = 296; RIB1 = 772; XIB1 = 452
    DNR1 = 756; MRL2 = 326; DXP1 = 168; DPR1 = 408; DPS1 = 444; DPJ1 = 609
    RRM1 = 332; RRL1 = 502; DWT1 = 714; DXR1 = 573
}
$recordMagics = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($record in @($registry.records)) {
    $magic = [string]$record.magic
    $recordAllowed = @('magic','version','framing','fieldCount','valueBytes','fixedLength','baseValueBytes','baseLength','unitBytes','maximumCount','maximumLength','proofHashBytes','maximumInclusionProofCount','maximumConsistencyProofCount','receiptCount','receiptLengthPrefixBytes','maximumReceiptLength','maximumCiphertextLength','addressMinimumLength','addressMaximumLength','maximumCatalogBytes','fields')
    Assert-ExactProperties -Object $record -Required @('magic','version','fields') -Allowed $recordAllowed -Name "record $magic"
    if ($magic -notmatch '^[A-Z0-9]{4}$') { Fail "invalid record magic: $magic" }
    if (-not $recordMagics.Add($magic)) { Fail "duplicate record: $magic" }
    if ($spec.IndexOf("``$magic``", [System.StringComparison]::Ordinal) -lt 0) {
        Fail "record magic absent from normative specification: $magic"
    }
    if ($null -ne $record.valueBytes) {
        $actual = 12 + (8 * [int]$record.fieldCount) + [int]$record.valueBytes
        if ($actual -ne [int]$record.fixedLength) { Fail "arithmetic mismatch for $magic" }
        if ($null -ne $expectedFixed[$magic] -and [int]$record.fixedLength -ne $expectedFixed[$magic]) {
            Fail "fixed length drift for $magic"
        }
        $fieldWidthSum = 0
        foreach ($field in @($record.fields)) {
            if ([string]$field -notmatch '(\d+)$') { Fail "fixed record field lacks exact width: $magic.$field" }
            $fieldWidthSum += [int]$Matches[1]
        }
        if ($fieldWidthSum -ne [int]$record.valueBytes) { Fail "field width sum mismatch for $magic" }
    }
    elseif ($null -ne $record.baseValueBytes) {
        $actual = 12 + (8 * [int]$record.fieldCount) + [int]$record.baseValueBytes
        if ($actual -ne [int]$record.baseLength) { Fail "base arithmetic mismatch for $magic" }
        $baseFieldWidthSum = 0
        foreach ($field in @($record.fields)) {
            if ([string]$field -match '(\d+)$') { $baseFieldWidthSum += [int]$Matches[1] }
        }
        if ($baseFieldWidthSum -ne [int]$record.baseValueBytes) { Fail "base field width sum mismatch for $magic" }
    }
    if (@($record.fields).Count -eq 0) { Fail "field table missing for $magic" }
    if ($null -ne $record.fieldCount -and @($record.fields).Count -ne [int]$record.fieldCount) {
        Fail "fieldCount mismatch for $magic"
    }
}
if ($recordMagics.Count -ne 36) { Fail "record count must be 36, actual $($recordMagics.Count)" }
if ([int]$registrySchema.properties.records.minItems -ne 36 -or [int]$registrySchema.properties.records.maxItems -ne 36) {
    Fail 'record schema bounds must equal the exact registry inventory'
}

function Record([string]$Magic) {
    $matches = @($registry.records | Where-Object { $_.magic -eq $Magic })
    if ($matches.Count -ne 1) { Fail "record lookup failed for $Magic" }
    return $matches[0]
}

$drs = Record 'DRS1'
if ([int]$drs.baseLength -ne 356 -or [int]$drs.unitBytes -ne 62 -or
    [int]$drs.maximumCount -ne 1024 -or
    [int]$drs.maximumLength -ne (356 + 62 * 1024)) { Fail 'DRS1 bounds drifted' }
$dcn = Record 'DCN1'
if ([int]$dcn.baseLength -ne 758 -or [int]$dcn.proofHashBytes -ne 32 -or
    [int]$dcn.maximumInclusionProofCount -ne 32 -or
    [int]$dcn.maximumConsistencyProofCount -ne 32 -or
    [int]$dcn.maximumLength -ne 2806 -or
    (@($dcn.fields) -join '|') -notmatch 'witnessEpoch8\|DWDRef38\|releaseRootGeneration8\|releaseRootTransitionRef38\|terminalKRFRef38\|terminalState1\|releaseRootAuthorityHeadHash32') { Fail 'DCN1 proof/authority-head bounds drifted' }
$dcq = Record 'DCQ1'
if ([int]$dcq.baseLength -ne 375 -or [int]$dcq.receiptCount -ne 3 -or
    [int]$dcq.maximumLength -ne (375 + 3 * (4 + 2806))) { Fail 'DCQ1 quorum arithmetic drifted' }
$dhl = Record 'DHL1'
if ([int]$dhl.baseLength -ne 710 -or [int]$dhl.maximumConsistencyProofCount -ne 32 -or
    [int]$dhl.maximumLength -ne 1734 -or
    (@($dhl.fields) -join '|') -notmatch 'witnessEpoch8\|DWDRef38\|releaseRootGeneration8\|releaseRootTransitionRef38\|terminalKRFRef38\|terminalState1\|releaseRootAuthorityHeadHash32') { Fail 'DHL1 consistency/authority-head bounds drifted' }
$dcl = Record 'DCL1'
if ([int]$dcl.baseLength -ne 409 -or [int]$dcl.receiptCount -ne 3 -or
    [int]$dcl.maximumLength -ne (409 + 3 * (4 + 1734)) -or
    @($dcl.fields) -notcontains 'releaseRootAuthorityHeadHash32') { Fail 'DCL1 lease/authority-head arithmetic drifted' }
$drc = Record 'DRC1'
if ([int]$drc.maximumCiphertextLength -ne 33554432 -or
    [int]$drc.maximumLength -ne (482 + 33554432) -or
    @($drc.fields) -contains 'candidateDCPRef38' -or @($drc.fields) -contains 'nextDPLRef38') {
    Fail 'DRC1 bounds or acyclic layout drifted'
}
$dwl = Record 'DWL1'
if ([int]$dwl.fixedLength -ne 708 -or @($dwl.fields) -notcontains 'fourWitnessHeads288') {
    Fail 'DWL1 must retain all four witness heads'
}
$dpc = Record 'DPC1'
if ([int]$dpc.baseLength -ne 427 -or [int]$dpc.addressMinimumLength -ne 3 -or
    [int]$dpc.addressMaximumLength -ne 253 -or [int]$dpc.maximumLength -ne 680) {
    Fail 'DPC1 address bounds drifted'
}
$rip2 = Record 'RIP2'
if ([int]$rip2.version -ne 2 -or [int]$rip2.fieldCount -ne 14 -or
    [int]$rip2.baseValueBytes -ne 449 -or [int]$rip2.baseLength -ne 573 -or
    [int]$rip2.proofHashBytes -ne 32 -or
    [int]$rip2.maximumInclusionProofCount -ne 12 -or
    [int]$rip2.maximumLength -ne (573 + 32 * 12) -or
    @($rip2.fields) -notcontains 'canonicalMRL2_326' -or
    @($rip2.fields) -notcontains 'siblingHashes32N') {
    Fail 'RIP2 proof arithmetic or exact embedded descriptor drifted'
}
$dxp = Record 'DXP1'
$dxpWidth = 0
foreach ($field in @($dxp.fields)) {
    if ([string]$field -notmatch '(\d+)$') { Fail "DXP1 field lacks exact width: $field" }
    $dxpWidth += [int]$Matches[1]
}
if ([int]$dxp.fixedLength -ne 168 -or $dxpWidth -ne 168 -or $dxp.framing -ne 'fixed-transcript') {
    Fail 'DXP1 fixed transcript arithmetic drifted'
}
$dcm = Record 'DCM1'
$dpl = Record 'DPL1'
if ([int]$dcm.fixedLength -ne 812 -or @($dcm.fields) -notcontains 'DRSRevision8' -or
    [int]$dpl.fixedLength -ne 576 -or @($dpl.fields) -notcontains 'DRSRevision8') {
    Fail 'DCM1/DPL1 must bind current DRS revision'
}
$dwd = Record 'DWD1'
if ([int]$dwd.fixedLength -ne 1217 -or @($dwd.fields) -notcontains 'maximumTreeSize8' -or
    @($dwd.fields) -notcontains 'predecessorFinalHeadsHash32' -or
    @($dwd.fields) -notcontains 'subjectPolicyHash32' -or
    [uint64]$registry.witness.maximumTreeSize -ne 4294967296 -or
    [int]$registry.witness.maximumReplacementsPerSuccessor -ne 1 -or
    [int]$registry.witness.minimumRetainedWitnesses -ne 3 -or
    [int]$registry.witness.subjectPolicyBytes -ne 63 -or
    $registry.witness.allNewEpochPolicy -ne 'reject-and-permanently-latch-before-successor-activation' -or
    $registry.witness.successorAuthorization -notmatch 'three-retained-old-keys-authorize-one-replacement' -or
    $registry.witness.subjectPolicySource -notmatch 'never-caller-hash' -or
    $registry.witness.subjectPolicyAcl -notmatch 'kind1-deployment-subject-formula-only' -or
    $registry.witness.subjectPolicyPreimage -ne 'network16|policy-version2=1|subject-acl-kind1=1|component-mask8=15|component-count1=4|sorted-component-kinds8=1,2,3,4|maximum-component-rows1=4|maximum-DCPs-per-set1=4|maximum-active-DCS-per-subject1=1|maximum-checkpoint-TTL8|maximum-lease-TTL8|maximum-tree-size8') {
    Fail 'DWD1 witness rotation/tree fencing drifted'
}
$mrlc = Record 'MRLC'
if ([int]$mrlc.fieldCount -ne 27 -or [int]$mrlc.baseLength -ne 898 -or
    [int]$mrlc.maximumCatalogBytes -ne 16777216 -or [int]$mrlc.maximumLength -ne 16778114 -or
    @($mrlc.fields) -notcontains 'DRSRevision8' -or @($mrlc.fields) -notcontains 'membershipClosureHash32' -or
    @($mrlc.fields) -notcontains 'artifactEntryCount4' -or
    @($mrlc.fields) -notcontains 'PMRSnapshotHash32' -or @($mrlc.fields) -notcontains 'HMAC32') {
    Fail 'MRLC1 protected composite LKG drifted'
}
$dpoj = Record 'DPJ1'
if ([int]$dpoj.fixedLength -ne 609 -or [int]$dpoj.fieldCount -ne 21 -or
    @($dpoj.fields) -notcontains 'journalKey32' -or @($dpoj.fields) -notcontains 'phase1' -or
    @($dpoj.fields) -notcontains 'deliveryAuthorized1' -or @($dpoj.fields) -notcontains 'terminalStale1' -or
    @($dpoj.fields) -notcontains 'HMAC32') { Fail 'DPJ1 layout drifted' }
$rrm = Record 'RRM1'
$rrl = Record 'RRL1'
if ([int]$rrm.fixedLength -ne 332 -or [int]$rrm.fieldCount -ne 10 -or
    (@($rrm.fields) -join '|') -ne 'network16|manifestGeneration8|environmentResetId32|releaseRootGeneration8|releaseRootEd25519Public32|activationAt8|componentMask8|schemaFingerprint32|manifestSignerKeyId32|manifestSignature64' -or
    [int]$rrl.fixedLength -ne 502 -or [int]$rrl.fieldCount -ne 16 -or
    (@($rrl.fields) -join '|') -ne 'network16|genesisRRM1Ref38|currentGeneration8|currentPublic32|currentTransitionRef38|terminalKRF1Ref38|terminalState1|forkLatch1|latestDWDGeneration8|latestDWDRef38|latestWitnessEpoch8|chainEntryCount2|chainCheckpointHash32|terminalDWT1Ref38|protectedStateKeyId32|HMAC32') {
    Fail 'ReleaseRoot manifest/LKG fixed layout drifted'
}
$dwt = Record 'DWT1'
if ([int]$dwt.fixedLength -ne 714 -or [int]$dwt.fieldCount -ne 10 -or
    (@($dwt.fields) -join '|') -ne 'network16|priorDWD1Ref38|witnessEpoch8|releaseRootGeneration8|releaseRootTransitionRef38|KRF1Ref38|effectiveAt8|receiptCount1|threeSortedReceiptRows435|quorumDigest32') {
    Fail 'ReleaseRoot terminal witness quorum layout drifted'
}
$dxr = Record 'DXR1'
if ([int]$dxr.fixedLength -ne 573 -or [int]$dxr.fieldCount -ne 19 -or
    (@($dxr.fields) -join '|') -ne 'phase1|role1|network16|operationId32|subjectProjectionHash32|holderX25519Public32|issuerEphemeralPublic32|nonce32|nonceLedgerKey32|issuedAt8|expiresAt8|verifiedAt8|transcriptHash32|subjectArtifactRef38|currentSourceFingerprint32|protectedStateKeyId32|forkLatch1|retainedUntil8|HMAC32') {
    Fail 'DXR1 protected possession receipt layout drifted'
}

$expectedRecordClasses = [ordered]@{
    publicAuthenticated = @{ suite = 1; records = 'DPA1|DPD1|DPM1|DRS1|KRT1|KRF1|DCM1|DRA1|DWD1|DCP1|DCS1|DCT1|DCN1|DCQ1|DHL1|DCL1|DNR1|DPC1|DPR1|DPS1|RRM1|DWT1' }
    publicCommittedUnsigned = @{ suite = 0; records = 'DRT1|MRL2|RIP2' }
    protectedHmac = @{ suite = 32769; records = 'DPL1|DBG1|RIB1|XIB1|DWL1|MRLC|DPJ1|RRL1|DXR1' }
    protectedAead = @{ suite = 32770; records = 'DRC1' }
    fixedTranscript = @{ suite = $null; records = 'DXP1' }
}
$classifiedRecords = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($className in $expectedRecordClasses.Keys) {
    $actualClass = $registry.recordClasses.$className
    if ($null -eq $actualClass) { Fail "record class missing: $className" }
    $expectedSuite = $expectedRecordClasses[$className].suite
    if (($null -eq $expectedSuite -and $null -ne $actualClass.headerSuite) -or
        ($null -ne $expectedSuite -and [int]$actualClass.headerSuite -ne [int]$expectedSuite) -or
        (@($actualClass.records) -join '|') -ne [string]$expectedRecordClasses[$className].records) {
        Fail "record class drifted: $className"
    }
    foreach ($recordName in @($actualClass.records)) {
        if (-not $classifiedRecords.Add([string]$recordName)) { Fail "record is classified twice: $recordName" }
    }
}
if (-not $classifiedRecords.SetEquals([string[]]@($recordMagics))) { Fail 'record class table is not a complete exact partition' }

$expectedTranscriptNames = @('artifactRef','releaseRootGenesis','releaseManifestKeyId','releaseRootKeyHash','releaseRootChain','releaseRootAuthorityHead','witnessTerminalQuorum','witnessTerminalReceiptSigningInput','dxpSalt','dxpKeyDevice','dxpKeyRouter','dxpTranscriptHash','deepAccountId','componentSubject','deploymentSubject','witnessSetRoot','witnessDelegationSigningInput','witnessSetSuccessorSigningInput','subjectPolicy','witnessFinalHeads','witnessLeaf','witnessNode','witnessHead','witnessEmptyRoot','quorumDigest','leaseDigest','mrlRealLeaf','mrlEmptyLeaf','mrlNode','mrlRoot','membershipClosure','membershipTransitionContainer','compositeSelection','catalogHash','outerJournalKey','dxpSubjectProjection','dxpOfflineGenesisIdentityIssuanceSource','dxpAccountDeviceIssuanceScope','dxpCurrentCutoverRouterIssuanceScope','dxpNonceIndexKeyId','dxpNonceLedgerKey','dxpOperationSource','outerRequestHash','outerOutcomeHash','currentCutoverSource','dnrcSource','membershipHeadSource','mailboxAuthorityHeadSource','mrlcSource','recoveryArtifactInventory','recoveryCapsuleSource','recoveryFrontierCheckpoint','recoverySchemaFingerprint','recoveryReleaseContext','recoveryGenesisReleaseContext','recoveryIdentityContext','recoveryIdentityCatalog','recoveryOldProtectedSource','recoveryGenesisCutoverSource','recoveryGenesisCutoverAnchor','recoveryFrontierSubjects','recoveryTargetSubjects','recoveryPredecessorFrontier','recoveryDrtCatalog','recoveryWitnessHeadHistory','recoveryResetAuthorityHead','recoveryGenesisResetLogicalScope','recoveryGenesisResetIntent','recoveryGenesisQuorumPendingOperation','recoveryGenesisQuorumPending','recoveryGenesisQuorumSelection','recoveryGenesisTransactionLogicalScope','recoveryGenesisReplayForkEvidence','recoveryGenesisAuthorJournal','deploymentGovernanceOrigin','deploymentGovernanceBootstrap','deploymentGovernanceEnvironmentIndex','firstDeploymentCutoverBranch','sameAccountCutoverBranch','accountResetCutoverBranch','accountResetOrigin','deploymentGovernanceIndex','accountResetOriginReceipt','genesisDcmAuthoringRecord','genesisResetAuthoringRecord','genesisAuthorSet')
$transcriptNames = @($registry.hashTranscripts.PSObject.Properties | ForEach-Object { [string]$_.Name })
if (($transcriptNames -join '|') -ne ($expectedTranscriptNames -join '|')) { Fail 'hash transcript inventory drifted' }
$expectedTranscripts = [ordered]@{
    artifactRef = 'sha256-d(artifact-hash-domain, exact-canonical-bytes)'
    releaseRootGenesis = 'sha256-d(Deep/Cutover/V1/release-root-genesis,network16|manifest-signer-key-id32|manifest-signer-ed25519-public32|minimum-manifest-generation-u64be-zero|expected-RRM1-ref38)'
    releaseManifestKeyId = 'sha256-d(Deep/Cutover/V1/release-manifest-key-id,manifest-signer-ed25519-public32)'
    releaseRootKeyHash = 'sha256-d(Deep/IdentityAuth/V1/key-hash,network16|scope1|account-hash32|account-generation8|current-public32)'
    releaseRootChain = 'sha256-d(Deep/Cutover/V1/release-root-chain,genesis-RRM1-ref38|entry-count2|ordered-exact-KRT1-or-KRF1-refs|latest-DWD1-ref38)'
    releaseRootAuthorityHead = 'sha256-d(Deep/Cutover/V1/release-root-authority-head,genesis-RRM1-ref38|current-generation8|current-public32|current-transition-ref38|terminal-KRF1-ref38|terminal-state1|fork-latch1|latest-DWD-generation8|latest-DWD-ref38|latest-witness-epoch8|chain-entry-count2|chain-checkpoint-hash32|terminal-DWT1-ref38)'
    witnessTerminalQuorum = 'sha256-d(Deep/Cutover/V1/witness-terminal-quorum,DWT1-fields-1-through-7-canonical-values|receipt-count1=3|three-sorted-receipt-rows435)'
    witnessTerminalReceiptSigningInput = 'siginput(Deep/Cutover/V1/witness-terminal-receipt,suite1,payload-length235,network16|prior-DWD-ref38|witness-epoch8|release-root-generation8|release-root-transition-ref38|KRF-ref38|effective-at8|witness-id32|tree-size8|tree-root32|durability-class1|issued-at8)'
    dxpSalt = 'sha256(u16-domain-length|Deep/IdentityAuth/V1/x25519-pop-salt|network16|role1|subject-unsigned-canonical-hash32|nonce32|issuer-ephemeral-public32|holder-public32)'
    dxpKeyDevice = 'hkdf-sha256-expand(hkdf-sha256-extract(dxp-salt32,x25519-shared-secret32),u16-domain-length|Deep/IdentityAuth/V1/x25519-pop-key/device|u32be-168|exact-DXP1,32)'
    dxpKeyRouter = 'hkdf-sha256-expand(hkdf-sha256-extract(dxp-salt32,x25519-shared-secret32),u16-domain-length|Deep/IdentityAuth/V1/x25519-pop-key/router|u32be-168|exact-DXP1,32)'
    dxpTranscriptHash = 'sha256-d(Deep/IdentityAuth/V1/x25519-pop-transcript-hash,u32be-168|exact-DXP1|u32be-32|proof32)'
    deepAccountId = 'sha256-d(Deep/IdentityAuth/V1/account-id, network16|account-generation8|account-ed25519-public32)'
    componentSubject = 'sha256-d(Deep/Cutover/V1/component-subject, network16|account-hash32|component-kind2|account-revocation-handle32)'
    deploymentSubject = 'sha256-d(Deep/Cutover/V1/deployment-subject, network16|account-hash32|reset-id32)'
    witnessSetRoot = 'sha256-d(Deep/Cutover/V1/witness-set-root, witness-epoch8|witness-count1|four-sorted-descriptors464)'
    witnessDelegationSigningInput = 'siginput(Deep/Cutover/V1/witness-delegation,suite1,payload-length857,canonical-DWD1-fields-1-through-16-857)'
    witnessSetSuccessorSigningInput = 'siginput(Deep/Cutover/V1/witness-set-successor,suite1,payload-length889,canonical-DWD1-fields-1-through-16-857|signer-witness-id32)'
    subjectPolicy = 'sha256-d(Deep/Cutover/V1/subject-policy,network16|policy-version2=1|subject-acl-kind1=1|component-mask8=15|component-count1=4|sorted-component-kinds8=1,2,3,4|maximum-component-rows1=4|maximum-DCPs-per-set1=4|maximum-active-DCS-per-subject1=1|maximum-checkpoint-TTL8|maximum-lease-TTL8|maximum-tree-size8)'
    witnessFinalHeads = 'sha256-d(Deep/Cutover/V1/witness-heads, predecessor-epoch8|four-sorted-heads288)'
    witnessLeaf = 'sha256-d(Deep/Cutover/V1/witness-log-leaf, deployment-subject32|sequence8|DCS-ref38|DCT-ref38)'
    witnessNode = 'sha256-d(Deep/Cutover/V1/witness-log-node, level2|node-index8|left32|right32)'
    witnessHead = 'sha256-d(Deep/Cutover/V1/witness-log-head, witness-epoch8|tree-size8|tree-root32)'
    witnessEmptyRoot = 'sha256-d(Deep/Cutover/V1/witness-empty-root, witness-epoch8|witness-id32|maximum-tree-size8|zero-tree-size8)'
    quorumDigest = 'sha256-d(Deep/Cutover/V1/quorum-digest, deployment-subject32|sequence8|DCS-ref38|DCT-ref38|three-ordered-DCN-artifact-refs114)'
    leaseDigest = 'sha256-d(Deep/Cutover/V1/lease-digest, deployment-subject32|sequence8|DCS-ref38|query-nonce32|three-ordered-DHL-artifact-refs114)'
    mrlRealLeaf = 'sha256-d(Deep/NativeRouting/V2/mrl-leaf, tag00|reset-id32|epoch8|descriptor-generation8|index4|length4=326|canonical-MRL2-membership-projection326-with-field5-and-field9-zero38)'
    mrlEmptyLeaf = 'sha256-d(Deep/NativeRouting/V2/mrl-leaf, tag01|reset-id32|epoch8|index4)'
    mrlNode = 'sha256-d(Deep/NativeRouting/V2/mrl-node, level2|node-index4|left32|right32)'
    mrlRoot = 'sha256-d(Deep/NativeRouting/V2/mrl-root, reset-id32|epoch8|protocol-version2=2|member-count4|padded-leaf-count4|node-root32)'
    membershipClosure = 'sha256-d(Deep/NativeRouting/V2/membership-closure, exact-MNG1-ref38|ordered-signed-MDG1-MRV1-container-hash32|MSM1-ref38)'
    membershipTransitionContainer = 'sha256-d(Deep/NativeRouting/V2/membership-transition-container, entry-count-u16be|ordered-rows-of-artifact-type2-length4-hash32-exact-bytes)'
    compositeSelection = 'sha256-d(Deep/NativeRouting/V2/composite-selection, network16|MSM-ref38|MSM-sequence8|member-count4|MRL-root32|PMA-ref38|PMA-generation8|PMA-epoch8|PMR-ref38|PMR-generation8|PMR-head32|PMR-snapshot-hash32|ordered-router-id32-DNR1-ref38-full-MRL2-ref38-anchor-DPC1-ref38-tuples)'
    catalogHash = 'sha256-d(Deep/NativeRouting/V2/catalog-hash, artifact-entry-count4|catalog-length8|catalog-bytes)'
    outerJournalKey = 'hmac-sha256(journal-index-key, u16-domain-length|Deep/NativeRouting/V1/outer-journal-key|network16|sender32|recipient32|request-id32)'
    dxpSubjectProjection = 'sha256-d(Deep/IdentityAuth/V1/x25519-pop-subject,role1|u32be-projection-length|canonical-DPD1-or-DNR1-unsigned-projection-with-signature-and-PoP-signature-TLVs-omitted-and-x25519PoPTranscriptHash-value-zero32)'
    dxpOfflineGenesisIdentityIssuanceSource = 'sha256-d(Deep/IdentityAuth/V2/offline-genesis-identity-issuance-source,network16|account-hash32|account-generation8=1|DPA1-ref38|DRS-revision8=1|DRS-count8=0|zero-DRS-head32|DRS1-ref38)'
    dxpAccountDeviceIssuanceScope = 'sha256-d(Deep/IdentityAuth/V2/account-device-issuance-scope,network16|account-hash32|account-generation8=1|DPA1-ref38)'
    dxpCurrentCutoverRouterIssuanceScope = 'sha256-d(Deep/IdentityAuth/V2/current-cutover-router-issuance-scope,network16|reset-id32|component-kind2|account-hash32|account-generation8)'
    dxpNonceIndexKeyId = 'sha256-d(Deep/ProtectedState/V2/DXP1-nonce-index-key-id,source-kind1|network16|issuance-scope32|dxp-nonce-index-key32)'
    dxpNonceLedgerKey = 'hmac-sha256(dxp-nonce-index-key32,u16be-domain-length|Deep/ProtectedState/V2/DXP1-nonce-ledger-key|source-kind1|network16|issuance-scope32|role1|nonce32)'
    dxpOperationSource = 'sha256-d(Deep/IdentityAuth/V2/dxp-operation-source,source-kind1|role1|stage1|identity-issuance-source32|issuance-scope32|DRS-revision8|DRS-count8|DRS-head32|DRS-ref38|subject-projection-hash32|prior-subject-LKG-ref38|transcript-hash32|subject-artifact-ref38|identity-catalog-key-id32|DXR-key-id32|nonce-index-key-id32)'
    outerRequestHash = 'sha256-d(Deep/NativeRouting/V1/outer-request-hash,u32be-408|exact-DPR1-408|u32be-PRQ2-length|exact-PRQ2)'
    outerOutcomeHash = 'sha256-d(Deep/NativeRouting/V1/outer-outcome-hash,u32be-296|exact-MRR2-296|u32be-444|exact-DPS1-444)'
    currentCutoverSource = 'sha256-d(Deep/NativeRouting/V2/current-cutover-source,network16|reset-id32|component-kind2|account-hash32|account-generation8|DCM-generation8|DCM-ref38|DCP-ref38|DCS-ref38|DCQ-ref38|DWL-ref38|DCL-ref38|DPL-ref38|release-root-authority-head32|DRS-revision8|DRS-count8|DRS-head32|DRS-ref38|lease-expires8|DPL-key-id32|DWL-key-id32|RRL-key-id32|RIB-key-id32|MRLC-key-id32|DXR-key-id32)'
    dnrcSource = 'sha256-d(Deep/NativeRouting/V2/dnrc-source,cutover-source32|owner-id32|DPMC-ref38|PMA-ref38|PMA-generation8|PMA-epoch8|PMR-ref38|PMR-generation8|PMR-head32|PMR-snapshot-hash32|DNR-ref38|router-DXP-transcript-hash32|DXR1-key-id32)'
    membershipHeadSource = 'sha256-d(Deep/NativeRouting/V2/membership-head-source,network16|MNG1-ref38|transition-container-hash32|MSM-sequence8|MSM-canonical-hash32|MSM-ref38)'
    mailboxAuthorityHeadSource = 'sha256-d(Deep/NativeRouting/V2/mailbox-authority-head-source,network16|PMA-ref38|PMA-generation8|PMA-canonical-hash32|PMR-ref38|PMR-generation8|PMR-head32|PMR-snapshot-hash32)'
    mrlcSource = 'sha256-d(Deep/NativeRouting/V2/mrlc-source,cutover-source32|old-membership-head-source32|new-membership-head-source32|old-mailbox-authority-head-source32|new-mailbox-authority-head-source32|MRLC-ref38|MRLC-protected-key-id32|composite-selection32|member-count4|ordered-router-id32-DNRC-source32-tuples)'
    recoveryArtifactInventory = 'sha256-d(Deep/Cutover/V1/recovery-artifact-inventory,artifact-count-u16be|strictly-sorted-artifact-ref38-array)'
    recoveryCapsuleSource = 'sha256-d(Deep/Cutover/V2/recovery-capsule-source,predecessor-kind1|old-protected-source-fingerprint32|RSM2-hash32|RFC1-hash32|RFC1-key-id32|RPF1-hash32|RAH1-hash32|DTC2-hash32|DTC2-key-id32|DWH1-hash32)'
    recoveryFrontierCheckpoint = 'sha256-d(Deep/Cutover/V1/recovery-frontier-checkpoint-hash,u32be-RFC1-length|exact-RFC1-including-key-id-and-HMAC); verify RFC1 HMAC before computing or trusting this hash'
    recoverySchemaFingerprint = 'sha256-d(Deep/Cutover/V1/recovery-schema-profile-fingerprint,UTF8(sourceLines joined by LF with one final LF)); sourceLines are immutable compile-time profile input and exclude this fingerprint, deployment, package, documentation and mutable policy'
    recoveryReleaseContext = 'sha256-d(Deep/Cutover/V1/recovery-release-context,network16|reset-id32|RRM1-ref38|root-generation8|current-public32|current-transition-ref38|terminal-KRF-ref38|terminal-state1|fork-latch1|latest-DWD-generation8|latest-DWD-ref38|DWT-ref38|DCL-ref38|DCL-expires8|transition-count2|ordered-transition-refs38N|DWD-count2|ordered-DWD-refs38N); ExistingDPL only; terminal uses exact DWT and nonterminal uses exact fresh DCL'
    recoveryGenesisReleaseContext = 'sha256-d(Deep/Cutover/V3/recovery-genesis-release-context,network16|reset-id32|RRM1-ref38|root-generation8|current-public32|current-transition-ref38|zero-terminal-KRF-ref38|terminal-state1-zero|fork-latch1-zero|latest-DWD-generation8|latest-DWD-ref38|latest-witness-epoch8|current-release-root-authority-head32|transition-count2|ordered-nonterminal-KRT1-refs38N|DWD-count2|ordered-DWD1-refs38M|head-history-count2|ordered-predecessor-head-history-entries342H|protected-state-HMAC-key-id32); GenesisCutoverAnchor only; N0..64,M1..65,H=M-1; derive after immutable RRM pin, complete nonterminal scope1 KRT chain, DWD/DWH ancestry, current nonterminal RRL/WHL head and WHL HMAC verify; entry bytes are stable history facts and never the transaction DWH1 hash; fork latch is exact zero at mint, before authoring and final zero-to-one CAS; KRF,DWT,DCL,lease,deployment-head and candidate descendants absent; no caller bytes, public factory or authority conversion'
    recoveryIdentityContext = 'sha256-d(Deep/Cutover/V1/recovery-identity-context,network16|reset-id32|account-generation8|DPA-ref38|DCM-ref38|DRS-revision8|DRS-count8|DRS-head32|DRS-ref38|device-role-head-ref38|mailbox-role-head-ref38|router-role-head-ref38|identity-catalog-hash32)'
    recoveryIdentityCatalog = 'sha256-d(Deep/Cutover/V1/recovery-identity-catalog,network16|reset-id32|account-generation8|catalog-key-id32|transition-count-u16be|sorted-scope2-through4-generation8-KRT-or-final-KRF-ref38-rows|three-role-head-refs38|device-count-u16be|sorted-device-id32-generation8-DPD-ref38-rows|mailbox-count-u16be|sorted-owner-id32-role-generation8-DPM-ref38-rows|router-count-u16be|sorted-router-id32-generation8-DNR-ref38-rows|DRS-ref38|DRS-revision8|DRS-count8|DRS-head32|DTC2-hash32|DTC2-key-id32); all counts bounded by DRM20 profile and every row HMAC/signature/current-DRS verified before sealing; ReleaseRoot scope1 rows excluded'
    recoveryOldProtectedSource = 'sha256-d(Deep/Cutover/V2/recovery-old-protected-source,predecessor-kind1|old-DPL-ref38|genesis-anchor-hash32|release-context-fingerprint32|identity-context-fingerprint32|cutover-or-genesis-source-fingerprint32|terminal-state1|DWT-ref38|DCL-ref38|DCL-expires8|protected-HMAC-key-id32|recovery-latch-key-id32|protector-key-id32); kind1 ExistingDPL requires nonzero old-DPL, zero anchor and regular terminal DWT-or-nonterminal DCL rules; kind2 GenesisCutoverAnchor requires zero old-DPL, nonzero anchor, exact GenesisReleaseContextV1 fingerprint, terminal0, zero DWT/DCL/expiry; ordinary and genesis release fingerprints never cross-feed'
    recoveryGenesisCutoverSource = 'sha256-d(Deep/Cutover/V2/recovery-genesis-cutover-source,network16|reset-id32|component-kind2|component-subject32|account-generation8|DCM-generation8|DCM-ref38|DRS-revision8|DRS-count8|DRS-head32|DRS-ref38|DWD-ref38|witness-epoch8|component-schema-fingerprint32|DPL-key-id32|DWL-key-id32|RRL-key-id32|RIB-key-id32|MRLC-key-id32|DXR-key-id32); exact492 and excludes DCP,DCS,DCT,DCN,DCQ,DCL,DHL,DPL,lease and external deployment head'
    recoveryGenesisCutoverAnchor = 'sha256-d(Deep/Cutover/V2/recovery-genesis-cutover-anchor,network16|reset-id32|component-kind2|component-subject32|account-generation8|DCM-ref38|DRS-ref38|DWD-ref38|release-context-fingerprint32|identity-context-fingerprint32|genesis-cutover-source-fingerprint32|transaction-id32|protector-key-id32|protected-state-HMAC-key-id32|recovery-nonce-latch-key-id32|schema-fingerprint32); exact460 internal non-artifact intent; excludes all DCL,DCQ,DCP,DCS,DCT,DCN,DHL,DPL,lease and deployment-head descendants'
    recoveryFrontierSubjects = 'DPA-or-DCM=sha256-d(kind-domain,network16|account-hash32|account-generation8);DRA=sha256-d(DRA-domain,network16|old-account-hash32|old-account-generation8);DPD=sha256-d(DPD-domain,network16|account-hash32|account-generation8|device-id32|device-generation8);DPM=sha256-d(DPM-domain,network16|account-hash32|account-generation8|mailbox-owner-id32|device-id32|role-generation8);DNR=sha256-d(DNR-domain,network16|owner-id32|router-id32|router-generation8);MRL=sha256-d(MRL-domain,network16|router-id32|descriptor-generation8);DPC=sha256-d(DPC-domain,network16|router-id32|contact-generation8)'
    recoveryTargetSubjects = 'target-kind3-DPA=sha256-d(Deep/Cutover/V1/recovery-target-subject/DPA,network16|account-hash32|account-generation8);target-kind1-DPD=sha256-d(Deep/Cutover/V1/recovery-target-subject/DPD,network16|account-hash32|account-generation8|device-id32|device-generation8);target-kind2-DPM=sha256-d(Deep/Cutover/V1/recovery-target-subject/DPM,network16|account-hash32|account-generation8|device-id32|mailbox-owner-id32|role-generation8);other-kind-type-domain rejects'
    recoveryPredecessorFrontier = 'sha256-d(Deep/Cutover/V1/recovery-predecessor-frontier,exact-RPF1)'
    recoveryDrtCatalog = 'sha256-d(Deep/Cutover/V2/recovery-drt-catalog,exact-DTC2)'
    recoveryWitnessHeadHistory = 'sha256-d(Deep/Cutover/V1/recovery-witness-head-history,u32be-DWH1-length|exact-DWH1-including-key-id-and-HMAC); verify DWH1 HMAC before computing or trusting this hash'
    recoveryResetAuthorityHead = 'sha256-d(Deep/Cutover/V1/recovery-reset-authority-head-fact,u32be-426|exact-RAH1-including-key-id-and-HMAC); verify RAH1 HMAC before computing or trusting this hash'
    recoveryGenesisResetLogicalScope = 'sha256-d(Deep/Cutover/V6/genesis-reset-logical-scope,u16be-logical-key-length|exact-branch-logical-key); FirstDeployment key is mode1|network16|deployment-bootstrap-subject32 and AccountReset key is mode2|network16|old-account-generation8|old-account-hash32'
    recoveryGenesisResetIntent = 'sha256-d(Deep/Cutover/V6/genesis-reset-intent,u16be-235|exact-sealed-reset-intent235)'
    recoveryGenesisQuorumPendingOperation = 'sha256-d(Deep/Cutover/V6/genesis-quorum-pending-operation,exact339 network16|reset-id32|deployment-subject32|account-generation8|transaction-id32|DCT-ref38|DCS-ref38|DWD-ref38|witness-epoch8|receipt-count1=3|three-strictly-sorted-witness-id32-values96)'
    recoveryGenesisQuorumPending = 'sha256-d(Deep/Cutover/V6/genesis-quorum-pending,u32be-461|exact-GQP1-including-key-id-and-HMAC); verify GQP1 HMAC before computing or trusting this hash'
    recoveryGenesisQuorumSelection = 'sha256-d(Deep/Cutover/V5/genesis-quorum-selection,u32be-580|exact-GQS1-including-key-id-and-HMAC); verify GQS1 HMAC before computing or trusting this hash'
    recoveryGenesisTransactionLogicalScope = 'sha256-d(Deep/Cutover/V7/genesis-transaction-logical-scope,u16be-122|exact-sealed-transaction-scope122); scope is network16|reset-id32|component-kind2|component-subject32|account-generation8|reservation-hash32 and excludes every transaction, DTC, RSM, DRC, nonce, ciphertext and candidate descendant'
    recoveryGenesisReplayForkEvidence = 'sha256-d(Deep/Cutover/V8/genesis-replay-fork-evidence,u32be-1056|exact-evidence-transcript1056); transcript is sealed-scope122|reason1|expected-GAJ1-hash32|expected-GAJ1-revision8|expected-candidate-slots374|observed-tuple519 and is Protocol-derived only after GAJ, external and local authenticity verification'
    recoveryGenesisAuthorJournal = 'sha256-d(Deep/Cutover/V9/genesis-author-journal-hash,u32be-880|exact-full-HMAC-verified-GAJ1-880); Protocol verifies the GAJ1 HMAC under the exact shared protected-state key before computing or trusting this hash'
    deploymentGovernanceOrigin = 'sha256-d(Deep/Cutover/V10/deployment-governance-origin,u16be-282|exact-DGO1-282); DGO1 is ASCII-DGO1|version1|reserved3-zero|network16|manifestGeneration8|environmentResetId32|activationAt8|componentMask8|componentCount2|four-kind-ordered-rows168|manifestSignerPublic32; public key is nonzero, byte-equal the immutable offline release pin, sha256-d(Deep/Cutover/V1/release-manifest-key-id,public32) equals RRM.manifestSignerKeyId, network16|manifestGeneration8|environmentResetId32|activationAt8|componentMask8 each fixed-time byte-equals its signed RRM counterpart, and DGOHash32 byte-equals signed RRM.schemaFingerprint32'
    deploymentGovernanceBootstrap = 'sha256-d(Deep/Cutover/V10/deployment-governance-bootstrap,u16be-166|network16|environmentResetId32|manifestSignerKeyId32|manifestGeneration8|componentMask8|DGOHash32|RRMRef38)'
    deploymentGovernanceEnvironmentIndex = 'sha256-d(Deep/Cutover/V10/deployment-governance-environment-index,u16be-80|network16|environmentResetId32|manifestSignerKeyId32); this stable consumer environment index is distinct from the bootstrap hash and changed RRM/bootstrap at the same index permanently fork-latches'
    firstDeploymentCutoverBranch = 'sha256-d(Deep/Cutover/V10/first-deployment-cutover-branch,u16be-197|branchKind1=1|network16|newAccountGeneration8|newAccountHash32|newDPARef38|newDRSRef38|governanceHash32|bootstrapSubject32); bootstrapSubject32 fixed-time equals deploymentGovernanceBootstrapHash32 from the sealed governance context'
    sameAccountCutoverBranch = 'sha256-d(Deep/Cutover/V10/same-account-cutover-branch,u16be-203|branchKind1=2|network16|accountGeneration8|accountHash32|DPARef38|DRSRef38|currentDCMRef38|governanceHash32)'
    accountResetCutoverBranch = 'sha256-d(Deep/Cutover/V10/account-reset-cutover-branch,u16be-65|branchKind1=3|accountResetOriginHash32|governanceHash32)'
    accountResetOrigin = 'sha256-d(Deep/Cutover/V10/account-reset-origin,u16be-588|network16|oldAccountGeneration8|oldAccountHash32|oldDPARef38|oldDCMGeneration8|oldDCMRef38|oldDRSRevision8|oldDRSCount8|oldDRSHead32|oldDRSRef38|oldResetGeneration8|oldResetTransitionRef38|oldResetKeyHash32|newAccountGeneration8|newAccountHash32|newDPARef38|newDRSRevision8|newDRSCount8|newDRSHead32|newDRSRef38|newResetGeneration8|newResetTransitionRef38|newResetKeyHash32|governanceHash32|cutoffAt8|reason2); old side is terminal AccountTerminal, new side is nonterminal, new account generation equals old plus one, reason/cutoff policy is closed, and reset/account public-key hashes are raw SHA-256 exactly as the current DRA verifier requires'
    deploymentGovernanceIndex = 'sha256-d(Deep/Cutover/V10/deployment-governance-index,u32be-160|exact-full-HMAC-verified-DGI1-160)'
    accountResetOriginReceipt = 'sha256-d(Deep/Cutover/V10/account-reset-origin-receipt,u32be-742|exact-full-HMAC-verified-GAR1-742)'
    genesisDcmAuthoringRecord = 'sha256-d(Deep/Cutover/V10/genesis-dcm-authoring-record,u32be-1031|exact-full-HMAC-verified-Signed-GDI1-1031)'
    genesisResetAuthoringRecord = 'sha256-d(Deep/Cutover/V10/genesis-reset-authoring-record,u32be-980|exact-full-HMAC-verified-Signed-GRA1-980)'
    genesisAuthorSet = 'sha256-d(Deep/Cutover/V10/genesis-author-set,u16be-65|branchKind1|signedGDIHash32|signedGRAHashOrZero32); branchKind is closed to First=1,Same=2,Reset=3'
}
foreach ($name in $expectedTranscriptNames) {
    $formula = [string]$registry.hashTranscripts.$name
    if ($formula -ne [string]$expectedTranscripts[$name]) { Fail "hash transcript $name drifted" }
    foreach ($domainMatch in [regex]::Matches($formula, 'Deep/[A-Za-z0-9/-]+')) {
        if (-not $domains.Contains($domainMatch.Value) -or
            $spec.IndexOf($domainMatch.Value, [System.StringComparison]::Ordinal) -lt 0) {
            Fail "hash transcript $name references an unregistered domain"
        }
    }
}

$expectedDecryptOrder = @('fixed-metadata-preflight','length-count-cap-check','derive-key-and-nonce-compare','freeze-associated-data','bounded-single-aead-open','zero-prk-and-key','owned-DRM20-profile-reference-dag-order-uniqueness-preflight','closed-per-type-artifact-ref-verify','required-artifact-and-protocol-restore','RSM2-predecessor-union-anchor-and-pin-core-compare','materialize-candidate-DPL-relative-plan')
$recoveryNames = @('suiteId','suite','inputKeyMaterial','transactionId','extractSalt','aeadKey','nonce','associatedData','pinCoreProjection','drmHeader','frontierCheckpoint','predecessorFrontier','frontierSlots','drtCatalog','witnessHeadHistory','resetAuthorityHead','drmCardinality','drmRow','drmRowOrder','drmRowUniqueness','drmReferenceRules','drmReferenceFields','drmAdjacency','drmHash','genesisCutoverAnchor','schemaProfileSourceLines','schemaFingerprint','shadowManifest','artifactInventoryHash','shadowStateHash','pinCoreHash','materializeCandidateDpl','sealPlaintextHash','nonceLatchKey','nonceLatchValue','nonceReuse','decryptOrder')
Assert-ExactProperties -Object $registry.recovery -Required $recoveryNames -Allowed $recoveryNames -Name 'recovery contract'
$recoverySchemaNames = @($registrySchema.properties.recovery.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$recoverySchemaRequired = @($registrySchema.properties.recovery.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.recovery.additionalProperties -ne $false -or
    ($recoverySchemaNames -join '|') -ne ($recoveryNames -join '|') -or
    ($recoverySchemaRequired -join '|') -ne ($recoveryNames -join '|')) {
    Fail 'recovery schema closure drifted'
}
function Test-RecoverySchemaSemanticMirror($Schema, $Registry) {
    return ([int]$Schema.properties.recovery.properties.schemaProfileSourceLines.minItems -eq 26 -and
        [int]$Schema.properties.recovery.properties.schemaProfileSourceLines.maxItems -eq 26 -and
        [string]$Schema.properties.recovery.properties.sealPlaintextHash.const -eq [string]$Registry.recovery.sealPlaintextHash -and
        [string]$Schema.properties.recovery.properties.sealPlaintextHash.const -eq 'sha256-d(Deep/Cutover/V5/recovery-seal-plaintext,u64be-plaintext-length|exact-owned-DRM20-plaintext)')
}
if (-not (Test-RecoverySchemaSemanticMirror $registrySchema $registry)) {
    Fail 'recovery registry schema profile-count or seal-plaintext mirror drifted'
}
$negativeRecoverySchema = ($registrySchema | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
$negativeRecoverySchema.properties.recovery.properties.schemaProfileSourceLines.maxItems = 25
if (Test-RecoverySchemaSemanticMirror $negativeRecoverySchema $registry) { Fail 'recovery schema profile-count negative self-test failed' }
$negativeRecoverySchema = ($registrySchema | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
$negativeRecoverySchema.properties.recovery.properties.sealPlaintextHash.const = 'sha256-d(Deep/Cutover/V5/recovery-seal-plaintext,u64be-plaintext-length|exact-owned-DRM18-plaintext)'
if (Test-RecoverySchemaSemanticMirror $negativeRecoverySchema $registry) { Fail 'recovery seal-plaintext schema negative self-test failed' }
$expectedFrontierSlots = @(
    '1:DPA1:predecessorDPACRef38:DPA1:True:1:True',
    '2:DCM1:predecessorDCMRef38:DCM1:True:1:True',
    '3:DRA1:oldDPACRef38:DPA1:False:1:True',
    '4:DRA1:oldDCMRef38:DCM1:False:1:True',
    '5:DRA1:oldDRSRef38:DRS1:False:1:True',
    '6:DPD1:predecessorDPDCRef38:DPD1:True:1:True',
    '7:DPM1:predecessorDPMCRef38:DPM1:True:1:True',
    '8:DNR1:predecessorDNRCRef38:DNR1:True:1:True',
    '9:MRL2:predecessorMRLRef38:MRL2:True:1:True',
    '10:DPC1:predecessorDPCRef38:DPC1:True:1:True'
)
$actualFrontierSlots = @($registry.recovery.frontierSlots | ForEach-Object { "$([int]$_.kind):$($_.successorType):$($_.field):$($_.predecessorType):$($_.zeroAllowed):$([int]$_.maximumPerSuccessor):$($_.sameCanonicalSubject)" })
$expectedDrmCardinality = @(
    'release-authority:RRM1=1,scope1-KRT1+KRF1=0..64,DWD1=1..65,DWT1=terminal?1:0,DCL1=0',
    'current-identity:mandatory DPA1=1,DCM1=1,DRS1=1; scope2,scope3,scope4 KRT1+KRF1 each0..64 aggregate0..192; nontransition optional aggregate0..61 including DRA1=0..1; total3..256',
    'historical-reset-authority:iff-DRA1 then old-DPA1=1 plus scope4-KRT1=0..64 and KRF1=0 else zero rows; total0..65; full component total3..321',
    'frontier:entries=0..66,one-iff-each-nonzero-closed-slot including separate current/old DPA kind1 subjects,zero-slot=none,no-extra',
    'drt-catalog:entries=DRS1.entryCount=0..1024,one-to-one-same-index,target-fact-one-to-one,no-missing-extra-duplicate',
    'witness-head-history:entries=DWD1-ancestry-count-minus-one=0..64,one-to-one-successor-order,no-missing-extra-duplicate'
)
$expectedDrmAdjacency = @(
    'DPA1:predecessorDPACRef38->RPF1-kind1-or-zero',
    'DCM1:DPACRef38->current-DPA1;DRSRef38->DRS1;predecessorDCMRef38->RPF1-kind2-or-zero;resetTransitionRef38->scope4-nonterminal-KRT1-or-zero-DPA-initial',
    'DRA1:oldDPACRef38->historical-DPA1-and-RPF1-kind3;oldDCMRef38->RPF1-kind4;oldDRSRef38->RPF1-kind5;newDPACRef38->current-DPA1;newDCMRef38->DCM1;oldResetControlKeyHash32->RAH1-exact-reconstructed-historical-scope4-head',
    'DRS1:revocationTransitionRef38->scope3-nonterminal-KRT1-or-zero-DPA-initial;entries62N.DRT1Ref38->DTC2-same-index',
    'DPD1:observedDRSRef38->DRS1;issuerTransitionRef38->scope2-nonterminal-KRT1-or-zero-DPA-initial;predecessorDPDCRef38->RPF1-kind6-or-zero',
    'DPM1:DPDCRef38->DPD1;observedDRSRef38->DRS1;predecessorDPMCRef38->RPF1-kind7-or-zero',
    'DNR1:DPMCRef38->DPM1;PMARef38->PMA1;PMRRef38->PMR1;predecessorDNRCRef38->RPF1-kind8-or-zero',
    'MRL2:DNRCRef38->DNR1;anchorDPCRef38->DPC1;predecessorMRLRef38->RPF1-kind9-or-zero',
    'DPC1:DNRCRef38->DNR1;predecessorDPCRef38->RPF1-kind10-or-zero',
    'MSM1-PMA1-PMR1-D-G-SOURCE-MNG1-MDG1-MRV1-MMC1:retained-sealed-restore-rules-only;no-candidate-derived-predecessor',
    'scope1-RRM1-KRT1-KRF1-DWD1-DWT1:release-root-DAG-only;current-scopes2-4:DPA1-then-KRT1-star-then-optional-final-KRF1;historical-reset:DPA1-then-scope4-KRT1-star-no-KRF1;partition-account-scope-generation-exact'
)
if (($actualFrontierSlots -join '|') -ne ($expectedFrontierSlots -join '|') -or
    (@($registry.recovery.drmCardinality) -join '|') -ne ($expectedDrmCardinality -join '|') -or
    (@($registry.recovery.drmAdjacency) -join '|') -ne ($expectedDrmAdjacency -join '|') -or
    @($registrySchema.properties.recovery.properties.frontierSlots.items.required).Count -ne 7 -or
    $registrySchema.properties.recovery.properties.frontierSlots.items.additionalProperties -ne $false) {
    Fail 'recovery frontier slot or cardinality table drifted'
}
$recoveryReferenceRecordTypes = @('DPA1','DPD1','DPM1','DRT1','DRS1','KRT1','KRF1','DCM1','DRA1','DWD1','DWT1','DNR1','MRL2','DPC1')
$expectedRecoveryReferenceFields = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($record in @($registry.records | Where-Object { $recoveryReferenceRecordTypes -contains [string]$_.magic })) {
    foreach ($field in @($record.fields | Where-Object { [string]$_ -match 'Ref38$' })) {
        $null = $expectedRecoveryReferenceFields.Add("$($record.magic).$field")
    }
}
$classifiedRecoveryReferenceFields = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($property in @($registry.recovery.drmReferenceFields.PSObject.Properties)) {
    if (-not $classifiedRecoveryReferenceFields.Add([string]$property.Name) -or
        [string]$property.Value -notmatch '^(RFC1|row|DTC2-target-fact)\|' -or
        [string]$property.Value -notmatch '\|(zero-allowed|zero-only-generation0-DPA-initial|nonzero)\|' -or
        [string]$property.Value -notmatch '\|one(;terminal-no-successor)?$') {
        Fail "invalid or duplicate DRM reference-field classification: $($property.Name)"
    }
}
if (-not $classifiedRecoveryReferenceFields.SetEquals($expectedRecoveryReferenceFields)) {
    Fail 'DRM reference-field table does not exhaustively equal allowed record Ref38 fields'
}
if ([int]$registry.recovery.suiteId -ne 1 -or
    $registry.recovery.suite -ne 'XChaCha20-Poly1305-IETF+HKDF-SHA-512' -or
    $registry.recovery.inputKeyMaterial -ne 'DeepRecoveryV1 backupWrappingSeed32' -or
    $registry.recovery.transactionId -notmatch 'RestoreOrReserveGenesisTransactionAsync.*CSPRNG32 nonzero.*exact122.*GTI1-243.*HMAC-fsynced before return.*process loss.*no caller ID, raw factory or second mint' -or
    $registry.recovery.extractSalt -ne 'sha512(u16-domain-length|Deep/Cutover/V1/recovery-kdf-salt|network16|component-subject32|transaction-id32)' -or
    $registry.recovery.aeadKey -ne 'hkdf-sha512-expand(prk,u16-domain-length|Deep/Cutover/V1/recovery-aead-key|protector-key-id32,32)' -or
    $registry.recovery.nonce -ne 'hkdf-sha512-expand(prk,u16-domain-length|Deep/Cutover/V1/recovery-aead-nonce|protector-key-id32,24)' -or
    $registry.recovery.associatedData -ne 'u32be-metadata-length|canonical-DRC1-fields-1-through-15-with-field-count-15' -or
    $registry.recovery.pinCoreProjection -notmatch 'exact274=network16' -or
    $registry.recovery.pinCoreProjection -notmatch 'internal-non-artifact-no-parser-or-authority' -or
    $registry.recovery.drmHeader -notmatch 'DRMV.*wire-version20.*component-profile1.*exact-prefix284.*artifact-rows-only.*DRM20-then-RFC1-then-RPF1-then-RAH1-then-DTC2-then-DWH1-then-rows.*DTC1-rejected.*DRM1-DRM2-DRM3-DRM4-DRM5-DRM6-DRM7-DRM8-DRM9-DRM10-DRM11-DRM12-DRM13-DRM14-DRM15-DRM16-DRM17-DRM18-and-DRM19.*mixed-or-unsupported' -or
    $registry.recovery.frontierCheckpoint -notmatch 'RFC1 exact232\+72N.*entry-count2.*protected-key-id32.*HMAC32' -or
    $registry.recovery.frontierCheckpoint -notmatch 'same closed1\.\.10 registry as RPF1.*oldDPAC=3 oldDCM=4 oldDRS=5 distinct entries.*DRA subject formula' -or
    $registry.recovery.frontierCheckpoint -notmatch 'predecessor/source lock.*Deep/ProtectedState/V1/RFC1.*inside DRM20.*ExistingDPL.*GenesisCutoverAnchor' -or
    $registry.recovery.predecessorFrontier -notmatch 'entry-count-u16be-0\.\.66.*kinds1=DPA.*10=DPC.*no-generic-or-cross-kind-authority' -or
    $registry.recovery.drtCatalog -notmatch 'DTC2 exact234\+370N\+172H.*target-count2 N.*history-count2 H.*target-entries370N.*history-entries172H.*maximum555242' -or
    $registry.recovery.drtCatalog -notmatch 'Target370.*history-ordinal2.*History172.*observed-DRS-ref38.*snapshot-revision8.*entry-count8.*entry-head32.*revocation-transition-generation8.*transition-ref38.*revocation-key-hash32' -or
    $registry.recovery.drtCatalog -notmatch 'Deep/ProtectedState/V1/DTC2.*Deep/Cutover/V2/recovery-drt-catalog.*kind1 DPD1.*kind2 DPM1.*kind3 DPA1' -or
    $registry.recovery.drtCatalog -notmatch 'protected recovery facts only, never active DRM rows or capabilities.*historyOrdinal1\.\.H.*History rows are unique and strictly increasing by unsigned bytewise lexicographic comparison of complete exact172 bytes.*historyOrdinal is the one-based index in that canonical order.*every row is used.*not current DRS ref.*revision less than current.*prefix' -or
    $registry.recovery.drtCatalog -notmatch 'same-count history requires an older revision with the same head.*scope3 nonterminal authority.*issuedAt<=targetIssuedAt<=revokedAt<=currentDRSIssuedAt.*Active artifact-ref collision.*AccountTerminal DPA uses ordinal0.*DTC1 and mixed versions reject DRM20' -or
    $registry.recovery.witnessHeadHistory -notmatch 'DWH1 exact232\+342N.*entry-count2.*four-predecessor-heads288.*protected-key-id32.*HMAC32' -or
    $registry.recovery.witnessHeadHistory -notmatch 'old predecessor DWD descriptor order.*size0 root equals witness-empty-root.*retained predecessor heads.*copy byte-exact to successor DWL' -or
    $registry.recovery.witnessHeadHistory -notmatch 'replacement witness is absent from heads288.*genesis DWD generation0 epoch1.*predecessorEpoch0\|zero288' -or
    $registry.recovery.witnessHeadHistory -notmatch 'underlying protected history starts with genesis.*DWD/RRL/DWL lock.*T1 copies it.*missing history fails closed' -or
    $registry.recovery.witnessHeadHistory -notmatch 'RFC1KeyId equals DTC2KeyId equals DWH1KeyId equals sealed ProtectedStateHmac keyId' -or
    $registry.recovery.resetAuthorityHead -notmatch 'RAH1 exact426.*present1 iff exactly one DRA1.*historical scope4 KRT1.*Deep/ProtectedState/V1/RAH1' -or
    $registry.recovery.drmRow -ne 'artifact-ref38|exact-bytes; artifact-ref38=artifact-type-u16be|canonical-length-u32be|canonical-hash32' -or
    $registry.recovery.drmRowOrder -ne 'after-one-AEAD-open-on-owned-plaintext-strict-unsigned-bytewise-lexicographic-increasing-on-exact-artifact-ref38-before-per-row-copy-artifact-decode-ref-hash-signature-network-storage-or-mutation-callback; ancestry-follows-predecessor-refs-not-physical-row-order' -or
    $registry.recovery.drmRowUniqueness -ne 'after-one-AEAD-open-equal-artifact-ref38-rejects-before-per-row-copy-or-downstream-callback-even-if-exact-bytes-differ; every-row-exact-bytes-redecode-recompose-and-recompute-the-same-artifact-ref38' -or
    $registry.recovery.drmReferenceRules -notmatch 'DRM20-wire20-profile1-closed.*release authority exactly RRM1=1,scope1 KRT1-plus-KRF1=0\.\.64,DWD1=1\.\.65,and DWT1=1 iff terminal else zero terminal-or-lease rows' -or
    $registry.recovery.drmReferenceRules -notmatch 'fresh nonterminal DCL1 is external sealed current fact' -or
    $registry.recovery.drmReferenceRules -notmatch 'three exact account-subject chains scopes2,3,4 each KRT1-plus-final-optional-KRF1=0\.\.64 aggregate0\.\.192' -or
    $registry.recovery.drmReferenceRules -notmatch 'Iff DRA1, historical reset partition is exact old DPA1 plus scope4 KRT1-only chain0\.\.64, no KRF' -or
    $registry.recovery.drmReferenceRules -notmatch 'KRF is terminal with no successor and never signing authority' -or
    $registry.recovery.drmReferenceRules -notmatch 'DRT1 only in DTC2.*drmReferenceFields exhaustively classifies every Ref38.*drmAdjacency is transitive acyclic' -or
    $registry.recovery.drmReferenceRules -notmatch 'DPL1,DRC1,DCP1,DCS1,DCT1,DCN1,DCQ1,DHL1,DCL1' -or
    $registry.recovery.drmReferenceRules -notmatch 'DRM1/DRM2/DRM3/DRM4/DRM5/DRM6/DRM7/DRM8/DRM9/DRM10/DRM11/DRM12/DRM13/DRM14/DRM15/DRM16/DRM17/DRM18/DRM19 reject and future type-or-edge requires DRM21' -or
    $registry.recovery.drmHash -ne 'sha256-d(Deep/Cutover/V1/recovery-drm-hash, exact-DRM20)' -or
    $registry.recovery.genesisCutoverAnchor -notmatch 'exact460 internal non-artifact intent.*recovery-genesis-cutover-anchor.*no caller bytes.*descendant reference' -or
    @($registry.recovery.schemaProfileSourceLines).Count -ne 26 -or
    (@($registry.recovery.schemaProfileSourceLines | Select-Object -Unique)).Count -ne 26 -or
    $registry.recovery.schemaFingerprint -notmatch 'sourceLineCount=26.*payloadBytes=[0-9]+.*expectedHex=[0-9a-f]{64}.*stored lines equal derived lines.*RSM2 before provider and after open.*requires DRM21.*no caller bytes' -or
    @($registry.recovery.drmAdjacency).Count -ne 11 -or
    (@($registry.recovery.drmAdjacency) -join '|') -notmatch 'DCM1:DPACRef38->current-DPA1;DRSRef38->DRS1.*DRS1:revocationTransitionRef38->scope3-nonterminal-KRT1.*DPC1:DNRCRef38->DNR1' -or
    $registry.recovery.shadowManifest -notmatch 'RSM2-exact723=.*predecessor-kind1.*old-DPL-ref38.*genesis-anchor-hash32.*artifact-inventory-hash32.*RFC1-hash32.*RPF1-hash32.*RAH1-hash32.*DTC2-hash32.*DWH1-hash32.*RFC1-key-id32.*DTC2-key-id32.*release-context-fingerprint32.*identity-context-fingerprint32.*cutover-or-genesis-source-fingerprint32.*old-protected-source-fingerprint32.*ExistingDPL.*GenesisCutoverAnchor' -or
    $registry.recovery.artifactInventoryHash -notmatch 'recovery-artifact-inventory.*strictly-sorted-artifact-ref38-array.*equal-DRM20' -or
    $registry.recovery.shadowStateHash -ne 'sha256-d(Deep/Cutover/V2/recovery-shadow-state, exact-RSM2-723)' -or
    $registry.recovery.pinCoreHash -notmatch 'exact-DplPinCoreProjectionV1-274.*before-provider.*after-open' -or
    $registry.recovery.materializeCandidateDpl -notmatch 'VerifiedPredecessorCutoverContext.*ExistingDPL.*GenesisCutoverAnchor.*freeze576-local-verify-reread.*expectedSequence0.*candidate sequence1/DCSRef.*No DCL1 zero grammar.*ExternalCheckpointAhead zero publication' -or
    $registry.recovery.sealPlaintextHash -ne 'sha256-d(Deep/Cutover/V5/recovery-seal-plaintext,u64be-plaintext-length|exact-owned-DRM20-plaintext)' -or
    $registry.recovery.nonceLatchKey -ne 'recovery-latch-key-id32|protector-key-id32|derived-nonce24' -or
    $registry.recovery.nonceLatchValue -ne 'sha256-d(Deep/Cutover/V5/recovery-seal-intent,suite-id-u16be|protector-key-id32|derived-nonce24|transaction-id32|u32be-associated-data-length|exact-associated-data|u64be-plaintext-length|seal-plaintext-hash32)' -or
    $registry.recovery.nonceReuse -ne 'durable-absent-to-intent-CAS-before-AEAD; same-key-and-same-intent-is-exact-retry; same-key-and-different-intent-permanently-latches; cancellation-after-CAS-retains-row' -or
    (@($registry.recovery.decryptOrder) -join '|') -ne ($expectedDecryptOrder -join '|')) {
    Fail 'recovery AEAD/KDF/decrypt ordering drifted'
}
$recoverySizes = $registry.substructures.recoveryArtifactRow
$derivedSchemaLines = New-Object System.Collections.Generic.List[string]
$derivedSchemaLines.Add("PROFILE|DRM20|magic=DRMV|wireVersion=20|componentProfile=1|prefixBytes=$($recoverySizes.prefixBytes)|projectionBytes=$($recoverySizes.projectionBytes)|maximumPlaintextBytes=$($recoverySizes.maximumPlaintextBytes)")
$derivedSchemaLines.Add([string]@($registry.recovery.schemaProfileSourceLines)[1])
$derivedSchemaLines.Add("KEYSET|GenesisProtectedKeySetContext=exact296-sealed-nonserializable-no-raw-factory-or-accessor|scope=network16|resetId32|componentKind2|componentSubject32|accountGeneration8|rowCount2=6|rows=kind-u16be|keyId32|kinds=1:DPL,2:DWL,3:RRL,4:RIB,5:MRLC,6:DXR|order=strict-kind1-through6|ids=nonzero-pairwise-distinct-and-distinct-from-shared-HMAC-latch-protector|DPL-HMAC=kind1-only-never-shared-recovery-HMAC|provider=consumer-owned-reset-surviving-HSM-registry-verifier|sourceRevision=u64be-nonzero-monotonic-sealed-metadata-not-hash-input|health=all-six-roles-healthy|reservation=idempotent-byte-identical-same-scope-changed-set-permanent-fork-latch|retention=until-authenticated-DRC-candidate-capsule-and-transaction-horizon-GC-zero|join=separate-sealed-GenesisIdentityContext-DCM-DRS-plus-GenesisReleaseContextV1-DWD-epoch-plus-GenesisComponentIntent-kind-subject-schema-fixed-time-common-axis-match-then-internal-GenesisCutoverSourceContext-derives-unchanged-Source492-anchor460|excludes=artifact-refs,transaction,schema-fingerprint,DRC,RSM,source,anchor,candidate-descendants|reread=pre-author-after-every-provider-await-immediately-pre-and-post-final-zero-to-one-CAS|movement=ExternalCheckpointAhead-zero-new-DRC-CAS-publication|ownership=consumer-durable-allocation-and-registry-CAS,Protocol-sealed-shape-join-and-Source492-hash-only")
$derivedSchemaLines.Add('GENESIS_INPUTS|base=VerifiedGenesisBaseIdentityContext owns verified DPA1 signed exact DCM1 fully-replayed-current-DRS1-with-no-AccountTerminal scopes2..4 role heads and bounded role-plus-DRT facts but no DTC hash/key or Source authority|dcmAuthor=AuthorCutoverManifestAsync sealed relative exact812 freeze-two-signers-self-verify-NoAuthorityClaim with ResetManifestPredecessorIntent exactly one of FirstDeployment(provider-reserved-nonzero-resetId,gen1,pred0),SameAccountSuccessor(exact-prior,+1,same-resetId,no-provider),AccountResetSuccessor(sealed-old-new-tuple,new-accountGen-old+1,gen1,pred0,provider-reserved-fresh-resetId-not-old)|reservation=exact235 sealed authority intent without IDs; stable logical index is branch-exact FirstDeployment49 or AccountReset57 hashed under V6, GRI1-217 protects intentHash-plus-operationId-plus-GRRHash, atomic GRI1-plus-GRR1 create, same logical key different intent fork-latches, process-loss unique remint, no second mint; pre-post signer-CAS-distribution reread|transaction=GenesisTransactionScopeContext exact122 from sealed base-identity release reset-reservation and DCM component row; RestoreOrReserveGenesisTransactionAsync fsyncs GTI1-243 under V7 scope hash and GTI1 HMAC, process-loss remints one nonzero tx, no raw-or-second-ID, reread-and-retain through latch-seal-journal-CAS-GC|accountReset=author-new-DCM-then-DRA-binding-ref-and-old-new-tuple; consumer atomic old-terminal-head-to-new-DCM-plus-DRA CAS; current/candidate AccountTerminal rejects pre-signer-HMAC and only verified DRA old side may be terminal|outer=GenesisAuthorReplay exact-one outer branch with zero-DPL-DWT-DCL and authenticated GAJ1 phases Created0,ExternalCommitted1,LocalCommitted2; process-loss remint by RestoreGenesisPreJournalAsync, RestoreGenesisArtifactSetAsync and RestoreGenesisAuthorReplayAsync under exhaustive pre-journal and phase-head matrices; after LocalCommitted only fresh NormalCurrentStore|dtc=GenesisCutoverAnchor exact oldDPLRef38-zero and oldSourceFingerprint32-zero under HMAC after frozen tx-component-account; ExistingDPL both nonzero; mixed-cross-branch reject|finalIdentity=only-after-genesis-DTC-HMAC binds exact DTC hash-key with provenance CurrentProtectedStore-or-RecoveredDRM20; base cannot Source; genesis author requires CurrentProtectedStore|release=GenesisReleaseContextV1 internal verified network-reset-latestDWDRef-witnessEpoch|intent=no-public-ctor derives kind1..4 row and componentSubject from final identity plus exact DCM table|order=restore-or-reserve-resetId,author-DCM,DRA-branch-CAS,distribute-four,base-identity-current-DRS-fence,verify-genesis-release,derive-transaction-scope,restore-or-reserve-GTI1,freeze-tx-component-account,genesis-DTC-HMAC,final-identity,release,intent,keyset,composite-join,Source492-anchor460-oldSource-RFC-RAH-DWH-RSM2-DRC,preseal-intent-CAS,seal-DRM20,author-DCPx4-DCS-DCT,store-GAS1,persist-GQP1-Pending,fsync-GAJ1-Created,call-only-selected-three-DCN-witnesses,verify-exact3-DCQ-and-external-zero-to-one,complete-GQS1-from-bound-Pending,materialize-DPL,GAJ1-ExternalCommitted,empty-local-CAS,GAJ1-LocalCommitted')
$derivedSchemaLines.Add("GENESIS_REPLAY|reservation=$($registry.apiInvariants.genesisResetReservation)|author=$($registry.apiInvariants.genesisCandidateAuthoring)|restore=$($registry.apiInvariants.genesisAuthorReplayRestore)")
$derivedSchemaLines.Add('DOMAINS|frontierCheckpoint=Deep/Cutover/V1/recovery-frontier-checkpoint-hash|schemaProfile=Deep/Cutover/V1/recovery-schema-profile-fingerprint|rpf=Deep/Cutover/V1/recovery-predecessor-frontier|rah=Deep/Cutover/V1/recovery-reset-authority-head-fact|dtc=Deep/Cutover/V2/recovery-drt-catalog|dwh=Deep/Cutover/V1/recovery-witness-head-history|shadow=Deep/Cutover/V2/recovery-shadow-state|capsule=Deep/Cutover/V2/recovery-capsule-source|oldSource=Deep/Cutover/V2/recovery-old-protected-source|genesisSource=Deep/Cutover/V2/recovery-genesis-cutover-source|genesisAnchor=Deep/Cutover/V2/recovery-genesis-cutover-anchor|genesisRelease=Deep/Cutover/V3/recovery-genesis-release-context|resetReservation=Deep/Cutover/V4/genesis-reset-reservation|genesisCandidate=Deep/Cutover/V4/genesis-author-candidate|artifactReceipt=Deep/Cutover/V4/genesis-artifact-set-receipt|sealPlaintext=Deep/Cutover/V5/recovery-seal-plaintext|sealIntent=Deep/Cutover/V5/recovery-seal-intent|quorumSelection=Deep/Cutover/V5/genesis-quorum-selection|resetLogicalScope=Deep/Cutover/V6/genesis-reset-logical-scope|resetIntent=Deep/Cutover/V6/genesis-reset-intent|quorumPendingOperation=Deep/Cutover/V6/genesis-quorum-pending-operation|quorumPending=Deep/Cutover/V6/genesis-quorum-pending|transactionScope=Deep/Cutover/V7/genesis-transaction-logical-scope|replayFork=Deep/Cutover/V8/genesis-replay-fork-evidence|journal=Deep/Cutover/V9/genesis-author-journal-hash|rfcHmac=Deep/ProtectedState/V1/RFC1|rahHmac=Deep/ProtectedState/V1/RAH1|dtcHmac=Deep/ProtectedState/V1/DTC2|dwhHmac=Deep/ProtectedState/V1/DWH1|whlHmac=Deep/ProtectedState/V1/WHL1|grrHmac=Deep/ProtectedState/V1/GRR1|griHmac=Deep/ProtectedState/V1/GRI1|gajHmac=Deep/ProtectedState/V1/GAJ1|gasHmac=Deep/ProtectedState/V1/GAS1|gqpHmac=Deep/ProtectedState/V1/GQP1|gqsHmac=Deep/ProtectedState/V1/GQS1|gtiHmac=Deep/ProtectedState/V1/GTI1|gflHmac=Deep/ProtectedState/V1/GFL1')
$derivedSchemaLines.Add("LIMITS|rfc=$($recoverySizes.frontierCheckpointFixedBytes)+$($recoverySizes.frontierCheckpointEntryBytes)*N,N<=$($recoverySizes.frontierCheckpointMaximumCount),max$($recoverySizes.frontierCheckpointMaximumBytes)|rpf=$($recoverySizes.frontierHeaderBytes)+$($recoverySizes.frontierEntryBytes)*N,N<=$($recoverySizes.frontierMaximumCount),max$($recoverySizes.frontierMaximumBytes)|rah=$($recoverySizes.resetAuthorityHeadBytes)|dtc=$($recoverySizes.drtCatalogFixedBytes)+$($recoverySizes.drtCatalogEntryBytes)*N+$($recoverySizes.drtCatalogHistoryEntryBytes)*H,N<=$($recoverySizes.drtCatalogMaximumCount),H<=N,max$($recoverySizes.drtCatalogMaximumBytes)|dwh=$($recoverySizes.witnessHeadHistoryFixedBytes)+$($recoverySizes.witnessHeadHistoryEntryBytes)*N,N<=$($recoverySizes.witnessHeadHistoryMaximumCount),max$($recoverySizes.witnessHeadHistoryMaximumBytes)|terminalRows=$($recoverySizes.terminalMaximumCount)|nonterminalRows=$($recoverySizes.nonterminalMaximumCount)|currentRoleRows=$($recoverySizes.maximumCurrentRoleTransitionRows)|currentOtherRows=$($recoverySizes.maximumCurrentNontransitionRows)|historicalResetRows=$($recoverySizes.maximumHistoricalResetAuthorityRows)|componentRows=3..$($recoverySizes.maximumComponentRows)|componentBudget=$($recoverySizes.commonMaximumComponentEncodedBytes)")
$derivedSchemaLines.Add("RFC|$($registry.recovery.frontierCheckpoint)")
$derivedSchemaLines.Add("RPF|$($registry.recovery.predecessorFrontier)")
$derivedSchemaLines.Add("DTC|$($registry.recovery.drtCatalog)")
$derivedSchemaLines.Add("DWH|$($registry.recovery.witnessHeadHistory)|WHL=$($registry.releaseRootTrust.witnessHeadHistory)")
$derivedSchemaLines.Add("RAH|$($registry.recovery.resetAuthorityHead)")
$derivedSchemaLines.Add("SUBJECTS|frontier=$($registry.hashTranscripts.recoveryFrontierSubjects)|target=$($registry.hashTranscripts.recoveryTargetSubjects)")
$slotRows = @($registry.recovery.frontierSlots | ForEach-Object { "$($_.kind),$($_.successorType),$($_.field),$($_.predecessorType),$(if ($_.zeroAllowed) { 1 } else { 0 }),$($_.maximumPerSuccessor),$(if ($_.sameCanonicalSubject) { 1 } else { 0 })" })
$derivedSchemaLines.Add("SLOTS|$($slotRows -join ';')")
$derivedSchemaLines.Add("CARDINALITY|$(@($registry.recovery.drmCardinality) -join ';')")
$derivedSchemaLines.Add("RULES|$($registry.recovery.drmReferenceRules)")
$referenceKeys = [string[]]@($registry.recovery.drmReferenceFields.PSObject.Properties.Name)
[Array]::Sort($referenceKeys, [StringComparer]::Ordinal)
$referenceRows = @($referenceKeys | ForEach-Object { "$_=$($registry.recovery.drmReferenceFields.$_)" })
$derivedSchemaLines.Add("REFERENCE_FIELDS|$($referenceRows -join ';')")
$derivedSchemaLines.Add("ADJACENCY|$(@($registry.recovery.drmAdjacency) -join ';')")
$derivedSchemaLines.Add("ORDER|header=$($registry.recovery.drmHeader)|row=$($registry.recovery.drmRow)|rowOrder=$($registry.recovery.drmRowOrder)|rowUniqueness=$($registry.recovery.drmRowUniqueness)|decrypt=$(@($registry.recovery.decryptOrder) -join ',')")
$derivedSchemaLines.Add("HASHES|drm=$($registry.recovery.drmHash)|rfc=$($registry.hashTranscripts.recoveryFrontierCheckpoint)|rpf=$($registry.hashTranscripts.recoveryPredecessorFrontier)|dtc=$($registry.hashTranscripts.recoveryDrtCatalog)|dwh=$($registry.hashTranscripts.recoveryWitnessHeadHistory)|resetScope=$($registry.hashTranscripts.recoveryGenesisResetLogicalScope)|resetIntent=$($registry.hashTranscripts.recoveryGenesisResetIntent)|gqpOperation=$($registry.hashTranscripts.recoveryGenesisQuorumPendingOperation)|gqp=$($registry.hashTranscripts.recoveryGenesisQuorumPending)|gqs=$($registry.hashTranscripts.recoveryGenesisQuorumSelection)|transactionScope=$($registry.hashTranscripts.recoveryGenesisTransactionLogicalScope)|replayFork=$($registry.hashTranscripts.recoveryGenesisReplayForkEvidence)|journal=$($registry.hashTranscripts.recoveryGenesisAuthorJournal)|capsule=$($registry.hashTranscripts.recoveryCapsuleSource)")
$derivedSchemaLines.Add("RSM|grammar=$($registry.recovery.shadowManifest)|inventory=$($registry.recovery.artifactInventoryHash)|shadow=$($registry.recovery.shadowStateHash)|pin=$($registry.recovery.pinCoreHash)")
$derivedSchemaLines.Add("GENESIS|anchor=$($registry.recovery.genesisCutoverAnchor)|source=$($registry.hashTranscripts.recoveryGenesisCutoverSource)|anchorHash=$($registry.hashTranscripts.recoveryGenesisCutoverAnchor)")
$derivedSchemaLines.Add("AEAD|suiteId=$($registry.recovery.suiteId)|suite=$($registry.recovery.suite)|ikm=$($registry.recovery.inputKeyMaterial)|transaction=$($registry.recovery.transactionId)|extract=$($registry.recovery.extractSalt)|key=$($registry.recovery.aeadKey)|nonce=$($registry.recovery.nonce)|ad=$($registry.recovery.associatedData)|plaintextHash=$($registry.recovery.sealPlaintextHash)|latchKey=$($registry.recovery.nonceLatchKey)|latchValue=$($registry.recovery.nonceLatchValue)|reuse=$($registry.recovery.nonceReuse)")
$derivedSchemaLines.Add("CONTEXTS|release=$($registry.hashTranscripts.recoveryReleaseContext)|genesisRelease=$($registry.hashTranscripts.recoveryGenesisReleaseContext)|catalog=$($registry.hashTranscripts.recoveryIdentityCatalog)|identity=$($registry.hashTranscripts.recoveryIdentityContext)|cutover=$($registry.hashTranscripts.currentCutoverSource)|genesisSource=$($registry.hashTranscripts.recoveryGenesisCutoverSource)|oldSource=$($registry.hashTranscripts.recoveryOldProtectedSource)")
$derivedSchemaLines.Add("MATERIALIZE|expected=$($registry.apiInvariants.recoveryExpectedContext)|plan=$($registry.recovery.materializeCandidateDpl)")
$derivedSchemaLines.Add("PHASE_AUTHORITY|$($registry.apiInvariants.genesisReplayDisposition)")
if ((@($registry.recovery.schemaProfileSourceLines) -join "`n") -cne (@($derivedSchemaLines) -join "`n")) {
    for ($profileLineIndex = 0; $profileLineIndex -lt [Math]::Max(@($registry.recovery.schemaProfileSourceLines).Count, $derivedSchemaLines.Count); $profileLineIndex++) {
        if ([string]@($registry.recovery.schemaProfileSourceLines)[$profileLineIndex] -cne [string]$derivedSchemaLines[$profileLineIndex]) {
            Fail "stored recovery schema profile line $profileLineIndex differs from value derived from machine tables"
        }
    }
    Fail 'stored recovery schema profile lines differ from values derived from machine tables'
}
$schemaProfilePayload = [Text.Encoding]::UTF8.GetBytes((@($derivedSchemaLines) -join "`n") + "`n")
if ($schemaProfilePayload.Length -ne 72345) { Fail 'recovery schema profile canonical LF payload drifted' }
$schemaProfileDomain = [Text.Encoding]::ASCII.GetBytes('Deep/Cutover/V1/recovery-schema-profile-fingerprint')
$schemaProfileTranscript = New-Object byte[] (2 + $schemaProfileDomain.Length + 4 + $schemaProfilePayload.Length)
$schemaProfileTranscript[0] = [byte](($schemaProfileDomain.Length -shr 8) -band 255)
$schemaProfileTranscript[1] = [byte]($schemaProfileDomain.Length -band 255)
[Array]::Copy($schemaProfileDomain, 0, $schemaProfileTranscript, 2, $schemaProfileDomain.Length)
$schemaProfileOffset = 2 + $schemaProfileDomain.Length
$schemaProfileTranscript[$schemaProfileOffset] = [byte](($schemaProfilePayload.Length -shr 24) -band 255)
$schemaProfileTranscript[$schemaProfileOffset + 1] = [byte](($schemaProfilePayload.Length -shr 16) -band 255)
$schemaProfileTranscript[$schemaProfileOffset + 2] = [byte](($schemaProfilePayload.Length -shr 8) -band 255)
$schemaProfileTranscript[$schemaProfileOffset + 3] = [byte]($schemaProfilePayload.Length -band 255)
[Array]::Copy($schemaProfilePayload, 0, $schemaProfileTranscript, $schemaProfileOffset + 4, $schemaProfilePayload.Length)
$schemaProfileSha = [Security.Cryptography.SHA256]::Create()
try { $schemaProfileActual = ([BitConverter]::ToString($schemaProfileSha.ComputeHash($schemaProfileTranscript))).Replace('-', '').ToLowerInvariant() }
finally { $schemaProfileSha.Dispose() }
if ($schemaProfileActual -ne '0728ac6fd910831c935077012a9a90284f343ae8e3642ebced7072a45debac11') {
    Fail 'recovery schema profile fingerprint drifted; a source-line change requires DRM21'
}
foreach ($familyIndex in 0..24) {
    $negativeSchemaLines = @($derivedSchemaLines)
    $negativeSchemaLines[$familyIndex] = [string]$negativeSchemaLines[$familyIndex] + '-substitution'
    $negativePayload = [Text.Encoding]::UTF8.GetBytes(($negativeSchemaLines -join "`n") + "`n")
    $negativeTranscript = New-Object byte[] (2 + $schemaProfileDomain.Length + 4 + $negativePayload.Length)
    $negativeTranscript[0] = [byte](($schemaProfileDomain.Length -shr 8) -band 255); $negativeTranscript[1] = [byte]($schemaProfileDomain.Length -band 255)
    [Array]::Copy($schemaProfileDomain, 0, $negativeTranscript, 2, $schemaProfileDomain.Length)
    $negativeOffset = 2 + $schemaProfileDomain.Length
    $negativeTranscript[$negativeOffset] = [byte](($negativePayload.Length -shr 24) -band 255); $negativeTranscript[$negativeOffset + 1] = [byte](($negativePayload.Length -shr 16) -band 255)
    $negativeTranscript[$negativeOffset + 2] = [byte](($negativePayload.Length -shr 8) -band 255); $negativeTranscript[$negativeOffset + 3] = [byte]($negativePayload.Length -band 255)
    [Array]::Copy($negativePayload, 0, $negativeTranscript, $negativeOffset + 4, $negativePayload.Length)
    $negativeSha = [Security.Cryptography.SHA256]::Create()
    try { $negativeHash = ([BitConverter]::ToString($negativeSha.ComputeHash($negativeTranscript))).Replace('-', '').ToLowerInvariant() }
    finally { $negativeSha.Dispose() }
    if ($negativeHash -eq '0728ac6fd910831c935077012a9a90284f343ae8e3642ebced7072a45debac11') { Fail "schema profile family mutation preserved fingerprint: $familyIndex" }
}
$expectedJournalPhases = @('Prepared=0','InnerPending=1','Completed=2')
if ($registry.outerJournal.record -ne 'DPJ1' -or
    (@($registry.outerJournal.phases) -join '|') -ne ($expectedJournalPhases -join '|') -or
    $registry.outerJournal.latches -notmatch 'cannot both be set' -or
    $registry.outerJournal.phaseShape -notmatch 'terminal-stale preserves phase and all fields' -or
    $registry.outerJournal.staleRule -notmatch 'zero-inner-callback' -or
    $registry.outerJournal.garbageCollection -notmatch 'verify-row-HMAC-first' -or
    $registry.outerJournal.requestHash -notmatch 'outerRequestHash' -or
    $registry.outerJournal.outcomeHash -notmatch 'outerOutcomeHash' -or
    $registry.outerJournal.transitionOrder -notmatch 'persist-HMAC-Prepared') {
    Fail 'outer journal phases, stale rule or authenticated GC drifted'
}
$expectedActivation = @('normative-docs-and-machine-gates','exact-three-protocol-packages-and-independent-review','external-witness-service-tooling-and-four-witness-rehearsal','recovery-capsule-loss-and-whole-store-rollback-rehearsal','registry-destructive-reset','xnode-destructive-reset','shared-and-maui-destructive-reset','devops-clean-rebuild','registry-4C-only-after-every-prior-gate-is-GO')
if ((@($registry.activationOrder) -join '|') -ne ($expectedActivation -join '|')) { Fail 'activation order gates drifted' }

if ([int]$registry.witness.count -ne 4 -or [int]$registry.witness.quorum -ne 3 -or
    [int]$registry.witness.byzantineFaults -ne 1 -or
    -not $registry.witness.oneGlobalDeploymentSetCas -or
    [int]$registry.witness.componentCount -ne 4 -or
    -not $registry.witness.freshLeaseRequiredForSensitiveUse) {
    Fail 'external witness safety policy drifted'
}
if ([int]$registry.substructures.dcmComponentRow.bytes -ne 42 -or
    [int]$registry.substructures.dcmComponentRow.count -ne 4 -or
    [int]$registry.substructures.drsEntry.bytes -ne 62 -or
    [int]$registry.substructures.witnessDescriptor.bytes -ne 116 -or
    [int]$registry.substructures.witnessDescriptor.count -ne 4 -or
    [int]$registry.substructures.dcsComponentRow.bytes -ne 104 -or
    [int]$registry.substructures.dcsComponentRow.count -ne 4 -or
    [int]$registry.substructures.witnessHead.bytes -ne 72 -or
    [int]$registry.substructures.witnessHead.count -ne 4 -or
    [int]$registry.substructures.mrlCatalogRowMaximum.bytes -ne 1768 -or
    [int]$registry.substructures.mrlCatalog.headerBytes -ne 10 -or
    [int]$registry.substructures.mrlCatalog.rowOverheadBytes -ne 38 -or
    [int]$registry.substructures.mrlCatalog.baseAuthorityEntries -ne 5 -or
    [int]$registry.substructures.mrlCatalog.minimumArtifactEntries -ne 8 -or
    [int]$registry.substructures.mrlCatalog.maximumArtifactEntries -ne 16389 -or
    [int]$registry.substructures.mrlCatalog.maximumTransitionEntries -ne 4096 -or
    [int]$registry.substructures.mrlCatalog.minimumMembers -ne 1 -or
    [int]$registry.substructures.mrlCatalog.maximumMembers -ne 4096 -or
    [int]$registry.substructures.mrlCatalog.memberArtifactEntries -ne 3 -or
    [int]$registry.substructures.mrlCatalog.maximumBytes -ne 16777216 -or
    [int]$registry.substructures.recoveryArtifactRow.overheadBytes -ne 38 -or
    [int]$registry.substructures.recoveryArtifactRow.prefixBytes -ne 284 -or
    [int]$registry.substructures.recoveryArtifactRow.projectionBytes -ne 274 -or
    [int]$registry.substructures.recoveryArtifactRow.frontierCheckpointFixedBytes -ne 232 -or
    [int]$registry.substructures.recoveryArtifactRow.frontierCheckpointEntryBytes -ne 72 -or
    [int]$registry.substructures.recoveryArtifactRow.frontierCheckpointMaximumCount -ne 66 -or
    [int]$registry.substructures.recoveryArtifactRow.frontierCheckpointMaximumBytes -ne 4984 -or
    [int]$registry.substructures.recoveryArtifactRow.frontierHeaderBytes -ne 8 -or
    [int]$registry.substructures.recoveryArtifactRow.frontierEntryBytes -ne 78 -or
    [int]$registry.substructures.recoveryArtifactRow.frontierMaximumCount -ne 66 -or
    [int]$registry.substructures.recoveryArtifactRow.frontierMaximumBytes -ne 5156 -or
    [int]$registry.substructures.recoveryArtifactRow.resetAuthorityHeadBytes -ne 426 -or
    [int]$registry.substructures.recoveryArtifactRow.drtCatalogFixedBytes -ne 234 -or
    [int]$registry.substructures.recoveryArtifactRow.drtCatalogEntryBytes -ne 370 -or
    [int]$registry.substructures.recoveryArtifactRow.drtCatalogMaximumCount -ne 1024 -or
    [int]$registry.substructures.recoveryArtifactRow.drtCatalogHistoryEntryBytes -ne 172 -or
    [int]$registry.substructures.recoveryArtifactRow.drtCatalogMaximumHistoryCount -ne 1024 -or
    [int]$registry.substructures.recoveryArtifactRow.drtCatalogMaximumBytes -ne 555242 -or
    [int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryFixedBytes -ne 232 -or
    [int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryEntryBytes -ne 342 -or
    [int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryMaximumCount -ne 64 -or
    [int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryMaximumBytes -ne 22120 -or
    [int]$registry.substructures.recoveryArtifactRow.terminalMaximumCount -ne 452 -or
    [int]$registry.substructures.recoveryArtifactRow.nonterminalMaximumCount -ne 451 -or
    [int]$registry.substructures.recoveryArtifactRow.authorityGenesisRows -ne 1 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumRootTransitionRows -ne 64 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumDwdAncestryRows -ne 65 -or
    [int]$registry.substructures.recoveryArtifactRow.terminalDwtRows -ne 1 -or
    [int]$registry.substructures.recoveryArtifactRow.nonterminalTerminalRows -ne 0 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumCurrentRoleTransitionRows -ne 192 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumCurrentNontransitionRows -ne 61 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumHistoricalResetAuthorityRows -ne 65 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumComponentRows -ne 321 -or
    [int]$registry.substructures.recoveryArtifactRow.terminalMaximumAuthorityEncodedBytes -ne 111497 -or
    [int]$registry.substructures.recoveryArtifactRow.terminalFixedBytes -ne 111781 -or
    [int]$registry.substructures.recoveryArtifactRow.nonterminalMaximumAuthorityEncodedBytes -ne 110745 -or
    [int]$registry.substructures.recoveryArtifactRow.nonterminalFixedBytes -ne 111029 -or
    [int]$registry.substructures.recoveryArtifactRow.commonMaximumComponentEncodedBytes -ne 32854723 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumPlaintextBytes -ne 33554432 -or
    [int]$registry.substructures.recoveryArtifactRow.terminalMaximumAuthorityEncodedBytes -ne ((38 + 332) + 64 * (38 + 412) + 65 * (38 + 1217) + (38 + 714)) -or
    [int]$registry.substructures.recoveryArtifactRow.nonterminalMaximumAuthorityEncodedBytes -ne ((38 + 332) + 64 * (38 + 412) + 65 * (38 + 1217)) -or
    [int]$registry.substructures.recoveryArtifactRow.terminalFixedBytes -ne ([int]$registry.substructures.recoveryArtifactRow.prefixBytes + [int]$registry.substructures.recoveryArtifactRow.terminalMaximumAuthorityEncodedBytes) -or
    [int]$registry.substructures.recoveryArtifactRow.nonterminalFixedBytes -ne ([int]$registry.substructures.recoveryArtifactRow.prefixBytes + [int]$registry.substructures.recoveryArtifactRow.nonterminalMaximumAuthorityEncodedBytes) -or
    [int]$registry.substructures.recoveryArtifactRow.frontierMaximumBytes -ne ([int]$registry.substructures.recoveryArtifactRow.frontierHeaderBytes + [int]$registry.substructures.recoveryArtifactRow.frontierEntryBytes * [int]$registry.substructures.recoveryArtifactRow.frontierMaximumCount) -or
    [int]$registry.substructures.recoveryArtifactRow.frontierCheckpointMaximumBytes -ne ([int]$registry.substructures.recoveryArtifactRow.frontierCheckpointFixedBytes + [int]$registry.substructures.recoveryArtifactRow.frontierCheckpointEntryBytes * [int]$registry.substructures.recoveryArtifactRow.frontierCheckpointMaximumCount) -or
    [int]$registry.substructures.recoveryArtifactRow.drtCatalogMaximumBytes -ne ([int]$registry.substructures.recoveryArtifactRow.drtCatalogFixedBytes + [int]$registry.substructures.recoveryArtifactRow.drtCatalogEntryBytes * [int]$registry.substructures.recoveryArtifactRow.drtCatalogMaximumCount + [int]$registry.substructures.recoveryArtifactRow.drtCatalogHistoryEntryBytes * [int]$registry.substructures.recoveryArtifactRow.drtCatalogMaximumHistoryCount) -or
    [int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryMaximumBytes -ne ([int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryFixedBytes + [int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryEntryBytes * [int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryMaximumCount) -or
    [int]$registry.substructures.recoveryArtifactRow.commonMaximumComponentEncodedBytes -ne ([int]$registry.substructures.recoveryArtifactRow.maximumPlaintextBytes - [int]$registry.substructures.recoveryArtifactRow.terminalFixedBytes - [int]$registry.substructures.recoveryArtifactRow.frontierCheckpointMaximumBytes - [int]$registry.substructures.recoveryArtifactRow.frontierMaximumBytes - [int]$registry.substructures.recoveryArtifactRow.resetAuthorityHeadBytes - [int]$registry.substructures.recoveryArtifactRow.drtCatalogMaximumBytes - [int]$registry.substructures.recoveryArtifactRow.witnessHeadHistoryMaximumBytes) -or
    [int]$registry.substructures.recoveryArtifactRow.terminalMaximumCount -ne ([int]$registry.substructures.recoveryArtifactRow.authorityGenesisRows + [int]$registry.substructures.recoveryArtifactRow.maximumRootTransitionRows + [int]$registry.substructures.recoveryArtifactRow.maximumDwdAncestryRows + [int]$registry.substructures.recoveryArtifactRow.terminalDwtRows + [int]$registry.substructures.recoveryArtifactRow.maximumComponentRows) -or
    [int]$registry.substructures.recoveryArtifactRow.nonterminalMaximumCount -ne ([int]$registry.substructures.recoveryArtifactRow.authorityGenesisRows + [int]$registry.substructures.recoveryArtifactRow.maximumRootTransitionRows + [int]$registry.substructures.recoveryArtifactRow.maximumDwdAncestryRows + [int]$registry.substructures.recoveryArtifactRow.maximumComponentRows)) {
    Fail 'fixed substructure arithmetic drifted'
}
$recoveryArtifactNames = @('overheadBytes','prefixBytes','projectionBytes','frontierCheckpointFixedBytes','frontierCheckpointEntryBytes','frontierCheckpointMaximumCount','frontierCheckpointMaximumBytes','frontierHeaderBytes','frontierEntryBytes','frontierMaximumCount','frontierMaximumBytes','resetAuthorityHeadBytes','drtCatalogFixedBytes','drtCatalogEntryBytes','drtCatalogMaximumCount','drtCatalogHistoryEntryBytes','drtCatalogMaximumHistoryCount','drtCatalogMaximumBytes','witnessHeadHistoryFixedBytes','witnessHeadHistoryEntryBytes','witnessHeadHistoryMaximumCount','witnessHeadHistoryMaximumBytes','terminalMaximumCount','nonterminalMaximumCount','authorityGenesisRows','maximumRootTransitionRows','maximumDwdAncestryRows','terminalDwtRows','nonterminalTerminalRows','maximumCurrentRoleTransitionRows','maximumCurrentNontransitionRows','maximumHistoricalResetAuthorityRows','maximumComponentRows','terminalMaximumAuthorityEncodedBytes','terminalFixedBytes','nonterminalMaximumAuthorityEncodedBytes','nonterminalFixedBytes','commonMaximumComponentEncodedBytes','maximumPlaintextBytes','layout')
Assert-ExactProperties -Object $registry.substructures.recoveryArtifactRow -Required $recoveryArtifactNames -Allowed $recoveryArtifactNames -Name 'recovery artifact closure'
$expectedComponentKinds = @('1:Registry','2:XNode','3:Shared','4:MAUI')
$actualComponentKinds = @($registry.componentKinds | ForEach-Object { "$([int]$_.id):$([string]$_.name)" })
if (($actualComponentKinds -join '|') -ne ($expectedComponentKinds -join '|')) {
    Fail 'closed component-kind registry drifted'
}
$componentSchema = $registrySchema.properties.componentKinds
if (@($componentSchema.prefixItems).Count -ne 4 -or $componentSchema.items -ne $false -or $componentSchema.uniqueItems -ne $true) {
    Fail 'component-kind schema is not an exact closed ordered table'
}
for ($i = 0; $i -lt 4; $i++) {
    if (($registry.componentKinds[$i] | ConvertTo-Json -Compress) -ne ($componentSchema.prefixItems[$i].const | ConvertTo-Json -Compress)) {
        Fail "component-kind schema mapping drifted at index $i"
    }
}
$releaseRootTrustNames = @('carrier','source','pinFields','fingerprint','manifestSignerProvenance','pinCardinality','sealedFactory','genesisGeneration','genesisPredecessorRef','firstTransitionGeneration','transitionRule','dwdRule','lkg','lkgHmac','maximumRootTransitionCount','maximumDwdAncestryCount','oldKeyHash','rotationCommit','genesisInitialization','witnessEpoch','effectiveTime','terminalReceipt','terminalMutation','terminalEffect','forkRule','recovery','witnessHeadHistory','chainExhaustion','consumerBinding','unknownOrMissing')
Assert-ExactProperties -Object $registry.releaseRootTrust -Required $releaseRootTrustNames -Allowed $releaseRootTrustNames -Name 'release-root trust input'
$releaseRootSchemaNames = @($registrySchema.properties.releaseRootTrust.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$releaseRootSchemaRequired = @($registrySchema.properties.releaseRootTrust.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.releaseRootTrust.additionalProperties -ne $false -or
    ($releaseRootSchemaNames -join '|') -ne ($releaseRootTrustNames -join '|') -or
    ($releaseRootSchemaRequired -join '|') -ne ($releaseRootTrustNames -join '|')) {
    Fail 'release-root trust schema property set/order is not exact and closed'
}
if ($registry.releaseRootTrust.carrier -ne 'RRM1-signed-release-root-manifest' -or
    $registry.releaseRootTrust.source -ne 'read-only-release-root-manifest-pin-v1-from-software-release-trust-outside-resettable-stores' -or
    $registry.releaseRootTrust.pinFields -ne 'network16|manifest-signer-key-id32|manifest-signer-ed25519-public32|minimum-manifest-generation-u64be-zero|expected-RRM1-ref38' -or
    $registry.releaseRootTrust.fingerprint -ne 'sha256-d(Deep/Cutover/V1/release-root-genesis,network16|manifest-signer-key-id32|manifest-signer-ed25519-public32|minimum-manifest-generation-u64be-zero|expected-RRM1-ref38)' -or
    $registry.releaseRootTrust.manifestSignerProvenance -notmatch 'offline-software-release-trust-root' -or
    $registry.releaseRootTrust.pinCardinality -notmatch 'exactly-one-row' -or
    $registry.releaseRootTrust.sealedFactory -notmatch 'returns-sealed-signature-relative-fact' -or
    $registry.releaseRootTrust.sealedFactory -notmatch 'no-public-authority-conversion' -or
    [uint64]$registry.releaseRootTrust.genesisGeneration -ne 0 -or
    $registry.releaseRootTrust.genesisPredecessorRef -ne 'exact-RRM1-ArtifactRef38' -or
    [uint64]$registry.releaseRootTrust.firstTransitionGeneration -ne 1 -or
    $registry.releaseRootTrust.transitionRule -notmatch 'current-generation-plus-one' -or
    $registry.releaseRootTrust.dwdRule -notmatch 'never-zero' -or
    $registry.releaseRootTrust.lkg -notmatch 'RRL1-HMAC-CAS' -or
    $registry.releaseRootTrust.lkgHmac -notmatch 'non-DB-key-id' -or
    [int]$registry.releaseRootTrust.maximumRootTransitionCount -ne 64 -or
    [int]$registry.releaseRootTrust.maximumDwdAncestryCount -ne 65 -or
    $registry.releaseRootTrust.oldKeyHash -ne $registry.hashTranscripts.releaseRootKeyHash -or
    $registry.releaseRootTrust.rotationCommit -notmatch 'KRT1-successor-DWD1-and-RRL1' -or
    $registry.releaseRootTrust.genesisInitialization -notmatch 'witnessEpoch-one' -or
    $registry.releaseRootTrust.genesisInitialization -notmatch 'one-transaction-first-DWD-generation-zero.*genesis-RRL' -or
    $registry.releaseRootTrust.witnessEpoch -notmatch 'exactly-one-no-reuse' -or
    $registry.releaseRootTrust.effectiveTime -notmatch 'DWD-validFrom-greater-than-or-equal-KRT-effectiveAt' -or
    $registry.releaseRootTrust.effectiveTime -notmatch 'txNow-greater-than-or-equal-both' -or
    $registry.releaseRootTrust.terminalReceipt -notmatch 'DWT1-exact-three-of-four-durable-receipts-before-local-terminal-RRL-CAS' -or
    $registry.releaseRootTrust.terminalMutation -notmatch 'HMAC-verify-old-WHL.*rewrite-only-WHL-current-release-root-authority-head-plus-HMAC.*stale-WHL-authority-head-reject.*exact-old-or-new-RRL-WHL-pair' -or
    $registry.releaseRootTrust.terminalEffect -notmatch 'invalidates-root-DWD-and-referencing-leases' -or
    $registry.releaseRootTrust.forkRule -notmatch 'permanently-latches' -or
    $registry.releaseRootTrust.recovery -notmatch 'complete-DWD-ancestry-one-through-65' -or
    $registry.releaseRootTrust.recovery -notmatch 'successor DWD consumes exact protected witness-head-history.*genesis restore synthesizes predecessorEpoch0 plus zero288' -or
    $registry.releaseRootTrust.recovery -notmatch 'DWT1-iff-terminal' -or
    $registry.releaseRootTrust.recovery -notmatch 'nonterminal-requires-fresh-exact-three-of-four-DCL' -or
    $registry.releaseRootTrust.witnessHeadHistory -notmatch 'WHL1 exact222\+342N.*Deep/ProtectedState/V1/WHL1' -or
    $registry.releaseRootTrust.witnessHeadHistory -notmatch 'Genesis activation atomically creates DWD/RRL/DWL plus WHL1 count0' -or
    $registry.releaseRootTrust.witnessHeadHistory -notmatch 'ordinary KRT\+DWD or independent successor DWD.*CASes successor DWD, RRL, new DWL and WHL1 including the exact new RRL authority head together' -or
    $registry.releaseRootTrust.witnessHeadHistory -notmatch 'Terminal KRF/DWT HMAC-verifies old WHL.*rewrites only WHL current-release-root-authority-head plus HMAC.*stale old head rejects.*exact old or new RRL/WHL pair' -or
    $registry.releaseRootTrust.witnessHeadHistory -notmatch 'never capsule authority.*cannot be reconstructed.*destructive reset' -or
    $registry.releaseRootTrust.chainExhaustion -notmatch 'root-transition-65-or-DWD-ancestry-record-66-terminal-fail-closed' -or
    $registry.releaseRootTrust.consumerBinding -notmatch 'consumer-internal-verified-deployment-source' -or
    $registry.releaseRootTrust.consumerBinding -notmatch 'no-public-Protocol-caller-authority-input' -or
    $registry.releaseRootTrust.unknownOrMissing -ne 'fail-closed-before-signature-or-network' -or
    $registry.hashTranscripts.releaseRootGenesis -ne $registry.releaseRootTrust.fingerprint) {
    Fail 'external ReleaseRoot genesis trust, transition or sealed consumer binding drifted'
}
$wireEnumNames = @($registry.wireEnums.PSObject.Properties | ForEach-Object { [string]$_.Name })
$expectedWireEnumNames = @(
    'dpaMinimumSuite','dpdSuite','dpdCapabilities','dpmCapabilities','drtTargetKind','drsReason','draReason',
    'keyScope','keyAction','dxpRole','dxpIdentityIssuanceSourceKind','routerRoles','routerCapabilities','dpcEndpointKind','dpcFlags',
    'witnessEndpointKind','dcnDurabilityClass','componentMask','outerPeerOperation','innerPrq2Operation',
    'dpjPhase','dxrPhase','booleanByte','rip2ProtocolVersion','unknownPolicy','drtTargetPolicy','keyPolicy','dxpPolicy',
    'routerPolicy','dpcPolicy','reasonPolicy','phasePolicy','reservedPolicy'
)
$schemaWireEnumNames = @($registrySchema.properties.wireEnums.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$schemaWireRequired = @($registrySchema.properties.wireEnums.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.wireEnums.additionalProperties -ne $false -or
    ($schemaWireEnumNames -join '|') -ne ($expectedWireEnumNames -join '|') -or
    ($schemaWireRequired -join '|') -ne ($expectedWireEnumNames -join '|')) {
    Fail 'wire enum schema property set/order is not exact and closed'
}
$constWireEnumNames = @('dpaMinimumSuite','dpdSuite','dpdCapabilities','dpmCapabilities','drtTargetKind','drsReason','draReason','keyScope','keyAction','dxpRole','dxpIdentityIssuanceSourceKind','routerRoles','routerCapabilities','dpcEndpointKind','dpcFlags','witnessEndpointKind','dcnDurabilityClass','componentMask','outerPeerOperation','innerPrq2Operation','dpjPhase','dxrPhase','booleanByte','rip2ProtocolVersion')
foreach ($name in $constWireEnumNames) {
    if (($registry.wireEnums.$name | ConvertTo-Json -Compress) -ne ($registrySchema.properties.wireEnums.properties.$name.const | ConvertTo-Json -Compress)) {
        Fail "wire enum schema const drifted: $name"
    }
}
if (($wireEnumNames -join '|') -ne ($expectedWireEnumNames -join '|') -or
    [uint16]$registry.wireEnums.dpaMinimumSuite -ne 1 -or
    [uint16]$registry.wireEnums.dpdSuite -ne 1 -or
    [uint64]$registry.wireEnums.dpdCapabilities.MailboxRoleIssuer -ne 1 -or
    [uint64]$registry.wireEnums.dpdCapabilities.allowedMask -ne 1 -or
    $registry.wireEnums.dpdCapabilities.requiredNonzero -ne $true -or
    [uint64]$registry.wireEnums.dpmCapabilities.RouteOwnerControl -ne 1 -or
    [uint64]$registry.wireEnums.dpmCapabilities.RouterCertificateIssuer -ne 2 -or
    [uint64]$registry.wireEnums.dpmCapabilities.allowedMask -ne 3 -or
    $registry.wireEnums.dpmCapabilities.requiredNonzero -ne $true -or
    (@($registry.wireEnums.drtTargetKind) -join '|') -ne 'DeviceCertificate=1|MailboxRoleCertificate=2|AccountTerminal=3' -or
    (@($registry.wireEnums.drsReason) -join '|') -ne 'KeyCompromise=1|DeviceLost=2|RoleRetired=3|AccountShutdown=4' -or
    (@($registry.wireEnums.draReason) -join '|') -ne 'UserInitiatedRecovery=1|KeyCompromise=2|AdministrativeReset=3' -or
    (@($registry.wireEnums.keyScope) -join '|') -ne 'ReleaseRoot=1|DeviceCertificateIssuer=2|AccountRevocation=3|ResetControl=4' -or
    (@($registry.wireEnums.keyAction) -join '|') -ne 'Rotate=1|Revoke=2' -or
    (@($registry.wireEnums.dxpRole) -join '|') -ne 'Device=1|Router=2' -or
    (@($registry.wireEnums.dxpIdentityIssuanceSourceKind) -join '|') -ne 'OfflineAccountDeviceGenesis=1|CurrentCutoverRouter=2' -or
    (@($registry.wireEnums.dpcEndpointKind) -join '|') -ne 'IPv4=1|IPv6=2|DNS=3' -or
    [uint64]$registry.wireEnums.routerRoles.PeerIngress -ne 1 -or
    [uint64]$registry.wireEnums.routerRoles.PeerCore -ne 2 -or
    [uint64]$registry.wireEnums.routerRoles.MailboxReplica -ne 4 -or
    [uint64]$registry.wireEnums.routerRoles.allowedMask -ne 7 -or
    $registry.wireEnums.routerRoles.requiredNonzero -ne $true -or
    [uint64]$registry.wireEnums.routerCapabilities.NativePeerMailboxV2 -ne 1 -or
    [uint64]$registry.wireEnums.routerCapabilities.ClientMailboxIngressV2 -ne 2 -or
    [uint64]$registry.wireEnums.routerCapabilities.ProductionMailboxCacheV2 -ne 4 -or
    [uint64]$registry.wireEnums.routerCapabilities.ProductionMailboxCapacityV1 -ne 8 -or
    [uint64]$registry.wireEnums.routerCapabilities.MembershipCatalogV2 -ne 16 -or
    [uint64]$registry.wireEnums.routerCapabilities.allowedMask -ne 31 -or
    $registry.wireEnums.routerCapabilities.requiredNonzero -ne $true -or
    [uint64]$registry.wireEnums.dpcFlags.NoNextPin -ne 1 -or
    [uint64]$registry.wireEnums.dpcFlags.allowedMask -ne 1 -or
    (@($registry.wireEnums.witnessEndpointKind) -join '|') -ne 'IPv4=1|IPv6=2' -or
    (@($registry.wireEnums.dcnDurabilityClass) -join '|') -ne 'FsyncReplicated=1' -or
    [uint64]$registry.wireEnums.componentMask -ne 15 -or
    (@($registry.wireEnums.outerPeerOperation) -join '|') -ne 'MailboxPeerV2=1' -or
    (@($registry.wireEnums.innerPrq2Operation) -join '|') -ne 'Store=1|Tombstone=2' -or
    (@($registry.wireEnums.dpjPhase) -join '|') -ne 'Prepared=0|InnerPending=1|Completed=2' -or
    (@($registry.wireEnums.dxrPhase) -join '|') -ne 'Pending=0|Verified=1|Aborted=2' -or
    (@($registry.wireEnums.booleanByte) -join '|') -ne '0|1' -or
    [uint16]$registry.wireEnums.rip2ProtocolVersion -ne 2 -or
    $registry.wireEnums.routerPolicy -notmatch 'DPC1-capabilities-equal' -or
    $registry.wireEnums.reasonPolicy -notmatch 'AccountTerminal-requires-AccountShutdown' -or
    $registry.wireEnums.phasePolicy -notmatch 'DPL-DWL-fork-latches-use-only-0-or-1' -or
    $registry.wireEnums.reservedPolicy -notmatch 'unknown-enum-or-mask-reject-before-callback') {
    Fail 'closed scalar and bit-mask registry drifted'
}
$membershipProof = $registry.membershipProof
if ($membershipProof.outerCarrier -ne 'MIP1-byte-and-api-identical' -or
    $membershipProof.outerType -ne 'Deep.Protocol.DeepExtension.MailboxCapabilities.MailboxReplicaMembershipProof' -or
    $membershipProof.outerCodec -ne 'MailboxPeerReplicationCodec.EncodeMembershipProof/DecodeMembershipProof' -or
    $membershipProof.outerLayout -notmatch 'SigningPublicKey32@40' -or
    $membershipProof.outerLayout -notmatch 'opaque-inner@120' -or
    $membershipProof.p04RejectedType -notmatch 'MembershipInclusionProof-72-plus-32N-no-opaque-carrier' -or
    $membershipProof.innerRecord -ne 'RIP2' -or
    (@($membershipProof.legacyRejectedBeforeAllocation) -join '|') -ne 'RIP1|MRL1' -or
    [int]$membershipProof.minimumInnerBytes -ne 573 -or
    [int]$membershipProof.maximumInnerBytes -ne 957 -or
    [int]$membershipProof.minimumOuterBytes -ne 693 -or
    [int]$membershipProof.maximumOuterBytes -ne 1077 -or
    [int]$membershipProof.maximumSiblingCount -ne 12 -or
    [int]$membershipProof.maximumMembers -ne 4096 -or
    $membershipProof.siblingOrder -notmatch 'leaf-to-root' -or
    $membershipProof.sealedVerifier -notmatch 'sealed-MRLC' -or
    $membershipProof.sealedVerifier -notmatch 'projection root' -or
    $membershipProof.sealedVerifier -notmatch 'standalone RIP2 or projection has no ref authority') {
    Fail 'MIP1/RIP2 sealed membership-proof contract drifted'
}
$identifierNames = @('mailboxOwnerId','mailboxRoleBinding','mailboxRoleRotation','routerId','componentSubject','selfReferenceAudit','nonzero','mailboxCollisionScope','routerCollisionScope')
Assert-ExactProperties -Object $registry.identifiers -Required $identifierNames -Allowed $identifierNames -Name 'identifier provenance'
$identifierSchemaNames = @($registrySchema.properties.identifiers.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$identifierSchemaRequired = @($registrySchema.properties.identifiers.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.identifiers.additionalProperties -ne $false -or
    ($identifierSchemaNames -join '|') -ne ($identifierNames -join '|') -or
    ($identifierSchemaRequired -join '|') -ne ($identifierNames -join '|')) {
    Fail 'identifier provenance schema closure drifted'
}
if ($registry.identifiers.mailboxOwnerId -ne 'sha256-d(Deep/IdentityAuth/V1/mailbox-owner-id, network16|account-hash32|mailbox-ed25519-public32)' -or
    $registry.identifiers.mailboxRoleBinding -ne 'DPMC-verifier-recomputes-owner-id-then-verifies-exact-DPDC-account-device-authorization-and-mailbox-role-PoP' -or
    $registry.identifiers.mailboxRoleRotation -ne 'changed-mailbox-ed25519-public-key-produces-new-owner-id' -or
    $registry.identifiers.routerId -ne 'sha256-d(Deep/NativeRouting/V1/router-id, network16|mailbox-owner-id32|router-generation8|router-ed25519-public32)' -or
    $registry.identifiers.componentSubject -ne 'sha256-d(Deep/Cutover/V1/component-subject, network16|account-hash32|component-kind2|account-revocation-handle32)' -or
    $registry.identifiers.selfReferenceAudit -ne 'mailbox-owner-router-and-component-subject-preimages-exclude-the-containing-artifact-ref-and-derived-target-hash' -or
    $registry.identifiers.nonzero -ne $true -or
    $registry.identifiers.mailboxCollisionScope -ne 'same-network-and-account-different-preimage-latches-account' -or
    $registry.identifiers.routerCollisionScope -ne 'same-network-different-preimage-latches-routing-domain') {
    Fail 'mailbox owner/router identifier provenance or collision policy drifted'
}
$apiInvariantNames = @('rrmPreflight','rrmTime','relativeResult','authorityConversion','dwdRestore','authorityTuple','authorityCas','hmacTranscript','hmacKeyId','recoveryFreeze','recoveryExpectedContext','recoveryProvider','genesisProtectedKeySet','genesisIdentitySource','cutoverManifestAuthor','genesisResetReservation','genesisCandidateAuthoring','genesisAuthorReplayRestore','deploymentGovernance','recoveryNonce','recoveryPlaintext','cancellation','commitAuthority','consumerFinalRecheck','mrlProjectionBoundary','mrlCompositeCas','mrlCacheIdentity','dxpProjection','dxpReceipt','dxpNonce','dxpFinalCas','mrlCurrentInputs','mrlContinuity','mrlSourceCas','genesisReplayDisposition','callbackOrder')
Assert-ExactProperties -Object $registry.apiInvariants -Required $apiInvariantNames -Allowed $apiInvariantNames -Name 'API invariants'
$apiSchemaNames = @($registrySchema.properties.apiInvariants.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$apiSchemaRequired = @($registrySchema.properties.apiInvariants.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.apiInvariants.additionalProperties -ne $false -or
    ($apiSchemaNames -join '|') -ne ($apiInvariantNames -join '|') -or
    ($apiSchemaRequired -join '|') -ne ($apiInvariantNames -join '|')) {
    Fail 'API invariant schema closure drifted'
}
if ($registry.apiInvariants.deploymentGovernance -notmatch 'DRM20 introduces immutable deployment governance.*untrusted defensively-owned DGO1-282 and DGI1-160.*RelativeRRM is never authority' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'ASCII magic DGO1,DGI1,GAR1,GDI1,GRA1 or GMD1 plus version1=1 and reserved3=zero.*mismatch rejects before mutation' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'header8,network16@8,manifestGeneration8@24,environmentResetId32@32,activationAt8@64,componentMask8@72,componentCount2@80,four kind-ordered component schema rows168@82,manifestSignerPublic32@250' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'network,manifestGeneration,environmentResetId,activationAt,componentMask each fixed-time equal the signed RRM counterpart.*DGOHash equals signed RRM.schemaFingerprint.*deploymentGovernanceBootstrapHash32.*every governanceHash32 equals it, never DGOHash or DGI hash' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'Bootstrap and the stable environment index.*derive only from the same verified common RRM/DGO tuple' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'DGI1 exact160.*RRMRef38@8.*DGOHash32@46.*sourceRevision8@78.*retainUntil8@86.*state1@94 Retained=1 only.*forkLatch1@95.*protectedKeyId32@96.*HMAC32@128' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'FirstDeployment=1 exact197.*bootstrapSubject32 fixed-time equals deploymentGovernanceBootstrapHash32 from the sealed governance context.*SameAccount=2 exact203.*AccountReset=3 exact65.*AccountResetOrigin exact588' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'GAR1 exact742.*verifiedResetTranscript588@8.*originHash32@596.*operationId32@628.*sourceRevision8@660.*retainUntil8@668.*state1@676 Retained=1 only.*fork@677.*keyId@678.*HMAC@710.*separately referenced exact evidence.*without inlining.*accountResetOriginReceiptHash' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'GDI1 exact1031.*phase@965.*HMAC@999.*GRA1 exact980.*GARReceiptHash@8.*phase@914.*HMAC@948' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'Prepared=1 all signature slots zero and Signed=2 complete only.*DCM order is new ResetControl then account PoP.*DRA order old ResetControl,new Account,new ResetControl' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'GMD1 exact447.*branchKind@8.*branchHash@9.*authorSetHash@41.*bitmap@300.*revisions@301.*HMAC@415.*one Protocol-verified branch transcript is the sole branch source.*Signed GDI and GMD branch kind/hash fixed-time equal it and each other.*authorSet branch kind equals GDI.*GMD accountGeneration,accountHash,resetId,resetGeneration,DCMRef,predecessorDCMRef and governanceHash equal fields parsed from the frozen signed DCM and verified branch.*Committed=1 starts bitmap/revisions zero.*atomic Distributed=2 only after bitmap0x0f plus four fresh rereads.*immutable' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'reservationHash is exact nonzero First/Reset and zero Same.*GRA exists iff Reset.*signedGRA/DRARef zero iff First/Same and exact iff Reset.*predecessorDCMRef zero First/Reset and exact prior Same.*GAR/GDI/GRA/GMD operationId is identical' -or
    $registry.apiInvariants.deploymentGovernance -notmatch 'AuthorCutoverManifestAsync consumes only sealed governance context.*sole source of exact DGO schemas/activation/bootstrapHash.*accepts no caller VerifiedComponentSchemaSet,schema row,activation or governance hash.*createdAt remains a distinct trusted input.*data-only DRA/DWH verifiers.*RelativeRRM laundering.*DRM19 and earlier reject without reinterpretation') {
    Fail 'DRM20 deployment governance API closure drifted'
}
if ((8 + 1 + 32 + 32 + 8 + 32 + 32 + 8 + 38 + 38 + 38 + 32 + 1 + 1 + 32 + 32 + 8 + 8 + 1 + 1 + 32 + 32) -ne 447) {
    Fail 'GMD1 exact447 field arithmetic drifted'
}
if ($registry.apiInvariants.rrmPreflight -ne 'freeze-exact-canonical-RRM1-332-and-full-pin-tuple-network16-manifest-signer-key-id32-manifest-signer-ed25519-public32-minimum-generation-u64be-zero-expected-RRM1-ref38; recompute-reference-and-fixed-time-compare-every-pin-field-before-Ed25519-callback' -or
    $registry.apiInvariants.rrmTime -ne 'caller-supplies-one-authoritative-txNow-u64; copy-once-before-callback; require-manifest-generation-equals-minimum-manifest-generation-equals-zero-and-txNow-at-least-activationAt; verifier-has-no-clock-callback' -or
    $registry.apiInvariants.relativeResult -ne 'public-results-are-sealed-defensively-owned-nonserializable-signature-relative-facts-with-no-durable-authority' -or
    $registry.apiInvariants.authorityConversion -ne 'no-public-constructor-factory-conversion-or-method-mints-genesis-or-durable-authority-from-raw-key-fingerprint-policy-pin-or-relative-result; consumer-internal-verified-deployment-source-alone-combines-relative-fact' -or
    $registry.apiInvariants.dwdRestore -ne 'preflight-complete-bounded-closure-before-callbacks; exact-RRM1; zero-through-64-ordered-KRT1-or-KRF1-root-transitions; complete-one-through-65-DWD1-ancestry with exact DWH1 predecessor-head input for every successor; genesis DWD requires zero predecessorFinalHeadsHash and no DWH entry and its verifier input is internally synthesized as predecessorEpoch0 plus zero288; each-KRT1-paired-with-exact-successor-DWD1; DWT1-iff-terminal-else-fresh-exact-DCL1; reject-skip-tail-duplicate-same-generation-fork-or-unconsumed-entry' -or
    $registry.apiInvariants.authorityTuple -ne 'genesis-RRM1-ref38|current-generation8|current-public32|current-transition-ref38|terminal-KRF1-ref38|terminal-state1|fork-latch1|latest-DWD-generation8|latest-DWD-ref38|latest-witness-epoch8|chain-entry-count2|chain-checkpoint-hash32|terminal-DWT1-ref38' -or
    $registry.apiInvariants.authorityCas -ne 'transition-plan-defensively-owns-exact-old-authority-tuple-and-exact-new-authority-tuple; store-CAS-is-old-to-new-full-tuple-only; no-ad-hoc-PlanHash-generation-only-bool-or-caller-authority' -or
    $registry.apiInvariants.hmacTranscript -ne 'Protocol-returns-only-exact-unsigned-protected-transcript-domain-suite-and-key-id; never-accepts-or-returns-HMAC-key-and-never-claims-durable-authority' -or
    $registry.apiInvariants.hmacKeyId -ne 'key-id32-is-nonzero-fixed-preflighted-before-HMAC-callback; callback-output-is-frozen-once-then-locally-verified-and-only-owned-tag-is-used' -or
    $registry.apiInvariants.recoveryFreeze -ne 'preflight-bounds-and-defensively-copy-all-DRC1-metadata-ciphertext-and-provider-input-before-callback-or-await; no-public-seed-key-or-nonce-override' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'candidateBoundDrcFields=network16\|componentSubject32\|accountGeneration8\|DCMRef38\|DRSRef38\|shadowStateHash32\|nextPinCoreHash32\|protectorKeyId32' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'sealed internally-constructed tagged union with exactly one of three outer branches and no optional or generic branch' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'NormalCurrentStore owns ExistingDPL=1, VerifiedCurrentReleaseRootContext, VerifiedCurrentIdentityContext and a VerifiedPredecessorCutoverContext whose exact nonzero full DPL and source are current at T1; its anchor is zero' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'ColdExternalCheckpoint owns ExistingDPL=1 and a closed nested authority tag: Nonterminal owns exact fresh DCL and forbids DWT; Terminal owns exact DWT and forbids DCL and can return only terminal/no-use; its old DPL is exact nonzero and anchor is zero' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'before AEAD it trusts no caller fingerprint or witness row' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'Outer branch and predecessor kind are one closed discriminant' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'DRM1/DRM2/DRM3/DRM4/DRM5/DRM6/DRM7/DRM8/DRM9/DRM10/DRM11/DRM12/DRM13/DRM14/DRM15/DRM16/DRM17/DRM18/DRM19 reject without reinterpretation' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'verifies exact-RSM2-723 hashes to frozen DRC1 shadowStateHash' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'HMAC-verifies RFC/RAH/DTC/DWH, restores RRM plus scope1 KRT/KRF and full DWD/DWH ancestry, and only then verifies exact DWT or witness-verifies external DCL/DCQ/DRC/current head' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'restores three current scopes2\.\.4 role chains, exact historical old-DPA/scope4-KRT chain iff DRA, exact-compares RAH head, verifies DRA old signature' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'RFC, RAH, DTC and DWH use reset-surviving external HSM lookup by one exact shared ProtectedStateHmac keyId' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'mints VerifiedRecoveredIdentityContext from owned current rows' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'VerifiedRecoveredCutoverCheckpoint is minted only from the HMAC-protected containers plus witness-authenticated DRC/RSM and exact terminal-or-nonterminal evidence' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'Existing recoveryOldProtectedSource binds predecessor kind, exact oldDPLRef, zero anchor, release, identity, current cutover, DWT-or-DCL and all key IDs under T1 lock' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'Genesis oldSource-v2 binds predecessor kind, zero oldDPLRef, exact anchor, exact GenesisReleaseContextV1 and genesis source, hardcodes terminal0 and zero DWTRef/DCLRef/DCL expiry' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'Candidate DRC/DCP/DCS/DCQ/DPL are separate from the predecessor' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'no invariant compares old DCP.capsuleRef to candidate DRC' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'sequence1 predecessor zero.*expectedSequence0 and zero expectedDCSRef' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'linearizable zero-to-one external CAS plus three-of-four DCQ and capsule durability is the sole absence proof' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'DCL1 gains no zero grammar' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'GenesisReleaseContextV1 rechecks exact forkLatch0 and the exact nonterminal RRL/WHL head at mint, pre-author and final CAS: DWT or DCL substitution causes terminal/fail-closed before authoring and zero candidate refs' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'Normal pre/post/final rechecks full predecessor and candidate contexts' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'Cold final CAS rechecks the recovered receipt, exact terminal DWT or nonterminal DCL' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'GenesisReleaseContextV1 rechecks exact forkLatch0 and the exact nonterminal RRL/WHL head' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'ExternalCheckpointAhead with zero publication' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'Capsule rows never directly mint capabilities' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'Raw keys, pins, tuples and caller factories reject' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'no authority or durability claim' -or
    $registry.apiInvariants.recoveryProvider -ne 'RecoveryProviderRegistryContext is sealed reset-surviving defensively owned nonserializable and internally minted only by a typed external registry verifier; its exact 158-byte scope is network16|resetId32|componentSubject32|accountGeneration8|rowCount2-equals2|kind1-u16-equals1|ProtectedStateHmacKeyId32|kind2-u16-equals2|RecoveryNonceLatchKeyId32; both IDs are nonzero and distinct; verifier internally selects immutable deployment resetId without caller input then lookup freezes DRC operation selector network16|componentSubject32|accountGeneration8|transactionId32|protectorKeyId32 and returns monotonic sourceRevision8 with both roles healthy; Protocol pre-AEAD validates canonical scope rows revision health and operation selector but terminal cold has no independent reset comparator; no raw ID key public factory optional row role substitution or caller selection; Protocol derives the HKDF key and nonce and fixed-time compares the derived nonce with the stored nonce before AEAD open' -or
    $registry.apiInvariants.genesisProtectedKeySet -notmatch 'exact 296-byte key-only scope.*rowCount2-equals6.*kinds1=DPL,2=DWL,3=RRL,4=RIB,5=MRLC,6=DXR' -or
    $registry.apiInvariants.genesisProtectedKeySet -notmatch 'pairwise distinct.*ProtectedStateHmac, RecoveryNonceLatch and DRC protector.*DPL HMAC uses only kind1 DPL' -or
    $registry.apiInvariants.genesisProtectedKeySet -notmatch 'reservation is idempotent only for the byte-identical set.*permanently fork-latches.*GC reaches zero' -or
    $registry.apiInvariants.genesisProtectedKeySet -notmatch 'GenesisIdentityContext.*GenesisReleaseContextV1.*GenesisComponentIntent.*GenesisCutoverSourceContext.*exact492 and anchor460' -or
    $registry.apiInvariants.genesisIdentitySource -notmatch 'VerifiedGenesisBaseIdentityContext.*no DTC2 hash/key and no Source authority' -or
    $registry.apiInvariants.genesisIdentitySource -notmatch 'genesis DTC2.*oldDPLRef38=zero and oldSourceFingerprint32=zero.*ExistingDPL DTC2 requires both fields nonzero' -or
    $registry.apiInvariants.genesisIdentitySource -notmatch 'CurrentProtectedStore or RecoveredDRM20.*base context alone cannot mint Source or authority' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'AuthorCutoverManifestAsync.*single deployment-wide DCM1 prerequisite.*sealed deployment-governance context owning exact DGO1 rows/activationAt/deploymentGovernanceBootstrapHash32' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'accepts no caller schema set, schema row, activationAt or governance hash.*DCM schemas and activationAt come byte-exactly from DGO1.*branch governanceHash equals the bootstrap166 hash' -or
    $registry.apiInvariants.cutoverManifestAuthor -match 'Inputs are sealed DPA1.*VerifiedComponentSchemaSet.*activationAt8, createdAt8' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'freezes one unsigned DCM transcript before either callback.*canonical DCM1 exact812.*branch-exact.*all four components' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'exactly one Protocol-derived sealed ResetManifestPredecessorIntent branch whose verified transcript is the sole branch source.*FirstDeployment owns the exact provider-HMAC-verified nonzero CSPRNG deploymentWideResetId32.*resetGeneration1.*zero predecessorDCMRef38' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'SameAccountSuccessor owns the exact current signed predecessor DCM1.*preserves its account generation and resetId byte-exact.*increments resetGeneration by one' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'AccountResetSuccessor owns a sealed verified old/new account-reset intent.*new accountGeneration=old\+1.*provider-HMAC-verified fresh nonzero resetId unequal to the old resetId' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'first authors the new DCM then authors DRA1 binding its exact ref.*one atomic old-terminal-account/DCM/DRS to new-DCM-plus-DRA CAS' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'Any AccountTerminal on the candidate/current DRS side.*fails before signer/HMAC or publication.*accepted only in the sealed verified DRA old-side tuple' -or
    $registry.apiInvariants.cutoverManifestAuthor -notmatch 'Signed GDI/GMD branch kind/hash, author-set kind and the parsed frozen signed DCM/branch axes must all match byte-exactly.*same-operation cross-branch substitution rejects before mutation' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'GenesisAuthorReplay.*zero old DPL, DWT and DCL.*Created.*ExternalCommitted.*LocalCommitted' -or
    $registry.apiInvariants.recoveryExpectedContext -notmatch 'After external success GenesisAuthorReplay CASes GAJ1 to ExternalCommitted and empty-local-to-candidate CAS completes before GAJ1 LocalCommitted.*committed candidate becomes a predecessor only after fresh later restore' -or
    $registry.apiInvariants.genesisResetReservation -notmatch 'RestoreOrReserveGenesisResetIdByScopeAsync.*exact235-byte scope intent.*neither operationId nor candidate reset ID.*SameAccountSuccessor.*never calls the provider' -or
    $registry.apiInvariants.genesisResetReservation -notmatch 'exact235 intent is not the provider index.*FirstDeployment exact49 mode1\|network16\|bootstrapSubject32.*bootstrapSubject32 fixed-time equals deploymentGovernanceBootstrapHash32.*sourced only from the sealed governance context and verified First197 transcript.*no independent consumer or caller deployment-authority value.*AccountReset exact57.*genesis-reset-logical-scope.*genesis-reset-intent.*atomically indexes logicalScopeHash32' -or
    $registry.apiInvariants.genesisResetReservation -match 'immutable consumer deployment-authority fact|deploymentBootstrapSubject32' -or
    $registry.apiInvariants.genesisResetReservation -notmatch 'GRR1-381.*GRI1-217.*Deep/ProtectedState/V1/GRI1.*same logical key with a different exact235 intent hash.*permanent fork latch.*no second mint occurs' -or
    $registry.apiInvariants.genesisResetReservation -notmatch 'process loss before the provider response.*one byte-identical sealed row.*State1 is canonically Reserved=1.*no mutable Reserved-to-Committed transition.*no raw ID, public constructor, parser, factory or authority conversion.*Cancellation never releases or permits reuse' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'GenesisTransactionScopeContext exact122.*RestoreOrReserveGenesisTransactionAsync.*genesis-transaction-logical-scope.*GTI1-243.*Deep/ProtectedState/V1/GTI1.*same sealed nonserializable transaction.*process loss.*never mints a second ID.*restart after durable nonce-intent CAS.*exact-replay the latch' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'RecoveryProtector.SealCandidateAsync.*recovery-seal-plaintext.*recovery-seal-intent.*durably CAS.*before AEAD.*different intent permanently latches.*one deterministic suite0x0001 AEAD seal.*PRK is zeroed after derivation.*AEAD key is retained only through.*self-verification.*Ciphertext cannot release or persist' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'AuthorDcpSetAsync.*AuthorDcsAsync.*AuthorDctAsync.*Only after GAS1, GQP1 and GAJ1 Created are durable, AuthorDcnReceiptAsync calls only the three witness IDs.*VerifyAndAssembleDcqAsync accepts exactly those three sealed DCN1 receipts.*alternate-trio.*inputs reject' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'GQP1-461 Pending.*receiptCount1=3.*three-witnessId32-values96-strictly-sorted.*exact339.*three-sorted-witness-ids96.*u32be-461.*contains no future DCN ref.*before GAJ1 Created, all witness callbacks and external CAS.*GAJ1 Created binds pendingHash32' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'After the selected three durable DCN receipts return.*only that Pending row may complete one exact GQS1-580.*byte-identical witness IDs plus the actual three DCNRef38.*genesis-quorum-selection,u32be-580.*keys completion by exact pendingHash32.*missing Pending.*permanently fork-latches' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'MaterializeGenesisCandidateDpl consumes the sealed HMAC-verified GQS1 exact DCQRef.*exact296.*DPL-role key.*never shared recovery HMAC or DCL/ExistingDPL.*freeze.*576 bytes' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'exactly seven pre-external canonical artifacts.*preExternalArtifactCount2 is exactly7.*preExternalArtifactInventoryHash32=.*u16be7.*preExternalTotalBytes8.*at most33558991' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'candidateCoreFingerprint32=.*exact494.*excludes GAS1 hash, GAJ1, DCN1, DCQ1, candidate DPL/source and local state.*GAS1-285.*artifactCount2=7.*receiptHash32=.*computed after the core and cannot feed back into it' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'stable provider index is the exact sealed network16\|resetId32\|componentKind2\|componentSubject32\|accountGeneration8\|transactionId32 scope.*RestoreGenesisArtifactSetByScopeAsync.*fsync-before-return loss.*HMAC-revision-health-retention-fork checks.*no raw path-or-ID' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'RestoreGenesisQuorumPendingByScopeAsync consumes only that sealed scope derived from the candidate plan.*exactly one HMAC-valid Pending row.*operation-revision-health-retention-fork state.*fsync-before-return loss.*cannot select a new trio' -or
    $registry.apiInvariants.genesisCandidateAuthoring -notmatch 'GAS1 itself, GAJ1, DCN1, DCQ1, candidate DPL/source and every local slot are excluded from this inventory.*DCS/DCQ prove signed intent and witness quorum only and never prove consumer byte durability' -or
    $registry.apiInvariants.genesisAuthorReplayRestore -notmatch 'RestoreGenesisPreJournalAsync.*sealed exact author/store scope.*reminted GTI1.*obtains GAS1.*RestoreGenesisArtifactSetByScopeAsync.*optional GQP1.*RestoreGenesisQuorumPendingByScopeAsync.*no raw path, handle, phase or reference factory.*authenticated GAJ1 absence.*external head zero and local DPL/source zero.*AfterGAS.*AfterGQP' -or
    $registry.apiInvariants.genesisAuthorReplayRestore -notmatch 'RestoreGenesisArtifactSetByScopeAsync consumes only the sealed exact network-reset-component-kind-component-subject-account-generation-transaction author/store scope.*exactly one retained HMAC-valid GAS1 row and artifact set.*same sealed receipt bytes plus a new nonserializable stable handle.*fsync-before-return loss.*no raw path, receipt hash or caller-selected row ID.*same-scope changed bytes fork-latch' -or
    $registry.apiInvariants.genesisAuthorReplayRestore -notmatch 'RestoreGenesisArtifactSetAsync.*exact HMAC-verified GAS1 bytes.*matching HMAC-verified GAJ1 tuple.*sealed consumer-store context.*exactly one retained set.*streams and rereads the exact seven.*returns a new sealed nonserializable stable handle.*No caller path' -or
    $registry.apiInvariants.genesisAuthorReplayRestore -notmatch 'RestoreGenesisAuthorReplayAsync.*latest external DCS/DCQ/DCP/DRC/capsule tuple.*no raw phase enum.*GAJ1 is exact880.*quorumSelectionHash32.*Deep/ProtectedState/V1/GAJ1' -or
    $registry.apiInvariants.genesisAuthorReplayRestore -notmatch 'GAJ1 is exact880.*quorumPendingHash32.*quorumPendingRevision8.*Created=0 requires.*quorumPendingHash32 and quorumPendingRevision8' -or
    $registry.apiInvariants.genesisAuthorReplayRestore -notmatch 'Created with external-zero/local-zero.*exact bound GQP1 Pending.*Created with external exactly matching.*requires the bound Pending and completes the byte-identical GQS1 once.*CASes GAJ1 to ExternalCommitted.*ExternalCommitted with the exact external tuple and local zero.*local already byte-equal candidate.*LocalCommitted with exact external and local candidate' -or
    $registry.apiInvariants.genesisAuthorReplayRestore -notmatch 'Every other phase/head combination.*ExternalCheckpointAhead.*permanently fork-latches.*outside DRM/RSM/source/anchor/candidate DAG' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'DRM20 does not extend RecordError.*GenesisReplayScopeV1 exact122.*untrusted defensively-owned bounded GenesisReplayHeadReadResult.*consumer code cannot mint VerifiedGenesisReplayHeadSnapshot.*no public bytes-to-verified factory' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'observedTuple519.*externalTag1.*externalSequence8.*DRCRef38.*fourDCPRefs152.*DCSRef38.*DCTRef38.*DCQRef38.*externalDPLRef38.*externalSourceFingerprint32.*localTag1.*localDPLRef38.*localSourceFingerprint32.*GAJPhase1.*GAJRevision8.*GAJHash32.*externalRevision8.*leaseExpiry8.*localRevision8' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'derives tags rather than trusting provider tags.*External tag0 requires sequence0, every candidate slot zero and leaseExpiry0.*tag1 requires sequence1.*leaseExpiry equal the minimum of authenticated provider lease expiry, four signed DCP expiresAt values, DCS expiresAt, DCT expiresAt and DCQ quorumExpiresAt.*strictly greater than the one authoritative transaction time.*Local tag0 requires zero DPL/source and no local DPL bytes.*tag1 requires exact HMAC-verified DPL bytes and recomputed DPLRef38/source32' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'internal-constructor NoAuthorityClaim subtype CreatedContinue, ExternalCatchUp, LocalCatchUp, NormalCurrentRequired or ExternalCheckpointAhead.*no public enum raw phase-ref factory generic result or RecordError mapping' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'Created plus external0/local0 yields CreatedContinue.*Created plus exact external/local0 yields ExternalCatchUp.*ExternalCommitted plus exact external and local0-or-byte-equal candidate yields LocalCatchUp.*LocalCommitted plus exact GAJ-candidate-external-local equality yields NormalCurrentRequired' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'ExternalCatchUp owning sealed GAS,DRC,DCPx4,DCS,DCT,GQP,exact3-DCN,DCQ and a sealed current GenesisProtectedKeySetContext with DPL-role revision/health.*LocalCatchUp owning exact DPL bytes/source, external tuple and local-plus-GAJ CAS predicate' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'equality-only external DPL/source assertions.*deterministically materializes exact external DPL bytes.*DPL-role key.*recomputes ref/source.*local tag1 likewise requires exact local DPL bytes.*rereads sealed key-set revision and health before and after materialization, GAJ transition and local CAS.*no raw DPL key or key ID' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'reason1 derived only from the final stable authenticated tuple is 1 ExternalDifferent,2 LocalDifferent,3 InvalidPhaseCombination.*there is no movement reason.*A/B movement always retries without latching.*expectedCandidateSlots374.*phase0 copies exact GAJ DRC/DCPx4/DCS/DCT and zeroes DCQ/DPL/source.*phase1/2 copy all exact nonzero GAJ candidate slots.*expectedGAJHash32=sha256-d\(Deep/Cutover/V9/genesis-author-journal-hash,u32be880\|exact-full-HMAC-verified-GAJ1-880\).*evidenceTranscript1056.*sealedScope122.*observedTuple519.*genesis-replay-fork-evidence,u32be1056' -or
    $registry.apiInvariants.genesisReplayDisposition -match 'PostValidationMovement' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'preliminary authenticated external head-plus-lease read-A.*transactional GAJ1-plus-local-DPL/source read.*authoritative external read-B.*same per-scope orchestration lock.*Stable head identity is sequence plus the complete candidate ref/source tuple.*renewable lease and external revision are metadata.*zero-to-exact-candidate head progress.*internally retries.*each attempt counts as one network callback' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'exact maxAttempts=3.*one absolute deadline.*trusted consumer time/timeout policy.*checks cancellation and deadline before and after every read-A, read-B and transactional GAJ/local read.*Three moving attempts exhaust.*fourth callback is forbidden.*no disposition subtype, GFL, GAJ/local mutation, authority or publication.*releases the scope lock.*fresh three-attempt budget' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'atomically inserts or exact-replays.*CASes the exact full HMAC-verified GAJ1 forkLatch0-to1.*one local journal transaction.*GFL1 exact1176.*Deep/ProtectedState/V1/GFL1.*exact expected GAJ shared protected-state HMAC key ID.*latchRevision equals resulting GAJ journalRevision equals checked expectedGAJRevision\+1.*maximum-u64 rejects.*observedAt is the one authoritative nonzero local DB transaction time.*external tag1 requires observedAt strictly less than final read-B leaseExpiry.*GAJ bytes0-through806 are byte-exact preserved' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'Lost response rereads unique GFL1 plus full GAJ1.*verifies both HMACs.*GFL-only or GAJ-only half-write.*returns no disposition or authority' -or
    $registry.apiInvariants.genesisReplayDisposition -notmatch 'Final authoritative read-B.*Only a final stable authenticated tuple is classified.*A/B movement retries without latching.*local installation uses exact empty-to-candidate CAS and immediate transactional reread.*Timeout, unavailable or unauthenticated state fails closed and is not fork evidence.*No signer, witness, local CAS or publication callback occurs between authenticated mismatch detection and durable latch verification' -or
    $registry.apiInvariants.recoveryNonce -notmatch 'exact typed120-byte latch request.*recovery-seal-plaintext.*recovery-seal-intent.*durably atomically CASes absent latch key.*before any AEAD.*exact key-intent retry.*changed intent permanently latches.*cancellation after CAS retains.*one deterministic AEAD seal.*cannot escape or persist before immediate self-open' -or
    $registry.apiInvariants.recoveryPlaintext -ne 'successful-open-yields-one-shot-owned-plaintext-consumed-once-and-zeroed-in-finally-on-success-failure-or-cancellation' -or
    $registry.apiInvariants.cancellation -ne 'cancellation-before-or-after-every-signature-HMAC-agreement-AEAD-or-provider-callback-yields-no-commit-authority-and-no-retained-caller-buffer' -or
    $registry.apiInvariants.commitAuthority -ne 'Protocol-recovery-and-relative-results-never-authorize-durable-commit' -or
    $registry.apiInvariants.consumerFinalRecheck -ne 'consumer-final-durable-transaction-rechecks-current-DPL1-RRL1-DWL1-DRS1-txNow-lease-key-health-kill-switch-and-exact-old-authority-tuple-before-CAS' -or
    $registry.apiInvariants.mrlProjectionBoundary -ne 'projection-is-internal-non-artifact-and-derived-only-from-sealed-pre-root-intent-or-validated-full-MRL2; no-public-parser-model-caller-bytes-ArtifactRef-or-authority-conversion' -or
    $registry.apiInvariants.mrlCompositeCas -ne 'final-plan-defensively-owns-projected-root-MMC1-MSM1-PMA1-PMR1-DNR1-DPC1-full-MRL2-composite-selection-and-exact-old-new-source-fingerprints; atomic-full-tuple-CAS-precedes-publication' -or
    $registry.apiInvariants.mrlCacheIdentity -ne 'every-cache-and-index-key-retains-projected-leaf32-projected-root32-and-full-MRL2-ref38-and-exact-prior-full-MRL2-LKG' -or
    $registry.apiInvariants.dxpProjection -notmatch 'internal-non-artifact-only' -or
    $registry.apiInvariants.dxpProjection -notmatch 'tag21 value zero32' -or
    $registry.apiInvariants.dxpProjection -notmatch 'tag19 value zero32' -or
    $registry.apiInvariants.dxpReceipt -notmatch 'core239' -or
    $registry.apiInvariants.dxpReceipt -notmatch 'fixed573' -or
    $registry.apiInvariants.dxpNonce -notmatch 'operationId32 is consumer-internal CSPRNG nonzero' -or
    $registry.apiInvariants.dxpNonce -notmatch 'source kinds are closed OfflineAccountDeviceGenesis=1 and CurrentCutoverRouter=2' -or
    $registry.apiInvariants.dxpNonce -notmatch 'nonceLedgerKey is derived only by dxpNonceLedgerKey' -or
    $registry.apiInvariants.dxpNonce -notmatch 'source-kind-network-issuanceScope-bound non-DB index key' -or
    $registry.apiInvariants.dxpNonce -notmatch 'immutable and nonrotating for that sealed issuance scope' -or
    $registry.apiInvariants.dxpNonce -notmatch 'retired V1 cutover-only/reset-bound derivations have no reader or dual interpretation' -or
    $registry.apiInvariants.dxpNonce -notmatch 'missing-wrong-retired-early key fails closed' -or
    $registry.apiInvariants.dxpNonce -notmatch 'Pending CAS precedes challenge' -or
    $registry.apiInvariants.dxpFinalCas -notmatch 'exact389 stage0 dxpOperationSource' -or
    $registry.apiInvariants.dxpFinalCas -notmatch 'stage1 dxpOperationSource' -or
    $registry.apiInvariants.dxpFinalCas -notmatch 'OfflineAccountDeviceGenesis is Device-only and derives entirely offline' -or
    $registry.apiInvariants.dxpFinalCas -notmatch 'CurrentCutoverRouter is Router-only and binds the exact current-cutover source' -or
    $registry.apiInvariants.dxpFinalCas -notmatch 'same atomic CAS installs subject head' -or
    $registry.apiInvariants.mrlCurrentInputs -notmatch 'fields3-through8' -or
    $registry.apiInvariants.mrlContinuity -notmatch 'separate RestoreCurrentCompositeLkg and VerifyNextCompositeLkg' -or
    $registry.apiInvariants.mrlSourceCas -notmatch 'raw old-new membership-PMA-PMR-cutover-DRS tuples' -or
    $registry.apiInvariants.callbackOrder -notmatch 'HMAC-and-current-head checks precede') {
    Fail 'B0/B1 public API authority/callback/recovery invariants drifted'
}
if ((@($registry.witness.canonicalOrder) -join '|') -ne 'DCP1[4]|DCS1|DCT1|DCN1/DCQ1|DPL1') {
    Fail 'witness dependency order must remain acyclic'
}
$membershipAuthorityNames = @('membershipChain','mailboxAuthorityChain','join','crossAuthorityInference','mrlProjection','mrlProjectionSource','fullMrlRule','predecessorRule','authorOrder','compositeMemberTuple','finalPlan','cacheIdentity','maximumMembers','maximumArtifactEntries','maximumTransitionEntries','maximumCatalogBytes','currentCutoverInput','currentMailboxInput','currentDnrcInput','membershipHead','mailboxAuthorityHead')
Assert-ExactProperties -Object $registry.membershipAuthority -Required $membershipAuthorityNames -Allowed $membershipAuthorityNames -Name 'membership authority'
$membershipAuthoritySchemaNames = @($registrySchema.properties.membershipAuthority.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$membershipAuthoritySchemaRequired = @($registrySchema.properties.membershipAuthority.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.membershipAuthority.additionalProperties -ne $false -or
    ($membershipAuthoritySchemaNames -join '|') -ne ($membershipAuthorityNames -join '|') -or
    ($membershipAuthoritySchemaRequired -join '|') -ne ($membershipAuthorityNames -join '|')) {
    Fail 'membership authority schema closure drifted'
}
if ((@($registry.membershipAuthority.membershipChain) -join '|') -ne 'MNG1|MDG1|MRV1|MMC1|MSM1' -or
    (@($registry.membershipAuthority.mailboxAuthorityChain) -join '|') -ne 'PMA1|PMR1|DNR1' -or
    $registry.membershipAuthority.join -ne 'PMA.CurrentEpoch.MembershipCommitment equals verified MSM/MMC MRL2-projection root' -or
    $registry.membershipAuthority.crossAuthorityInference -or
    $registry.membershipAuthority.mrlProjection -ne 'internal-non-artifact canonical-MRL2-326 with field5-DNR1Ref38 and field9-anchorDPC1Ref38 replaced by 38 zero bytes each; every other byte unchanged' -or
    $registry.membershipAuthority.mrlProjectionSource -notmatch 'sealed-pre-root-intent-or-validated-full-canonical-MRL2' -or
    $registry.membershipAuthority.mrlProjectionSource -notmatch 'no-public-caller-bytes-model-ArtifactRef-authority-conversion' -or
    $registry.membershipAuthority.fullMrlRule -notmatch 'mandatory nonzero exact verified DNR1Ref38 and anchorDPC1Ref38' -or
    $registry.membershipAuthority.predecessorRule -notmatch 'zero only at descriptor genesis' -or
    $registry.membershipAuthority.predecessorRule -notmatch 'sealed prior full-MRL2 LKG' -or
    $registry.membershipAuthority.authorOrder -ne 'sealed-projection-intent-and-root|MMC1-MSM1|PMA1|PMR1|DNR1|DPC1|full-MRL2|MRLC-final-defensive-plan-and-atomic-CAS' -or
    $registry.membershipAuthority.compositeMemberTuple -ne 'router-id32|DNR1-ref38|full-MRL2-ref38|anchor-DPC1-ref38' -or
    $registry.membershipAuthority.finalPlan -notmatch 'one-atomic-CAS-before-publication' -or
    $registry.membershipAuthority.cacheIdentity -notmatch 'projected-leaf32\|projected-root32\|full-MRL2-ref38' -or
    $registry.membershipAuthority.currentCutoverInput -notmatch 'fields1-through8 compare before callbacks' -or
    $registry.membershipAuthority.currentMailboxInput -notmatch 'exact DPMCRef38' -or
    $registry.membershipAuthority.currentDnrcInput -notmatch 'Router-role DXR1 transcript' -or
    $registry.membershipAuthority.membershipHead -notmatch 'candidate-derived LKG is forbidden' -or
    $registry.membershipAuthority.mailboxAuthorityHead -notmatch 'candidate-derived LKG forbidden') {
    Fail 'independent membership/mailbox authority policy drifted'
}
if ([int]$registry.membershipAuthority.maximumMembers -ne 4096 -or
    [int]$registry.membershipAuthority.maximumArtifactEntries -ne 16389 -or
    [int]$registry.membershipAuthority.maximumTransitionEntries -ne 4096 -or
    [int]$registry.membershipAuthority.maximumCatalogBytes -ne 16777216) {
    Fail 'MRLC bounds drifted'
}
if ($registry.http.path -ne '/api/peer/native/v1/mailbox' -or
    [int]$registry.http.responseBytes -ne 748 -or
    [int]$registry.http.storeMinimumBytes -ne 1202 -or
    [int]$registry.http.storeMaximumBytes -ne 91128 -or
    [int]$registry.http.tombstoneMinimumBytes -ne 1050 -or
    [int]$registry.http.tombstoneMaximumBytes -ne 9240 -or
    $registry.http.compression -ne 'reject' -or
    $registry.http.publicAddressPolicy -ne 'normalize-IPv4-mapped-IPv6-to-IPv4;deny-IPv4=0.0.0.0/8,10.0.0.0/8,100.64.0.0/10,127.0.0.0/8,169.254.0.0/16,172.16.0.0/12,192.0.0.0/24,192.0.2.0/24,192.88.99.0/24,192.168.0.0/16,198.18.0.0/15,198.51.100.0/24,203.0.113.0/24,224.0.0.0/4,240.0.0.0/4;allow-IPv6-only-2000::/3-minus=2001::/23,2001:db8::/32,3fff::/20;deny-everything-else' -or
    $registry.http.resolutionContract -ne 'DNS ASCII-LDH labels 1-through-63 total 3-through-253 at-least-two-labels no-empty-leading-trailing-hyphen; DNS one typed resolve callback returns 1-through-16 canonical unique addresses sorted family-then-unsigned-bytes; direct address produces one-element owned set without resolver callback; every address passes exact public policy; connector receives owned set once and returns actual connected canonical IP plus TLS-SPKI32; no second resolution; connected IP membership and SPKI fixed-time compare' -or
    $registry.http.connectOrder -notmatch 'repeat txNow-current-head-lease after resolve' -or
    $registry.http.connectOrder -notmatch 'immediately before first HTTP request byte' -or
    $registry.http.connectOrder -notmatch 'zero HTTP headers-or-data' -or
    $registry.http.transportIsolation -ne 'system-and-user-proxy-disabled; redirects-disabled; Alt-Svc-disabled-and-ignored; HTTP2-origin-coalescing-disabled; connection-pooling-and-reuse-disabled; one-fresh-typed-resolve-connect-TLS-transport-per-request; DNS-SNI-is-exact-canonical-DPC-name-and-direct-IP-SNI-is-empty; no-caller-handler-connector-or-pool-substitution') { Fail 'native peer HTTP contract drifted' }

$packageIds = @($registry.packages | ForEach-Object { [string]$_.id })
if (($packageIds -join '|') -ne 'Deep.Protocol|Deep.Protocol.MembershipRoutes|Deep.Protocol.ProfileCarrier') {
    Fail 'package closure must contain the exact current three package IDs'
}
if ($spec -match 'Deep\.Protocol\.Native(?:\b|\*)[^\r\n]*package') {
    Fail 'Native package must remain absent'
}
foreach ($required in @(
    'PQ fields models parsers tests or package in Wave1 production grammar',
    'message confidentiality claim',
    'Ed25519-to-X25519 conversion',
    'Session compatibility fallback or database migration',
    'mutating reviewed D-G wire bytes',
    'Deep.Protocol.Native package',
    'storage or privacy peer operation',
    'MQR3 in DPS1',
    'sensitive use without current DRS and fresh witness lease',
    'DCP-DCS or DCP-DRC hash cycle'
)) {
    if (@($registry.forbidden) -notcontains $required) { Fail "missing forbidden rule: $required" }
}

if ($vectorSchema.'$schema' -ne 'https://json-schema.org/draft/2020-12/schema' -or
    $vectorSchema.'$id' -ne 'urn:deep:dnp1:classical:v1:vectors') {
    Fail 'vector schema identity drifted'
}
$vectorTop = @('$schema','schemaVersion','status','decision','workPackage','cases')
$vectorSchemaRequired = @($vectorSchema.required | ForEach-Object { [string]$_ })
$vectorSchemaProperties = @($vectorSchema.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
if (($vectorSchemaRequired -join '|') -ne ($vectorTop -join '|') -or
    ($vectorSchemaProperties -join '|') -ne ($vectorTop -join '|') -or
    $vectorSchema.additionalProperties -ne $false -or
    $vectorSchema.properties.'$schema'.const -ne 'dnp1-classical-v1.vectors.schema.json') {
    Fail 'vector Draft 2020-12 closed top-level schema drifted'
}
if ($vectors.schemaVersion -ne '1.0.0' -or $vectors.status -ne 'required-before-code' -or
    $vectors.decision -ne 'DR-0003' -or $vectors.workPackage -ne $registry.workPackage -or
    $vectors.'$schema' -ne 'dnp1-classical-v1.vectors.schema.json') {
    Fail 'vector skeleton governance binding changed'
}
Assert-ExactProperties $vectors $vectorTop $vectorTop 'vectors'
if ([int]$vectorSchema.properties.cases.minItems -ne 314 -or [int]$vectorSchema.properties.cases.maxItems -ne 314 -or
    $vectorSchema.properties.cases.uniqueItems -ne $true -or
    $vectorSchema.'$defs'.case.additionalProperties -ne $false) {
    Fail 'vector schema bounds/closed case grammar drifted'
}
if (-not (Test-ClosedVectorDocumentAgainstSchema $vectors $vectorSchema)) {
    Fail 'vector skeleton does not validate against the closed Draft 2020-12-equivalent schema gate'
}
$negativeTop = ($vectors | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
$negativeTop | Add-Member -NotePropertyName 'unexpected' -NotePropertyValue $true
if (Test-ClosedVectorDocumentAgainstSchema $negativeTop $vectorSchema) {
    Fail 'vector schema negative self-test accepted a top-level additional property'
}
$negativeCase = ($vectors | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
$negativeCase.cases[0] | Add-Member -NotePropertyName 'unexpected' -NotePropertyValue $true
if (Test-ClosedVectorDocumentAgainstSchema $negativeCase $vectorSchema) {
    Fail 'vector schema negative self-test accepted a case additional property'
}
$nonStringValues = @(
    [pscustomobject]@{ label = 'number'; value = 7 },
    [pscustomobject]@{ label = 'boolean'; value = $true },
    [pscustomobject]@{ label = 'null'; value = $null }
)
foreach ($topStringName in @('$schema','schemaVersion','status','decision','workPackage')) {
    foreach ($invalid in $nonStringValues) {
        $negativeType = ($vectors | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
        $negativeType.$topStringName = $invalid.value
        if (Test-ClosedVectorDocumentAgainstSchema $negativeType $vectorSchema) {
            Fail "vector schema negative self-test accepted $($invalid.label) $topStringName"
        }
    }
}
foreach ($invalid in @(
    [pscustomobject]@{ label = 'string'; value = 'not-an-array' },
    [pscustomobject]@{ label = 'number'; value = 7 },
    [pscustomobject]@{ label = 'boolean'; value = $true },
    [pscustomobject]@{ label = 'null'; value = $null }
)) {
    $negativeCasesType = ($vectors | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
    $negativeCasesType.cases = $invalid.value
    if (Test-ClosedVectorDocumentAgainstSchema $negativeCasesType $vectorSchema) {
        Fail "vector schema negative self-test accepted $($invalid.label) cases"
    }
}
foreach ($caseStringName in @('id','area','outcome','purpose')) {
    foreach ($invalid in $nonStringValues) {
        $negativeType = ($vectors | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
        $negativeType.cases[0].$caseStringName = $invalid.value
        if (Test-ClosedVectorDocumentAgainstSchema $negativeType $vectorSchema) {
            Fail "vector schema negative self-test accepted $($invalid.label) case $caseStringName"
        }
    }
}
foreach ($invalid in @(
    [pscustomobject]@{ label = 'array'; value = @() },
    [pscustomobject]@{ label = 'string'; value = 'not-an-object' },
    [pscustomobject]@{ label = 'number'; value = 7 },
    [pscustomobject]@{ label = 'boolean'; value = $true },
    [pscustomobject]@{ label = 'null'; value = $null }
)) {
    $negativeCallbacksType = ($vectors | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
    $negativeCallbacksType.cases[0].callbacks = $invalid.value
    if (Test-ClosedVectorDocumentAgainstSchema $negativeCallbacksType $vectorSchema) {
        Fail "vector schema negative self-test accepted $($invalid.label) callbacks"
    }
}
$allowedAreas = @('grammar','identity','revocation','reset','witness','membership','routing','peer','recovery','api','package')
$allowedOutcomes = @('valid','invalid-before-allocation','invalid-before-crypto','fork-latched','fail-closed','exact-replay')
$caseIds = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($case in @($vectors.cases)) {
    Assert-ExactProperties -Object $case -Required @('id','area','outcome','callbacks','purpose') -Allowed @('id','area','outcome','callbacks','purpose') -Name "vector $($case.id)"
    if (-not $caseIds.Add([string]$case.id)) { Fail "duplicate vector case: $($case.id)" }
    if ([string]$case.id -notmatch '^[a-z0-9-]+$' -or
        $allowedAreas -notcontains [string]$case.area -or
        $allowedOutcomes -notcontains [string]$case.outcome -or
        ([string]$case.purpose).Length -lt 8 -or ([string]$case.purpose).Length -gt 256) {
        Fail "vector semantic/schema violation: $($case.id)"
    }
    Assert-ExactProperties -Object $case.callbacks -Required @('signature','agreement','network','mutation') -Allowed @('signature','agreement','network','mutation') -Name "vector callbacks $($case.id)"
    foreach ($callback in @('signature','agreement','network','mutation')) {
        $value = $case.callbacks.$callback
        if ($value -isnot [int] -and $value -isnot [long]) { Fail "non-integer callback count: $($case.id)" }
        if ([int]$value -lt 0) { Fail "negative callback count: $($case.id)" }
    }
    if ([string]$case.outcome -eq 'invalid-before-allocation' -and
        ([int]$case.callbacks.signature + [int]$case.callbacks.agreement + [int]$case.callbacks.network + [int]$case.callbacks.mutation) -ne 0) {
        Fail "invalid-before-allocation vector invokes a callback: $($case.id)"
    }
}
$requiredCases = @(
    'grammar-all-exact-lengths','grammar-truncated-max-plus-one','grammar-tag-order-duplicate-trailing',
    'grammar-unknown-suite-and-pq','identity-role-key-reuse','identity-pop-substitution',
    'identity-krt-rotate-revoke-fork','identity-dxp-valid','identity-dxp-mutation-expiry-reuse',
    'revocation-empty-and-prefixes','revocation-terminal-any-index','revocation-ordinary-entry-1024',
    'revocation-key-only-resign','revocation-stale-observed-snapshot','revocation-terminal-drt-retention',
    'reset-dra-old-new-pop','reset-dcp-database-rollback','reset-component-row-substitution',
    'witness-three-of-four-valid','witness-two-of-four-insufficient','witness-equivocation-intersection',
    'witness-inclusion-consistency-corrupt','witness-freeze-and-lease-expiry','witness-four-head-lkg-rotation',
    'membership-independent-authorities','membership-cross-authority-substitution','membership-mrl-v1-v2-cross-feed',
    'routing-dpc-anchor-and-successor','routing-dns-private-mixed-rebind','routing-remote-ip-and-spki',
    'peer-sender-recipient-dpc-swap','peer-prq-request-id-window-hash','peer-dps-mrr2-not-mqr3',
    'peer-inner-commit-outer-lost-response','peer-http-framing-compression-trailing',
    'recovery-before-prepare','recovery-after-cas-before-commit','recovery-external-ahead-capsule-missing',
    'recovery-drc-cycle-and-aead',
    'grammar-artifact-domain-cross-type','grammar-transcript-preimage-widths',
    'witness-maximum-tree-fence','witness-rotation-bootstrap-and-removal',
    'membership-mrlc-cold-restore','membership-mrlc-hmac-catalog-corrupt',
    'recovery-kdf-nonce-ad-vectors','recovery-nonce-reuse-latch','recovery-drm-order-row-corrupt',
    'recovery-drm-row-reversed','recovery-drm-row-equal-duplicate','recovery-drm-row-ref-collision-shaped',
    'recovery-drm-direct-plaintext-parser',
    'recovery-drm-ref-rule-missing-cross-class',
    'peer-outer-journal-phase-crashes','peer-outer-journal-fork-stale','peer-outer-journal-cap-hmac-gc',
    'reset-witness-tooling-gate','grammar-machine-artifact-set-digest',
    'membership-mrlc-canonical-container','witness-empty-tree-root','peer-outer-journal-terminal-shape',
    'grammar-record-header-suite-cross-feed','identity-owner-router-id-collision',
    'membership-mrc-member-entry-counts',
    'membership-rip2-valid','membership-rip2-legacy-reject','membership-rip2-count-index-cross-feed',
    'reset-component-kind-closed-enum','grammar-closed-wire-enums','routing-role-capability-flags',
    'identity-suite-capability-enums','identity-release-root-genesis-transition','revocation-reason-enums',
    'witness-enum-latch-reserved','peer-outer-inner-operation-discriminators',
    'grammar-protected-hmac-framing','identity-dxp-kdf-transcript','identity-release-manifest-signer-substitution',
    'identity-release-lkg-hmac-rollback','identity-release-krt-dwd-atomic-crash',
    'identity-release-krt-predecessor-type-cross-feed','identity-release-root-terminal-lease',
    'membership-mailbox-p04-mip1-cross-feed',
    'witness-dwd-epoch-reuse','witness-terminal-krf-quorum-before-rrl',
    'witness-authority-head-receipt-cross-feed','identity-release-genesis-first-dwd-atomic',
    'identity-release-chain-entry-65','identity-release-effective-at',
    'witness-rotation-cross-epoch-key-substitution','witness-rotation-all-four-replacement',
    'witness-subject-policy-closed','grammar-vector-schema-additional-property',
    'identity-mailbox-owner-id-noncircular','identity-router-component-id-self-reference',
    'api-rrm-pin-time-callback-order','api-relative-authority-reflection','api-dwd-full-ancestry-bounds',
    'api-authority-full-tuple-cas','api-hmac-keyid-return-buffer-toctou',
    'api-recovery-freeze-provider-nonce','api-recovery-nonce-reuse-latch',
    'api-recovery-cancel-plaintext-zero','api-recovery-no-commit-final-recheck',
    'membership-mrl2-projection-cycle-break','membership-mrl2-full-leaf-reject',
    'membership-mrl2-zero-full-refs','membership-mrl2-projection-substitution-cross-feed',
    'membership-mrl2-prior-full-lkg','membership-rip2-sealed-full-tuple',
    'membership-composite-selection-full-tuples','membership-final-full-set-cas',
    'membership-cache-dual-identity',
    'identity-dxp-subject-projection-cycle-break','identity-dxp-subject-projection-substitution',
    'identity-dxp-pending-before-challenge','identity-dxp-pending-crash-ephemeral-loss',
    'identity-dxp-nonce-operation-fork','identity-dxp-receipt-hmac-retention-gc',
    'identity-dxp-final-source-cas-race','membership-current-cutover-fields-source',
    'membership-current-mailbox-revoked','membership-router-dxp-receipt-required',
    'membership-dnrc-fact-set-bounds','membership-msm-prior-head-successor',
    'membership-msm-candidate-derived-lkg','membership-pma-pmr-prior-head-successor',
    'membership-pma-pmr-candidate-derived-lkg','membership-composite-old-new-source-cas',
    'peer-outer-request-hash-transcript','peer-outer-outcome-hash-transcript',
    'peer-outer-hash-phase-crash-replay','routing-public-address-closed-table',
    'routing-resolve-owned-set-mapped-order','routing-resolve-cancel-recheck-race',
    'identity-dxp-nonce-ledger-derived-unique','identity-dxp-operation-id-authority-correlation',
    'identity-dxp-operation-source-stages','identity-dxp-operation-source-race',
    'routing-transport-proxy-redirect-altsvc','routing-transport-coalescing-pool-disabled',
    'identity-dxp-index-key-restart-stable','identity-dxp-index-key-rotation-retention',
    'routing-final-post-tls-source-race','routing-final-post-tls-lease-expiry',
    'package-exact-three-session-free',
    'api-recovery-expected-context-key-order','api-recovery-expected-context-preopen',
    'api-recovery-expected-context-postopen','api-recovery-expected-context-toctou',
    'peer-outer-journal-pure-transitions','peer-http-aspnet-host-framing',
    'maui-reset-ddbg-dpl-rollback','maui-reset-destructive-empty-store','maui-no-legacy-session-surface',
    'identity-owner-router-id-durable-collision-latch','api-recovery-component-deployment-subject-cross-feed',
    'recovery-drm2-pin-core-cycle-free','recovery-drm2-allowlist-dag-bounds',
    'recovery-drm2-post-genesis-frontier','recovery-drm2-frontier-unauthorized-cross-feed','recovery-drm2-max-drs-drt-catalog',
    'recovery-drm2-terminal-dpa-target','recovery-drm2-target-fact-cross-feed',
    'recovery-drm2-dra-three-frontier-kinds','recovery-drm2-target-subject-cross-kind',
    'recovery-rfc-hash-golden','recovery-rfc-hash-domain-hmac-order',
    'recovery-schema-profile-golden','recovery-schema-profile-order-substitution',
    'recovery-context-sealed-authority-valid','recovery-context-wrong-stale-cross-reset',
    'recovery-context-movement-race','recovery-context-cold-remint','recovery-context-cold-remint-missing',
    'recovery-identity-catalog-canonical','recovery-identity-catalog-head-key-cross-feed',
    'recovery-cold-cutover-checkpoint-constructible','recovery-cold-cutover-checkpoint-rfc-cross-feed','recovery-cold-rfc-hsm-key-survival','recovery-cold-rfc-dtc-key-id-mismatch',
    'recovery-shadow-manifest-inventory-old-dpl','recovery-materialize-candidate-dpl-cold',
    'recovery-materialize-candidate-dpl-key-reread','recovery-materialize-candidate-dpl-source-cas',
    'recovery-dwh-genesis-zero-input','recovery-dwh-successor-retained-replacement','recovery-dwh-max64-history',
    'recovery-dwh-order-id-head-hash-cross-feed','recovery-dwh-missing-history-reset','recovery-dwh-cold-receipt-before-authority',
    'recovery-whl-atomic-rotation-crash','recovery-whl-terminal-authority-head-crash',
    'recovery-generation-existing-constructible','recovery-generation-self-cycle-reject','recovery-generation-cross-dcp-reject',
    'recovery-generation-exact-replay','recovery-generation-cas-crash','recovery-generation-source-move',
    'recovery-genesis-anchor-constructible','recovery-genesis-double-bootstrap-race','recovery-genesis-crash-replay',
    'recovery-genesis-descendant-cross-feed','recovery-genesis-terminal-reject',
    'recovery-genesis-release-context-golden','recovery-genesis-release-ordinary-cross-feed',
    'recovery-existing-release-genesis-cross-feed','recovery-genesis-release-stale-head',
    'recovery-genesis-release-dwt-race','recovery-genesis-release-dcl-substitution',
    'recovery-genesis-release-fork-latch',
    'recovery-genesis-keyset-shape-order','recovery-genesis-keyset-closed-rows',
    'recovery-genesis-keyset-axis-cross-feed','recovery-genesis-keyset-role-swap',
    'recovery-genesis-keyset-provider-cross-feed','recovery-genesis-keyset-source492-golden',
    'recovery-genesis-keyset-reflection','recovery-genesis-keyset-registry-fork-restart',
    'recovery-genesis-keyset-health-retention','recovery-genesis-keyset-final-reread-race',
    'recovery-genesis-identity-context-golden','recovery-genesis-identity-dcm-absent',
    'recovery-genesis-component-table-cross-feed','recovery-genesis-identity-provenance',
    'recovery-genesis-author-order','recovery-genesis-dcm-single-author-distribution',
    'recovery-genesis-dcm-divergent-distribution','recovery-genesis-dcm-dual-signer-mutation',
    'recovery-genesis-base-identity-no-source','recovery-genesis-dtc-zero-branch',
    'recovery-genesis-dtc-existing-cross-feed','recovery-genesis-full-constructibility-dag',
    'recovery-genesis-dcm-first-reset-intent','recovery-genesis-dcm-same-account-successor',
    'recovery-genesis-dcm-account-reset-intent','recovery-genesis-dcm-reset-intent-cross-feed',
    'recovery-genesis-account-terminal-fence','recovery-genesis-outer-author-replay',
    'recovery-genesis-outer-crash-after-external-cas','recovery-genesis-dcm-coordinator-distribution-crash',
    'recovery-genesis-reset-reservation-request-shape','recovery-genesis-reset-same-account-bypass',
    'recovery-genesis-reset-result-reflection','recovery-genesis-author-replay-phase-matrix',
    'recovery-genesis-author-replay-raw-phase-reflection','recovery-genesis-author-replay-local-committed-normal',
    'recovery-genesis-seal-candidate-selfcheck-cancel','recovery-genesis-author-dcp-dcs-dct-freeze',
    'recovery-genesis-dcn-dcq-quorum-no-durability','recovery-genesis-materialize-dpl-dedicated-key',
    'recovery-genesis-artifact-receipt-shape-bounds','recovery-genesis-reset-reservation-durable-replay',
    'recovery-genesis-reset-reservation-fork-no-reuse','recovery-genesis-reset-reservation-cancel-retention',
    'recovery-genesis-author-replay-created-crash','recovery-genesis-author-replay-external-committed-crash',
    'recovery-genesis-author-replay-external-ahead-missing','recovery-genesis-author-replay-toctou-candidate-fork',
    'recovery-genesis-artifact-store-stream-reread','recovery-genesis-artifact-store-revision-race',
    'recovery-genesis-dcq-durability-substitution','recovery-genesis-candidate-core-cycle-free',
    'recovery-genesis-artifact-receipt-max-plus-one','recovery-genesis-reset-reservation-state-immutable',
    'recovery-genesis-seal-intent-pre-aead','recovery-genesis-dcn-selection-exact3-replay',
    'recovery-genesis-artifact-store-handle-remint','recovery-genesis-reset-reservation-provider-return-crash',
    'recovery-drmv-version-pair-preflight','recovery-genesis-gqs-hash-length-framing',
    'recovery-genesis-reset-logical-scope-fork','recovery-genesis-quorum-pending-crash-rollback',
    'recovery-genesis-transaction-intent-remint','recovery-genesis-prejournal-gas-crash-remint',
    'recovery-genesis-prejournal-gqp-crash-remint','recovery-genesis-post-seal-pre-gas-crash-replay',
    'recovery-genesis-gas-fsync-return-loss-remint','recovery-genesis-gqp-fsync-return-loss-remint',
    'recovery-genesis-replay-disposition-matrix','recovery-genesis-replay-untrusted-head-tags',
    'recovery-genesis-replay-fork-latch-atomic','recovery-genesis-replay-head-toctou',
    'recovery-genesis-replay-gaj-hash-phase-slots','recovery-genesis-replay-gfl-revision-time',
    'recovery-genesis-replay-external-dpl-provenance','recovery-genesis-replay-local-dpl-bytes-required',
    'recovery-genesis-replay-lease-renewal-authoritative-b','recovery-genesis-replay-compatible-head-progress-retry',
    'recovery-genesis-replay-compatible-phase-progress-retry','recovery-genesis-replay-movement-retry-bound',
    'recovery-drm20-dgo-layout-pin','recovery-drm20-dgo-rrm-schema-binding','recovery-drm20-bootstrap-environment-index',
    'recovery-drm20-dgi-remint-fork','recovery-drm20-branch-transcripts','recovery-drm20-reset-origin-complete',
    'recovery-drm20-gar-atomic-remint','recovery-drm20-gdi-prepared-signed','recovery-drm20-gdi-signer-order-idempotency',
    'recovery-drm20-gra-prepared-signed','recovery-drm20-gra-signer-order-idempotency','recovery-drm20-gmd-bitmap-revision',
    'recovery-drm20-gmd-final-barrier','api-drm20-relative-rrm-no-authority','api-drm20-data-only-relative-verifiers',
    'recovery-dtc2-max-target-history','recovery-dtc2-history-crossfeed','recovery-dtc2-history-ordinal-closure',
    'recovery-dtc2-cycle-free-dag','recovery-dtc1-drm20-migration-reject','recovery-dtc2-protected-fact-no-capability',
    'recovery-dtc2-active-ref-collision','recovery-dtc2-history-order-time'
)
if (-not $caseIds.SetEquals([string[]]$requiredCases)) { Fail 'vector case inventory drifted' }

$ownershipIds = @($ownership.rows | ForEach-Object { [string]$_.id })
if (-not (Test-EvidenceOwnershipDocument $ownership $ownershipIds)) {
    Fail 'evidence ownership document is not closed or unique'
}
if (-not (Test-EvidenceOwnershipDocument $ownership ([string[]]@($caseIds)))) {
    Fail 'evidence ownership IDs differ from the semantic vector inventory'
}
if ($ownershipSchema.'$schema' -ne 'https://json-schema.org/draft/2020-12/schema' -or
    $ownershipSchema.'$id' -ne 'urn:deep:dnp1:classical:v1:evidence-ownership' -or
    $ownership.'$schema' -ne 'dnp1-classical-v1.evidence-ownership.schema.json' -or
    $evidenceSchema.'$schema' -ne 'https://json-schema.org/draft/2020-12/schema' -or
    $evidenceSchema.'$id' -ne 'urn:deep:dnp1:classical:v1:evidence-manifest' -or
    $evidenceSchema.additionalProperties -ne $false) {
    Fail 'evidence ownership/manifest schema identity or closure drifted'
}
$expectedOwners = @('Protocol','Registry','XNode','Shared','DevOpsWitness','CrossRepoE2E','MAUI')
$expectedGates = @('ProtocolPackageBlocking','CutoverFinalRelease')
$expectedOwnerCounts = [ordered]@{ Protocol=216; Registry=15; XNode=11; Shared=2; DevOpsWitness=12; CrossRepoE2E=55; MAUI=3 }
function Test-EvidenceProseCountMirror([string]$Text) {
    $ownerPattern = ('The owner totals are Protocol {0}, Registry {1}, XNode {2}, Shared {3},\s+DevOpsWitness {4}, CrossRepoE2E {5}, and MAUI {6}\.' -f
        $expectedOwnerCounts.Protocol, $expectedOwnerCounts.Registry, $expectedOwnerCounts.XNode, $expectedOwnerCounts.Shared,
        $expectedOwnerCounts.DevOpsWitness, $expectedOwnerCounts.CrossRepoE2E, $expectedOwnerCounts.MAUI)
    $packageCount = @($ownership.rows | Where-Object { $_.gate -eq 'ProtocolPackageBlocking' }).Count
    $finalCount = @($ownership.rows | Where-Object { $_.gate -eq 'CutoverFinalRelease' }).Count
    $gatePattern = ('The gate totals are {0}\s+`ProtocolPackageBlocking` rows \(Protocol {1} plus exactly three\s+DevOpsWitness rows\) and {2} `CutoverFinalRelease` rows\.' -f
        $packageCount, $expectedOwnerCounts.Protocol, $finalCount)
    return ($Text -match ('contains exactly {0} unique\s+semantic vector IDs' -f @($ownership.rows).Count) -and
        $Text -match $ownerPattern -and $Text -match $gatePattern)
}
if (-not (Test-EvidenceProseCountMirror $spec)) { Fail 'normative prose evidence owner/gate count mirror drifted' }
$negativeEvidenceProse = $spec.Replace('and 95 `CutoverFinalRelease` rows.', 'and 85 `CutoverFinalRelease` rows.')
if ($negativeEvidenceProse -ceq $spec -or (Test-EvidenceProseCountMirror $negativeEvidenceProse)) {
    Fail 'normative prose evidence count negative self-test failed'
}
foreach ($owner in $expectedOwners) {
    if (@($ownership.rows | Where-Object { $_.executableOwner -eq $owner }).Count -ne [int]$expectedOwnerCounts[$owner]) {
        Fail "evidence owner count drifted: $owner"
    }
}
if (@($ownership.rows | Where-Object { $_.gate -eq 'ProtocolPackageBlocking' }).Count -ne 219 -or
    @($ownership.rows | Where-Object { $_.gate -eq 'CutoverFinalRelease' }).Count -ne 95 -or
    @($ownership.rows | Where-Object { $_.gate -eq 'ProtocolPackageBlocking' -and $_.executableOwner -eq 'Protocol' }).Count -ne 216 -or
    @($ownership.rows | Where-Object { $_.gate -eq 'ProtocolPackageBlocking' -and $_.executableOwner -eq 'DevOpsWitness' }).Count -ne 3 -or
    @($ownership.rows | Where-Object { $_.gate -eq 'CutoverFinalRelease' -and $_.executableOwner -eq 'DevOpsWitness' }).Count -ne 9 -or
    @($ownership.rows | Where-Object { $_.gate -eq 'CutoverFinalRelease' -and $_.executableOwner -eq 'MAUI' }).Count -ne 3) {
    Fail 'evidence gate arithmetic drifted'
}
if ($ownership.normativeCommit -ne '7390d0996dd8ec9c6d8953ed55d299e7f2e90ddb' -or
    $ownership.normativeVectorSkeletonSha256 -ne '449c84b2bfd754e44da11fcd69aa4d3917db95a2a410168cabc98d6d57959b25' -or
    $ownership.sourceSnapshot.path -ne 'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.evidence-source-snapshot.json' -or
    $ownership.sourceSnapshot.originPath -ne 'deep-protocol/artifacts/dnp1-vector-fragments/all146-classification.json' -or
    $ownership.sourceSnapshot.sha256 -ne '64066a8081777736f4e697b6c9fe58c81e9c4be9af65866362b5c2471e7bed43') {
    Fail 'evidence classification provenance drifted'
}
$sourceSnapshotPath = Join-Path $repoRoot ([string]$ownership.sourceSnapshot.path).Replace('/', '\')
if (-not (Test-Path -LiteralPath $sourceSnapshotPath -PathType Leaf) -or
    (Get-FileHash -LiteralPath $sourceSnapshotPath -Algorithm SHA256).Hash.ToLowerInvariant() -ne [string]$ownership.sourceSnapshot.sha256) {
    Fail 'frozen evidence source snapshot is missing or hash-mismatched'
}
$sourceSnapshot = Get-Content -LiteralPath $sourceSnapshotPath -Raw -Encoding UTF8 | ConvertFrom-Json
$expectedAddedIds = @('api-recovery-component-deployment-subject-cross-feed','api-recovery-expected-context-key-order','api-recovery-expected-context-postopen','api-recovery-expected-context-preopen','api-recovery-expected-context-toctou','identity-owner-router-id-durable-collision-latch','maui-no-legacy-session-surface','maui-reset-ddbg-dpl-rollback','maui-reset-destructive-empty-store','peer-http-aspnet-host-framing','peer-outer-journal-pure-transitions','recovery-drm2-allowlist-dag-bounds','recovery-drm2-pin-core-cycle-free','recovery-materialize-candidate-dpl-cold','recovery-materialize-candidate-dpl-key-reread','recovery-materialize-candidate-dpl-source-cas','recovery-shadow-manifest-inventory-old-dpl','recovery-drm2-frontier-unauthorized-cross-feed','recovery-drm2-max-drs-drt-catalog','recovery-drm2-post-genesis-frontier','recovery-drm2-terminal-dpa-target','recovery-drm2-target-fact-cross-feed','recovery-drm2-dra-three-frontier-kinds','recovery-drm2-target-subject-cross-kind','recovery-rfc-hash-golden','recovery-rfc-hash-domain-hmac-order','recovery-schema-profile-golden','recovery-schema-profile-order-substitution','recovery-context-sealed-authority-valid','recovery-context-wrong-stale-cross-reset','recovery-context-movement-race','recovery-context-cold-remint','recovery-context-cold-remint-missing','recovery-identity-catalog-canonical','recovery-identity-catalog-head-key-cross-feed','recovery-cold-cutover-checkpoint-constructible','recovery-cold-cutover-checkpoint-rfc-cross-feed','recovery-cold-rfc-hsm-key-survival','recovery-cold-rfc-dtc-key-id-mismatch','recovery-dwh-genesis-zero-input','recovery-dwh-successor-retained-replacement','recovery-dwh-max64-history','recovery-dwh-order-id-head-hash-cross-feed','recovery-dwh-missing-history-reset','recovery-dwh-cold-receipt-before-authority','recovery-whl-atomic-rotation-crash','recovery-whl-terminal-authority-head-crash','recovery-generation-existing-constructible','recovery-generation-self-cycle-reject','recovery-generation-cross-dcp-reject','recovery-generation-exact-replay','recovery-generation-cas-crash','recovery-generation-source-move','recovery-genesis-anchor-constructible','recovery-genesis-double-bootstrap-race','recovery-genesis-crash-replay','recovery-genesis-descendant-cross-feed','recovery-genesis-terminal-reject','recovery-genesis-release-context-golden','recovery-genesis-release-ordinary-cross-feed','recovery-existing-release-genesis-cross-feed','recovery-genesis-release-stale-head','recovery-genesis-release-dwt-race','recovery-genesis-release-dcl-substitution','recovery-genesis-release-fork-latch','recovery-genesis-keyset-shape-order','recovery-genesis-keyset-closed-rows','recovery-genesis-keyset-axis-cross-feed','recovery-genesis-keyset-role-swap','recovery-genesis-keyset-provider-cross-feed','recovery-genesis-keyset-source492-golden','recovery-genesis-keyset-reflection','recovery-genesis-keyset-registry-fork-restart','recovery-genesis-keyset-health-retention','recovery-genesis-keyset-final-reread-race','recovery-genesis-identity-context-golden','recovery-genesis-identity-dcm-absent','recovery-genesis-component-table-cross-feed','recovery-genesis-identity-provenance','recovery-genesis-author-order','recovery-genesis-dcm-single-author-distribution','recovery-genesis-dcm-divergent-distribution','recovery-genesis-dcm-dual-signer-mutation','recovery-genesis-base-identity-no-source','recovery-genesis-dtc-zero-branch','recovery-genesis-dtc-existing-cross-feed','recovery-genesis-full-constructibility-dag','recovery-genesis-dcm-first-reset-intent','recovery-genesis-dcm-same-account-successor','recovery-genesis-dcm-account-reset-intent','recovery-genesis-dcm-reset-intent-cross-feed','recovery-genesis-account-terminal-fence','recovery-genesis-outer-author-replay','recovery-genesis-outer-crash-after-external-cas','recovery-genesis-dcm-coordinator-distribution-crash','recovery-genesis-reset-reservation-request-shape','recovery-genesis-reset-same-account-bypass','recovery-genesis-reset-result-reflection','recovery-genesis-author-replay-phase-matrix','recovery-genesis-author-replay-raw-phase-reflection','recovery-genesis-author-replay-local-committed-normal','recovery-genesis-seal-candidate-selfcheck-cancel','recovery-genesis-author-dcp-dcs-dct-freeze','recovery-genesis-dcn-dcq-quorum-no-durability','recovery-genesis-materialize-dpl-dedicated-key','recovery-genesis-artifact-receipt-shape-bounds','recovery-genesis-reset-reservation-durable-replay','recovery-genesis-reset-reservation-fork-no-reuse','recovery-genesis-reset-reservation-cancel-retention','recovery-genesis-author-replay-created-crash','recovery-genesis-author-replay-external-committed-crash','recovery-genesis-author-replay-external-ahead-missing','recovery-genesis-author-replay-toctou-candidate-fork','recovery-genesis-artifact-store-stream-reread','recovery-genesis-artifact-store-revision-race','recovery-genesis-dcq-durability-substitution')
$expectedAddedIds += @(
    'recovery-genesis-candidate-core-cycle-free',
    'recovery-genesis-artifact-receipt-max-plus-one',
    'recovery-genesis-reset-reservation-state-immutable',
    'recovery-genesis-seal-intent-pre-aead',
    'recovery-genesis-dcn-selection-exact3-replay',
    'recovery-genesis-artifact-store-handle-remint',
    'recovery-genesis-reset-reservation-provider-return-crash',
    'recovery-drmv-version-pair-preflight',
    'recovery-genesis-gqs-hash-length-framing',
    'recovery-genesis-reset-logical-scope-fork',
    'recovery-genesis-quorum-pending-crash-rollback',
    'recovery-genesis-transaction-intent-remint',
    'recovery-genesis-prejournal-gas-crash-remint',
    'recovery-genesis-prejournal-gqp-crash-remint',
    'recovery-genesis-post-seal-pre-gas-crash-replay',
    'recovery-genesis-gas-fsync-return-loss-remint',
    'recovery-genesis-gqp-fsync-return-loss-remint',
    'recovery-genesis-replay-disposition-matrix',
    'recovery-genesis-replay-untrusted-head-tags',
    'recovery-genesis-replay-fork-latch-atomic',
    'recovery-genesis-replay-head-toctou',
    'recovery-genesis-replay-gaj-hash-phase-slots',
    'recovery-genesis-replay-gfl-revision-time',
    'recovery-genesis-replay-external-dpl-provenance',
    'recovery-genesis-replay-local-dpl-bytes-required',
    'recovery-genesis-replay-lease-renewal-authoritative-b',
    'recovery-genesis-replay-compatible-head-progress-retry',
    'recovery-genesis-replay-compatible-phase-progress-retry',
    'recovery-genesis-replay-movement-retry-bound',
    'recovery-drm20-dgo-layout-pin','recovery-drm20-dgo-rrm-schema-binding','recovery-drm20-bootstrap-environment-index',
    'recovery-drm20-dgi-remint-fork','recovery-drm20-branch-transcripts','recovery-drm20-reset-origin-complete',
    'recovery-drm20-gar-atomic-remint','recovery-drm20-gdi-prepared-signed','recovery-drm20-gdi-signer-order-idempotency',
    'recovery-drm20-gra-prepared-signed','recovery-drm20-gra-signer-order-idempotency','recovery-drm20-gmd-bitmap-revision',
    'recovery-drm20-gmd-final-barrier','api-drm20-relative-rrm-no-authority','api-drm20-data-only-relative-verifiers',
    'recovery-dtc2-max-target-history','recovery-dtc2-history-crossfeed','recovery-dtc2-history-ordinal-closure',
    'recovery-dtc2-cycle-free-dag','recovery-dtc1-drm20-migration-reject','recovery-dtc2-protected-fact-no-capability',
    'recovery-dtc2-active-ref-collision','recovery-dtc2-history-order-time'
)
$expectedOverrideIds = @('peer-outer-journal-cap-hmac-gc','peer-outer-journal-fork-stale','peer-outer-journal-phase-crashes','peer-outer-journal-terminal-shape')
if ([int]$ownership.sourceAudit.sourceRowCount -ne 146 -or (@($ownership.sourceAudit.addedIds) -join '|') -ne ($expectedAddedIds -join '|') -or
    (@($ownership.sourceAudit.overriddenIds) -join '|') -ne ($expectedOverrideIds -join '|') -or @($sourceSnapshot.rows).Count -ne 146) {
    Fail 'evidence source-audit delta drifted'
}
$normativeById = @{}; foreach ($row in @($ownership.rows)) { $normativeById[[string]$row.id] = $row }
$expectedDrm20OwnershipMirrors = @{
    'recovery-drm2-pin-core-cycle-free' = 'Protocol owns the internal non-artifact pin-core projection, exact DRM20 prefix construction, and mandatory DRM1/DRM2/DRM3/DRM4/DRM5/DRM6/DRM7/DRM8/DRM9/DRM10/DRM11/DRM12/DRM13/DRM14/DRM15/DRM16/DRM17/DRM18/DRM19 rejection without reinterpretation.'
    'recovery-drm2-allowlist-dag-bounds' = 'Protocol owns the closed DRM20 scoped per-type allowlist, reference DAG and allocation bounds; DRM1/DRM2/DRM3/DRM4/DRM5/DRM6/DRM7/DRM8/DRM9/DRM10/DRM11/DRM12/DRM13/DRM14/DRM15/DRM16/DRM17/DRM18/DRM19 are rejected without reinterpretation.'
    'recovery-schema-profile-order-substitution' = 'Protocol rejects any schema source line, table, domain, order or cap drift as a DRM21 requirement.'
    'recovery-genesis-identity-provenance' = 'Protocol keeps CurrentProtectedStore and RecoveredDRM20 identity provenance distinct at the genesis authoring boundary.'
}
foreach ($mirrorId in $expectedDrm20OwnershipMirrors.Keys) {
    if (-not $normativeById.ContainsKey($mirrorId) -or
        [string]$normativeById[$mirrorId].reasonApiSeam -cne [string]$expectedDrm20OwnershipMirrors[$mirrorId]) {
        Fail "DRM20 evidence ownership mirror drifted: $mirrorId"
    }
}
foreach ($sourceRow in @($sourceSnapshot.rows)) {
    if (-not $normativeById.ContainsKey([string]$sourceRow.id)) { Fail "source snapshot ID missing from normative ownership: $($sourceRow.id)" }
    $normativeRow = $normativeById[[string]$sourceRow.id]
    if ($expectedOverrideIds -notcontains [string]$sourceRow.id -and
        ($sourceRow.executableOwner -ne $normativeRow.executableOwner -or $sourceRow.gate -ne $normativeRow.gate)) {
        Fail "unaudited source owner/gate change: $($sourceRow.id)"
    }
}
foreach ($addedId in $expectedAddedIds) { if (-not $normativeById.ContainsKey($addedId)) { Fail "missing audited added evidence ID: $addedId" } }
$expectedAddedBindings = [ordered]@{
    'api-recovery-component-deployment-subject-cross-feed'='Protocol|ProtocolPackageBlocking'
    'api-recovery-expected-context-key-order'='Protocol|ProtocolPackageBlocking'
    'api-recovery-expected-context-postopen'='Protocol|ProtocolPackageBlocking'
    'api-recovery-expected-context-preopen'='Protocol|ProtocolPackageBlocking'
    'api-recovery-expected-context-toctou'='Protocol|ProtocolPackageBlocking'
    'identity-owner-router-id-durable-collision-latch'='CrossRepoE2E|CutoverFinalRelease'
    'maui-no-legacy-session-surface'='MAUI|CutoverFinalRelease'
    'maui-reset-ddbg-dpl-rollback'='MAUI|CutoverFinalRelease'
    'maui-reset-destructive-empty-store'='MAUI|CutoverFinalRelease'
    'peer-http-aspnet-host-framing'='XNode|CutoverFinalRelease'
    'peer-outer-journal-pure-transitions'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-allowlist-dag-bounds'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-pin-core-cycle-free'='Protocol|ProtocolPackageBlocking'
    'recovery-materialize-candidate-dpl-cold'='Protocol|ProtocolPackageBlocking'
    'recovery-materialize-candidate-dpl-key-reread'='Protocol|ProtocolPackageBlocking'
    'recovery-materialize-candidate-dpl-source-cas'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-shadow-manifest-inventory-old-dpl'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-frontier-unauthorized-cross-feed'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-max-drs-drt-catalog'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-post-genesis-frontier'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-terminal-dpa-target'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-target-fact-cross-feed'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-dra-three-frontier-kinds'='Protocol|ProtocolPackageBlocking'
    'recovery-drm2-target-subject-cross-kind'='Protocol|ProtocolPackageBlocking'
    'recovery-rfc-hash-golden'='Protocol|ProtocolPackageBlocking'
    'recovery-rfc-hash-domain-hmac-order'='Protocol|ProtocolPackageBlocking'
    'recovery-schema-profile-golden'='Protocol|ProtocolPackageBlocking'
    'recovery-schema-profile-order-substitution'='Protocol|ProtocolPackageBlocking'
    'recovery-dwh-genesis-zero-input'='Protocol|ProtocolPackageBlocking'
    'recovery-dwh-successor-retained-replacement'='Protocol|ProtocolPackageBlocking'
    'recovery-dwh-max64-history'='Protocol|ProtocolPackageBlocking'
    'recovery-dwh-order-id-head-hash-cross-feed'='Protocol|ProtocolPackageBlocking'
    'recovery-dwh-missing-history-reset'='Protocol|ProtocolPackageBlocking'
    'recovery-dwh-cold-receipt-before-authority'='Protocol|ProtocolPackageBlocking'
    'recovery-whl-atomic-rotation-crash'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-whl-terminal-authority-head-crash'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-reset-reservation-request-shape'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-reset-same-account-bypass'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-reset-result-reflection'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-author-replay-phase-matrix'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-author-replay-raw-phase-reflection'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-author-replay-local-committed-normal'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-seal-candidate-selfcheck-cancel'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-author-dcp-dcs-dct-freeze'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-dcn-dcq-quorum-no-durability'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-materialize-dpl-dedicated-key'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-artifact-receipt-shape-bounds'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-reset-reservation-durable-replay'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-reset-reservation-fork-no-reuse'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-reset-reservation-cancel-retention'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-author-replay-created-crash'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-author-replay-external-committed-crash'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-author-replay-external-ahead-missing'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-author-replay-toctou-candidate-fork'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-artifact-store-stream-reread'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-artifact-store-revision-race'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-dcq-durability-substitution'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-candidate-core-cycle-free'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-artifact-receipt-max-plus-one'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-reset-reservation-state-immutable'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-seal-intent-pre-aead'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-dcn-selection-exact3-replay'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-artifact-store-handle-remint'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-reset-reservation-provider-return-crash'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-drmv-version-pair-preflight'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-gqs-hash-length-framing'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-reset-logical-scope-fork'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-quorum-pending-crash-rollback'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-transaction-intent-remint'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-prejournal-gas-crash-remint'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-prejournal-gqp-crash-remint'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-post-seal-pre-gas-crash-replay'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-gas-fsync-return-loss-remint'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-gqp-fsync-return-loss-remint'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-replay-disposition-matrix'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-replay-untrusted-head-tags'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-replay-fork-latch-atomic'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-replay-head-toctou'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-replay-gaj-hash-phase-slots'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-replay-gfl-revision-time'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-replay-external-dpl-provenance'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-replay-local-dpl-bytes-required'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-replay-lease-renewal-authoritative-b'='Protocol|ProtocolPackageBlocking'
    'recovery-genesis-replay-compatible-head-progress-retry'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-replay-compatible-phase-progress-retry'='CrossRepoE2E|CutoverFinalRelease'
    'recovery-genesis-replay-movement-retry-bound'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-dgo-layout-pin'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-dgo-rrm-schema-binding'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-bootstrap-environment-index'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-dgi-remint-fork'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-branch-transcripts'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-reset-origin-complete'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-gar-atomic-remint'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-gdi-prepared-signed'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-gdi-signer-order-idempotency'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-gra-prepared-signed'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-gra-signer-order-idempotency'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-gmd-bitmap-revision'='Protocol|ProtocolPackageBlocking'
    'recovery-drm20-gmd-final-barrier'='CrossRepoE2E|CutoverFinalRelease'
    'api-drm20-relative-rrm-no-authority'='Protocol|ProtocolPackageBlocking'
    'api-drm20-data-only-relative-verifiers'='Protocol|ProtocolPackageBlocking'
    'recovery-dtc2-max-target-history'='Protocol|ProtocolPackageBlocking'
    'recovery-dtc2-history-crossfeed'='Protocol|ProtocolPackageBlocking'
    'recovery-dtc2-history-ordinal-closure'='Protocol|ProtocolPackageBlocking'
    'recovery-dtc2-cycle-free-dag'='Protocol|ProtocolPackageBlocking'
    'recovery-dtc1-drm20-migration-reject'='Protocol|ProtocolPackageBlocking'
    'recovery-dtc2-protected-fact-no-capability'='Protocol|ProtocolPackageBlocking'
    'recovery-dtc2-active-ref-collision'='Protocol|ProtocolPackageBlocking'
    'recovery-dtc2-history-order-time'='Protocol|ProtocolPackageBlocking'
}
foreach ($id in $expectedAddedBindings.Keys) {
    $row = $normativeById[$id]
    if ("$($row.executableOwner)|$($row.gate)" -ne [string]$expectedAddedBindings[$id]) { Fail "audited added evidence binding drifted: $id" }
}
$expectedOverrides = [ordered]@{
    'peer-outer-journal-cap-hmac-gc'='XNode|CutoverFinalRelease'
    'peer-outer-journal-fork-stale'='XNode|CutoverFinalRelease'
    'peer-outer-journal-phase-crashes'='CrossRepoE2E|CutoverFinalRelease'
    'peer-outer-journal-terminal-shape'='XNode|CutoverFinalRelease'
}
foreach ($id in $expectedOverrides.Keys) {
    $row = $normativeById[$id]
    if ("$($row.executableOwner)|$($row.gate)" -ne [string]$expectedOverrides[$id]) { Fail "durable DPJ ownership split drifted: $id" }
}
foreach ($pair in @(
    [pscustomobject]@{ id='identity-owner-router-id-collision'; binding='Protocol|ProtocolPackageBlocking' },
    [pscustomobject]@{ id='peer-http-framing-compression-trailing'; binding='Protocol|ProtocolPackageBlocking' }
)) {
    $row = $normativeById[$pair.id]
    if ("$($row.executableOwner)|$($row.gate)" -ne $pair.binding) { Fail "pure Protocol ownership boundary drifted: $($pair.id)" }
}
$negativeSource = ($sourceSnapshot | ConvertTo-Json -Depth 20 | ConvertFrom-Json)
$unchangedSourceRow = @($negativeSource.rows | Where-Object { $expectedOverrideIds -notcontains [string]$_.id })[0]
$unchangedSourceRow.executableOwner = if ($unchangedSourceRow.executableOwner -eq 'Protocol') { 'XNode' } else { 'Protocol' }
$negativeDetected = $false
foreach ($sourceRow in @($negativeSource.rows)) {
    $normativeRow = $normativeById[[string]$sourceRow.id]
    if ($expectedOverrideIds -notcontains [string]$sourceRow.id -and
        ($sourceRow.executableOwner -ne $normativeRow.executableOwner -or $sourceRow.gate -ne $normativeRow.gate)) { $negativeDetected = $true; break }
}
if (-not $negativeDetected) { Fail 'source-snapshot negative self-test accepted fake owner mapping' }
$ownershipSha = (Get-FileHash -LiteralPath $ownershipPath -Algorithm SHA256).Hash.ToLowerInvariant()
$vectorSha = (Get-FileHash -LiteralPath $vectorPath -Algorithm SHA256).Hash.ToLowerInvariant()
$evidenceNames = @('classificationPath','classificationSha256','classificationSchemaPath','evidenceManifestSchemaPath','evidenceAttestationSchemaPath','owners','gates','ownerCounts','gateCounts','allowedMatrix','protocolPackageRule','cutoverFinalRule','repositoryBindings','currentClaim','evidenceManifestPaths','machineBinding','evidenceDigestRule','provenanceRule','noEarlyGreen')
Assert-ExactProperties $registry.evidenceOwnership $evidenceNames $evidenceNames 'evidence ownership policy'
$evidenceSchemaNames = @($registrySchema.properties.evidenceOwnership.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$evidenceSchemaRequired = @($registrySchema.properties.evidenceOwnership.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.evidenceOwnership.additionalProperties -ne $false -or
    ($evidenceSchemaNames -join '|') -ne ($evidenceNames -join '|') -or
    ($evidenceSchemaRequired -join '|') -ne ($evidenceNames -join '|')) {
    Fail 'registry evidence ownership schema closure drifted'
}
if ($registry.evidenceOwnership.classificationSha256 -ne $ownershipSha -or
    [string]$ownership.normativeVectorSkeletonSha256 -ne $vectorSha -or
    $registry.evidenceOwnership.classificationPath -ne 'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.evidence-ownership.json' -or
    $registry.evidenceOwnership.classificationSchemaPath -ne 'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.evidence-ownership.schema.json' -or
    $registry.evidenceOwnership.evidenceManifestSchemaPath -ne 'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.evidence-manifest.schema.json' -or
    $registry.evidenceOwnership.evidenceAttestationSchemaPath -ne 'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.evidence-attestation.schema.json' -or
    (@($registry.evidenceOwnership.owners) -join '|') -ne ($expectedOwners -join '|') -or
    (@($registry.evidenceOwnership.gates) -join '|') -ne ($expectedGates -join '|') -or
    @('ClassificationOnly','ProtocolPackageGO','CutoverFinalReleaseGO') -notcontains [string]$registry.evidenceOwnership.currentClaim -or
    ($registry.evidenceOwnership.currentClaim -eq 'ClassificationOnly' -and @($registry.evidenceOwnership.evidenceManifestPaths).Count -ne 0) -or
    ($registry.evidenceOwnership.currentClaim -ne 'ClassificationOnly' -and @($registry.evidenceOwnership.evidenceManifestPaths).Count -eq 0) -or
    -not $registry.evidenceOwnership.noEarlyGreen) {
    Fail 'evidence ownership policy binding drifted'
}
foreach ($owner in $expectedOwners) {
    if ([int]$registry.evidenceOwnership.ownerCounts.$owner -ne [int]$expectedOwnerCounts[$owner]) { Fail "registry evidence owner count drifted: $owner" }
}
if ([int]$registry.evidenceOwnership.gateCounts.ProtocolPackageBlocking -ne 219 -or
    [int]$registry.evidenceOwnership.gateCounts.CutoverFinalRelease -ne 95 -or
    (@($registry.evidenceOwnership.allowedMatrix.ProtocolPackageBlocking) -join '|') -ne 'Protocol|DevOpsWitness' -or
    (@($registry.evidenceOwnership.allowedMatrix.CutoverFinalRelease) -join '|') -ne 'Registry|XNode|Shared|DevOpsWitness|CrossRepoE2E|MAUI') {
    Fail 'registry evidence gate matrix drifted'
}
$expectedRepositories = [ordered]@{ Protocol='deep-protocol'; Registry='deep-registry-api'; XNode='xnode'; Shared='deep-client-shared'; DevOpsWitness='deep-devops'; CrossRepoE2E='deep-tests-e2e'; MAUI='deep-client-maui' }
foreach ($owner in $expectedRepositories.Keys) {
    $binding = $registry.evidenceOwnership.repositoryBindings.$owner
    if ($binding.repository -ne [string]$expectedRepositories[$owner] -or
        ($registry.evidenceOwnership.currentClaim -eq 'ClassificationOnly' -and $null -ne $binding.expectedRevision) -or
        ($registry.evidenceOwnership.currentClaim -ne 'ClassificationOnly' -and [string]$binding.expectedRevision -notmatch '^[0-9a-f]{40}$')) {
        Fail "evidence repository binding drifted for current claim $($registry.evidenceOwnership.currentClaim): $owner"
    }
}
if ($registry.evidenceOwnership.protocolPackageRule -notmatch 'all 216 Protocol rows and the exact 3' -or
    $registry.evidenceOwnership.protocolPackageRule -notmatch 'incomplete manifests contribute zero' -or
    $registry.evidenceOwnership.cutoverFinalRule -notmatch 'all314 rows' -or
    $registry.evidenceOwnership.machineBinding -notmatch 'every-listed-evidence-manifest' -or
    $registry.evidenceOwnership.evidenceDigestRule -notmatch 'never stored inside the hashed evidence manifest') {
    Fail 'evidence release or non-self-reference rule drifted'
}
$negativeOwnership = ($ownership | ConvertTo-Json -Depth 20 | ConvertFrom-Json)
$negativeOwnership.rows[1].id = $negativeOwnership.rows[0].id
if (Test-EvidenceOwnershipDocument $negativeOwnership [string[]]$caseIds) { Fail 'ownership negative self-test accepted duplicate ID' }
$negativeOwnership = ($ownership | ConvertTo-Json -Depth 20 | ConvertFrom-Json)
$negativeOwnership.rows[0].executableOwner = 'MAUI'
if (Test-EvidenceOwnershipDocument $negativeOwnership [string[]]$caseIds) { Fail 'ownership negative self-test accepted forbidden owner/gate pair' }
$negativeOwnership = ($ownership | ConvertTo-Json -Depth 20 | ConvertFrom-Json)
$negativeOwnership.rows[0] | Add-Member -NotePropertyName unexpected -NotePropertyValue $true
if (Test-EvidenceOwnershipDocument $negativeOwnership [string[]]$caseIds) { Fail 'ownership negative self-test accepted additional property' }
$packageResults = @{}
foreach ($row in @($ownership.rows | Where-Object { $_.gate -eq 'ProtocolPackageBlocking' })) { $packageResults[[string]$row.id] = 'Passed' }
if (-not (Test-EvidenceGateSatisfied 'ProtocolPackageGO' $ownership.rows $packageResults)) { Fail 'complete package evidence failed synthetic gate' }
$packageResults.Remove([string](@($ownership.rows | Where-Object { $_.gate -eq 'ProtocolPackageBlocking' })[0].id))
if (Test-EvidenceGateSatisfied 'ProtocolPackageGO' $ownership.rows $packageResults) { Fail 'package gate accepted one missing result' }
$finalResults = @{}
foreach ($row in @($ownership.rows)) { $finalResults[[string]$row.id] = 'Passed' }
if (-not (Test-EvidenceGateSatisfied 'CutoverFinalReleaseGO' $ownership.rows $finalResults)) { Fail 'complete final evidence failed synthetic gate' }
$finalResults.Remove([string]$ownership.rows[0].id)
if (Test-EvidenceGateSatisfied 'CutoverFinalReleaseGO' $ownership.rows $finalResults) { Fail 'final gate accepted one missing result' }
$evidenceManifestTop = @('$schema','schemaVersion','status','decision','workPackage','classificationSha256','vectorSkeletonSha256','producer','repository','revision','gitTree','worktreeClean','configuration','toolchainExecutableName','toolchainVersion','toolchainSha256','testArtifactSetSha256','artifactInventory','cases')
if ((@($evidenceSchema.required) -join '|') -ne ($evidenceManifestTop -join '|') -or
    (@($evidenceSchema.properties.PSObject.Properties | ForEach-Object { [string]$_.Name }) -join '|') -ne ($evidenceManifestTop -join '|') -or
    $evidenceSchema.additionalProperties -ne $false -or [int]$evidenceSchema.properties.cases.maxItems -ne 314 -or
    $evidenceSchema.properties.cases.uniqueItems -ne $true -or
    $ownershipSchema.properties.rows.uniqueItems -ne $true -or $evidenceSchema.'$defs'.case.additionalProperties -ne $false) {
    Fail 'evidence manifest schema required-set or closed shape drifted'
}
$ownershipById = @{}
foreach ($row in @($ownership.rows)) { $ownershipById[[string]$row.id] = $row }
$vectorById = @{}
foreach ($case in @($vectors.cases)) { $vectorById[[string]$case.id] = $case }
$attestationTop = @('$schema','schemaVersion','caseId','executableOwner','gate','expectedOutcome','expectedCallbacks','observed','result','runner','configuration','toolchain','source','packageClosure','deployment','participants','output')
if ($attestationSchema.'$schema' -ne 'https://json-schema.org/draft/2020-12/schema' -or
    $attestationSchema.'$id' -ne 'urn:deep:dnp1:classical:v1:evidence-attestation' -or
    $attestationSchema.additionalProperties -ne $false -or
    (@($attestationSchema.required) -join '|') -ne ($attestationTop -join '|') -or
    (@($attestationSchema.properties.PSObject.Properties | ForEach-Object { [string]$_.Name }) -join '|') -ne ($attestationTop -join '|')) {
    Fail 'evidence attestation schema identity or closed shape drifted'
}
$syntheticRow = @($ownership.rows | Where-Object { $_.id -eq 'api-dwd-full-ancestry-bounds' })[0]
$syntheticVector = $vectorById[[string]$syntheticRow.id]
$runnerPath = 'scripts/dnp1-evidence-selftest-runner.ps1'; $runnerOutputPath = 'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.evidence-selftest-result.json'
$packagePath = 'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.registry.json'
$deploymentPath = 'docs/survival-program/releases/v3.0.0/program-manifest.json'; $outputPath = 'docs/survival-program/releases/v3.0.0/specs/dnp1-classical-v1.evidence-source-snapshot.json'
$artifactByPath = @{}
foreach ($path in @($runnerPath,$runnerOutputPath,$packagePath,$deploymentPath,$outputPath)) { $artifactByPath[$path] = [pscustomobject]@{ sha256=(Get-FileHash (Join-Path $repoRoot $path.Replace('/', '\')) -Algorithm SHA256).Hash.ToLowerInvariant() } }
$ownedArtifactByPath = @{}
foreach ($path in @($artifactByPath.Keys)) { $item=Get-Item (Join-Path $repoRoot $path.Replace('/', '\')); $ownedArtifactByPath[$path]=Read-OwnedEvidenceArtifact $repoRoot $path ([long]$item.Length) ([string]$artifactByPath[$path].sha256) }
$toolchainCommand = Get-Command powershell -CommandType Application | Select-Object -First 1
$toolchainSha = (Get-FileHash $toolchainCommand.Source -Algorithm SHA256).Hash.ToLowerInvariant()
$syntheticManifest = [pscustomobject]@{ repository='deep-protocol'; revision=('a'*40); gitTree=('b'*40); worktreeClean=$true; configuration='Release'; toolchainExecutableName='powershell'; toolchainVersion=[string]$PSVersionTable.PSVersion; toolchainSha256=$toolchainSha }
$syntheticAttestation = [pscustomobject][ordered]@{
    '$schema'='dnp1-classical-v1.evidence-attestation.schema.json'; schemaVersion='1.0.0'; caseId=[string]$syntheticRow.id; executableOwner='Protocol'; gate=[string]$syntheticRow.gate;
    expectedOutcome=[string]$syntheticVector.outcome; expectedCallbacks=($syntheticVector.callbacks | ConvertTo-Json -Compress | ConvertFrom-Json);
    observed=[pscustomobject][ordered]@{ runnerOutputPath=$runnerOutputPath; runnerOutputSha256=$artifactByPath[$runnerOutputPath].sha256; result='Passed'; outcome=[string]$syntheticVector.outcome; callbacks=($syntheticVector.callbacks | ConvertTo-Json -Compress | ConvertFrom-Json); exitCode=0; testIds=@([string]$syntheticRow.id) };
    result='Passed';
    runner=[pscustomobject][ordered]@{ id='dnp1-evidence-selftest'; version='1.0.0'; artifactPath=$runnerPath; sha256=$artifactByPath[$runnerPath].sha256; arguments=@('-NoProfile','-ExecutionPolicy','Bypass','-File',$runnerPath,'-CaseId',[string]$syntheticRow.id) };
    configuration='Release'; toolchain=[pscustomobject][ordered]@{ executableName='powershell'; version=[string]$PSVersionTable.PSVersion; executableSha256=$toolchainSha };
    source=[pscustomobject][ordered]@{ mode='FrozenArchive'; repository='deep-protocol'; revision=('a'*40); gitTree=('b'*40); clean=$true; archiveArtifactSetSha256=('c'*64) };
    packageClosure=[pscustomobject][ordered]@{ artifactPath=$packagePath; sha256=$artifactByPath[$packagePath].sha256 };
    deployment=[pscustomobject][ordered]@{ artifactPath=$deploymentPath; sha256=$artifactByPath[$deploymentPath].sha256 };
    participants=@([pscustomobject][ordered]@{ repository='deep-protocol'; revision=('a'*40); gitTree=('b'*40); packageArtifactPath=$packagePath; packageSetSha256=$artifactByPath[$packagePath].sha256; deploymentArtifactPath=$deploymentPath; deploymentSha256=$artifactByPath[$deploymentPath].sha256 });
    output=[pscustomobject][ordered]@{ artifactPath=$outputPath; sha256=$artifactByPath[$outputPath].sha256 }
}
if ((Get-FileHash $toolchainCommand.Source -Algorithm SHA256).Hash.ToLowerInvariant() -ne $syntheticManifest.toolchainSha256) { Fail 'deterministic evidence toolchain binding failed' }
$runnerPsi = [Diagnostics.ProcessStartInfo]::new(); $runnerPsi.FileName=$toolchainCommand.Source; $runnerPsi.WorkingDirectory=$repoRoot; $runnerPsi.UseShellExecute=$false; $runnerPsi.RedirectStandardOutput=$true; $runnerPsi.RedirectStandardError=$true; $runnerPsi.CreateNoWindow=$true
$runnerPsi.Arguments='-NoProfile -ExecutionPolicy Bypass -File "scripts/dnp1-evidence-selftest-runner.ps1" -CaseId "api-dwd-full-ancestry-bounds"'
$runnerProcess=[Diagnostics.Process]::new();$runnerProcess.StartInfo=$runnerPsi
try { if (-not $runnerProcess.Start()) { Fail 'deterministic evidence runner did not start' }; $runnerStdout=$runnerProcess.StandardOutput.ReadToEnd();$null=$runnerProcess.StandardError.ReadToEnd();$runnerProcess.WaitForExit() } finally { $runnerProcess.Dispose() }
$expectedRunnerBytes=[IO.File]::ReadAllBytes((Join-Path $repoRoot $runnerOutputPath.Replace('/','\')));$actualRunnerBytes=[Text.Encoding]::UTF8.GetBytes($runnerStdout)
$runnerDiff=if($expectedRunnerBytes.Length -eq $actualRunnerBytes.Length){0}else{1};if($runnerDiff -eq 0){for($i=0;$i-lt$expectedRunnerBytes.Length;$i++){$runnerDiff=$runnerDiff-bor($expectedRunnerBytes[$i]-bxor$actualRunnerBytes[$i])}}
if($runnerDiff-ne0){Fail 'deterministic evidence runner output differs from the closed observed result'}
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.source.mode='FrozenArchive'; $negativeAttestation.source.archiveArtifactSetSha256=('c'*64)
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted forbidden FrozenArchive GO provenance' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.source.mode='FrozenArchive'; $negativeAttestation.source.archiveArtifactSetSha256=$null
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted missing FrozenArchive inventory binding' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.source.mode='FrozenArchive'; $negativeAttestation.source.archiveArtifactSetSha256=('d'*64); $negativeAttestation.participants[0].revision=('e'*40)
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted fake FrozenArchive participant tuple' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.toolchain.executableSha256=('0'*64)
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted fake toolchain' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.source.clean=$false
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted dirty source' }
$wrongRevisionManifest = ($syntheticManifest | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $wrongRevisionManifest.revision=('f'*40)
if (Test-EvidenceAttestationDocument $syntheticAttestation $syntheticRow $syntheticVector $wrongRevisionManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted wrong producer revision' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.participants=@([pscustomobject]@{ repository='xnode'; revision=('a'*40); gitTree=('b'*40); packageArtifactPath=$packagePath; packageSetSha256=$artifactByPath[$packagePath].sha256; deploymentArtifactPath=$deploymentPath; deploymentSha256=$artifactByPath[$deploymentPath].sha256 })
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $true $repoRoot) { Fail 'attestation accepted wrong participant repository' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.observed.result='Passed'; $negativeAttestation.observed.outcome='valid'
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted forged Passed with wrong observed outcome' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.observed.callbacks.signature=1
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted wrong observed callbacks' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.observed.exitCode=1
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted wrong runner exit code' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.observed.testIds=@('wrong-test-id')
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $false $repoRoot) { Fail 'attestation accepted wrong runner test ID' }
$negativeAttestation = ($syntheticAttestation | ConvertTo-Json -Depth 20 | ConvertFrom-Json); $negativeAttestation.runner.arguments=@('-NoProfile','-File','scripts/check-dnp1-classical-spec.ps1')
if (Test-EvidenceAttestationDocument $negativeAttestation $syntheticRow $syntheticVector $syntheticManifest $artifactByPath $ownedArtifactByPath $true $repoRoot) { Fail 'attestation accepted output from a different runner invocation' }
if ($null -ne (Read-OwnedEvidenceArtifact $repoRoot 'scripts/missing-evidence-attestation.json' 1 ('0'*64))) { Fail 'missing evidence artifact was accepted' }
if (Test-EvidencePathPolicy '../escape.json' $false -or Test-EvidencePathPolicy 'safe/result.json' $true) { Fail 'evidence path policy accepted traversal or reparse-point input' }
$arbitraryFileRejected = $false
try { $null = Get-Content (Join-Path $repoRoot $runnerPath.Replace('/', '\')) -Raw | ConvertFrom-Json }
catch { $arbitraryFileRejected = $true }
if (-not $arbitraryFileRejected) { Fail 'arbitrary runner file parsed as a result attestation' }
$incompleteEvidence = [pscustomobject]@{ status='incomplete'; cases=@([pscustomobject]@{ id=[string]$syntheticRow.id; result='Passed' }) }
$incompleteResults = @{}
if ($incompleteEvidence.status -eq 'complete') { foreach ($case in @($incompleteEvidence.cases)) { $incompleteResults[[string]$case.id] = [string]$case.result } }
if (Test-EvidenceGateSatisfied 'ProtocolPackageGO' $ownership.rows $incompleteResults) { Fail 'incomplete manifest with Passed result counted toward package GO' }
$resultMap = @{}
$machinePaths = @($programManifest.machineSpecificationSet.paths | ForEach-Object { [string]$_ })
foreach ($relativePath in @($registry.evidenceOwnership.evidenceManifestPaths)) {
    if ($machinePaths -notcontains [string]$relativePath) { Fail "listed evidence manifest is outside machine specification set: $relativePath" }
    $fullPath = Join-Path $repoRoot ([string]$relativePath).Replace('/', '\')
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) { Fail "listed evidence manifest missing: $relativePath" }
    $manifestEvidence = Get-Content -LiteralPath $fullPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $binding = $registry.evidenceOwnership.repositoryBindings.([string]$manifestEvidence.producer)
    $repositoryRoot = Join-Path $repoRoot ([string]$binding.repository)
    if ($null -eq $binding.expectedRevision) { Fail "listed evidence manifest has no frozen expected revision: $relativePath" }
    $actualRepositoryRevision = (& git -C $repositoryRoot rev-parse HEAD 2>$null).Trim()
    $actualRepositoryTree = (& git -C $repositoryRoot rev-parse 'HEAD^{tree}' 2>$null).Trim()
    $repositoryDirty = @(& git -C $repositoryRoot status --porcelain=v1 --untracked-files=all 2>$null)
    if ($LASTEXITCODE -ne 0 -or $actualRepositoryRevision -ne [string]$binding.expectedRevision -or
        $actualRepositoryTree -ne [string]$manifestEvidence.gitTree -or $repositoryDirty.Count -ne 0 -or -not $manifestEvidence.worktreeClean) {
        Fail "evidence repository revision differs from frozen binding: $relativePath"
    }
    if (-not (Test-EvidenceManifestDocument $manifestEvidence $ownershipById $vectorById $ownershipSha $binding $repositoryRoot $true)) { Fail "invalid evidence manifest: $relativePath" }
    if ($manifestEvidence.status -ne 'complete') { continue }
    foreach ($case in @($manifestEvidence.cases)) {
        if ($resultMap.ContainsKey([string]$case.id)) { Fail "duplicate cross-manifest evidence case: $($case.id)" }
        $resultMap[[string]$case.id] = [string]$case.result
    }
}
if (-not (Test-EvidenceGateSatisfied $RequiredEvidenceClaim $ownership.rows $resultMap)) {
    Fail "evidence manifests do not satisfy claim $RequiredEvidenceClaim"
}
$authorityVectorOutcomes = [ordered]@{
    'witness-dwd-epoch-reuse' = 'fork-latched'
    'witness-terminal-krf-quorum-before-rrl' = 'exact-replay'
    'witness-authority-head-receipt-cross-feed' = 'invalid-before-crypto'
    'identity-release-genesis-first-dwd-atomic' = 'exact-replay'
    'identity-release-chain-entry-65' = 'fail-closed'
    'identity-release-effective-at' = 'fail-closed'
    'witness-rotation-cross-epoch-key-substitution' = 'fork-latched'
    'witness-rotation-all-four-replacement' = 'fork-latched'
    'witness-subject-policy-closed' = 'invalid-before-crypto'
    'grammar-vector-schema-additional-property' = 'invalid-before-allocation'
    'identity-mailbox-owner-id-noncircular' = 'valid'
    'identity-router-component-id-self-reference' = 'invalid-before-crypto'
    'api-rrm-pin-time-callback-order' = 'invalid-before-crypto'
    'api-relative-authority-reflection' = 'fail-closed'
    'api-dwd-full-ancestry-bounds' = 'invalid-before-allocation'
    'api-authority-full-tuple-cas' = 'exact-replay'
    'api-hmac-keyid-return-buffer-toctou' = 'fail-closed'
    'api-recovery-freeze-provider-nonce' = 'invalid-before-crypto'
    'api-recovery-nonce-reuse-latch' = 'fork-latched'
    'api-recovery-cancel-plaintext-zero' = 'fail-closed'
    'api-recovery-no-commit-final-recheck' = 'fail-closed'
    'recovery-drm-row-reversed' = 'fail-closed'
    'recovery-drm-row-equal-duplicate' = 'fail-closed'
    'recovery-drm-row-ref-collision-shaped' = 'fail-closed'
    'recovery-drm-direct-plaintext-parser' = 'invalid-before-crypto'
    'recovery-drm-ref-rule-missing-cross-class' = 'fail-closed'
    'recovery-drm2-pin-core-cycle-free' = 'valid'
    'recovery-drm2-allowlist-dag-bounds' = 'fail-closed'
    'recovery-shadow-manifest-inventory-old-dpl' = 'fail-closed'
    'recovery-materialize-candidate-dpl-cold' = 'valid'
    'recovery-materialize-candidate-dpl-key-reread' = 'fail-closed'
    'recovery-materialize-candidate-dpl-source-cas' = 'fail-closed'
    'recovery-drm2-post-genesis-frontier' = 'valid'
    'recovery-drm2-frontier-unauthorized-cross-feed' = 'fail-closed'
    'recovery-drm2-max-drs-drt-catalog' = 'valid'
    'recovery-drm2-terminal-dpa-target' = 'valid'
    'recovery-drm2-target-fact-cross-feed' = 'fail-closed'
    'recovery-drm2-dra-three-frontier-kinds' = 'valid'
    'recovery-drm2-target-subject-cross-kind' = 'fail-closed'
    'recovery-rfc-hash-golden' = 'valid'
    'recovery-rfc-hash-domain-hmac-order' = 'fail-closed'
    'recovery-schema-profile-golden' = 'valid'
    'recovery-schema-profile-order-substitution' = 'fail-closed'
    'recovery-dwh-genesis-zero-input' = 'valid'
    'recovery-dwh-successor-retained-replacement' = 'valid'
    'recovery-dwh-max64-history' = 'valid'
    'recovery-dwh-order-id-head-hash-cross-feed' = 'fail-closed'
    'recovery-dwh-missing-history-reset' = 'fail-closed'
    'recovery-dwh-cold-receipt-before-authority' = 'fail-closed'
    'recovery-whl-atomic-rotation-crash' = 'exact-replay'
    'recovery-whl-terminal-authority-head-crash' = 'exact-replay'
    'membership-mrl2-projection-cycle-break' = 'valid'
    'membership-mrl2-full-leaf-reject' = 'invalid-before-crypto'
    'membership-mrl2-zero-full-refs' = 'invalid-before-crypto'
    'membership-mrl2-projection-substitution-cross-feed' = 'invalid-before-crypto'
    'membership-mrl2-prior-full-lkg' = 'fork-latched'
    'membership-rip2-sealed-full-tuple' = 'fail-closed'
    'membership-composite-selection-full-tuples' = 'invalid-before-crypto'
    'membership-final-full-set-cas' = 'exact-replay'
    'membership-cache-dual-identity' = 'fail-closed'
}
foreach ($id in $authorityVectorOutcomes.Keys) {
    $match = @($vectors.cases | Where-Object { $_.id -eq $id })
    if ($match.Count -ne 1 -or [string]$match[0].outcome -ne [string]$authorityVectorOutcomes[$id]) {
        Fail "authority vector outcome drifted: $id"
    }
}
$apiClosureVectors = [ordered]@{
    'api-rrm-pin-time-callback-order' = 'generation-one RRM|0'
    'api-dwd-full-ancestry-bounds' = 'sixty-five complete DWD ancestry|0'
    'recovery-drm-order-row-corrupt' = 'terminal 452-row/nonterminal 451-row and 32-MiB DRM20 closure|1'
    'api-recovery-nonce-reuse-latch' = 'exact typed latch request; protector plus derived nonce|0'
    'api-recovery-expected-context-key-order' = 'malformed scope, selector, kind, count, order, ID or caller construction|0'
    'api-recovery-expected-context-preopen' = 'Exact DRC1 network, component subject|0'
    'api-recovery-component-deployment-subject-cross-feed' = 'witness deployment subject cannot substitute|0'
    'api-recovery-expected-context-postopen' = 'oldSource recomputation must bind sealed row 1, row 2 and DRC protector IDs|1'
    'api-recovery-expected-context-toctou' = 'source revision, health or latch mutation between pre-open, post-open and final CAS|1'
    'recovery-drm-row-reversed' = 'Encrypted integration opens AEAD once|1'
    'recovery-drm-row-equal-duplicate' = 'Encrypted integration opens AEAD once|1'
    'recovery-drm-row-ref-collision-shaped' = 'Encrypted integration opens AEAD once|1'
    'recovery-drm-direct-plaintext-parser' = 'explicitly direct owned-plaintext parser unit|0'
    'recovery-drm-ref-rule-missing-cross-class' = 'After one AEAD open|1'
    'recovery-drm2-pin-core-cycle-free' = 'exact 284-byte DRM20 prefix carries the 274-byte|1'
    'recovery-drm2-allowlist-dag-bounds' = 'closed DRM20 profile|1'
    'recovery-shadow-manifest-inventory-old-dpl' = 'RSM2 is exactly 723 bytes|1'
    'recovery-materialize-candidate-dpl-cold' = 'local candidate bytes and shadow pointer are absent|4'
    'recovery-materialize-candidate-dpl-key-reread' = 'protected key, changed authored bytes or failed durable reread|4'
    'recovery-materialize-candidate-dpl-source-cas' = 'ExternalCheckpointAhead with no publication|4'
    'recovery-drm2-post-genesis-frontier' = 'old local store absent after restart|4'
    'recovery-drm2-frontier-unauthorized-cross-feed' = 'RFC or RAH tamper, truncated historical scope-4 prefix|1'
    'recovery-drm2-max-drs-drt-catalog' = '1024 distinct DPA/DPD/DPM target facts|2'
    'recovery-drm2-terminal-dpa-target' = 'AccountTerminal DRT resolves exactly to current DPA|2'
    'recovery-drm2-target-fact-cross-feed' = 'wrong target ref, kind, account, subject, generation, handle, notAfter|1'
    'recovery-drm2-dra-three-frontier-kinds' = 'DRA requires distinct RFC/RPF kinds 3, 4 and 5 plus a second kind-1|4'
    'recovery-drm2-target-subject-cross-kind' = 'target kind, artifact type, subject domain or exact subject preimage cannot substitute|1'
    'recovery-rfc-hash-golden' = 'exact length-framed full canonical RFC bytes including protected key ID and verified HMAC|1'
    'recovery-rfc-hash-domain-hmac-order' = 'Cross-domain hashing, unsigned RFC bytes, omitted or changed tag|1'
    'recovery-schema-profile-golden' = 'twenty-six exact LF-terminated DRM20 schema profile source lines|0'
    'recovery-schema-profile-order-substitution' = 'Line reorder, table substitution, domain, cap, slot, subject, reference rule|0'
    'recovery-context-sealed-authority-valid' = 'Sealed current identity, full ReleaseRoot ancestry and current cutover contexts bind exact fingerprints|5'
    'recovery-context-wrong-stale-cross-reset' = 'NormalCurrentStore rejects wrong, stale or cross-reset sealed identity|0'
    'recovery-context-movement-race' = 'final old-protected-source CAS with zero publication|5'
    'recovery-context-cold-remint' = 'exact sealed 158-byte provider scope supplies stable healthy row IDs and source revision|5'
    'recovery-context-cold-remint-missing' = 'Post-open DCM reset mismatch|1'
    'recovery-identity-catalog-canonical' = 'bounded canonical ordered DPA, role transition, DPD, DPM, DNR, DRS and exact DRT/DTC inventory|4'
    'recovery-identity-catalog-head-key-cross-feed' = 'Catalog row order, count, role head, DRS revision, DRT set, target, protected key ID or cross-reset substitution|1'
    'recovery-cold-cutover-checkpoint-constructible' = 'old store absent, HMAC-verified RFC plus witness-authenticated DRC/RSM and fresh DCL/DCQ/DCP/DCS|5'
    'recovery-cold-cutover-checkpoint-rfc-cross-feed' = 'Missing or tampered RFC, wrong RFC key ID, old DPL ref, old-source fingerprint, DRC shadow hash, capsule receipt or external head|1'
    'recovery-cold-rfc-hsm-key-survival' = 'reset-surviving typed external HSM provider after bounds; missing, wrong, disabled or unhealthy state for the shared key|1'
    'recovery-cold-rfc-dtc-key-id-mismatch' = 'must be exactly equal before HMAC lookup; distinct IDs reject with zero callbacks|0'
    'recovery-dwh-genesis-zero-input' = 'predecessor epoch zero plus zero288|3'
    'recovery-dwh-successor-retained-replacement' = 'old descriptor-ordered predecessor heads|6'
    'recovery-dwh-max64-history' = '232+342*64 DWH container restores all 65 DWD rows|66'
    'recovery-dwh-order-id-head-hash-cross-feed' = 'Changed successor order or generation, prior descriptor ID/order|1'
    'recovery-dwh-missing-history-reset' = 'cannot be synthesized from current DWL or a signed head hash|0'
    'recovery-dwh-cold-receipt-before-authority' = 'tagged DCL-or-DWT, DCQ and DRC as untrusted bytes|1'
    'recovery-whl-atomic-rotation-crash' = 'updates the WHL authority head and CASes successor DWD, RRL, DWL and WHL|7'
    'recovery-whl-terminal-authority-head-crash' = 'rewrites only its authority head and HMAC with terminal RRL|6'
    'recovery-generation-existing-constructible' = 'ExistingDPL binds the exact predecessor current at T1|1'
    'recovery-generation-self-cycle-reject' = 'candidate DPL as its own predecessor|1'
    'recovery-generation-cross-dcp-reject' = 'cannot cross-feed the sealed old/new plan|1'
    'recovery-generation-exact-replay' = 'byte-identical RSM2, DRC, four DCPs|1'
    'recovery-generation-cas-crash' = 'never relabels the candidate as its predecessor|6'
    'recovery-generation-source-move' = 'ExternalCheckpointAhead and zero publication|5'
    'recovery-genesis-anchor-constructible' = 'exact492 source and exact460 anchor|6'
    'recovery-genesis-double-bootstrap-race' = 'exactly one candidate sequence1 can win|8'
    'recovery-genesis-crash-replay' = 'completes empty-local-to-candidate CAS once|8'
    'recovery-genesis-descendant-cross-feed' = 'inside the exact492 genesis source or exact460 anchor|1'
    'recovery-genesis-terminal-reject' = 'terminal no-use with zero candidate refs|0'
    'recovery-genesis-release-context-golden' = 'complete nonterminal scope-1 KRT chain, DWD/DWH ancestry|3'
    'recovery-genesis-release-ordinary-cross-feed' = 'ordinary recovery-release-context fingerprint|1'
    'recovery-existing-release-genesis-cross-feed' = 'cannot satisfy ExistingDPL|1'
    'recovery-genesis-release-stale-head' = 'stale or substituted RRL authority head|3'
    'recovery-genesis-release-dwt-race' = 'returns terminal no-use with zero publication|3'
    'recovery-genesis-release-dcl-substitution' = 'DCL, lease, deployment head or candidate descendant|1'
    'recovery-genesis-release-fork-latch' = 'fork latch to equal zero at context mint|1'
    'membership-mrl2-projection-cycle-break' = 'root constructible before PMA without accepting projection bytes as authority|0'
    'membership-mrl2-full-leaf-reject' = 'full MRL2 bytes instead of the internal|0'
    'membership-mrl2-zero-full-refs' = 'zero DNR ref, zero anchor DPC ref|0'
    'membership-mrl2-projection-substitution-cross-feed' = 'V1 or full-leaf cross-feed|0'
    'membership-mrl2-prior-full-lkg' = 'exact sealed prior full-MRL2 ArtifactRef|0'
    'membership-rip2-sealed-full-tuple' = 'Standalone RIP2, MIP1, projection, leaf or root cannot authorize refs|0'
    'membership-composite-selection-full-tuples' = 'router ID, DNR ref, full MRL2 ref and anchor DPC ref|0'
    'membership-final-full-set-cas' = 'exact source fingerprints before publication|1'
    'membership-cache-dual-identity' = 'projected leaf, projected root, full MRL2 ArtifactRef and prior full LKG|0'
    'identity-dxp-subject-projection-cycle-break' = 'Internal DPD and DNR projections zero only the retained transcript-hash value|4'
    'identity-dxp-subject-projection-substitution' = 'Caller projection bytes|0'
    'identity-dxp-pending-before-challenge' = 'before challenge or issuer ephemeral public bytes|1'
    'identity-dxp-pending-crash-ephemeral-loss' = 'nonpersisted ephemeral private key|1'
    'identity-dxp-nonce-operation-fork' = 'permanently latch before challenge|0'
    'identity-dxp-receipt-hmac-retention-gc' = 'core239|0'
    'identity-dxp-final-source-cas-race' = 'one exact source-fingerprint CAS|4'
    'membership-current-cutover-fields-source' = 'MRLC fields 1 through 8|0'
    'membership-current-mailbox-revoked' = 'cannot mint a current mailbox-role fact|0'
    'membership-router-dxp-receipt-required' = 'Verified Router-role DXR transcript|0'
    'membership-dnrc-fact-set-bounds' = 'bounded to member count|0'
    'membership-msm-prior-head-successor' = 'exact sealed prior membership head|3'
    'membership-msm-candidate-derived-lkg' = 'Synthesizing membership LKG from candidate|0'
    'membership-pma-pmr-prior-head-successor' = 'sealed prior authority hash|3'
    'membership-pma-pmr-candidate-derived-lkg' = 'Candidate-derived PMA or PMR|0'
    'membership-composite-old-new-source-cas' = 'raw old and new membership, PMA/PMR, cutover and DRS tuples|1'
    'peer-outer-request-hash-transcript' = 'length-framed exact DPR1 then PRQ2|0'
    'peer-outer-outcome-hash-transcript' = 'length-framed exact MRR2 then DPS1|0'
    'peer-outer-hash-phase-crash-replay' = 'without inner mutation|1'
    'routing-public-address-closed-table' = 'exact closed public-unicast exclusion table|0'
    'routing-resolve-owned-set-mapped-order' = 'connector returns a member IP and exact SPKI|3'
    'routing-resolve-cancel-recheck-race' = 'prevents connect|2'
    'identity-dxp-nonce-ledger-derived-unique' = 'Protected-index HMAC derives one ledger key|0'
    'identity-dxp-operation-id-authority-correlation' = 'Nonzero consumer CSPRNG operation ID|0'
    'identity-dxp-operation-source-stages' = 'Stage zero source binds zero final fields|4'
    'identity-dxp-operation-source-race' = 'makes final DXR and subject CAS stale|3'
    'routing-transport-proxy-redirect-altsvc' = 'cannot create a second network request|2'
    'routing-transport-coalescing-pool-disabled' = 'no HTTP2 origin coalescing|3'
    'identity-dxp-index-key-restart-stable' = 'same reset-bound nonce index key ID|0'
    'identity-dxp-index-key-rotation-retention' = 'before every retained DXR and tombstone is gone|0'
    'routing-final-post-tls-source-race' = 'zero HTTP request bytes|3'
    'routing-final-post-tls-lease-expiry' = 'immediately before write|3'
    'recovery-genesis-keyset-shape-order' = 'exactly 296 bytes with rowCount six|1'
    'recovery-genesis-keyset-closed-rows' = 'missing, extra, unknown, reordered or duplicate|1'
    'recovery-genesis-keyset-axis-cross-feed' = 'network, reset, component kind, component subject or account generation mismatch|1'
    'recovery-genesis-keyset-role-swap' = 'DPL HMAC can use only the DPL-role key|1'
    'recovery-genesis-keyset-provider-cross-feed' = 'ProtectedStateHmac, RecoveryNonceLatch or DRC protector ID|1'
    'recovery-genesis-keyset-source492-golden' = 'unchanged exact492 source and exact460 anchor|1'
    'recovery-genesis-keyset-reflection' = 'no public raw-ID constructor, parser, accessor, factory or authority conversion|0'
    'recovery-genesis-keyset-registry-fork-restart' = 'changed set for the same exact296 scope permanently fork-latches|3'
    'recovery-genesis-keyset-health-retention' = 'authenticated GC cannot retire a reserved key|3'
    'recovery-genesis-keyset-final-reread-race' = 'immediately around final zero-to-one CAS|5'
    'recovery-genesis-identity-context-golden' = 'preexisting signed current DPA/DCM/DRS|4'
    'recovery-genesis-identity-dcm-absent' = 'recovery never invents a DCM authoring authority|0'
    'recovery-genesis-component-table-cross-feed' = 'DCM 42-byte component rows|1'
    'recovery-genesis-identity-provenance' = 'only verified CurrentProtectedStore may enter the author path|0'
    'recovery-genesis-author-order' = 'Base identity and DCM/DRS verify before DTC HMAC|5'
    'recovery-genesis-dcm-single-author-distribution' = 'exact812 dual-signed DCM relative plan|2'
    'recovery-genesis-dcm-divergent-distribution' = 'divergent, partial or component-local DCM/schema set|2'
    'recovery-genesis-dcm-dual-signer-mutation' = 'same frozen unsigned DCM|2'
    'recovery-genesis-base-identity-no-source' = 'cannot mint Source492, anchor, RSM, DRC or any authority|0'
    'recovery-genesis-dtc-zero-branch' = 'exact zero oldDPLRef and oldSourceFingerprint under HMAC|0'
    'recovery-genesis-dtc-existing-cross-feed' = 'ExistingDPL DTC requires both predecessor fields nonzero|0'
    'recovery-genesis-full-constructibility-dag' = 'one acyclic constructible author and replay DAG|13'
    'recovery-genesis-dcm-first-reset-intent' = 'sealed durably reserved nonzero CSPRNG reset ID|2'
    'recovery-genesis-dcm-same-account-successor' = 'preserves account generation and deployment reset ID byte-exact|2'
    'recovery-genesis-dcm-account-reset-intent' = 'authors new DCM before DRA binding its exact ref|5'
    'recovery-genesis-dcm-reset-intent-cross-feed' = 'mixed ResetManifestPredecessorIntent branch rejects before signer callbacks|0'
    'recovery-genesis-account-terminal-fence' = 'terminal DRS is accepted only on a verified DRA old side|0'
    'recovery-genesis-outer-author-replay' = 'advances Created to ExternalCommitted to LocalCommitted|13'
    'recovery-genesis-outer-crash-after-external-cas' = 'completes empty-local CAS without requiring DPL, DCL or DWT|5'
    'recovery-genesis-dcm-coordinator-distribution-crash' = 'byte-identical delivery to all four components|3'
    'recovery-drmv-version-pair-preflight' = 'only accepted recovery prefix pair is DRMV,wireVersion20,profile1,pin274|1'
    'recovery-genesis-gqs-hash-length-framing' = 'golden quorum-selection hash|0'
    'recovery-genesis-reset-logical-scope-fork' = 'same stable key with a different exact235 intent hash|1'
    'recovery-genesis-quorum-pending-crash-rollback' = 'GQP1 is HMAC-fsynced and bound by GAJ Created before witness callbacks|9'
    'recovery-genesis-transaction-intent-remint' = 'GTI1-243 is HMAC-fsynced before transaction-dependent authoring|2'
    'recovery-genesis-prejournal-gas-crash-remint' = 'After GAS fsync but before GQP, RestoreGenesisPreJournalAsync|1'
    'recovery-genesis-prejournal-gqp-crash-remint' = 'After GQP fsync but before GAJ Created, RestoreGenesisPreJournalAsync|1'
    'recovery-genesis-post-seal-pre-gas-crash-replay' = 'crash after successful AEAD self-open and partial DCP/DCS/DCT authoring but before durable GAS1|8'
    'recovery-genesis-gas-fsync-return-loss-remint' = 'After GAS1 and artifact-set fsync but before provider return|1'
    'recovery-genesis-gqp-fsync-return-loss-remint' = 'After GQP1 fsync but before provider return|1'
    'recovery-genesis-replay-gaj-hash-phase-slots' = 'V9 length-framed full HMAC-verified GAJ1 hash and phase-relative 374-byte expected slots|0'
    'recovery-genesis-replay-gfl-revision-time' = 'GFL latchRevision equals checked GAJ revision plus one|2'
    'recovery-genesis-replay-external-dpl-provenance' = 'External DPL ref/source are equality-only|0'
    'recovery-genesis-replay-local-dpl-bytes-required' = 'nonempty local DPL assertion without exact HMAC-verified DPL bytes|1'
    'recovery-genesis-replay-head-toctou' = 'Only a final stable authenticated same-sequence different-ref/source fork or revision/head rollback|3'
    'recovery-genesis-replay-lease-renewal-authoritative-b' = 'same-or-higher read-B revision and fresh same-or-later effective lease|1'
    'recovery-genesis-replay-compatible-head-progress-retry' = 'read-A zero to read-B exact expected candidate advance|2'
    'recovery-genesis-replay-compatible-phase-progress-retry' = 'compatible GAJ phase or local candidate advance during validation|2'
    'recovery-genesis-replay-movement-retry-bound' = 'Exactly three moving read-A/read-B attempts exhaust one absolute-deadline replay invocation|3'
    'recovery-drm20-dgo-layout-pin' = 'DGO is exact282 with DGO1/version1/reserved3-zero header|1'
    'recovery-drm20-dgo-rrm-schema-binding' = 'V10 DGO hash equals signed RRM.schemaFingerprint and all five duplicated axes equal signed RRM|1'
    'recovery-drm20-bootstrap-environment-index' = 'Bootstrap166 includes RRMRef38 and is the sole governanceHash|2'
    'recovery-drm20-dgi-remint-fork' = 'DGI1-160 retains exact DGO and source|2'
    'recovery-drm20-branch-transcripts' = 'First197 kind1, Same203 kind2 and Reset65 kind3 are distinct V10 branches|0'
    'recovery-drm20-reset-origin-complete' = 'ResetOrigin588 verifies exact old-terminal and new-nonterminal|3'
    'recovery-drm20-gar-atomic-remint' = 'GAR1-742 atomically binds verified reset588/hash/remint fields|4'
    'recovery-drm20-gdi-prepared-signed' = 'GDI1-1031 moves Prepared=1 zero to Signed=2 complete|4'
    'recovery-drm20-gdi-signer-order-idempotency' = 'DCM signer calls use stable operation-artifact-role-hash keys|3'
    'recovery-drm20-gra-prepared-signed' = 'GRA1-980 moves only from Prepared|5'
    'recovery-drm20-gra-signer-order-idempotency' = 'DRA signer calls are deterministic and idempotent|4'
    'recovery-drm20-gmd-bitmap-revision' = 'GMD1-447 kind/hash equal sole branch|1'
    'recovery-drm20-gmd-final-barrier' = 'Distributed requires bitmap0x0f after four component durable-CAS callbacks plus rereads|4'
    'api-drm20-relative-rrm-no-authority' = 'Untrusted DGO/DGI and RelativeRRM cannot mint authority|1'
    'api-drm20-data-only-relative-verifiers' = 'Standalone DCM-relative and data-only DRA/DWH verifiers|3'
    'recovery-dtc2-max-target-history' = 'DTC2 exact234+370N+172H accepts N=H=1024 at 555242 bytes|1'
    'recovery-dtc2-history-crossfeed' = 'Wrong network, account, scope3 transition, subject, generation, prefix head or current-DRS history cross-feed|0'
    'recovery-dtc2-history-ordinal-closure' = 'DPD/DPM ordinals must be 1..H|0'
    'recovery-dtc2-cycle-free-dag' = 'revoked DPD/DPM is a protected historical fact|2'
    'recovery-dtc1-drm20-migration-reject' = 'DRM20 accepts only protected DTC2 version2|1'
    'recovery-dtc2-protected-fact-no-capability' = 'DTC2 target and history rows prove revocation recovery facts only|0'
    'recovery-dtc2-active-ref-collision' = 'protected DPD/DPM target ArtifactRef colliding with any active DRM row rejects|0'
    'recovery-dtc2-history-order-time' = 'History revision is below current|1'
}
foreach ($id in $apiClosureVectors.Keys) {
    $parts = ([string]$apiClosureVectors[$id]).Split('|')
    $match = @($vectors.cases | Where-Object { $_.id -eq $id })
    if ($match.Count -ne 1 -or [string]$match[0].purpose -notmatch [regex]::Escape($parts[0]) -or
        ([int]$match[0].callbacks.signature + [int]$match[0].callbacks.agreement + [int]$match[0].callbacks.network + [int]$match[0].callbacks.mutation) -ne [int]$parts[1]) {
        Fail "API/recovery closure vector callback or purpose drifted: $id"
    }
}
$dgoHeaderVector = $vectorById['recovery-drm20-dgo-layout-pin']
$branchVector = $vectorById['recovery-drm20-branch-transcripts']
$dgiStateVector = $vectorById['recovery-drm20-dgi-remint-fork']
$garLayoutVector = $vectorById['recovery-drm20-gar-atomic-remint']
$gdiPhaseVector = $vectorById['recovery-drm20-gdi-prepared-signed']
$graPhaseVector = $vectorById['recovery-drm20-gra-prepared-signed']
$gmdPhaseVector = $vectorById['recovery-drm20-gmd-bitmap-revision']
$gmdBarrierVector = $vectorById['recovery-drm20-gmd-final-barrier']
$dtcOrderVector = $vectorById['recovery-dtc2-history-order-time']
if ([string]$dgoHeaderVector.purpose -notmatch 'DGO1/version1/reserved3-zero.*network, manifestGeneration, environmentResetId, activationAt and componentMask all equal the signed RRM tuple' -or
    [string]$branchVector.purpose -notmatch 'First197 kind1.*First bootstrapSubject and every governanceHash equal Bootstrap166 from sealed context.*substitution or cross-branch reuse rejects' -or
    [string]$dgiStateVector.purpose -notmatch 'DGI1/version1/reserved3-zero.*Retained=1 only.*bad header/state' -or
    [string]$garLayoutVector.purpose -notmatch 'verified reset588/hash/remint fields.*provider-retained referenced evidence.*without inlining artifact bytes.*bad header/state' -or
    [string]$gdiPhaseVector.purpose -notmatch 'Prepared=1 zero.*Signed=2 complete.*kind/hash equal the sole verified branch.*reservationHash is nonzero First/Reset and zero Same.*mismatched state rejects' -or
    [string]$graPhaseVector.purpose -notmatch 'Prepared=1.*Signed=2.*exists iff Reset.*post-HMAC GAR receipt.*bad header/phase' -or
    [string]$gmdPhaseVector.purpose -notmatch 'kind/hash equal sole branch.*Signed GDI and author-set kind.*DCM/branch axes match parsed frozen DCM.*Cross-branch same-operation.*rejects' -or
    [string]$dtcOrderVector.purpose -notmatch 'exact172 rows use unsigned lexicographic order and one-based ordinal') {
    Fail 'DRM20 header/enum/layout/comparator negative-vector closure drifted'
}
if ([int]$gmdBarrierVector.callbacks.signature -ne 0 -or
    [int]$gmdBarrierVector.callbacks.agreement -ne 0 -or
    [int]$gmdBarrierVector.callbacks.network -ne 0 -or
    [int]$gmdBarrierVector.callbacks.mutation -ne 4 -or
    [string]$gmdBarrierVector.purpose -notmatch 'four component durable-CAS callbacks.*four fresh rereads.*Committed1-to-Distributed2.*GRA HMAC/record.*zero signature callbacks') {
    Fail 'DRM20 GMD final-barrier callback semantics drifted'
}
$versionPairVector = @($vectors.cases | Where-Object { $_.id -eq 'recovery-drmv-version-pair-preflight' })
if ($versionPairVector.Count -ne 1 -or
    $versionPairVector[0].purpose -notmatch 'DRMV/version19.*DRM9/version20.*DRMV/version21.*wrong profile or pin length.*after one AEAD.*before every row callback') {
    Fail 'DRMV/version/profile/pin executable preflight vector drifted'
}

Write-Host 'DNP1 classical identity/reset/native-routing specification check passed.'
Write-Host "Records: $($recordMagics.Count)"
Write-Host "Domains: $($domains.Count)"
Write-Host "Vector requirements: $($caseIds.Count)"
Write-Host 'Evidence ownership: 314 exact IDs / package 219 (Protocol 216 + DevOpsWitness 3) / final 95'
Write-Host "Evidence claim: $RequiredEvidenceClaim / mapped $($resultMap.Count)"
Write-Host 'Evidence attestation: parsed result / grounded toolchain / clean tree / reparse-free / CrossRepo exact7'
Write-Host 'Vector schema: Draft 2020-12 equivalent / additionalProperties and JSON-type negative self-tests passed'
$derivedSchemaLines.Add("GENESIS_INPUTS|base=VerifiedGenesisBaseIdentityContext owns verified DPA1 signed exact DCM1 fully-replayed-current-DRS1-with-no-AccountTerminal scopes2..4 role heads and bounded role-plus-DRT facts but no DTC hash/key or Source authority|dcmAuthor=AuthorCutoverManifestAsync sealed relative exact812 freeze-two-signers-self-verify-NoAuthorityClaim with ResetManifestPredecessorIntent exactly one of FirstDeployment(nonzero-reserved-CSPRNG-resetId,gen1,pred0),SameAccountSuccessor(exact-prior,+1,same-resetId),AccountResetSuccessor(sealed-old-new-tuple,new-accountGen-old+1,gen1,pred0,fresh-nonzero-resetId-not-old)|transaction=GenesisTransactionScopeContext exact122 from sealed base-identity release reset-reservation and DCM component row; RestoreOrReserveGenesisTransactionAsync fsyncs GTI1-243 under V7 scope hash and GTI1 HMAC, process-loss remints one nonzero tx, no raw-or-second-ID, reread-and-retain through latch-seal-journal-CAS-GC|accountReset=author-new-DCM-then-DRA-binding-ref-and-old-new-tuple; consumer atomic old-terminal-head-to-new-DCM-plus-DRA CAS; current/candidate AccountTerminal rejects pre-signer-HMAC and only verified DRA old side may be terminal|outer=GenesisAuthorReplay exact-one outer branch with zero-DPL-DWT-DCL and phases Created0,ExternalCommitted1,LocalCommitted2; byte-identical crash replay; after LocalCommitted only fresh NormalCurrentStore|dtc=GenesisCutoverAnchor exact oldDPLRef38-zero and oldSourceFingerprint32-zero under HMAC after frozen tx-component-account; ExistingDPL both nonzero; mixed-cross-branch reject|finalIdentity=only-after-genesis-DTC-HMAC binds exact DTC hash-key with provenance CurrentProtectedStore-or-RecoveredDRM20; base cannot Source; genesis author requires CurrentProtectedStore|release=GenesisReleaseContextV1 internal verified network-reset-latestDWDRef-witnessEpoch|intent=no-public-ctor derives kind1..4 row and componentSubject from final identity plus exact DCM table|order=deployment-DCM-plan-branch-CAS-distribute,base-identity-current-DRS-fence,verify-genesis-release,derive-transaction-scope,restore-or-reserve-GTI1,freeze-tx-component-account,genesis-DTC-HMAC,final-identity,release,intent,keyset,composite-join,Source492-anchor460-oldSource-RFC-RAH-DWH-RSM2-DRC,external-zero-to-one-CAS,empty-local-CAS")
