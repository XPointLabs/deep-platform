# Protocol qualification case bindings — 2026-11-04

Status: accepted qualification mapping; no test or runtime acceptance.
Owner: Mr. X (delegated architecture authority).

These exact mappings preserve historical negative coverage under already
accepted contracts. They do not waive failures or skips. Original TRX files
remain unchanged; the current replacements must execute and pass. The canonical
repository gate owns case identity and unchanged-input validation.

## Exact reference replacements

| Historical case | Required current replacement | Reason |
| --- | --- | --- |
| `Deep.Protocol.Tests.ContactV2.CurrentContactSecurityTests.InBandRouteRejectsExactCrossFieldMutation(id: "xrc-pmt-xnv-binding", rejection: "Xrc1AuthorityBindingMismatch")` | `Deep.Protocol.Tests.ContactV2.CurrentContactSecurityTests.InBandRouteRejectsExactCrossFieldMutation(id: "xrc-pmt-xnv-binding", rejection: "ClosureReferenceMismatch")` | DR-0122 and Protocol `2dbac60` removed equality between issuance XNV and the current assignment PMT during ordinary view renewal. The same individually canonical mutation changes XRC1 tag8 while its XSS1 reference remains unchanged; the actual complete graph therefore rejects the broken XSS1→XRC1 reference. Neither artifact nor mutation is accepted. |
| `Deep.Protocol.Tests.ApplicationCore.Dmc2CodecTests.ReservedKind_RejectsBeforePayload(kind: 30)` | `Deep.Protocol.Tests.ApplicationCore.Dmc2CodecTests.GroupControlKind30_RequiresExactTypedCarrierAndKeepsGenericEmissionClosed` | Under DR-0145, kind30 is the typed group-control rendezvous carrier. The replacement verifies malformed-carrier rejection, canonical untrusted grammar round-trip, and refusal by the public generic author. The separate reserved-kind65535 rejection remains required. No group authority is fabricated by this codec-only test. |

Canonical runner bindings for the same two rows:

```text
Deep.Protocol.Tests.ContactV2.CurrentContactSecurityTests.InBandRouteRejectsExactCrossFieldMutation(id: "xrc-pmt-xnv-binding", rejection: "Xrc1AuthorityBindingMismatch") -> Deep.Protocol.Tests.ContactV2.CurrentContactSecurityTests.InBandRouteRejectsExactCrossFieldMutation(id: "xrc-pmt-xnv-binding", rejection: "ClosureReferenceMismatch")
Deep.Protocol.Tests.ApplicationCore.Dmc2CodecTests.ReservedKind_RejectsBeforePayload(kind: 30) -> Deep.Protocol.Tests.ApplicationCore.Dmc2CodecTests.GroupControlKind30_RequiresExactTypedCarrierAndKeepsGenericEmissionClosed
```

The exact device-signing and onion capability surface tests retain their current
identities. Their reviewed expected surfaces include the existing typed group
signers and nonforgeable group placement capability. Generic signer/key escape
and public capability construction remain forbidden; no production API changes
are introduced by those test corrections.

The original `route-history-20261104-full01` run had 2636 passed, four failed and
seven declared platform/operator skips. Its 2647 actual cases differed from the
2648-case reference union by the obsolete contact error identity above. It is
not accepted. Package metadata validation remains independent of these mappings.
