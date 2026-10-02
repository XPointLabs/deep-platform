# DR-0054 — DID2 private mailbox grant issuance

Status: accepted connected API/service contract; activation gates remain
Date: 2026-10-01
Decision owner: Mr. X (delegated architecture authority)

Keep neutral XMG1/XMC1/MCG2, private node authentication and two-store route
receipt transcripts unchanged. Do not activate the retired PMA1 coordinator
or wrap its identity/topology authority. The private issuer is not a resolver:
it receives no DID2, DCR plaintext, recovery key or recipient lookup key.

Freeze `DeepIdV2MailboxGrantIssuanceVerifier.VerifyAsync(network, root,
exactPma2, exactXmg1, exactRouteClosure, effectiveExpiry, replicaEvidence,
trustedTime, ct)` and its closed `VerifiedDeepIdV2MailboxGrantIssuance` result.
Evidence consists of exactly two bounded `DeepIdV2MailboxGrantReplicaEvidence`
records (node ID32, signature64). Before awaiting, own bounded canonical inputs.
Verify the holder proof, current NETCODEC projection/root binding, root PMA2,
full authenticated interval and original request maximum of 120 seconds.
Verify the exact six-record graph, current view/head/key epochs and PMS/XRC/XSS
witness signatures with distinct witness failure domains. The retained issuance
directory anchor must agree between XRC and XSS; it is not replaced with the
service observer's later checkpoint.

Independently derive the two ResolveInvite stores from current NETCODEC and
XMG locator. Both must sign the exact request hash, locator, role-separated
capability digest, Current disposition, exact route hash and effective expiry.
Deposit must equal the public route capability; Retrieve must differ from it
and have both stores' owner-capability lookup evidence. Threshold commitments
plus independently verified durable store attestations authorize this opaque
route only: they do not assert current recipient identity, contact consent,
device authority or delivery. Those remain mandatory client checks.

Freeze `IMailboxGrantIssuerSigner` (public key and asynchronous detached signing)
and `VerifiedDeepIdV2MailboxGrantIssuance.AuthorSuccessAsync(signer, ct)`.
Only the PMA2 role key may sign; capture the key before awaiting, verify the
returned signature, recheck full time/root/network/route bounds after signing.
Grant generation is the current PMA2 minimum (at least one), serial is fresh
independent random16, lifetime is bounded by PMA2 and every exact route/NET
expiry including the two-store effective expiry. XMC expiry is exactly the
original XMG expiry, never callback time plus a new lifetime. Authored bytes
are candidates, not proof of persistence or permission for client dispatch.
Freeze `VerifiedDeepIdV2MailboxGrantIssuance.VerifySuccessAsync(exactXmc1, ct)`
for independent exact read-back checks under that same issuance context; it
requires the original request still current, exact XMC expiry and current grant
issuer/signature/topology/lifetime, and grants no client installation authority.

Registry composes an independently nonce-proven public service observer,
external directory floor, signed time and matching complete DR52 bundle. It
rechecks unchanged root/time policy, proof and exact bundle before and after
the signer and before release. Role signers stay outside XNode; Production
uses protected external signer sockets with distinct PMA2 role keys.
The separate externally provisioned PostgreSQL grant journal reserves capacity
and network/operation/request-hash/scope-hash before signing, locks issuance
across processes and commits one immutable exact XMC winner with separate
read-back. No raw capability in database/logs, automatic DDL/root repair,
eviction, deletion or winner renewal. Changed hashes under an operation reject.

The private endpoint bounds the whole body before JSON materialization, rejects
duplicate/unknown fields and noncanonical binary encodings, authenticates a
currently selected forwarding node and both independently selected stores.
Admission replay memory and concurrent work are bounded. Fresh admission proof
may retry a retained exact XMG winner; it cannot change that winner. Unsupported
or non-current route issuance stays unavailable rather than minting authority.
Node acquisition requires current full-interval checks before/after durable
lookup, remote evidence and issuer response. No direct public issuer fallback.
Complete journal/HTTP/node fault coverage, machine/API/vectors, matching rollout,
credential use and physical Windows/USB Android E2E before activation claims.
