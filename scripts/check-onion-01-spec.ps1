[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$specRoot = Join-Path $repoRoot 'docs\survival-program\releases\v3.0.0\specs'
$schemaPath = Join-Path $specRoot 'onion-01.vectors.schema.json'
$vectorsPath = Join-Path $specRoot 'onion-01.vectors.json'
$privacyPath = Join-Path $repoRoot 'deep-protocol\docs\deep-extension-privacy-routing-v1.md'
$privacySourceRoot = Join-Path $repoRoot 'deep-protocol\src\Deep.Protocol\DeepExtension\PrivacyRouting'
$privacyCodecPath = Join-Path $privacySourceRoot 'PrivacyRoutingCodec.cs'
$registryPath = Join-Path $repoRoot 'deep-protocol\registry\deep-protocol-v1.registry.json'
$registryDocPath = Join-Path $repoRoot 'docs\architecture\PROTOCOL-REGISTRY-V1.md'
$planPath = Join-Path $repoRoot 'docs\architecture\IMPLEMENTATION-PLAN-V1.md'

function Fail([string] $Message) { throw "ONION-01 specification check failed: $Message" }
function Assert-Equal([object] $Actual, [object] $Expected, [string] $Name) {
    if ($Actual -cne $Expected) { Fail "${Name}: expected '$Expected', got '$Actual'" }
}
function Assert-Fields([object] $Contract, [object[]] $Expected) {
    $actual = @($Contract.fields | ForEach-Object { "$($_.offset):$($_.length):$($_.name)" })
    $wanted = @($Expected | ForEach-Object { "$_" })
    if (($actual -join '|') -cne ($wanted -join '|')) { Fail "field map $($Contract.magic)" }
}

foreach ($path in @($schemaPath, $vectorsPath, $privacyPath, $privacyCodecPath, $registryPath, $registryDocPath, $planPath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Fail "missing $path" }
}
try {
    $raw = Get-Content -LiteralPath $vectorsPath -Raw -Encoding UTF8
    $vectors = $raw | ConvertFrom-Json
    $registry = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch { Fail "invalid JSON: $($_.Exception.Message)" }
if (-not ($raw | Test-Json -SchemaFile $schemaPath)) { Fail 'vectors do not satisfy schema' }
Assert-Equal $vectors.status 'FROZEN_TARGET_NOT_ACTIVE' 'vectors status'
if ($vectors.runtimeActivation) { Fail 'runtime activation must remain false' }
$terminalOperations = @($vectors.terminalOperations)
if (($terminalOperations.Count -ne 5) -or
    ((@($terminalOperations | ForEach-Object { "$($_.id):$($_.name)" }) -join '|') -cne '1:Store|2:Retrieve|3:Acknowledge|4:ContactResolve|5:GroupControl')) {
    Fail 'terminal operation enum'
}
$groupOperation = $terminalOperations[4]
if ((@($groupOperation.requestMagic) -join '|') -cne 'GSW1|GSQ1' -or
    (@($groupOperation.successMagic) -join '|') -cne 'GSS1' -or
    [int]$groupOperation.maxRequestBytes -ne 33160 -or
    [int]$groupOperation.maxSuccessBytes -ne 65535) {
    Fail 'GroupControl exact pairing or bounds'
}
$contactOperation = $terminalOperations[3]
if ((@($contactOperation.requestMagic) -join '|') -cne 'XPU1|XIQ1|XPK1|XUW1|XUQ1' -or
    (@($contactOperation.successMagic) -join '|') -cne 'XPO1|XIS1|XPC1|XUS1' -or
    [int]$contactOperation.maxRequestBytes -ne 69649 -or
    [int]$contactOperation.maxSuccessBytes -ne 131072) {
    Fail 'ContactResolve exact pairing or bounds'
}

$contracts = @{}
foreach ($contract in @($vectors.wireContracts)) { $contracts[[string]$contract.magic] = $contract }
if ((@($contracts.Keys | Sort-Object) -join '|') -cne 'XPR1|XRE1|XRF1|XRL1|XRS1') { Fail 'exact wire contract magics' }
$expectedContracts = @{
    XRF1 = @{ prefix = 160; max = 1572864; fields = @('0:4:magic','4:1:version','5:1:minimumReader','6:1:suite','7:1:purpose','8:1:layerKind','12:16:networkId','28:32:keyOwnerId','60:8:epoch','68:32:keyId','100:32:ephemeralPublic','132:24:nonce','156:4:ciphertextLength') }
    XRL1 = @{ prefix = 80; max = 1180046; fields = @('0:4:magic','4:1:version','5:1:minimumReader','6:1:layerKind','8:32:replayId','40:32:nextRouterId','72:4:innerLength','76:1:paddingExponent','77:3:paddingLength') }
    XRE1 = @{ prefix = 144; max = 1114255; fields = @('0:4:magic','4:1:version','5:1:minimumReader','6:1:layerKind','7:1:operation','8:32:replayId','40:32:operationId','72:32:attemptId','104:32:replyPublic','136:4:requestLength','140:1:paddingExponent','141:3:paddingLength') }
    XPR1 = @{ prefix = 20; max = 1048576; fields = @('0:4:magic','4:1:version','5:1:minimumReader','6:1:kind','7:1:operation','8:2:failureCode','10:1:retryable','12:4:bodyLength','16:4:reserved') }
    XRS1 = @{ prefix = 80; max = 1114191; fields = @('0:4:magic','4:1:version','5:1:minimumReader','6:1:operation','8:32:operationId','40:32:attemptId','72:4:resultLength','76:1:paddingExponent','77:3:paddingLength') }
}
foreach ($magic in $expectedContracts.Keys) {
    Assert-Equal ([int]$contracts[$magic].fixedPrefixBytes) ([int]$expectedContracts[$magic].prefix) "$magic prefix"
    Assert-Equal ([int]$contracts[$magic].maxBytes) ([int]$expectedContracts[$magic].max) "$magic max"
    Assert-Fields $contracts[$magic] $expectedContracts[$magic].fields
}

$positive = @($vectors.positiveCases)
if ($positive.Count -ne 1) { Fail 'positive case count' }
$case = $positive[0]
if (-not $case.testEntropyOnly -or [int]$case.paddingExponent -ne 8) { Fail 'test-only entropy policy' }
foreach ($domain in @('Deep/XPoint/V1/canonical-mailbox-operation-id','Deep/XPoint/V1/reply-owner','Deep/XPoint/V1/reply-key')) {
    if (@($case.operationIdDomain, $case.replyOwnerIdDomain, $case.replyKeyIdDomain) -cnotcontains $domain) { Fail "missing exact domain $domain" }
}
if ((@($case.expectedFrames | ForEach-Object { $_.name }) -join '|') -cne 'exit-request|core-request|ingress-request|response') { Fail 'positive frame order' }
if ((@($case.expectedFrames | ForEach-Object { $_.length }) -join '|') -cne '512|768|1024|512') { Fail 'positive frame lengths' }
foreach ($frame in @($case.expectedFrames)) {
    if (($frame.sha256 -notmatch '^[0-9a-f]{64}$') -or ([int]$frame.length % 256) -ne 0) { Fail "positive frame fixture $($frame.name)" }
}
foreach ($value in @($case.entropy.routerPrivateScalars + $case.entropy.replyPrivateScalar + $case.entropy.requestEphemeralPrivateScalars + $case.entropy.responseEphemeralPrivateScalar + $case.entropy.requestNonces + $case.entropy.responseNonce)) {
    if ($value -notmatch '^(?:[0-9a-f]{2})+$' -or $value -match '^0+$') { Fail 'zero or malformed test entropy' }
}
if ((@($case.route.routerOwnerIds) -join '|') -cne ((@('11','22','33') | ForEach-Object { $_ * 32 }) -join '|') -or
    (@($case.route.routerKeyIds) -join '|') -cne ((@('a1','a2','a3') | ForEach-Object { $_ * 32 }) -join '|') -or
    (@($case.route.replayIds) -join '|') -cne ((@('63','62','61') | ForEach-Object { $_ * 32 }) -join '|') -or
    [int]$case.route.epoch -ne 7 -or $case.route.canonicalRequestHex -ne '') { Fail 'deterministic route binding' }
foreach ($value in @($case.route.attemptIdHex, $case.route.expectedOperationIdHex, $case.route.expectedReplyPublicHex, $case.route.expectedReplyOwnerIdHex, $case.route.expectedReplyKeyIdHex)) {
    if ($value -notmatch '^[0-9a-f]{64}$' -or $value -match '^0+$') { Fail 'deterministic derived binding' }
}

$negativeIds = @($vectors.negativeCases.id)
if ($negativeIds.Count -ne 18 -or $negativeIds.Count -ne (@($negativeIds | Select-Object -Unique).Count)) { Fail 'negative case IDs' }
$requiredNegatives = @('legacy-drf1','legacy-drl1','legacy-dre1','legacy-dpr1','legacy-drs1','xrf1-zero-public-or-shared-secret','padding-exponent-length-or-nonzero','fourth-nested-request-frame','reply-owner-key-operation-attempt-mismatch','trusted-time-overlap-expiry-retirement')
foreach ($id in $requiredNegatives) { if ($negativeIds -cnotcontains $id) { Fail "negative missing $id" } }
foreach ($negative in @($vectors.negativeCases)) {
    foreach ($callback in @('forward','mailbox','stateMutation')) {
        if ([int]$negative.callbacks.$callback -ne 0) { Fail "negative callbacks $($negative.id)" }
    }
}

$onionSuite = @($registry.suites | Where-Object { $_.scope -eq 'xpoint-onion-u8' -and $_.id -eq 1 })
if ($onionSuite.Count -ne 1 -or $onionSuite[0].lifecycle -ne 'FROZEN_TARGET_NOT_ACTIVE') { Fail 'onion suite lifecycle' }
$onionMagic = @($registry.magic | Where-Object { $_.value -in @('XRF1','XRL1','XRE1','XPR1','XRS1') })
if ($onionMagic.Count -ne 5 -or @($onionMagic | Where-Object lifecycle -ne 'FROZEN_TARGET_NOT_ACTIVE').Count -ne 0) { Fail 'onion magic lifecycle' }
$retiredPrivacyMagic = @($registry.magic | Where-Object { $_.value -in @('DRF1','DRL1','DRE1') })
if ($retiredPrivacyMagic.Count -ne 3 -or @($retiredPrivacyMagic | Where-Object lifecycle -ne 'RETIRED_REJECT').Count -ne 0 -or
    @($retiredPrivacyMagic | Where-Object { $_.PSObject.Properties.Name -contains 'targetLifecycle' }).Count -ne 0) {
    Fail 'legacy privacy magic is not an immediate retired reject set'
}
if (@($registry.magic.value | Group-Object | Where-Object Count -gt 1).Count -ne 0) { Fail 'registry magic collision' }
if ($registry.productionInventory.knownCrossNamespaceCollisions.Count -ne 0) { Fail 'global registry collision inventory' }

$privacy = Get-Content -LiteralPath $privacyPath -Raw -Encoding UTF8
$registryDoc = Get-Content -LiteralPath $registryDocPath -Raw -Encoding UTF8
$plan = Get-Content -LiteralPath $planPath -Raw -Encoding UTF8
foreach ($needle in @('Status: **FROZEN_CODEC_IMPLEMENTED_PUBLIC_API_INACTIVE**','runtimeActivation=false','exact 160-byte authenticated header','Deep/XPoint/V1/frame-salt','Deep/XPoint/V1/frame-key','frame[0..159]','all-zero X25519 shared secret','exactly 300 seconds','exactly two XRL1 and one XRE1','DPR1` and `DRS1` retain only their DNP1 meanings','MQR3','MRP1','MAR1','ContactResolve','XPU1/XIQ1/XPK1/XUW1/XUQ1','XPO1/XIS1/XPC1/XUS1','GroupControl','GSW1/GSQ1','GSS1','no HTTP client, URI, direct-service fallback','Protocol-owned attempt ID')) {
    if ($privacy.IndexOf($needle, [StringComparison]::Ordinal) -lt 0) { Fail "normative text absent: $needle" }
}
if ($privacy.IndexOf('Deep/PrivacyRouting', [StringComparison]::Ordinal) -ge 0) { Fail 'retired operation domain present' }
$privacySource = (@(Get-ChildItem -LiteralPath $privacySourceRoot -Filter '*.cs' -File | ForEach-Object {
    Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
}) -join "`n")
if ($privacySource.IndexOf('public const bool RuntimeActivation = false;', [StringComparison]::Ordinal) -lt 0 -or
    $privacySource.IndexOf('RuntimeActivation = true', [StringComparison]::Ordinal) -ge 0) {
    Fail 'runtime activation source flag'
}
foreach ($forbidden in @('public static class PrivacyRoutingRequestBuilder','public static class PrivacyRoutingRequestCodec','public static class PrivacyRoutingResponseCodec','public sealed class PrivacyRoutingHop','public sealed class PrivacyRoutingReceiveKey','public interface IPrivacyRoutingReplayStateStore')) {
    if ($privacySource.IndexOf($forbidden, [StringComparison]::Ordinal) -ge 0) { Fail "public raw runtime bypass present: $forbidden" }
}
foreach ($needle in @('FROZEN_TARGET_NOT_ACTIVE','old XSalsa/DRF1 bytes reject','runtimeActivation=false')) {
    if (($registryDoc + $plan).IndexOf($needle, [StringComparison]::Ordinal) -lt 0) { Fail "architecture freeze binding absent: $needle" }
}
Write-Host 'ONION-01 frozen specification consistency check passed.'
Write-Host "Wire records: $($contracts.Count); deterministic positives: $($positive.Count); hostile negatives: $($negativeIds.Count); runtime: inactive"
