[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$specRoot = Join-Path $repoRoot 'docs\survival-program\releases\v3.0.0\specs'
$schemaPath = Join-Path $specRoot 'contact-codec-v1.vectors.schema.json'
$vectorsPath = Join-Path $specRoot 'contact-codec-v1.vectors.json'
$anchorPath = Join-Path $specRoot 'contact-codec-v1.vectors.anchor.json'
$resolverPath = Join-Path $repoRoot 'docs\architecture\CONTACT-RESOLVER-V1.md'
$applicationPath = Join-Path $repoRoot 'docs\architecture\CONTACT-AND-GROUP-PROTOCOL-V1.md'
$networkPath = Join-Path $repoRoot 'docs\architecture\XPOINT-NETWORK-V1.md'
$registryPath = Join-Path $specRoot 'deep-crypto-v1.registry.json'
$executionTestPath = Join-Path $repoRoot 'deep-protocol\tests\Deep.Protocol.Tests\ContactV1\ContactCodecSecurityTests.cs'

function Fail([string]$message) { throw "CONTACT-CODEC specification check failed: $message" }
foreach ($path in @($schemaPath, $vectorsPath, $anchorPath, $resolverPath, $applicationPath, $networkPath, $registryPath, $executionTestPath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Fail "missing $path" }
}
try {
    $vectorsRaw = Get-Content -LiteralPath $vectorsPath -Raw -Encoding UTF8
    $vectors = $vectorsRaw | ConvertFrom-Json
    $registry = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $anchor = Get-Content -LiteralPath $anchorPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch { Fail "invalid JSON: $($_.Exception.Message)" }
if (-not ($vectorsRaw | Test-Json -SchemaFile $schemaPath)) { Fail 'vectors do not satisfy schema' }
if ($anchor.artifact -ne 'contact-codec-v1.vectors.json') { Fail 'anchor artifact' }
$vectorDigest = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($vectorsRaw)))).ToLowerInvariant()
if ($anchor.sha256 -cne $vectorDigest) { Fail 'anchor digest' }
if ($vectors.status -ne 'FROZEN_TARGET_NOT_ACTIVE') { Fail 'vectors status' }
$bounds = $vectors.canonicalBounds
if ($bounds.XRA1.recordBytes -ne 550 -or $bounds.XRA1.signatureProjectionBytes -ne 478) { Fail 'XRA1 canonical bounds' }
if ($bounds.DCB1.minimumRecordBytes -ne 3757 -or $bounds.DCB1.maximumRecordBytes -ne 10275 -or
    $bounds.DCB1.exactAdl1Bytes -ne 228) { Fail 'DCB1/ADL1 canonical bounds' }
if ($bounds.'DMC2/14'.minimumPayloadBytes -ne 4215 -or $bounds.'DMC2/14'.maximumPayloadBytes -ne 23367 -or
    $bounds.'DMC2/14'.minimumRecordBytes -ne 4497 -or $bounds.'DMC2/14'.maximumRecordBytes -ne 23649) { Fail 'DMC2/14 canonical bounds' }
if ((@($bounds.'DMC2/14'.closureOrder) -join '|') -ne 'XRR1|XRA1|XRC1|XSS1|PMT2|PMS2') { Fail 'DMC2/14 closure order' }
$expected = @('XIR1','XUR1','XRA1','PMT2','PMS2','XRC1','XSS1','XRR1','DCB1','DCR1','DIA1','DMC2/2','DMC2/3','DMC2/4','DMC2/14')
if ((@($vectors.primitives.target) -join '|') -ne ($expected -join '|')) { Fail 'primitive targets/order' }
foreach ($primitive in @($vectors.primitives)) {
    $actual = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Convert]::FromHexString([string]$primitive.fixtureBytesHex)))).ToLowerInvariant()
    if ($actual -cne [string]$primitive.sha256) { Fail "fixture hash $($primitive.id)" }
}
$fixtureIds = @($vectors.ed25519Fixtures | ForEach-Object { [string]$_.id })
if ($fixtureIds.Count -ne 3 -or $fixtureIds.Count -ne @($fixtureIds | Select-Object -Unique).Count) {
    Fail 'Ed25519 fixture ids'
}
foreach ($fixture in @($vectors.ed25519Fixtures)) {
    $projection = @($vectors.primitives | Where-Object { $_.id -eq $fixture.projectionPrimitiveId })
    if ($projection.Count -ne 1) { Fail "Ed25519 projection $($fixture.id)" }
    foreach ($property in @('seedHex','publicKeyHex')) {
        if ([string]$fixture.$property -cnotmatch '^[0-9a-f]{64}$') { Fail "Ed25519 $property $($fixture.id)" }
    }
    if ([string]$fixture.signatureHex -cnotmatch '^[0-9a-f]{128}$') { Fail "Ed25519 signature $($fixture.id)" }
    $domain = [Text.Encoding]::ASCII.GetBytes([string]$fixture.signatureDomain)
    $projectionBytes = [Convert]::FromHexString([string]$projection[0].fixtureBytesHex)
    $expectedInput = [byte[]]::new($domain.Length + 7 + $projectionBytes.Length)
    [Array]::Copy($domain, 0, $expectedInput, 0, $domain.Length)
    $expectedInput[$domain.Length] = 0
    $expectedInput[$domain.Length + 1] = 2
    $expectedInput[$domain.Length + 2] = 1
    $length = [BitConverter]::GetBytes([uint32]$projectionBytes.Length)
    if ([BitConverter]::IsLittleEndian) { [Array]::Reverse($length) }
    [Array]::Copy($length, 0, $expectedInput, $domain.Length + 3, 4)
    [Array]::Copy($projectionBytes, 0, $expectedInput, $domain.Length + 7, $projectionBytes.Length)
    $expectedInputHex = ([Convert]::ToHexString($expectedInput)).ToLowerInvariant()
    if ($expectedInputHex -cne [string]$fixture.signatureInputHex) { Fail "Ed25519 signature input $($fixture.id)" }
}
$hostileIds = @($vectors.hostileFixtures | ForEach-Object { [string]$_.id })
if ($hostileIds.Count -lt 10 -or $hostileIds.Count -ne @($hostileIds | Select-Object -Unique).Count) {
    Fail 'hostile fixture ids'
}
foreach ($fixture in @($vectors.hostileFixtures)) {
    $actual = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData(
        [Convert]::FromHexString([string]$fixture.fixtureBytesHex)))).ToLowerInvariant()
    if ($actual -cne [string]$fixture.sha256) { Fail "hostile fixture hash $($fixture.id)" }
}
$negativeIds = @($vectors.negativeCases | ForEach-Object { [string]$_.id })
$requiredNegativeIds = @(
    'dcr-missing-support','dcr-extra-support','dcr-duplicate-support','dcr-reordered-support',
    'dcr-unverified-drs','dcr-unverified-dpd','dcb-invalid-signature','xps-invalid-signature',
    'xir-xra-binding','xrc-xra-sealing-binding','xrc-pmt-xnv-binding','xrr-device-binding',
    'route-validity-intersection','invalid-profile-utf8','xrr-minimum-reader-zero',
    'dcr-support-overflow','pms-tie-break')
