# DR-0088 — owned DID2 one-time contact object

Status: accepted local producer target; threshold, protected client custody and shipping activation gated
Date: 2026-10-04
Decision owner: Mr. X (delegated architecture authority)

Close the local one-time producer gap without changing any wire allocation,
suite, signature domain or crypto library. The sole object/AEAD semantics remain
[CONTACT-AND-GROUP §6](../../architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md#6-permanent-deep-id-resolution-and-one-time-invitation);
retention remains RET-DCR-PUBLICATION-V1. Existing frozen DIA1 grammar and
positive/hostile vectors are unchanged. A DIA1 carrying a DID2-bound object is
not a DID1 credential, compatibility reader or alias.

Add closed artifact-specific `CompleteOneTimeGenesisAsync`,
`AuthorOneTimeGenesisAsync` and `RestoreOneTimeAsync`. Route completion requires
actual current DID2/NET/time and the owned publisher device. Require the DCA1
one-time policy bit before signing. Complete the existing six-record genesis
route and device-signed XIR1 V2 with kind 2/usage 1. No predecessor, retained
completion or one-time successor is authorized by this decision. Reusable
genesis/successor APIs remain reusable-only, with no caller-selected kind switch.

Share the existing DCB1/DCR1 authoring and identity/support checks, not a copied
signing implementation. Require the exact kind-2 genesis XIR1/route and a signed
XPS1 per current device. DCB1 policy is exactly bits 1 and 3 (10), generation 0
and zero predecessor; expiry is bounded by all existing inner authorizations
and the one-time retention limit, covering the full trusted interval. Current
directory issuance anchoring and post-await monotonic checks remain mandatory.

Create invitation ID, independent locator capability, independent decryption
key and AEAD nonce with CSPRNG. Bind the existing DIA1 to the exact signed DCB1
hash, network and effective bundle expiry. Protect only exact DCR1 V2 with the
existing one-time AEAD/AAD formula, never the permanent resolver derivation.
Restore decodes bounded inputs before asynchronous work, authenticates AEAD,
compares exact retained plaintext and independently rechecks signed current
route/identity/support on both sides of the time callback. Wrong invitation,
bundle, network, expiry, ciphertext, current proof or route rejects. Reusable
protection and restore do not adopt one-time objects.

The closed disposable result owns copies of exact DIA1, protected DCR1 and
locator. Returned invitation bytes are secret-bearing caller-owned copies;
dispose clears its owned bytes and rejects further exports. Parsed plaintext
is not a verified publication or redemption capability. No generic signing,
raw key or arbitrary protected-state factory is exposed.

This local result MUST NOT reach transport, QR or a public client callback
before account-owned exact pending/winner custody is implemented. No new journal,
wire envelope or release flag is introduced here. The existing publication
envelope V3 remains permanent-only: it lacks a publisher-signed, key-free
one-time locator/object/expiry commitment. Threshold witnesses must not receive
secret DIA1 or its decryption key. That missing coordination freeze, matched
Registry/Shared/node consumption, durable issuance/redemption and installed
Windows/Android E2E remain B8/S00 and later activation gates. Codec parsing or
this local producer alone cannot close B8.
