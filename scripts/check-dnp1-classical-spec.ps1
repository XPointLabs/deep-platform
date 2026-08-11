[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$specRoot = Join-Path $repoRoot 'docs\survival-program\releases\v3.0.0\specs'
$specPath = Join-Path $specRoot 'DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md'
$registryPath = Join-Path $specRoot 'dnp1-classical-v1.registry.json'
$registrySchemaPath = Join-Path $specRoot 'dnp1-classical-v1.registry.schema.json'
$vectorSchemaPath = Join-Path $specRoot 'dnp1-classical-v1.vectors.schema.json'
$vectorPath = Join-Path $specRoot 'dnp1-classical-v1.vectors.skeleton.json'

function Fail([string]$Message) {
    throw "DNP1 classical specification check failed: $Message"
}

foreach ($path in @($specPath, $registryPath, $registrySchemaPath, $vectorSchemaPath, $vectorPath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { Fail "missing artifact: $path" }
}

$spec = Get-Content -LiteralPath $specPath -Raw -Encoding UTF8
$registry = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8 | ConvertFrom-Json
$registrySchema = Get-Content -LiteralPath $registrySchemaPath -Raw -Encoding UTF8 | ConvertFrom-Json
$vectorSchema = Get-Content -LiteralPath $vectorSchemaPath -Raw -Encoding UTF8 | ConvertFrom-Json
$vectors = Get-Content -LiteralPath $vectorPath -Raw -Encoding UTF8 | ConvertFrom-Json

function Assert-ExactProperties($Object, [string[]]$Required, [string[]]$Allowed, [string]$Name) {
    $names = @($Object.PSObject.Properties | ForEach-Object { [string]$_.Name })
    foreach ($requiredName in $Required) {
        if ($names -notcontains $requiredName) { Fail "$Name missing required property $requiredName" }
    }
    foreach ($name in $names) {
        if ($Allowed -notcontains $name) { Fail "$Name contains unknown property $name" }
    }
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
$topLevel = @('$schema','schemaVersion','status','decision','workPackage','suite','grammar','recordClasses','artifactTypes','artifactHashDomains','retainedArtifactHashRules','domains','substructures','componentKinds','releaseRootTrust','wireEnums','records','membershipAuthority','membershipProof','witness','hashTranscripts','identifiers','recovery','apiInvariants','outerJournal','http','packages','activationOrder','forbidden')
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
    DPJ1='Deep/ProtectedState/V1/DPJ1'; RRL1='Deep/ProtectedState/V1/RRL1'; DXR1='Deep/ProtectedState/V1/DXP1-verified-receipt'
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

$expectedTranscriptNames = @('artifactRef','releaseRootGenesis','releaseManifestKeyId','releaseRootKeyHash','releaseRootChain','releaseRootAuthorityHead','witnessTerminalQuorum','witnessTerminalReceiptSigningInput','dxpSalt','dxpKeyDevice','dxpKeyRouter','dxpTranscriptHash','deepAccountId','componentSubject','deploymentSubject','witnessSetRoot','witnessDelegationSigningInput','witnessSetSuccessorSigningInput','subjectPolicy','witnessFinalHeads','witnessLeaf','witnessNode','witnessHead','witnessEmptyRoot','quorumDigest','leaseDigest','mrlRealLeaf','mrlEmptyLeaf','mrlNode','mrlRoot','membershipClosure','membershipTransitionContainer','compositeSelection','catalogHash','outerJournalKey','dxpSubjectProjection','dxpNonceIndexKeyId','dxpNonceLedgerKey','dxpOperationSource','outerRequestHash','outerOutcomeHash','currentCutoverSource','dnrcSource','membershipHeadSource','mailboxAuthorityHeadSource','mrlcSource')
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
    dxpNonceIndexKeyId = 'sha256-d(Deep/ProtectedState/V1/DXP1-nonce-index-key-id,network16|reset-id32|dxp-nonce-index-key32)'
    dxpNonceLedgerKey = 'hmac-sha256(dxp-nonce-index-key32,u16be-domain-length|Deep/ProtectedState/V1/DXP1-nonce-ledger-key|network16|reset-id32|role1|nonce32)'
    dxpOperationSource = 'sha256-d(Deep/IdentityAuth/V1/dxp-operation-source,role1|stage1|cutover-source32|DRS-revision8|DRS-count8|DRS-head32|DRS-ref38|subject-projection-hash32|prior-subject-LKG-ref38|transcript-hash32|subject-artifact-ref38|identity-catalog-key-id32|DXR-key-id32|nonce-index-key-id32)'
    outerRequestHash = 'sha256-d(Deep/NativeRouting/V1/outer-request-hash,u32be-408|exact-DPR1-408|u32be-PRQ2-length|exact-PRQ2)'
    outerOutcomeHash = 'sha256-d(Deep/NativeRouting/V1/outer-outcome-hash,u32be-296|exact-MRR2-296|u32be-444|exact-DPS1-444)'
    currentCutoverSource = 'sha256-d(Deep/NativeRouting/V2/current-cutover-source,network16|reset-id32|component-kind2|account-hash32|account-generation8|DCM-generation8|DCM-ref38|DCP-ref38|DCS-ref38|DCQ-ref38|DWL-ref38|DCL-ref38|DPL-ref38|release-root-authority-head32|DRS-revision8|DRS-count8|DRS-head32|DRS-ref38|lease-expires8|DPL-key-id32|DWL-key-id32|RRL-key-id32|RIB-key-id32|MRLC-key-id32|DXR-key-id32)'
    dnrcSource = 'sha256-d(Deep/NativeRouting/V2/dnrc-source,cutover-source32|owner-id32|DPMC-ref38|PMA-ref38|PMA-generation8|PMA-epoch8|PMR-ref38|PMR-generation8|PMR-head32|PMR-snapshot-hash32|DNR-ref38|router-DXP-transcript-hash32|DXR1-key-id32)'
    membershipHeadSource = 'sha256-d(Deep/NativeRouting/V2/membership-head-source,network16|MNG1-ref38|transition-container-hash32|MSM-sequence8|MSM-canonical-hash32|MSM-ref38)'
    mailboxAuthorityHeadSource = 'sha256-d(Deep/NativeRouting/V2/mailbox-authority-head-source,network16|PMA-ref38|PMA-generation8|PMA-canonical-hash32|PMR-ref38|PMR-generation8|PMR-head32|PMR-snapshot-hash32)'
    mrlcSource = 'sha256-d(Deep/NativeRouting/V2/mrlc-source,cutover-source32|old-membership-head-source32|new-membership-head-source32|old-mailbox-authority-head-source32|new-mailbox-authority-head-source32|MRLC-ref38|MRLC-protected-key-id32|composite-selection32|member-count4|ordered-router-id32-DNRC-source32-tuples)'
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

$expectedDecryptOrder = @('fixed-metadata-preflight','length-count-cap-check','derive-key-and-nonce-compare','freeze-associated-data','bounded-single-aead-open','zero-prk-and-key','owned-DRM-plaintext-preflight-order-uniqueness','closed-per-type-artifact-ref-verify','required-artifact-and-protocol-restore','shadow-and-pin-core-compare','commit-authorize')
$recoveryNames = @('suiteId','suite','inputKeyMaterial','transactionId','extractSalt','aeadKey','nonce','associatedData','drmHeader','drmRow','drmRowOrder','drmRowUniqueness','drmReferenceRules','drmHash','shadowStateHash','pinCoreHash','nonceLatchKey','nonceLatchValue','nonceReuse','decryptOrder')
Assert-ExactProperties -Object $registry.recovery -Required $recoveryNames -Allowed $recoveryNames -Name 'recovery contract'
$recoverySchemaNames = @($registrySchema.properties.recovery.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$recoverySchemaRequired = @($registrySchema.properties.recovery.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.recovery.additionalProperties -ne $false -or
    ($recoverySchemaNames -join '|') -ne ($recoveryNames -join '|') -or
    ($recoverySchemaRequired -join '|') -ne ($recoveryNames -join '|')) {
    Fail 'recovery schema closure drifted'
}
if ([int]$registry.recovery.suiteId -ne 1 -or
    $registry.recovery.suite -ne 'XChaCha20-Poly1305-IETF+HKDF-SHA-512' -or
    $registry.recovery.inputKeyMaterial -ne 'DeepRecoveryV1 backupWrappingSeed32' -or
    $registry.recovery.transactionId -ne 'CSPRNG32 unique per component-subject and account generation' -or
    $registry.recovery.extractSalt -ne 'sha512(u16-domain-length|Deep/Cutover/V1/recovery-kdf-salt|network16|component-subject32|transaction-id32)' -or
    $registry.recovery.aeadKey -ne 'hkdf-sha512-expand(prk,u16-domain-length|Deep/Cutover/V1/recovery-aead-key|protector-key-id32,32)' -or
    $registry.recovery.nonce -ne 'hkdf-sha512-expand(prk,u16-domain-length|Deep/Cutover/V1/recovery-aead-nonce|protector-key-id32,24)' -or
    $registry.recovery.associatedData -ne 'u32be-metadata-length|canonical-DRC1-fields-1-through-15-with-field-count-15' -or
    $registry.recovery.drmHeader -ne 'DRM1|version1|reserved1=0|artifact-count-u16be' -or
    $registry.recovery.drmRow -ne 'artifact-ref38|exact-bytes; artifact-ref38=artifact-type-u16be|canonical-length-u32be|canonical-hash32' -or
    $registry.recovery.drmRowOrder -ne 'after-one-AEAD-open-on-owned-plaintext-strict-unsigned-bytewise-lexicographic-increasing-on-exact-artifact-ref38-before-per-row-copy-artifact-decode-ref-hash-signature-network-storage-or-mutation-callback; ancestry-follows-predecessor-refs-not-physical-row-order' -or
    $registry.recovery.drmRowUniqueness -ne 'after-one-AEAD-open-equal-artifact-ref38-rejects-before-per-row-copy-or-downstream-callback-even-if-exact-bytes-differ; every-row-exact-bytes-redecode-recompose-and-recompute-the-same-artifact-ref38' -or
    $registry.recovery.drmReferenceRules -ne 'artifact-type-must-exist-in-exactly-one-closed-map; new-DNP-types-use-artifactHashDomains; retained-MSM1-PRQ2-MRR2-PMA1-PMR1-D-G-SOURCE-MNG1-MDG1-MRV1-MMC1-use-retainedArtifactHashRules; missing-or-cross-class-type-rejects-before-per-row-callback' -or
    $registry.recovery.drmHash -ne 'sha256-d(Deep/Cutover/V1/recovery-drm-hash, exact-DRM1)' -or
    $registry.recovery.shadowStateHash -ne 'sha256-d(Deep/Cutover/V1/recovery-shadow-state, exact-shadow-manifest)' -or
    $registry.recovery.pinCoreHash -ne 'sha256-d(Deep/Cutover/V1/recovery-pin-core, canonical-DPL1-fields-excluding-DCP-DCS-DCQ-HMAC)' -or
    $registry.recovery.nonceLatchKey -ne 'protector-key-id32|derived-nonce24' -or
    $registry.recovery.nonceLatchValue -ne 'sha256-d(Deep/Cutover/V1/recovery-aead, transaction-id32|u32be-associated-data-length|exact-associated-data|u64be-ciphertext-length|ciphertext|aead-tag16)' -or
    $registry.recovery.nonceReuse -ne 'same-key-and-same-value-is-exact-replay; same-key-and-different-value-permanently-latches-before-AEAD' -or
    (@($registry.recovery.decryptOrder) -join '|') -ne ($expectedDecryptOrder -join '|')) {
    Fail 'recovery AEAD/KDF/decrypt ordering drifted'
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
    [int]$registry.substructures.recoveryArtifactRow.maximumCount -ne 195 -or
    [int]$registry.substructures.recoveryArtifactRow.authorityGenesisRows -ne 1 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumRootTransitionRows -ne 64 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumDwdAncestryRows -ne 65 -or
    [int]$registry.substructures.recoveryArtifactRow.terminalOrLeaseRows -ne 1 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumComponentRows -ne 64 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumAuthorityEncodedBytes -ne 116410 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumComponentEncodedBytes -ne 33438022 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumPlaintextBytes -ne 33554432 -or
    [int]$registry.substructures.recoveryArtifactRow.maximumAuthorityEncodedBytes -ne (4 + (38 + 332) + 64 * (38 + 412) + 65 * (38 + 1217) + (38 + 5623)) -or
    [int]$registry.substructures.recoveryArtifactRow.maximumComponentEncodedBytes -ne ([int]$registry.substructures.recoveryArtifactRow.maximumPlaintextBytes - [int]$registry.substructures.recoveryArtifactRow.maximumAuthorityEncodedBytes) -or
    [int]$registry.substructures.recoveryArtifactRow.maximumCount -ne ([int]$registry.substructures.recoveryArtifactRow.authorityGenesisRows + [int]$registry.substructures.recoveryArtifactRow.maximumRootTransitionRows + [int]$registry.substructures.recoveryArtifactRow.maximumDwdAncestryRows + [int]$registry.substructures.recoveryArtifactRow.terminalOrLeaseRows + [int]$registry.substructures.recoveryArtifactRow.maximumComponentRows)) {
    Fail 'fixed substructure arithmetic drifted'
}
$recoveryArtifactNames = @('overheadBytes','maximumCount','authorityGenesisRows','maximumRootTransitionRows','maximumDwdAncestryRows','terminalOrLeaseRows','maximumComponentRows','maximumAuthorityEncodedBytes','maximumComponentEncodedBytes','maximumPlaintextBytes','layout')
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
$releaseRootTrustNames = @('carrier','source','pinFields','fingerprint','manifestSignerProvenance','pinCardinality','sealedFactory','genesisGeneration','genesisPredecessorRef','firstTransitionGeneration','transitionRule','dwdRule','lkg','lkgHmac','maximumRootTransitionCount','maximumDwdAncestryCount','oldKeyHash','rotationCommit','genesisInitialization','witnessEpoch','effectiveTime','terminalReceipt','terminalMutation','terminalEffect','forkRule','recovery','chainExhaustion','consumerBinding','unknownOrMissing')
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
    $registry.releaseRootTrust.witnessEpoch -notmatch 'exactly-one-no-reuse' -or
    $registry.releaseRootTrust.effectiveTime -notmatch 'DWD-validFrom-greater-than-or-equal-KRT-effectiveAt' -or
    $registry.releaseRootTrust.effectiveTime -notmatch 'txNow-greater-than-or-equal-both' -or
    $registry.releaseRootTrust.terminalReceipt -notmatch 'DWT1-exact-three-of-four-durable-receipts-before-local-terminal-RRL-CAS' -or
    $registry.releaseRootTrust.terminalMutation -notmatch 'keep-generation-current-public-transition-and-latest-DWD' -or
    $registry.releaseRootTrust.terminalEffect -notmatch 'invalidates-root-DWD-and-referencing-leases' -or
    $registry.releaseRootTrust.forkRule -notmatch 'permanently-latches' -or
    $registry.releaseRootTrust.recovery -notmatch 'complete-DWD-ancestry-one-through-65' -or
    $registry.releaseRootTrust.recovery -notmatch 'DWT1-iff-terminal' -or
    $registry.releaseRootTrust.recovery -notmatch 'nonterminal-requires-fresh-exact-three-of-four-DCL' -or
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
    'keyScope','keyAction','dxpRole','routerRoles','routerCapabilities','dpcEndpointKind','dpcFlags',
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
$constWireEnumNames = @('dpaMinimumSuite','dpdSuite','dpdCapabilities','dpmCapabilities','drtTargetKind','drsReason','draReason','keyScope','keyAction','dxpRole','routerRoles','routerCapabilities','dpcEndpointKind','dpcFlags','witnessEndpointKind','dcnDurabilityClass','componentMask','outerPeerOperation','innerPrq2Operation','dpjPhase','dxrPhase','booleanByte','rip2ProtocolVersion')
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
$apiInvariantNames = @('rrmPreflight','rrmTime','relativeResult','authorityConversion','dwdRestore','authorityTuple','authorityCas','hmacTranscript','hmacKeyId','recoveryFreeze','recoveryProvider','recoveryNonce','recoveryPlaintext','cancellation','commitAuthority','consumerFinalRecheck','mrlProjectionBoundary','mrlCompositeCas','mrlCacheIdentity','dxpProjection','dxpReceipt','dxpNonce','dxpFinalCas','mrlCurrentInputs','mrlContinuity','mrlSourceCas','callbackOrder')
Assert-ExactProperties -Object $registry.apiInvariants -Required $apiInvariantNames -Allowed $apiInvariantNames -Name 'API invariants'
$apiSchemaNames = @($registrySchema.properties.apiInvariants.properties.PSObject.Properties | ForEach-Object { [string]$_.Name })
$apiSchemaRequired = @($registrySchema.properties.apiInvariants.required | ForEach-Object { [string]$_ })
if ($registrySchema.properties.apiInvariants.additionalProperties -ne $false -or
    ($apiSchemaNames -join '|') -ne ($apiInvariantNames -join '|') -or
    ($apiSchemaRequired -join '|') -ne ($apiInvariantNames -join '|')) {
    Fail 'API invariant schema closure drifted'
}
if ($registry.apiInvariants.rrmPreflight -ne 'freeze-exact-canonical-RRM1-332-and-full-pin-tuple-network16-manifest-signer-key-id32-manifest-signer-ed25519-public32-minimum-generation-u64be-zero-expected-RRM1-ref38; recompute-reference-and-fixed-time-compare-every-pin-field-before-Ed25519-callback' -or
    $registry.apiInvariants.rrmTime -ne 'caller-supplies-one-authoritative-txNow-u64; copy-once-before-callback; require-manifest-generation-equals-minimum-manifest-generation-equals-zero-and-txNow-at-least-activationAt; verifier-has-no-clock-callback' -or
    $registry.apiInvariants.relativeResult -ne 'public-results-are-sealed-defensively-owned-nonserializable-signature-relative-facts-with-no-durable-authority' -or
    $registry.apiInvariants.authorityConversion -ne 'no-public-constructor-factory-conversion-or-method-mints-genesis-or-durable-authority-from-raw-key-fingerprint-policy-pin-or-relative-result; consumer-internal-verified-deployment-source-alone-combines-relative-fact' -or
    $registry.apiInvariants.dwdRestore -ne 'preflight-complete-bounded-closure-before-callbacks; exact-RRM1; zero-through-64-ordered-KRT1-or-KRF1-root-transitions; complete-one-through-65-DWD1-ancestry; each-KRT1-paired-with-exact-successor-DWD1; DWT1-iff-terminal-else-fresh-exact-DCL1; reject-skip-tail-duplicate-same-generation-fork-or-unconsumed-entry' -or
    $registry.apiInvariants.authorityTuple -ne 'genesis-RRM1-ref38|current-generation8|current-public32|current-transition-ref38|terminal-KRF1-ref38|terminal-state1|fork-latch1|latest-DWD-generation8|latest-DWD-ref38|latest-witness-epoch8|chain-entry-count2|chain-checkpoint-hash32|terminal-DWT1-ref38' -or
    $registry.apiInvariants.authorityCas -ne 'transition-plan-defensively-owns-exact-old-authority-tuple-and-exact-new-authority-tuple; store-CAS-is-old-to-new-full-tuple-only; no-ad-hoc-PlanHash-generation-only-bool-or-caller-authority' -or
    $registry.apiInvariants.hmacTranscript -ne 'Protocol-returns-only-exact-unsigned-protected-transcript-domain-suite-and-key-id; never-accepts-or-returns-HMAC-key-and-never-claims-durable-authority' -or
    $registry.apiInvariants.hmacKeyId -ne 'key-id32-is-nonzero-fixed-preflighted-before-HMAC-callback; callback-output-is-frozen-once-then-locally-verified-and-only-owned-tag-is-used' -or
    $registry.apiInvariants.recoveryFreeze -ne 'preflight-bounds-and-defensively-copy-all-DRC1-metadata-ciphertext-and-provider-input-before-callback-or-await; no-public-seed-key-or-nonce-override' -or
    $registry.apiInvariants.recoveryProvider -ne 'typed-internal-recovery-provider-derives-HKDF-key-and-nonce; Protocol-fixed-time-compares-derived-nonce-with-stored-nonce-before-AEAD-open' -or
    $registry.apiInvariants.recoveryNonce -ne 'latch-key-is-protector-key-id32|derived-nonce24; stored-value-hashes-transaction-id32-associated-data-metadata-ciphertext-and-tag; exact-key-value-replays; changed-value-permanently-latches-before-AEAD' -or
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
    $registry.apiInvariants.dxpNonce -notmatch 'nonceLedgerKey is derived only by dxpNonceLedgerKey' -or
    $registry.apiInvariants.dxpNonce -notmatch 'immutable and nonrotating for network-resetId' -or
    $registry.apiInvariants.dxpNonce -notmatch 'missing-wrong-retired-early key fails closed' -or
    $registry.apiInvariants.dxpNonce -notmatch 'Pending CAS precedes challenge' -or
    $registry.apiInvariants.dxpFinalCas -notmatch 'stage0 dxpOperationSource' -or
    $registry.apiInvariants.dxpFinalCas -notmatch 'stage1 dxpOperationSource' -or
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
if ([int]$vectorSchema.properties.cases.minItems -ne 146 -or [int]$vectorSchema.properties.cases.maxItems -ne 146 -or
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
    'package-exact-three-session-free'
)
if (-not $caseIds.SetEquals([string[]]$requiredCases)) { Fail 'vector case inventory drifted' }
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
    'recovery-drm-order-row-corrupt' = '195-row and 32-MiB DRM closure|1'
    'api-recovery-nonce-reuse-latch' = 'protector plus derived nonce|0'
    'recovery-drm-row-reversed' = 'Encrypted integration opens AEAD once|1'
    'recovery-drm-row-equal-duplicate' = 'Encrypted integration opens AEAD once|1'
    'recovery-drm-row-ref-collision-shaped' = 'Encrypted integration opens AEAD once|1'
    'recovery-drm-direct-plaintext-parser' = 'explicitly direct owned-plaintext parser unit|0'
    'recovery-drm-ref-rule-missing-cross-class' = 'After one AEAD open|1'
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
}
foreach ($id in $apiClosureVectors.Keys) {
    $parts = ([string]$apiClosureVectors[$id]).Split('|')
    $match = @($vectors.cases | Where-Object { $_.id -eq $id })
    if ($match.Count -ne 1 -or [string]$match[0].purpose -notmatch [regex]::Escape($parts[0]) -or
        ([int]$match[0].callbacks.signature + [int]$match[0].callbacks.agreement + [int]$match[0].callbacks.network + [int]$match[0].callbacks.mutation) -ne [int]$parts[1]) {
        Fail "API/recovery closure vector callback or purpose drifted: $id"
    }
}

Write-Host 'DNP1 classical identity/reset/native-routing specification check passed.'
Write-Host "Records: $($recordMagics.Count)"
Write-Host "Domains: $($domains.Count)"
Write-Host "Vector requirements: $($caseIds.Count)"
Write-Host 'Vector schema: Draft 2020-12 equivalent / additionalProperties and JSON-type negative self-tests passed'
Write-Host 'Witness: 3-of-4 / one global deployment-set CAS'
