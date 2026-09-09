[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$specRoot = Join-Path $repoRoot 'docs\survival-program\releases\v3.0.0\specs'
$specPath = Join-Path $specRoot 'DEEP-CRYPTO-V1-DRAFT.md'
$applicationSpecPath = Join-Path $repoRoot 'docs\architecture\CONTACT-AND-GROUP-PROTOCOL-V1.md'
$providerPath = Join-Path $specRoot 'PQ-PROVIDER-FEASIBILITY.md'
$registryPath = Join-Path $specRoot 'deep-crypto-v1.registry.json'
$registrySchemaPath = Join-Path $specRoot 'deep-crypto-v1.registry.schema.json'
$vectorSchemaPath = Join-Path $specRoot 'deep-crypto-v1.vectors.schema.json'
$contactVectorSchemaPath = Join-Path $specRoot 'contact-codec-v1.vectors.schema.json'
$contactVectorsPath = Join-Path $specRoot 'contact-codec-v1.vectors.json'

function Fail([string]$Message) { throw "Deep crypto specification check failed: $Message" }

function Assert-Equal([object]$Actual, [object]$Expected, [string]$Name) {
    if ([string]$Actual -cne [string]$Expected) {
        Fail "$Name drifted: expected '$Expected', actual '$Actual'"
    }
}

function Assert-Sequence([object[]]$Actual, [object[]]$Expected, [string]$Name) {
    $actualValues = @($Actual | Where-Object { $null -ne $_ } | ForEach-Object { [string]$_ })
    $expectedValues = @($Expected | Where-Object { $null -ne $_ } | ForEach-Object { [string]$_ })
    if ($actualValues.Count -ne $expectedValues.Count) {
        Fail "$Name count drifted: expected $($expectedValues.Count), actual $($actualValues.Count)"
    }
    for ($index = 0; $index -lt $expectedValues.Count; $index++) {
        if ($actualValues[$index] -cne $expectedValues[$index]) {
            Fail "$Name drifted at index $index`: expected '$($expectedValues[$index])', actual '$($actualValues[$index])'"
        }
    }
}

function Get-Field([object]$Record, [int]$Tag) {
    $field = @($Record.fields | Where-Object { [int]$_.tag -eq $Tag })
    if ($field.Count -ne 1) { Fail "$($Record.magic) must contain exactly one tag $Tag" }
    return $field[0]
}

function Get-FixedRecordTotal([object]$Record, [hashtable]$LengthOverrides = @{}) {
    $total = 12 + (8 * @($Record.fields).Count)
    foreach ($field in @($Record.fields)) {
        $tag = [int]$field.tag
        if ($LengthOverrides.ContainsKey($tag)) {
            $total += [int]$LengthOverrides[$tag]
            continue
        }
        $lengths = @($field.lengths)
        if ($lengths.Count -ne 1) {
            Fail "$($Record.magic) tag $tag is not fixed and has no arithmetic override"
        }
        $total += [int]$lengths[0]
    }
    return $total
}

function Assert-AllowedTotals([object]$Record, [int[]]$Expected) {
    $actual = @($Record.allowedTotalBytes | ForEach-Object { [int]$_ } | Sort-Object -Unique)
    $expectedSorted = @($Expected | Sort-Object -Unique)
    Assert-Sequence $actual $expectedSorted "$($Record.magic) allowed totals"
}

function Assert-ClosedObjectSchemas([object]$Node, [string]$Path) {
    if ($null -eq $Node) { return }
    if ($Node -is [System.Collections.IEnumerable] -and $Node -isnot [string] -and $Node -isnot [pscustomobject]) {
        $index = 0
        foreach ($item in $Node) {
            Assert-ClosedObjectSchemas $item "$Path[$index]"
            $index++
        }
        return
    }
    if ($Node -isnot [pscustomobject]) { return }
    if ([string]$Node.type -ceq 'object') {
        $additional = $Node.PSObject.Properties['additionalProperties']
        if ($null -eq $additional -or $additional.Value -ne $false) {
            Fail "object schema is not closed at $Path"
        }
    }
    foreach ($property in $Node.PSObject.Properties) {
        Assert-ClosedObjectSchemas $property.Value "$Path.$($property.Name)"
    }
}

foreach ($path in @($specPath, $applicationSpecPath, $providerPath, $registryPath, $registrySchemaPath, $vectorSchemaPath, $contactVectorSchemaPath, $contactVectorsPath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Fail "missing artifact: $path" }
}

try {
    $spec = Get-Content -LiteralPath $specPath -Raw -Encoding UTF8
    $applicationSpec = Get-Content -LiteralPath $applicationSpecPath -Raw -Encoding UTF8
    $provider = Get-Content -LiteralPath $providerPath -Raw -Encoding UTF8
    $registryRaw = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8
    $registrySchemaRaw = Get-Content -LiteralPath $registrySchemaPath -Raw -Encoding UTF8
    $vectorSchemaRaw = Get-Content -LiteralPath $vectorSchemaPath -Raw -Encoding UTF8
    $registry = $registryRaw | ConvertFrom-Json
    $registrySchema = $registrySchemaRaw | ConvertFrom-Json
    $vectorSchema = $vectorSchemaRaw | ConvertFrom-Json
    $contactVectorsRaw = Get-Content -LiteralPath $contactVectorsPath -Raw -Encoding UTF8
    $contactVectors = $contactVectorsRaw | ConvertFrom-Json
} catch {
    Fail "normative JSON does not parse: $($_.Exception.Message)"
}

if (-not ($registryRaw | Test-Json -SchemaFile $registrySchemaPath)) {
    Fail 'registry does not satisfy deep-crypto-v1.registry.schema.json'
}
Assert-Equal $registry.'$schema' 'deep-crypto-v1.registry.schema.json' 'registry schema link'
Assert-Equal $registrySchema.'$schema' 'https://json-schema.org/draft/2020-12/schema' 'registry schema dialect'
if ($registrySchema.additionalProperties -ne $false) { Fail 'registry top-level schema must be closed' }

# Compact structural governance gate; this intentionally is not a prose snapshot.
Assert-Equal $registry.schemaVersion '3.0.0' 'registry schemaVersion'
Assert-Equal $registry.registryGeneration 3 'registry generation'
Assert-Equal $registry.codecFamily 'DEEP-MESSAGING-CODEC-V1' 'codec family'
Assert-Equal $registry.decision 'DR-0003' 'decision binding'
Assert-Equal $registry.codecStatus 'PACKAGE_SPLIT' 'codec status'
Assert-Equal $registry.productionActivation 'NOT_ACTIVE' 'production activation'

$expectedPackages = @(
    @{ Id='E2EE-01'; Status='FROZEN_CLEAN_BREAK'; Records=@('DPK2','DPH2','DTR2','DPE2'); Kinds=@() },
    @{ Id='APPLICATION-CORE-CODEC-01'; Status='FROZEN_CLEAN_BREAK'; Records=@('DID1','DAB1','DMD1','DCA1','DAO1','DMC2'); Kinds=@() },
    @{ Id='ATTACHMENT-CODEC-01'; Status='FROZEN_CLEAN_BREAK'; Records=@('DAM1'); Kinds=@(18,19) },
    @{ Id='CONTACT-CODEC-01'; Status='FROZEN_TARGET_NOT_ACTIVE'; Records=@('DCB1','DCR1','DIA1','XIR1','XUR1','XRA1','XRC1','XRR1','XSS1','PMT2','PMS2'); Kinds=@(2,3,4,14) },
    @{ Id='GROUP-CODEC-01'; Status='FROZEN_TARGET_NOT_ACTIVE'; Records=@('GIV1','GIA1','DGP1','DGC1','DGM1','DGT1','GCP1','GCF1','GSR1','GSW1','GSQ1','GSS1'); Kinds=@(15,16,17,26,27,28,29) },
    @{ Id='CALL-CODEC-01'; Status='TARGET_UNFROZEN'; Records=@(); Kinds=@(20,21,22,23,24) },
    @{ Id='HISTORY-CODEC-01'; Status='TARGET_UNFROZEN'; Records=@(); Kinds=@(25) }
)
Assert-Equal @($registry.packages).Count $expectedPackages.Count 'package count'
for ($index = 0; $index -lt $expectedPackages.Count; $index++) {
    $actual = @($registry.packages)[$index]
    $expected = $expectedPackages[$index]
    Assert-Equal $actual.id $expected.Id "package[$index] id"
    Assert-Equal $actual.status $expected.Status "package[$index] status"
    Assert-Sequence @($actual.records) @($expected.Records) "$($expected.Id) records"
    Assert-Sequence @($actual.dmc2Kinds) @($expected.Kinds) "$($expected.Id) DMC2 kinds"
}

$suites = @($registry.suites)
Assert-Equal $suites.Count 2 'suite count'
Assert-Equal $suites[0].id 513 'target suite id'
Assert-Equal $suites[0].hex '0x0201' 'target suite hex'
Assert-Equal $suites[0].status 'FROZEN_TARGET_NOT_ACTIVE' 'target suite status'
if (-not $suites[0].classicalAndPqRequired -or $suites[0].runtimeFallback) {
    Fail 'suite 0x0201 must require classical plus PQ and forbid runtime fallback'
}
Assert-Equal $suites[1].id 514 'reserved suite id'
Assert-Equal $suites[1].hex '0x0202' 'reserved suite hex'
Assert-Equal $suites[1].status 'RESERVED_REJECT' 'reserved suite status'

$records = @($registry.records)
$expectedMagics = @('DPK2','DPH2','DTR2','DPE2','DID1','DAB1','DMD1','DCA1','DCB1','DCR1','DIA1','DAO1','DMC2','DAM1')
Assert-Equal $records.Count 14 'record count'
Assert-Sequence @($records.magic) $expectedMagics 'record magics'
$magicSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
foreach ($record in $records) {
    if (-not $magicSet.Add([string]$record.magic)) { Fail "duplicate record magic $($record.magic)" }
    if ([string]$record.magic -notmatch '^[A-Z0-9]{4}$') { Fail "invalid record magic $($record.magic)" }
    Assert-Equal $record.version 1 "$($record.magic) version"
    Assert-Equal $record.suite 513 "$($record.magic) suite"
    if ($record.status -eq 'FROZEN_TARGET_NOT_ACTIVE' -and $null -ne $record.fields) {
        $fields = @($record.fields)
        Assert-Equal $fields.Count $record.fieldCount "$($record.magic) field count"
        Assert-Sequence @($fields.tag) @(1..$fields.Count) "$($record.magic) tags"
    } elseif ($record.status -notin @('TARGET_UNFROZEN','FROZEN_TARGET_NOT_ACTIVE')) {
        Fail "unknown record status for $($record.magic)"
    }
}

$byMagic = @{}
foreach ($record in $records) { $byMagic[$record.magic] = $record }

# Field/header arithmetic for every frozen record, including all finite variants.
$dpk2 = $byMagic.DPK2
Assert-AllowedTotals $dpk2 @(
    (Get-FixedRecordTotal $dpk2 @{19=0;20=0}),
    (Get-FixedRecordTotal $dpk2 @{19=32;20=32})
)
foreach ($magic in @('DPH2','DTR2')) {
    $record = $byMagic[$magic]
    $variableTag = if ($magic -eq 'DPH2') { 20 } else { 10 }
    $totals = foreach ($length in @((Get-Field $record $variableTag).lengths)) {
        Get-FixedRecordTotal $record @{$variableTag=[int]$length}
    }
    Assert-AllowedTotals $record $totals
}
$dpe2 = $byMagic.DPE2
$dpe2Totals = foreach ($headerLength in @((Get-Field $dpe2 6).lengths)) {
    foreach ($ciphertextLength in @((Get-Field $dpe2 7).lengths)) {
        Get-FixedRecordTotal $dpe2 @{6=[int]$headerLength;7=[int]$ciphertextLength}
    }
}
Assert-AllowedTotals $dpe2 $dpe2Totals
foreach ($magic in @('DID1','DAB1','DCA1')) {
    $record = $byMagic[$magic]
    Assert-AllowedTotals $record @((Get-FixedRecordTotal $record))
}

$dmd1 = $byMagic.DMD1
Assert-Equal $dmd1.allowedTotalBytesFormula '356+70*N; N=1..16' 'DMD1 total formula'
Assert-Equal (Get-FixedRecordTotal $dmd1 @{9=0}) 356 'DMD1 fixed arithmetic'
Assert-Equal (Get-Field $dmd1 9).lengthFormula '70*N' 'DMD1 entry arithmetic'

$dmc2 = $byMagic.DMC2
Assert-Equal $dmc2.allowedTotalBytesFormula '282+replyLength+payloadLength; replyLength in {0,32}; payloadLength<=32768' 'DMC2 total formula'
Assert-Equal (Get-FixedRecordTotal $dmc2 @{11=0;12=0}) 282 'DMC2 fixed arithmetic'
Assert-Sequence @((Get-Field $dmc2 11).lengths) @(0,32) 'DMC2 reply lengths'
Assert-Equal (Get-Field $dmc2 12).lengthMaximum 32768 'DMC2 payload maximum'

$dam1 = $byMagic.DAM1
Assert-Equal $dam1.allowedTotalBytesFormula '270+40*N+F+M; N=1..100,F=0..255,M=0..128' 'DAM1 total formula'
Assert-Equal (Get-FixedRecordTotal $dam1 @{10=0;13=0;14=0}) 270 'DAM1 fixed arithmetic'
Assert-Equal (Get-Field $dam1 10).lengthFormula '40*N' 'DAM1 chunk arithmetic'
Assert-Equal $dam1.allowedTotalBytesMinimum 310 'DAM1 minimum total'
Assert-Equal $dam1.allowedTotalBytesMaximum 4653 'DAM1 maximum total'

$dao1 = $byMagic.DAO1
Assert-Equal (Get-FixedRecordTotal $dao1 @{6=0}) 196 'DAO1 fixed outer arithmetic before sealed value'
Assert-Equal $dao1.aeadHeader.totalBytes 188 'DAO1 AEAD header total'
Assert-Equal $dao1.aeadHeader.totalBytes (12 + 8 * 5 + 16 + 32 + 32 + 32 + 24) 'DAO1 AEAD header arithmetic'
$dao1Expected = @($byMagic.DPH2.allowedTotalBytes + $byMagic.DPE2.allowedTotalBytes | ForEach-Object { [int]$_ + 212 })
Assert-AllowedTotals $dao1 $dao1Expected

# Projection structure and domain binding, without duplicating signature tests.
$expectedProjectionDomains = [ordered]@{
    DPK2=@('Deep/Messaging/V2/x25519-signed-prekey','Deep/Messaging/V2/mlkem-prekey','Deep/Messaging/V2/prekey-bundle')
    DAB1=@('Deep/Application/V1/address-binding/address','Deep/Application/V1/address-binding/account')
    DMD1=@('Deep/Application/V1/device-directory')
    DCA1=@('Deep/Application/V1/contact-publication-authorization')
}
foreach ($magic in $expectedProjectionDomains.Keys) {
    $record = $byMagic[$magic]
    $projections = if ($null -ne $record.projections) { @($record.projections) } else { @($record.projection) }
    Assert-Sequence @($projections.domain) @($expectedProjectionDomains[$magic]) "$magic projection domains"
    foreach ($projection in $projections) {
        if ([int]$projection.signatureTag -lt 1 -or [int]$projection.signatureTag -gt [int]$record.fieldCount) {
            Fail "$magic projection has an invalid signature tag"
        }
    }
}
Assert-Equal $byMagic.DAB1.projections[0].totalBytes 250 'DAB1 projection arithmetic'
Assert-Equal $byMagic.DAB1.projections[1].totalBytes 250 'DAB1 projection arithmetic'
Assert-Equal $byMagic.DMD1.projection.totalBytesFormula '284+70*N' 'DMD1 projection arithmetic'
Assert-Equal $byMagic.DCA1.projection.totalBytes 401 'DCA1 projection arithmetic'

$normativeCodecText = $spec + "`n" + $applicationSpec
$domains = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
foreach ($domain in @($registry.domains)) {
    $label = [string]$domain.label
    if ([string]::IsNullOrWhiteSpace($label)) { Fail 'domain label is empty' }
    if (-not $domains.Add($label)) { Fail "duplicate domain: $label" }
    if ($label -notmatch '^Deep/[A-Za-z0-9/<>-]+$') { Fail "non-canonical domain: $label" }
    if ($normativeCodecText.IndexOf($label, [System.StringComparison]::Ordinal) -lt 0) {
        Fail "domain is absent from normative specification: $label"
    }
}

Assert-Equal $registry.applicationArtifactTypes.range '0x1000-0x1fff' 'application artifact type range'
Assert-Equal $registry.applicationArtifactTypes.DAB1 4097 'DAB1 application artifact type'

Assert-Equal $registry.provider.mlKemRuntimeCandidate 'mlkem-native v2.0.0 portable C backend' 'ML-KEM candidate'
if ($registry.provider.mlKemRuntimeAccepted) { Fail 'mlkem-native must remain unaccepted until activation evidence passes' }
Assert-Equal $registry.provider.bouncyCastleRole 'differential-vector-and-android-performance-oracle-only' 'Bouncy Castle role'
if ($registry.provider.spqrRuntimeSelected) { Fail 'SPQR runtime must remain unselected' }
Assert-Equal $registry.provider.productionVerdict 'NO_GO_UNTIL_ACTIVATION_GATES_PASS' 'provider production verdict'
foreach ($needle in @('mlkem-native', 'selected production candidate', 'Bouncy Castle', 'oracle')) {
    if ($provider.IndexOf($needle, [System.StringComparison]::OrdinalIgnoreCase) -lt 0) {
        Fail "provider feasibility does not state '$needle'"
    }
}

$expectedGates = [ordered]@{
    umbrellaApplicationCodecComplete=$false
    e2eeCodecFieldsClosed=$true
    applicationCoreCodecFieldsClosed=$true
    attachmentCodecFieldsClosed=$true
    contactCodecFieldsClosed=$true
    groupCodecFieldsClosed=$true
    callCodecFieldsClosed=$false
    historyCodecFieldsClosed=$false
    concreteVectorsComplete=$false
    generatedCodecsComplete=$false
    mlKemProviderApproved=$false
    tripleRatchetProviderApproved=$false
    androidWindowsInteropComplete=$false
    independentReviewP0P1Zero=$false
}
Assert-Sequence @($registry.activationGates.PSObject.Properties.Name) @($expectedGates.Keys) 'activation gate names'
foreach ($gate in $expectedGates.GetEnumerator()) {
    if ([bool]$registry.activationGates.($gate.Key) -ne [bool]$gate.Value) {
        Fail "activation gate $($gate.Key) drifted"
    }
}

Assert-Sequence @($registry.retiredReject.suites) @(257,258) 'retired suites'
Assert-Sequence @($registry.retiredReject.magics) @('DPAC','DPDC','DPKB','DPHI','DPE1','DMC1') 'retired magics'
if ($registry.retiredReject.fallbackOrDualReader) { Fail 'retired generation must not have fallback or a dual reader' }

Assert-Equal $vectorSchema.'$schema' 'https://json-schema.org/draft/2020-12/schema' 'vector schema dialect'
Assert-Equal $vectorSchema.'$id' 'urn:deep:crypto:v1:vectors' 'vector schema id'
Assert-ClosedObjectSchemas $vectorSchema '$'
if (-not ($contactVectorsRaw | Test-Json -SchemaFile $contactVectorSchemaPath)) { Fail 'contact vector document does not satisfy schema' }
Assert-Equal $registry.contactCodec.status 'FROZEN_TARGET_NOT_ACTIVE' 'contact codec registry status'
Assert-Sequence @($registry.contactCodec.records) @('DCB1','DCR1','DIA1','XIR1','XUR1','XRA1','XRC1','XRR1','XSS1','PMT2','PMS2') 'contact codec records'
Assert-Sequence @($registry.contactCodec.dmc2Kinds) @(2,3,4,14) 'contact codec kinds'
Assert-Equal @($contactVectors.primitives).Count 15 'contact primitive vector count'
Assert-Equal @($contactVectors.negativeCases).Count 17 'contact negative vector count'

Write-Host 'Deep crypto specification consistency check passed.'
Write-Host "Generation: $($registry.registryGeneration); packages: $(@($registry.packages).Count); records: $($records.Count)"
Write-Host "Domains: $($domains.Count); target suite: $($suites[0].hex); provider accepted: $($registry.provider.mlKemRuntimeAccepted)"
