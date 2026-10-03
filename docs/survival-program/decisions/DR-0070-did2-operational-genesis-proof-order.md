# DR-0070 — DID2 operational genesis proof ordering

Status: **accepted source/API candidate; connected activation gates pending**
Date: 2026-10-02
Decision owner: **Mr. X** (delegated pre-user clean-break authority)

Removing the V1 genesis helper exposed a dependency cycle: a real DID2 DTT1
requires the exact signed network view before current directory proof can exist.
Operational authors must not synthesize V1 non-membership to bypass that cycle.

Split authoring into two closed stages, with no wire or transcript change:

1. `XPointNetworkOperationalGenesisAuthor.AuthorNetworkCandidateAsync` takes
   a bounded ceremony request without obsolete directory-query, proof nonce or
   raw observed-time fields and returns a constructor-closed
   `PendingXPointNetworkOperationalGenesis`. It owns defensive copies of signed
   XVP1/XND1/XNV1/XNH1/PMA2 bytes and exposes no freshness, topology, trusted
   context or dispatch capability. Existing private signer intents and independent
   signature checks remain mandatory. This result is not network admission.
2. The directory owner independently issues and verifies an actual DID2 proof
   against the candidate's exact XNV1 and its own protected directory state.
3. `CompleteDid2Async` takes the pending candidate and verifier-minted
   `VerifiedDeepIdV2DirectoryFreshness` and an independent
   `OnionTrustedTimeAuthority`. Before topology signing it checks the
   network, authorizing root/witness policy, exact XNV core binding and current
   boot/monotonic interval from a current reading, not a snapshot clock invented
   by the author. It verifies PMA2 against the complete authenticated
   interval, authors witness-bound PMT2 against exact ADH1, and independently
   verifies the full ONION network closure with another current clock read
   before returning the completed result.
   It copies only the already verified exact ADH1/DTT1/ADP1 V2 evidence; it never
   issues a directory proof, invokes a generic verification callback or mints
   account, mailbox-holder, publication, message or delivery authority.

The ONION time lease must subtract elapsed monotonic time from both the DTT1
freshness budget and the network hard-expiry budget. Applying elapsed time only
to the first budget could extend a short network interval even while the
directory proof remains current. Completion rechecks boot, non-decreasing
monotonic time and full authenticated upper bound after topology signing;
the independently verified context repeats current-time lease admission.

No V1 author overload or compatibility reader is restored. Candidate ceremony
intervals are not trusted time or proof authority. Consumer/tooling source
cutover, closed API/resource review, schema/registry bindings and package repins
remain mandatory before activation. This candidate does not authorize redoing
registered node identities, protected floors or production genesis.

Required focused evidence: actual-native DID2 admission/proof and independent
network verification; wrong-view/authority/policy/network/boot/stale and cancelled
completion rejects before topology signer callbacks. Positive local fixtures
are not live authority installation, NTS acquisition, transport/TLS or device E2E.
