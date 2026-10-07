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
$mailboxPath = Join-Path $specRoot 'mailbox-authorization-v3.registry.json'
$executionTestPath = Join-Path $repoRoot 'deep-protocol\tests\Deep.Protocol.Tests\ContactV2\CurrentContactSecurityTests.cs'

function Fail([string]$message) { throw "CONTACT-CODEC specification check failed: $message" }
foreach ($path in @($schemaPath, $vectorsPath, $anchorPath, $resolverPath, $applicationPath, $networkPath, $registryPath, $mailboxPath, $executionTestPath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Fail "missing $path" }
}
try {
    $vectorsRaw = Get-Content -LiteralPath $vectorsPath -Raw -Encoding UTF8
    $vectors = $vectorsRaw | ConvertFrom-Json
    $registry = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $anchor = Get-Content -LiteralPath $anchorPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $mailbox = Get-Content -LiteralPath $mailboxPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch { Fail "invalid JSON: $($_.Exception.Message)" }
if (-not ($vectorsRaw | Test-Json -SchemaFile $schemaPath)) { Fail 'vectors do not satisfy schema' }
if ($anchor.artifact -ne 'contact-codec-v1.vectors.json') { Fail 'anchor artifact' }
$canonicalVectorsRaw = $vectorsRaw.Replace("`r`n", "`n")
$vectorDigest = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($canonicalVectorsRaw)))).ToLowerInvariant()
if ($anchor.sha256 -cne $vectorDigest) { Fail 'anchor digest' }
if ($vectors.status -ne 'FROZEN_TARGET_NOT_ACTIVE') { Fail 'vectors status' }
$bounds = $vectors.canonicalBounds
if ($bounds.XRA1.recordBytes -ne 550 -or $bounds.XRA1.signatureProjectionBytes -ne 478) { Fail 'XRA1 canonical bounds' }
foreach ($retired in @('DCB1','DCR1','XMC1','XMG1')) {
    if ($bounds.PSObject.Properties.Name -ccontains $retired -or
        @($vectors.primitives.target) -ccontains $retired -or
        @($vectors.records.target) -ccontains $retired) {
        Fail "retired positive contact input $retired"
    }
}
# DR-0063/0081 bounds come from the reviewed current vector producer, not
# historical DCB1/DCR1 identity grammar or an inferred default payload.
foreach ($kind in @('DMC2/2','DMC2/3')) {
    if ($bounds.$kind.minimumPayloadBytes -ne 5917 -or $bounds.$kind.maximumPayloadBytes -ne 25069 -or
        $bounds.$kind.minimumRecordBytes -ne 6199 -or $bounds.$kind.maximumRecordBytes -ne 25351) {
        Fail "$kind current private reply-route bounds"
    }
}
if ($bounds.XMC2.failureRecordBytes -ne 206 -or $bounds.XMC2.successRecordBytes -ne 510) {
    Fail 'XMC2 exact selector-bound grant bounds'
}
if ($bounds.XMG2.recordBytes -ne 435) { Fail 'XMG2 exact route-bound request size' }
$request = $mailbox.acquisitionRequest
if ($mailbox.requestBindingDecision -cne 'DR-0102' -or
    $request.magic -cne 'XMG2' -or $request.version -ne 1 -or $request.suite -cne '0x0201' -or
    $request.bytes -ne 435 -or $request.tags -ne 12 -or
    (@($request.fieldBytes) -join '|') -cne '16|32|32|32|32|1|38|32|8|8|32|64' -or
    (@($request.signatureProjectionTags) -join '|') -cne '1|2|3|4|5|6|7|8|9|10|11' -or
    $request.signatureProjectionBytes -ne 363 -or $request.signatureDomain -cne 'Deep/ContactResolver/V2/XMG2' -or
    $request.exactRouteHashTag -ne 11 -or $request.exactRouteHashBytes -ne 32 -or
    $request.exactRouteHashNonzero -cne $true -or $request.operationIdTag -ne 2 -or
    $request.operationIdIndependentlyRandom -cne $true -or
    $request.currentRequestMaximumSeconds -ne 120 -or $request.structuralRequestMaximumSeconds -ne 300 -or
    $request.successResultRouteHashMustEqualRequest -cne $true -or $request.legacyReader -cne $false -or
    $mailbox.result.requestMagic -cne 'XMG2' -or @($mailbox.retiredReject) -cnotcontains 'XMG1') {
    Fail 'XMG2 machine route/signature contract'
}
if ($bounds.'DMC2/14'.minimumPayloadBytes -ne 4215 -or $bounds.'DMC2/14'.maximumPayloadBytes -ne 23367 -or
    $bounds.'DMC2/14'.minimumRecordBytes -ne 4497 -or $bounds.'DMC2/14'.maximumRecordBytes -ne 23649) { Fail 'DMC2/14 canonical bounds' }
