# DR-0039 — DID2 opaque publication consumer

Status: accepted clean break; private coordination, replicas and device delivery remain gates
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Replace the existing Xpu1Codec/Xpu1Request consumer with version-2,
suite-0x0301-only parsing and authoring under DR38's frozen XPU1/XPA1 grammar.
The record names identify independently versioned artifacts, not compatibility
aliases. No version-1 XPU/XPA reader or identity/proof adapter remains. The
request/body hashes are exclusively the V2 domains. Full bounded route grammar,
network and distinct public-Deposit/private-Retrieve bindings are checked before
callbacks. Structural decode still creates no authorization.

Replace the existing public Xpa1PublicationAuthorizationVerifier with direct
VerifiedDeepIdV2DirectoryFreshness and actual NETCODEC placement/time inputs.
It returns its closed VerifiedXpa1PublicationAuthorization only after exact V2
body/witness/ADH/DTT/XNA/view/placement, complete conservative trusted interval
and monotonic boot checks. Re-read time after verification, reject backwards
time, boot changes, expiry and cancellation. The selected store receives no
DID2/DCA/plain DCR or resolver read key: the actual DR38 witness ceremony
authorizes opaque ciphertext/body hashes. The node must not fabricate a
publisher proof or pass a structurally nonzero membership hash as authority.
Initially admit only reusable generation-zero publication; unsupported one-time
or successor operations reject before mutation rather than use legacy authors.
The closed verified authorization retains its immutable Protocol inputs and
provides `EnsureCurrentAsync(CancellationToken)` for release-time rechecking
after asynchronous replica/storage/signing work. This cannot accept another
clock or proof, extend a lifetime, renew authority or trigger a proof HTTP fetch.
It re-verifies the same signed closure against current protected monotonic time
and refuses reversal relative to its original verified sample.

Node authorization obtains a fresh, rollback-protected DID2 directory proof
for the configured public observer and authenticated signed network closure.
The incoming publisher never chooses that observer or substitutes a clock.
Reuse the existing DID2 proof reader, network floor and independent current
root/time sources; no conversion from the old Contact snapshot is authorized.
The same current network mints the neutral PublishInvite placement. Missing
DID2 composition fails closed. Source changes must be fenced at capability
release and current time remains a requirement immediately before reservation.

Keep the independently frozen neutral XPO1 result grammar, padding and two
Ed25519 replica receipt purpose unchanged. Its request-hash field and receipt
input now bind exactly the V2 XPU request hash; never hash V2 requests using
the V1 request domain. XIQ/update records are independently versioned and do
not provide a V1 XPU fallback. Update ONION and peer consumers to the sole V2
XPU codec. Exact authorization reservation/replay/dual-replica fsync and
response-loss reconciliation remain required; signing/HTTP success alone is
not publication or device delivery. Old positive identity fixtures must be
replaced with real DID2 authority, not rewritten headers or synthetic proofs.
Receipt release independently re-verifies current authorization and requires
the exact committed saga record (canonical request digest, request/body hashes
and authorization bindings), not merely a committed authorization ID and object
hash. Another valid witness subset is not the committed exact request. Refuse
stale/substituted evidence without writing a new reservation or signing it.

The opaque-node authorization saga uses protected format `XPA2SAG2` and schema
2 only. Old saga files fail closed; explicit test-state reset is required, not
migration, silent clearing or adoption of V1 authorization reservations. The
protection key, registered node keys and other role stores are not reset by
this format change. Genesis request/authorization lifetimes are identical
and at most 120 seconds under DR38.

Machine manifests/vectors, API snapshots, consumer package repins and full
gates remain the final connected-business boundary. Deployment requires private
coordination ingress isolation and actual signed production composition;
no direct public Registry fallback or GitHub Release is authorized by this decision.
