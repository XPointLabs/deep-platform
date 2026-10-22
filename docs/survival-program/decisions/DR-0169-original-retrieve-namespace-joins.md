# DR-0169 — original Retrieve issuance and assignment joins

Date: 2026-10-22. Owner: Mr. X. Status: accepted bounded historical-fact correction;
source, connected and release qualification remain separate.

Original retained Retrieve can be issued under a newer PMA2 while its logical
assignment retains the original PMT2/PMA2. Requiring the issuance policy to be
the policy named by the original assignment incorrectly strands captured pages
after a policy renewal. Live same-profile recovery46 reproduced that refusal.

The existing original-read FACT verifier keeps its closed API and authenticates
both joins before and after checking the exact original grant: the issuance
PMA2 through its naming PMT2 in the CURRENT protected retained network history,
and the assignment PMT2 through its exact named PMA2 in authenticated issuer
history. The coincident pair keeps the existing strict join. Missing, altered,
foreign or unpublished metadata still refuses; raw signatures or current policy
cannot invent a missing historical join. DR-0108/0122 ancestor, threshold and
full history checks remain independently enforced.

This returns no live grant or permission. Original holder, result, role, epoch,
generation, lifetime, signature and request/body checks remain unchanged, as do
native page/materialization/SQL/counter fences. Fresh independent CURRENT ACK
acquisition and actual current time/issuer admission remain mandatory. No expired
request or captured loan is renewed and no page/grant/ciphertext is recreated.

No wire, public API, algorithm, private state generation, account/node key,
compatibility reader or reset changes. Qualification includes distinct-policy
captured-page and lost-ACK recovery plus existing hostile original evidence,
role, cancellation, native/SQL/page and history refusals. It is not device,
sustained availability or release qualification.