if ((@($bounds.'DMC2/14'.closureOrder) -join '|') -ne 'XRR1|XRA1|XRC1|XSS1|PMT2|PMS2') { Fail 'DMC2/14 closure order' }
# DR-0069 retained identity-neutral vectors; this is not DID2 owned DCR evidence.
$expected = @('XIR1','XUR1','XRA1','PMT2','PMS2','XRC1','XSS1','XRR1','DIA1','DMC2/2','DMC2/3','DMC2/4','DMC2/14')
if ((@($vectors.primitives.target) -join '|') -ne ($expected -join '|')) { Fail 'primitive targets/order' }
foreach ($primitive in @($vectors.primitives)) {
    $actual = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Convert]::FromHexString([string]$primitive.fixtureBytesHex)))).ToLowerInvariant()
    if ($actual -cne [string]$primitive.sha256) { Fail "fixture hash $($primitive.id)" }
}
$fixtureIds = @($vectors.ed25519Fixtures | ForEach-Object { [string]$_.id })
if (($fixtureIds -join '|') -cne 'xir1-signature-ed25519|xra1-core-ed25519' -or
    $fixtureIds.Count -ne @($fixtureIds | Select-Object -Unique).Count) {
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
$requiredHostileIds = @('xra1-u32-overflow','dmc2-route-closure-hash-mismatch',
    'xra1-header-reserved','xra1-noncanonical-tag','xra1-declared-overflow',
    'xra1-operation-mask-zero','xra1-maximum-hellos-zero','xrr1-minimum-reader-zero','xmg1-retired-request')
if (($hostileIds -join '|') -cne ($requiredHostileIds -join '|') -or
    $hostileIds.Count -ne @($hostileIds | Select-Object -Unique).Count) {
    Fail 'hostile fixture ids'
}
foreach ($fixture in @($vectors.hostileFixtures)) {
    $actual = ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData(
        [Convert]::FromHexString([string]$fixture.fixtureBytesHex)))).ToLowerInvariant()
    if ($actual -cne [string]$fixture.sha256) { Fail "hostile fixture hash $($fixture.id)" }
}
$negativeIds = @($vectors.negativeCases | ForEach-Object { [string]$_.id })
$requiredNegativeIds = @(
    'xir-xra-binding','xrc-xra-sealing-binding','xrc-pmt-xnv-binding','xrr-device-binding',
    'route-validity-intersection','xrr-minimum-reader-zero','pms-tie-break')
if (($negativeIds -join '|') -cne ($requiredNegativeIds -join '|') -or
    $negativeIds.Count -ne @($negativeIds | Select-Object -Unique).Count) { Fail 'negative coverage ids' }
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
# DR-0104 is a separately hash-bound private transcript, not a new public magic.
foreach ($taskRetainedName in @('registry', 'vectors')) {
    $taskRetainedInput = Join-Path $specRoot "mailbox-retained-read-v2.$taskRetainedName.json"
    $taskRetainedSchema = Join-Path $specRoot "mailbox-retained-read-v2.$taskRetainedName.schema.json"
    if (-not (Test-Path -LiteralPath $taskRetainedInput -PathType Leaf) -or
        -not (Test-Path -LiteralPath $taskRetainedSchema -PathType Leaf) -or
        -not (Test-Json -LiteralPath $taskRetainedInput -SchemaFile $taskRetainedSchema)) {
        Fail "DR-0104 closed $taskRetainedName input/schema"
    }
}
# Machine schema, independent digest, exact bounds and negative mappings above
# remain mandatory. Architecture prose is not a snapshot; documentation links
# and rendering are checked by Test-XPointDocumentation.ps1.
$taskRetainedContract = Get-Content -Raw -LiteralPath (Join-Path $specRoot 'mailbox-retained-read-v2.registry.json') | ConvertFrom-Json
# The target is inactive: its slot may be unused, but never occupied by another
# actual consumer operation. Once wired, the exact operation name must match.
foreach ($taskAllocation in @(
    @{ Path='xnode/src/XNode/ContactReplicaTransportContracts.cs'; Enum='ContactReplicaRpcOperation';
       Number=$taskRetainedContract.privateReadRpcOperation; Name='ReadRetainedMailboxGrantRoute' },
    @{ Path='xnode/src/XNode.Core/ContactResolver/ContactServiceReceiptAuthority.cs'; Enum='ContactServiceReceiptKind';
       Number=$taskRetainedContract.privateReceiptKind; Name='MailboxRetainedRead' }
)) {
    $taskConsumer = [IO.File]::ReadAllText((Join-Path $repoRoot $taskAllocation.Path))
    $taskEnum = [regex]::Match($taskConsumer, 'enum\s+' + $taskAllocation.Enum + '(?:\s*:\s*\w+)?\s*\{(?<body>[^}]+)\}')
    if (-not $taskEnum.Success) { Fail 'DR-0104 actual consumer enum missing' }
    $taskRows = [regex]::Matches($taskEnum.Groups['body'].Value, '(?<name>\w+)\s*=\s*(?<number>\d+)')
    if (@($taskRows | Group-Object { $_.Groups['number'].Value } | Where-Object Count -gt 1).Count -ne 0) {
        Fail 'private consumer allocation collision'
    }
    foreach ($taskRow in $taskRows) {
        if ([int]$taskRow.Groups['number'].Value -eq $taskAllocation.Number -and
            $taskRow.Groups['name'].Value -cne $taskAllocation.Name) { Fail 'DR-0104 target reuses existing consumer allocation' }
    }
}
Write-Host 'CONTACT-CODEC retained neutral specification consistency check passed (not executable/package/physical evidence).'
Write-Host "Primitives: $(@($vectors.primitives).Count); hostile fixtures: $(@($vectors.hostileFixtures).Count); policy negatives: $(@($vectors.negativeCases).Count); runtime: inactive"
