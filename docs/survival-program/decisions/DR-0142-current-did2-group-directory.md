# DR-0142 — Current DID2 group directory authority

Status: accepted allocation; source and connected activation are separate
Date: 2026-10-18
Decision owner: Mr. X (delegated architecture authority)

The current GROUP source has structural records but no DID2 transition
producer. Its ADC1/ADP1 references still select the retired identity generation.
Retarget those reference types to version2 only; other group record headers,
domains, field widths, DPD1/DRS1/DMD1/ADH1 references and pairwise fanout remain
unchanged. There is no version1 ADC/ADP reader, conversion or Session adapter.
Regenerate the canonical group corpus from its repository-owned producer and
retain an explicit negative retired-ADC-reference case. Git is the history.

The group account authority is minted only from an independently verified
`VerifiedDeepIdV2DirectoryFreshness` with CurrentValue, its exact verified
checkpoint/binding/directory, and a live boot-specific protected monotonic
clock. It selects signing keys from that directory, never caller key bytes.
Recheck currentness after asynchronous work and before returning authority.
Raw GCP1 support, SQL rows, parsed certificates and caller keys cannot mint it.

Nonce-bound ADP bytes are evidence of one lookup, not a stable account state
identifier. Independent clients may have different ADH/ADP evidence for the
same ADC/DMD/DRS state. An acceptance echoes the exact invitation tuple, while
its independently obtained current authority must match the stable ADC/DMD/DRS
and active-device state. It need not reproduce the inviter's lookup nonce.
An ADC/DMD/DRS advance still invalidates the pending invitation. The echoed
ADH/ADP are signed provenance, not a substitute currentness capability.

Genesis contains only the owner. Invitation and acceptance do not activate a
member. Only an owner-sequenced successor, binding exact consent and its base,
may activate it. Unsupported reducers remain closed. A verified transition is
not permission to emit DMC2: protected group custody, semantic receive/ACK,
durable batch fanout and control quorum are independent composition gates.
RuntimeActivation remains false until that complete path is qualified.

Remove the unused empty `GroupProductionAuthor` and generic caller-implemented
group device signing interface. The replacement owns artifact-specific intents
inside `OwnedGenesisDeviceSecrets`; no caller-provided key/sign callback is
introduced. The retained GCP1 package builder is internal, not a public raw author.

This allocation does not reset existing accounts/journals, enable old group
state, claim CLI/device E2E, or close S11/release. Downstream builds must repin
the exact Protocol surface; old group reference bytes require explicit reset,
not migration. Retained contact/file CLI accounts are not discarded.
