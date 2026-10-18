# DR-0145 — Owned opaque group-control composition

Status: accepted implementation allocation; runtime qualification is separate
Date: 2026-10-18
Decision owner: Mr. X (delegated authority)

Placement stability is corrected by [DR-0146](DR-0146-stable-group-control-placement.md);
that decision supersedes the moving-current-PMT interpretation below.
This closes missing composition grammar in CONTACT-AND-GROUP §14. It does not
claim GSR1 active merely because a codec or an activation flag exists.

GSW1/GSQ1 tag16 is the opaque service selector
`SHA256-D("Deep/Group/V1/control-selector", GSR1.tag2 || tag3 || tag7)`.
No inner identifier or full GSR1 is sent to a node. For current placement,
rank the verified PMT2 cohort with the existing PMS2 rendezvous rank transcript,
using `SHA256-D("Deep/Group/V1/control-placement-input", network16 || selector32)`
as input. Select the first two distinct nodes. The placement hash is
`SHA256-D("Deep/Group/V1/control-placement", network16 || viewCoreRef38 ||
PMT2ArtifactRef38 || selectionEpoch:u64be || selector32 || firstNode32 || secondNode32)`.
Descriptor tag6 anchors its original verified PMT2; it is not a perpetual current
placement capability. All requests still require current NETCODEC/time authority.
Production GSR admission, replica mutation and retention use the authenticated
DID2 service clock; OS wall time is not protocol authority. Peer HTTP signatures
retain their separate host clock. Reject expired requests and carriage beyond
the current signed network ceiling before effects.

Allocate DMC2 kind30, GroupControlRendezvous, exclusively to pairwise E2EE:
`groupId32 || recipientAccount32 || exactGSR1[528] || sealingPrivateScalar32`.
The scalar must match GSR1.tag9. Only the authenticated current group sequencer
may create/share it. Receipt of this carrier is not membership or invitation
consent. Unknown kinds, lengths, networks, recipients, owner devices and signatures
reject. No generic author, direct HTTP fallback or caller-supplied authority.

Sealed GCF1 bytes are `ephemeralX25519Public32 || nonce24 || ciphertext`.
Generate a fresh independent ephemeral scalar and nonce for each original write;
persist exact bytes before effects. Reject all-zero DH. Derive key32 with RFC5869
HKDF-SHA512, salt=exactGSR1Hash32, info=
`"Deep/Group/V1/control-seal" || 0x00 || network16 || sequence:u64be ||
predecessorSealedHash32 || effectiveExpiresAt:u64be`. Use XChaCha20-Poly1305,
AAD=info || sealingKeyId32 || ephemeralPublic32. This reuses suite0201 primitives,
not a new algorithm suite. Decryption authenticates before GCF1 parsing.

Keep a protected per-recipient descriptor/key, exact original write, cursor and
two-replica evidence owner. A local scheduling hint never proves Store. Persist
original writes before dispatch; after unknown outcomes retry the retained write,
never reencrypt changed bytes at the same sequence. Expired unknown work fails
explicitly until independently reconciled; do not create a new semantic write.
Control application and cursor advancement must survive interruption without
skipping predecessors. Unavailable, expired, missing or conflicting control is
not empty successful synchronization. Application fanout is blocked until every
required control chunk has independently verified two-replica evidence.

Bounded work reuse is allowed only inside one actual account lease and one
verification phase with no external callback: open each native history scope
once, and share a joint authority-floor read among exact same authority objects.
Re-read custody and floors after every external callback. Do not cache decrypted
secure-storage aggregates across reads, extend deadlines, skip native/receipt
verification, or change the DPAPI authentication contract to hide latency.

Allocate protected group journal generation3 for the descriptor/key, original
write/evidence and cursor fields; reject generation2 without migration. Ordinary
journal9 and SQL schema17 do not change. Retain old isolated profiles as evidence;
the GSR1 connected run uses fresh CLI profiles. The cursor and adopted package
share one protected root CAS, including exact predecessor replay after a crash.

No migration, legacy reader, production deployment or device activation is
authorized by this allocation. The implementation checkpoint must state exact
remaining boundaries and reset/repin impact.

Source-test retirement binding (Shared production tests):
`Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2Groups_OwnedBatchNativeReceiveColdHistoryAndReplayInBothDirections`
is replaced by
`Deep.Client.Shared.Production.Tests.DeepIdV2ContactPathAuthoritySourceTests.Did2Groups_DescriptorNativeCustodyAndUnpublishedCommitBlocksApplicationSend`.
The old case transported new commits through ordinary mailbox control. Its
replacement retains actual native/SQLCipher carrier, exact replay, tampered
package rejection, cold state and the new publication fence. Bidirectional
application delivery on the replacement path requires the independent real
three-CLI GSR scenario; this component case cannot substitute for it.
