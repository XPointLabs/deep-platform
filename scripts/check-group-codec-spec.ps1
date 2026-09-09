[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$specRoot = Join-Path $PSScriptRoot '..\docs\survival-program\releases\v3.0.0\specs'
$vectorPath = Join-Path $specRoot 'group-codec-v1.vectors.json'
$anchorPath = Join-Path $specRoot 'group-codec-v1.vectors.anchor.json'
$schemaPath = Join-Path $specRoot 'group-codec-v1.vectors.schema.json'
$codecPath = Join-Path $PSScriptRoot '..\deep-protocol\src\Deep.Protocol\GroupV1\GroupCodec.cs'
$transitionVerifierPath = Join-Path $PSScriptRoot '..\deep-protocol\src\Deep.Protocol\GroupV1\GroupTransitionVerifier.cs'
$protocolRegistryPath = Join-Path $PSScriptRoot '..\deep-protocol\registry\deep-protocol-v1.registry.json'
$generatedRegistryPath = Join-Path $PSScriptRoot '..\deep-protocol\src\Deep.Protocol\Generated\DeepProtocolRegistry.Generated.cs'
$vectorTool = Join-Path $PSScriptRoot '..\deep-protocol\eng\GroupCodecVectors\GroupCodecVectors.csproj'
$testProject = Join-Path $PSScriptRoot '..\deep-protocol\tests\Deep.Protocol.Tests\Deep.Protocol.Tests.csproj'
$expectedDigest = 'dca069d80c506c2fe5da5b1c14073d784a875666484f83f7deb13662dd60147e'

foreach ($path in @($vectorPath, $anchorPath, $schemaPath, $codecPath, $transitionVerifierPath, $protocolRegistryPath, $generatedRegistryPath, $vectorTool, $testProject)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing GROUP-CODEC-01 input: $path" }
}

$vectorsRaw = Get-Content -LiteralPath $vectorPath -Raw
if (-not ($vectorsRaw | Test-Json -SchemaFile $schemaPath)) { throw 'GROUP-CODEC-01 vectors do not satisfy their frozen schema.' }
$vectors = $vectorsRaw | ConvertFrom-Json -Depth 100
$anchor = Get-Content -LiteralPath $anchorPath -Raw | ConvertFrom-Json -Depth 20
$canonicalVectorBytes = [Text.Encoding]::UTF8.GetBytes(
    $vectorsRaw.Replace("`r`n", "`n").Replace("`r", "`n"))
$algorithm = [Security.Cryptography.SHA256]::Create()
try {
    $digestText = [BitConverter]::ToString($algorithm.ComputeHash($canonicalVectorBytes))
    $digest = $digestText.Replace('-', '').ToLowerInvariant()
}
finally {
    $algorithm.Dispose()
}
if ($digest -cne [string]$anchor.sha256) { throw "GROUP-CODEC-01 vector digest does not match the independent anchor." }
if ($digest -cne $expectedDigest) { throw 'GROUP-CODEC-01 vector digest does not match the checker literal pin.' }
if (@($vectors.records).Count -ne 12 -or @($vectors.hostileCases).Count -lt 14) { throw 'GROUP-CODEC-01 requires twelve canonical records and at least fourteen hostile fixtures.' }
$targets = @($vectors.records | ForEach-Object { [string]$_.target } | Sort-Object -Unique)
$expected = @('DGC1','DGM1','DGP1','DGT1','GCF1','GCP1','GIA1','GIV1','GSQ1','GSR1','GSS1','GSW1')
if (Compare-Object $expected $targets) { throw 'GROUP-CODEC-01 canonical target set is incomplete or contains extras.' }
foreach ($record in @($vectors.records)) {
    if ([string]$record.recordHash32 -notmatch '^[0-9a-f]{64}$') { throw "Invalid recordHash32: $($record.id)" }
}
if ([int]$anchor.recordCount -ne @($vectors.records).Count -or [int]$anchor.hostileCaseCount -ne @($vectors.hostileCases).Count) { throw 'GROUP-CODEC-01 anchor counts do not match vectors.' }
if ([bool]$anchor.runtimeActivation -or -not [bool]$anchor.accountDirectoryCapabilityAvailable) { throw 'GROUP-CODEC-01 anchor must keep runtime inactive and pin the available production directory capability.' }
$codec = Get-Content -LiteralPath $codecPath -Raw
$transitionVerifier = Get-Content -LiteralPath $transitionVerifierPath -Raw
if ($codec -notmatch 'public static bool RuntimeActivation => false;') { throw 'GROUP-CODEC-01 runtime must remain inactive.' }
if ($transitionVerifier -notmatch 'public static bool AccountDirectoryCapabilityAvailable => true;' -or
    $transitionVerifier -match 'AccountDirectoryVerifierUnavailable|#if !DEEP_PROTOCOL_RECOVERY_TEST_SEAM') { throw 'GROUP-CODEC-01 production directory capability is not wired cleanly.' }
if ($codec -match 'AuthorForValidation|CreateDmc2PayloadForValidation') { throw 'A production-callable validation author seam remains.' }

$protocolRegistry = Get-Content -LiteralPath $protocolRegistryPath -Raw | ConvertFrom-Json -Depth 100
foreach ($magic in @('GSR1','GSW1','GSQ1','GSS1')) {
    $rows = @($protocolRegistry.magic | Where-Object { [string]$_.value -ceq $magic })
    if ($rows.Count -ne 1 -or [string]$rows[0].lifecycle -cne 'FROZEN_TARGET_NOT_ACTIVE') {
        throw "GROUP-CODEC-01 registry row $magic is missing, duplicated, or not frozen."
    }
}
$generatedRegistry = Get-Content -LiteralPath $generatedRegistryPath -Raw
foreach ($magic in @('GSR1','GSW1','GSQ1','GSS1')) {
    $expectedGeneratedRow = 'new("magic", "' + $magic + '", null, ProtocolIdentifierLifecycle.FROZEN_TARGET_NOT_ACTIVE)'
    if (-not $generatedRegistry.Contains($expectedGeneratedRow, [StringComparison]::Ordinal)) {
        throw "GROUP-CODEC-01 generated registry does not freeze $magic."
    }
}

dotnet run --project $vectorTool -c Release --no-restore -- check $vectorPath
if ($LASTEXITCODE -ne 0) { throw 'GROUP-CODEC-01 executable vector verification failed.' }
dotnet test $testProject -c Release --no-restore --filter 'FullyQualifiedName~GroupV1'
if ($LASTEXITCODE -ne 0) { throw 'GROUP-CODEC-01 focused Release tests failed.' }

Write-Host "GROUP-CODEC-01 specification check passed. Records: $(@($vectors.records).Count); hostile: $(@($vectors.hostileCases).Count); runtime: inactive; directory capability: available"