if ($negativeIds.Count -lt $requiredNegativeIds.Count -or $negativeIds.Count -ne @($negativeIds | Select-Object -Unique).Count) { Fail 'negative coverage ids' }
foreach ($id in $requiredNegativeIds) { if ($negativeIds -notcontains $id) { Fail "missing negative coverage $id" } }
$executionSource = Get-Content -LiteralPath $executionTestPath -Raw -Encoding UTF8
foreach ($id in $requiredNegativeIds) {
    if ($executionSource.IndexOf(('"' + $id + '"'), [StringComparison]::Ordinal) -lt 0) {
        Fail "missing executable negative $id"
    }
}
foreach ($case in @($vectors.negativeCases)) {
    foreach ($name in @('hash','signature','resolver','mutation')) {
        if ([int]$case.callbacks.$name -ne 0) { Fail "negative callbacks $($case.id)" }
    }
}
$contact = @($registry.packages | Where-Object { $_.id -eq 'CONTACT-CODEC-01' })
if ($contact.Count -ne 1 -or $contact[0].status -ne 'FROZEN_TARGET_NOT_ACTIVE') { Fail 'CONTACT package status' }
if (-not $registry.activationGates.contactCodecFieldsClosed) { Fail 'contact field gate' }
if ($registry.contactCodec.status -ne 'FROZEN_TARGET_NOT_ACTIVE' -or $registry.contactCodec.vectors -ne 'contact-codec-v1.vectors.json') { Fail 'registry contact manifest' }
foreach ($needle in @('CONTACT-CODEC canonical record rule','XRA1','PMT2','PMS2','XRR1','ContactHello','ContactAccept','ContactReject','ContactRouteUpdate','MUST NOT receive or derive DID1')) {
    if ((Get-Content -LiteralPath $resolverPath -Raw -Encoding UTF8).IndexOf($needle, [StringComparison]::Ordinal) -lt 0 -and
        (Get-Content -LiteralPath $applicationPath -Raw -Encoding UTF8).IndexOf($needle, [StringComparison]::Ordinal) -lt 0) { Fail "normative text absent: $needle" }
}
foreach ($needle in @('XRA1 is exactly 550 bytes', 'tags 1..15 (478 bytes)', '12 + 16*8 + 410 = 550',
    '`4,215..23,367`', '`4,497..23,649`', '97 + 4,118 = 4,215', '97 + 23,270 = 23,367')) {
    if ((Get-Content -LiteralPath $resolverPath -Raw -Encoding UTF8).IndexOf($needle, [StringComparison]::Ordinal) -lt 0 -and
        (Get-Content -LiteralPath $applicationPath -Raw -Encoding UTF8).IndexOf($needle, [StringComparison]::Ordinal) -lt 0) { Fail "canonical bound absent: $needle" }
}
if ((Get-Content -LiteralPath $networkPath -Raw -Encoding UTF8).IndexOf('CONTACT-RESOLVER-V1 §3.6', [StringComparison]::Ordinal) -lt 0) { Fail 'network source link' }
Write-Host 'CONTACT-CODEC specification consistency check passed.'
Write-Host "Primitives: $(@($vectors.primitives).Count); hostile fixtures: $(@($vectors.hostileFixtures).Count); policy negatives: $(@($vectors.negativeCases).Count); runtime: inactive"
