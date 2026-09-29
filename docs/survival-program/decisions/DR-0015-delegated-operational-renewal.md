# DR-0015 — offline policies, delegated operational renewal

Status: accepted pre-production semantic clean break and additive producer API
Date: 2026-09-29
Decision owner: Mr. X

XVP1 tag 12 (`requiredPmt2Generation`) is a **minimum** PMT2 generation,
not an equality constraint. The projection still binds the exact signed XNV1,
network, witness policy, replica count, placement epoch and authenticated
protected PMT predecessor. This change does not authorize arbitrary placement
or weaken any signature, validity, history or rollback check. It permits short
operational views and PMT2 renewals under an unchanged root-signed policy.
Readers must be repinned together before deployment; no old equality reader
is retained. Existing layouts, domains and signed bytes are unchanged.

`XPointNetworkOperationalGenesisRequest` appends the optional
`rootPolicyExpiresAtUnixSeconds = 0` constructor argument and exposes
`RootPolicyExpiresAtUnixSeconds`. Zero selects the operational expiry.
An explicit value must cover the operational interval and remain within the
verified XNA1. It affects XVP1/PMA2 only; XND1/XNV1/XNH1/PMT2/ADH1 remain
short-lived. Root policy renewal is still an offline ceremony, not online work.

`XPointNetworkOperationalSuccessorAuthor.AuthorDelegatedAsync` takes the
existing request with an empty root signer list. It reauthenticates protected
predecessors, witnesses and identity signers before callbacks; retains exact
XVP1/PMA2 bytes; rejects intervals outside their live delegation; and authors
one XND1/XNV1/XNH1/PMT2 successor. A delegated current onion/TLS key must be
either the retained current key or its pre-announced next key. Promoting the
next onion key uses its announced epoch, not an epoch beyond it. Renewing the
current key retains its epoch. New next keys remain distinct. The existing
`AuthorAsync` still requires root custody and authors a policy successor.

Neither API publishes state. Operational custody must stage private next keys
durably before publication, CAS/readback the exact protected predecessor,
publish an atomic complete closure, then activate the matching private runtime
keys with replay/identity/history volumes retained. A partial closure, expired
delegation or signing/storage failure leaves the last committed generation and
readiness fails closed. No production identity, BLS registration or contract
ABI changes are authorized by this API. Updated snapshots and focused positive,
rollback, expired-policy and staged-key hostile tests are mandatory.

Owner: [network architecture](../../architecture/XPOINT-NETWORK-V1.md).
