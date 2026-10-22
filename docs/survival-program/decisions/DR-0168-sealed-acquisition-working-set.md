# DR-0168 — sealed acquisition custody is not namespace retirement

Date: 2026-10-22. Owner: Mr. X. Status: accepted local lifecycle correction;
source, connected and release qualification remain separate.

The128-entry working acquisition journal incorrectly acts as a lifetime issuance
limit inside a seven-day selection epoch. Raising that limit, forgetting counters
or declaring expiry to be namespace exclusion is not an acceptable correction.

Under the actual account lease, a known adopted, expired, superseded acquisition
may move out of the working chain only if it is the structurally oldest adopted
member of that scope, no acquisition in that chain is pending/unresolved, and no
protected active/closed-unknown Store or read/ACK references its exact grant.
Its actual independent nonzero replay floor must remain present. The selected
current holder is never moved. This is scheduling/storage tiering, not settlement,
non-delivery, holder destruction, a current grant or permission to repeat work.

The owner atomically CASes the exact working predecessor and inserts a sealed
copy of the COMPLETE original acquisition: request, response, private holder,
policy and route. No bytes, original unknown outcome, SQL history, accepted-object
authority, traversal, native anchor or replay floor are deleted. The current
journal grammar uses its reserved reference count and canonical sorted bounded
references (acquisition hash, grant hash, full-entry commitment, lifecycle phase).
The sealed copy uses the SAME single current grammar, not an older reader,
migration or compatibility fallback. A reference is not effect authority.

The working128 cap, existing byte budget,1024-slot/8MiB protected-inventory
limits and512/128 send/read floor limits do not increase. Retained references are
bounded by the existing combined floor budget; full unknown or otherwise pinned
custody still applies backpressure BEFORE new issuer work. Atomic storage failure
leaves either the exact predecessor or both the reference and complete copy;
there is no separate remove/insert window or reconstruction from SQL absence.
One maintenance call stages at most eight independently eligible originals in
memory, encodes the complete working successor once, and atomically inserts ALL
copies with that successor. It does not parse/re-encrypt the protected inventory
eight times. Every copy gets its own exact reference/read-back; any slot conflict
or capacity failure leaves the entire original protected predecessor unchanged.

Sealed custody never enters new-work acquisition. After an independently signed
selection-epoch advance AND original possible-issuance ceiling, the owner may
restore its EXACT original as the oldest working predecessor for the existing
strict namespace/dependency retirement producer. No original request is signed,
issued or sent again. Every DR-0096/0097 floor/history/native and complete
Store/read/replacement/object prerequisite remains mandatory and unchanged.

The sealed reference remains through restoration, strict floor/holder retirement
and guarded slot deletion. Missing, foreign or changed mandatory sealed bytes
refuse; a durable deletion phase permits only idempotent completion of an already
authorized local deletion, never a business effect. A cold interrupted restore
or namespace plan resumes its exact custody. Epoch expiry, current issuer renewal
and a decoded phase alone cannot remove a replay floor or accepted-object path.

Normative owner: TRANSPORT-NEUTRAL-MESSAGING section8.4.3. Qualification requires
atomic/cold handoffs, exact floor/native/SQL preservation, hostile reference and
missing-copy refusal, full unknown-capacity refusal, later genuine epoch cleanup,
and the retained three-CLI round46. This does not claim infinite retention,
unfiltered/full acceptance,1–2s delivery, device or release qualification.
