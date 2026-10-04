# DR-0090 — DID2 one-time publication commit verification

Status: accepted closed API increment; protected client custody and activation gated
Date: 2026-10-04
Decision owner: Mr. X (delegated architecture authority)

Close the missing client verifier before implementing B8 protected winner custody.
The sole normative owner is CONTACT-RESOLVER section 7. Add the artifact-specific
`DeepIdV2PublicationCommitVerifier.VerifyOneTimeCommittedAsync` for the existing
closed disposable DR-0088 object and signed DR-0089 request/result. Reusable
verification remains reusable-only. Share the existing canonical/currentness,
witness and two-replica verification machinery, not a raw kind/clock/key bypass.

Receipt IDs and descriptor signing keys are separate. Resolve keys from the
independently verified current network; reject signatures made using node-ID
bytes as signing keys. No wire, magic, suite, domain, journal generation, crypto
library or invitation export right is added. A verified past commit is not fresh
XPA dispatch authority, protected account custody, claim/consent or delivery.

The current reusable journal remains reusable-only. Exact one-time secret
pending/winner/read-back/AEAD restoration, retained genesis completion and local
format closure remain unfinished. Matched node composition, package artifacts,
shipping export and physical Windows/Android E2E remain required. This increment
does not authorize a reset or deployment.
