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

if ($registrySchema.'$schema' -ne 'https://json-schema.org/draft/2020-12/schema' -or
    $registrySchema.'$id' -ne 'urn:deep:dnp1:classical:v1:registry' -or
    $registry.'$schema' -ne 'dnp1-classical-v1.registry.schema.json') {
    Fail 'registry schema identity or binding drifted'
}
$topLevel = @('$schema','schemaVersion','status','decision','workPackage','suite','grammar','recordClasses','artifactTypes','artifactHashDomains','retainedArtifactHashRules','domains','substructures','records','membershipAuthority','witness','hashTranscripts','identifiers','recovery','outerJournal','http','packages','activationOrder','forbidden')
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
    [int]$registry.grammar.protectedIntegritySuite -ne 32769) {
    Fail 'canonical grammar constants drifted'
}

$artifactIds = New-Object 'System.Collections.Generic.HashSet[int]'
$artifactMagics = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
foreach ($artifact in @($registry.artifactTypes)) {
    $artifactAllowed = @('id','magic','retained')
    Assert-ExactProperties -Object $artifact -Required @('id','magic') -Allowed $artifactAllowed -Name "artifact type $($artifact.id)"
    if (-not $artifactIds.Add([int]$artifact.id)) { Fail "duplicate artifact id $($artifact.id)" }
    if (-not $artifactMagics.Add([string]$artifact.magic)) { Fail "duplicate artifact magic $($artifact.magic)" }
}
if ($artifactIds.Count -ne 40) { Fail "artifact type count must be 40, actual $($artifactIds.Count)" }
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

