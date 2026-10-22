# DR-0171 — original Store issuance and assignment joins

Date: 2026-10-23. Owner: Mr. X. Status: accepted bounded consumer correction;
source, connected and release qualification remain separate.

Retained three-CLI delivery54 reached late original Store settlement and failed
the strict policy/projection equality. DR-0122 permits current issuance under
a renewed PMA2 while preserving the exact earlier logical PMT2 assignment.
Requiring those distinct roles to name one policy strands the original receipt.
The same distinction already applies to Retrieve under DR-0169.

For original Deposit/Store FACT authentication, the owned consumer must join
issuance PMA2 through an exact retained PMT2 naming its core, and original
assignment PMT2 through its own exact named PMA2. BOTH pairs pass the existing
strict current-host retained-history/ancestor/signature verifier. Raw public
records only locate those pairs; missing/foreign/altered metadata still refuses.
If both roles coincide, the same strict pair supplies both facts. The existing
two-argument Protocol verifier remains strict; no public API or wire changes.

This supersedes the blanket single-policy Deposit historical-join clause in
TRANSPORT-NEUTRAL-MESSAGING. It grants no new Store permission: current issuer,
time, route, grant, revocation, holder, replay reservation and native admission
still independently govern dispatch. Late settlement retains the exact original
signed request/response, policy, route, body, replay counter, SQL commitment,
native custody and quorum receipt; no reissue, remint, counter rollback, retry
deadline extension or new command is allowed. Historical facts are not current
grant, deletion, non-issuance or absence authority.

Reuse Shared's existing owned dual-namespace verifier for original Store attempt
closure/late settlement. Positive coverage must use actual PQ/SQLCipher/native
state with signed same-epoch policy renewal and different issuance/assignment,
then expired original reply, cold reopen and identical request without another
dispatch. Existing strict-pair, missing/changed metadata, issuer substitution,
scope/native/SQL, atomic interruption and counter guards remain mandatory.
Recover original54 on the same three profiles; its failed first attempt stays
failed and is not a successful latency sample. No reset or compatibility reader,
state generation, algorithm, signed lifetime or release activation is introduced.