$expectedFixed = [ordered]@{
    DPA1 = 644; DPD1 = 776; DPM1 = 670; DRT1 = 179; KRT1 = 412; KRF1 = 300
    DCM1 = 812; DRA1 = 788; DWD1 = 1217; DCP1 = 706; DCS1 = 839; DCT1 = 414
    DWL1 = 708; DPL1 = 576; DBG1 = 296; RIB1 = 772; XIB1 = 452
    DNR1 = 756; MRL2 = 326; DXP1 = 168; DPR1 = 408; DPS1 = 444; DPJ1 = 609
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
if ($recordMagics.Count -ne 31) { Fail "record count must be 31, actual $($recordMagics.Count)" }

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
if ([int]$dcn.baseLength -ne 555 -or [int]$dcn.proofHashBytes -ne 32 -or
    [int]$dcn.maximumInclusionProofCount -ne 32 -or
    [int]$dcn.maximumConsistencyProofCount -ne 32 -or
    [int]$dcn.maximumLength -ne 2603) { Fail 'DCN1 proof bounds drifted' }
$dcq = Record 'DCQ1'
if ([int]$dcq.baseLength -ne 375 -or [int]$dcq.receiptCount -ne 3 -or
    [int]$dcq.maximumLength -ne (375 + 3 * (4 + 2603))) { Fail 'DCQ1 quorum arithmetic drifted' }
$dhl = Record 'DHL1'
if ([int]$dhl.baseLength -ne 507 -or [int]$dhl.maximumConsistencyProofCount -ne 32 -or
    [int]$dhl.maximumLength -ne 1531) { Fail 'DHL1 consistency bounds drifted' }
$dcl = Record 'DCL1'
if ([int]$dcl.baseLength -ne 369 -or [int]$dcl.receiptCount -ne 3 -or
    [int]$dcl.maximumLength -ne (369 + 3 * (4 + 1531))) { Fail 'DCL1 lease arithmetic drifted' }
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
    [uint64]$registry.witness.maximumTreeSize -ne 4294967296) {
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

$expectedRecordClasses = [ordered]@{
    publicAuthenticated = @{ suite = 1; records = 'DPA1|DPD1|DPM1|DRS1|KRT1|KRF1|DCM1|DRA1|DWD1|DCP1|DCS1|DCT1|DCN1|DCQ1|DHL1|DCL1|DNR1|DPC1|DPR1|DPS1' }
    publicCommittedUnsigned = @{ suite = 0; records = 'DRT1|MRL2' }
    protectedHmac = @{ suite = 32769; records = 'DPL1|DBG1|RIB1|XIB1|DWL1|MRLC|DPJ1' }
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

$expectedTranscriptNames = @('artifactRef','deepAccountId','componentSubject','deploymentSubject','witnessSetRoot','witnessFinalHeads','witnessLeaf','witnessNode','witnessHead','witnessEmptyRoot','quorumDigest','leaseDigest','mrlRealLeaf','mrlEmptyLeaf','mrlNode','mrlRoot','membershipClosure','membershipTransitionContainer','compositeSelection','catalogHash','outerJournalKey')
$transcriptNames = @($registry.hashTranscripts.PSObject.Properties | ForEach-Object { [string]$_.Name })
if (($transcriptNames -join '|') -ne ($expectedTranscriptNames -join '|')) { Fail 'hash transcript inventory drifted' }
$expectedTranscripts = [ordered]@{
    artifactRef = 'sha256-d(artifact-hash-domain, exact-canonical-bytes)'
    deepAccountId = 'sha256-d(Deep/IdentityAuth/V1/account-id, network16|account-generation8|account-ed25519-public32)'
    componentSubject = 'sha256-d(Deep/Cutover/V1/component-subject, network16|account-hash32|component-kind2|account-revocation-handle32)'
    deploymentSubject = 'sha256-d(Deep/Cutover/V1/deployment-subject, network16|account-hash32|reset-id32)'
    witnessSetRoot = 'sha256-d(Deep/Cutover/V1/witness-set-root, witness-epoch8|witness-count1|four-sorted-descriptors464)'
    witnessFinalHeads = 'sha256-d(Deep/Cutover/V1/witness-heads, predecessor-epoch8|four-sorted-heads288)'
    witnessLeaf = 'sha256-d(Deep/Cutover/V1/witness-log-leaf, deployment-subject32|sequence8|DCS-ref38|DCT-ref38)'
    witnessNode = 'sha256-d(Deep/Cutover/V1/witness-log-node, level2|node-index8|left32|right32)'
    witnessHead = 'sha256-d(Deep/Cutover/V1/witness-log-head, witness-epoch8|tree-size8|tree-root32)'
    witnessEmptyRoot = 'sha256-d(Deep/Cutover/V1/witness-empty-root, witness-epoch8|witness-id32|maximum-tree-size8|zero-tree-size8)'
    quorumDigest = 'sha256-d(Deep/Cutover/V1/quorum-digest, deployment-subject32|sequence8|DCS-ref38|DCT-ref38|three-ordered-DCN-artifact-refs114)'
    leaseDigest = 'sha256-d(Deep/Cutover/V1/lease-digest, deployment-subject32|sequence8|DCS-ref38|query-nonce32|three-ordered-DHL-artifact-refs114)'
    mrlRealLeaf = 'sha256-d(Deep/NativeRouting/V2/mrl-leaf, tag00|reset-id32|epoch8|descriptor-generation8|index4|length4=326|MRL2-326)'
    mrlEmptyLeaf = 'sha256-d(Deep/NativeRouting/V2/mrl-leaf, tag01|reset-id32|epoch8|index4)'
    mrlNode = 'sha256-d(Deep/NativeRouting/V2/mrl-node, level2|node-index4|left32|right32)'
    mrlRoot = 'sha256-d(Deep/NativeRouting/V2/mrl-root, reset-id32|epoch8|protocol-version2=2|member-count4|padded-leaf-count4|node-root32)'
    membershipClosure = 'sha256-d(Deep/NativeRouting/V2/membership-closure, exact-MNG1-ref38|ordered-signed-MDG1-MRV1-container-hash32|MSM1-ref38)'
    membershipTransitionContainer = 'sha256-d(Deep/NativeRouting/V2/membership-transition-container, entry-count-u16be|ordered-rows-of-artifact-type2-length4-hash32-exact-bytes)'
    compositeSelection = 'sha256-d(Deep/NativeRouting/V2/composite-selection, network16|MSM-ref38|MSM-sequence8|member-count4|MRL-root32|PMA-ref38|PMA-generation8|PMA-epoch8|PMR-ref38|PMR-generation8|PMR-head32|PMR-snapshot-hash32|ordered-selected-DNRC-refs)'
    catalogHash = 'sha256-d(Deep/NativeRouting/V2/catalog-hash, artifact-entry-count4|catalog-length8|catalog-bytes)'
    outerJournalKey = 'hmac-sha256(journal-index-key, u16-domain-length|Deep/NativeRouting/V1/outer-journal-key|network16|sender32|recipient32|request-id32)'
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

$expectedDecryptOrder = @('fixed-metadata-preflight','length-count-cap-check','derive-key-and-nonce-compare','freeze-associated-data','bounded-aead-open','zero-prk-and-key','DRM-metadata-preflight','canonical-row-hash-verify','required-artifact-and-protocol-restore','shadow-and-pin-core-compare','commit-authorize')
if ([int]$registry.recovery.suiteId -ne 1 -or
    $registry.recovery.suite -ne 'XChaCha20-Poly1305-IETF+HKDF-SHA-512' -or
    $registry.recovery.inputKeyMaterial -ne 'DeepRecoveryV1 backupWrappingSeed32' -or
    $registry.recovery.transactionId -ne 'CSPRNG32 unique per component-subject and account generation' -or
    $registry.recovery.extractSalt -ne 'sha512(u16-domain-length|Deep/Cutover/V1/recovery-kdf-salt|network16|component-subject32|transaction-id32)' -or
    $registry.recovery.aeadKey -ne 'hkdf-sha512-expand(prk,u16-domain-length|Deep/Cutover/V1/recovery-aead-key|protector-key-id32,32)' -or
    $registry.recovery.nonce -ne 'hkdf-sha512-expand(prk,u16-domain-length|Deep/Cutover/V1/recovery-aead-nonce|protector-key-id32,24)' -or
    $registry.recovery.associatedData -ne 'u32be-metadata-length|canonical-DRC1-fields-1-through-15-with-field-count-15' -or
    $registry.recovery.drmHeader -ne 'DRM1|version1|reserved1=0|artifact-count-u16be' -or
    $registry.recovery.drmRow -ne 'artifact-type-u16be|length-u32be|canonical-hash32|exact-bytes' -or
    $registry.recovery.drmHash -ne 'sha256-d(Deep/Cutover/V1/recovery-drm-hash, exact-DRM1)' -or
    $registry.recovery.shadowStateHash -ne 'sha256-d(Deep/Cutover/V1/recovery-shadow-state, exact-shadow-manifest)' -or
    $registry.recovery.pinCoreHash -ne 'sha256-d(Deep/Cutover/V1/recovery-pin-core, canonical-DPL1-fields-excluding-DCP-DCS-DCQ-HMAC)' -or
    $registry.recovery.nonceReuse -ne 'reject-and-latch' -or
    (@($registry.recovery.decryptOrder) -join '|') -ne ($expectedDecryptOrder -join '|')) {
    Fail 'recovery AEAD/KDF/decrypt ordering drifted'
}
$expectedJournalPhases = @('Prepared=0','InnerPending=1','Completed=2')
if ($registry.outerJournal.record -ne 'DPJ1' -or
    (@($registry.outerJournal.phases) -join '|') -ne ($expectedJournalPhases -join '|') -or
    $registry.outerJournal.latches -notmatch 'cannot both be set' -or
    $registry.outerJournal.phaseShape -notmatch 'terminal-stale preserves phase and all fields' -or
    $registry.outerJournal.staleRule -notmatch 'zero-inner-callback' -or
    $registry.outerJournal.garbageCollection -notmatch 'verify-row-HMAC-first') {
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
    [int]$registry.substructures.recoveryArtifactRow.maximumCount -ne 64) {
    Fail 'fixed substructure arithmetic drifted'
}
if ($registry.identifiers.mailboxOwnerId -ne 'sha256-d(Deep/IdentityAuth/V1/mailbox-owner-id, network16|account-hash32|DPMC-ref38|mailbox-ed25519-public32)' -or
    $registry.identifiers.routerId -ne 'sha256-d(Deep/NativeRouting/V1/router-id, network16|mailbox-owner-id32|router-generation8|router-ed25519-public32)' -or
    $registry.identifiers.nonzero -ne $true -or
    $registry.identifiers.mailboxCollisionScope -ne 'same-network-and-account-different-preimage-latches-account' -or
    $registry.identifiers.routerCollisionScope -ne 'same-network-different-preimage-latches-routing-domain') {
    Fail 'mailbox owner/router identifier provenance or collision policy drifted'
}
if ((@($registry.witness.canonicalOrder) -join '|') -ne 'DCP1[4]|DCS1|DCT1|DCN1/DCQ1|DPL1') {
    Fail 'witness dependency order must remain acyclic'
}
if ((@($registry.membershipAuthority.membershipChain) -join '|') -ne 'MNG1|MDG1|MRV1|MMC1|MSM1' -or
    (@($registry.membershipAuthority.mailboxAuthorityChain) -join '|') -ne 'PMA1|PMR1|DNR1' -or
    $registry.membershipAuthority.crossAuthorityInference) {
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
    $registry.http.compression -ne 'reject') { Fail 'native peer HTTP contract drifted' }

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
if ($vectors.schemaVersion -ne '1.0.0' -or $vectors.status -ne 'required-before-code' -or
    $vectors.decision -ne 'DR-0003' -or $vectors.workPackage -ne $registry.workPackage -or
    $vectors.'$schema' -ne 'dnp1-classical-v1.vectors.schema.json') {
    Fail 'vector skeleton governance binding changed'
}
$vectorTop = @('$schema','schemaVersion','status','decision','workPackage','cases')
Assert-ExactProperties $vectors $vectorTop $vectorTop 'vectors'
if ([int]$vectorSchema.properties.cases.minItems -ne 60 -or [int]$vectorSchema.properties.cases.maxItems -ne 60 -or
    $vectorSchema.properties.cases.uniqueItems -ne $true -or
    $vectorSchema.'$defs'.case.additionalProperties -ne $false) {
    Fail 'vector schema bounds/closed case grammar drifted'
}
$allowedAreas = @('grammar','identity','revocation','reset','witness','membership','routing','peer','recovery','package')
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
    'peer-outer-journal-phase-crashes','peer-outer-journal-fork-stale','peer-outer-journal-cap-hmac-gc',
    'reset-witness-tooling-gate','grammar-machine-artifact-set-digest',
    'membership-mrlc-canonical-container','witness-empty-tree-root','peer-outer-journal-terminal-shape',
    'grammar-record-header-suite-cross-feed','identity-owner-router-id-collision',
    'membership-mrc-member-entry-counts',
    'package-exact-three-session-free'
)
if (-not $caseIds.SetEquals([string[]]$requiredCases)) { Fail 'vector case inventory drifted' }

Write-Host 'DNP1 classical identity/reset/native-routing specification check passed.'
Write-Host "Records: $($recordMagics.Count)"
Write-Host "Domains: $($domains.Count)"
Write-Host "Vector requirements: $($caseIds.Count)"
Write-Host 'Witness: 3-of-4 / one global deployment-set CAS'
