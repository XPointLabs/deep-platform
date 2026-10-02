# DR-0075 — exact issued-head response and protected custody

Status: accepted connected clean-break increment; deployment/device gates open
Date: 2026-10-03
Decision owner: Mr. X (delegated architecture authority)

Connect DR74 to actual private issuance and DR73 exact request custody. Keep
the unchanged version-2 1151-byte request/media/endpoint. The response becomes
version 3 only, media application/vnd.deep.contact-route-authority-response.v3+octet-stream:
same header8/network16/nonce32 and three LP32 threshold records, followed by
fourth LP32 exact canonical issuance ADH1 (429..4096 bytes including its witness
receipts; minimum = header12 + field headers104 + fixed fields217 + receipt96).
Response bounds are 2584..15179. Reject V2 responses, missing/trailing,
hostile length or cross-network ADH before adoption. Parsing grants no authority.
No new crypto/domain/suite, request floor rewrite or compatibility reader.

The unchanged XCA2/XCS2 wrapper accepts this exact request-V2/response-V3 route
pair; publication remains V2. Update CONTACT-COORDINATION-02 target/body binding.
ONION limits, placement and security stay unchanged: the larger response fits
the existing Contact success bound. Every consuming server/client uses the
same canonical codec and target-specific bounds.

Registry records the exact issuance ADH from the SAME verified signing context
inside its permanent exact winner before release. It never substitutes a latest
or proposed head after signing. On replay, independently current account/network
and source fencing remain mandatory; DR74 reauthenticates the retained issuance
head and all current route checks. Current-only minting stays strict. Different
intermediate heads are handled by actual signed bytes, not hash inference.

Explicit operator provisioning adds response_envelope_version=3 to the permanent
network reservation row and widens opaque response storage capacity to 15179.
Runtime verifies this marker under its capacity lock BEFORE signing callbacks;
missing/old provision rejects without lazy DDL. An atomic operator upgrade keeps
all rows/counts/capacity/floors unchanged, including retired opaque V2 audit bytes.
Such bytes are never returned as current authority: the current response codec
rejects them, without deletion, resigning, reminting or retrofitted ADH.

Shared route journal becomes version 6 only. Append fourteenth LP32 record
(index13) for exact issuance ADH (max4096): empty at proposal phase1, mandatory
in phases2..7. Maximum entry becomes 437209; header92/prefix170, phases/revision
and 1MiB aggregate stay unchanged. Reserve complete terminal bytes before the
first callback; retain original request record12 through every phase. Adopt
threshold plus signed ADH only from DR74 closed verified issuance, then CAS and
independent readback before device completion. Reverify it on reopen/release,
object authoring and publication before callbacks. No migration, reconstruction,
dual reader or silent reset. Version5 disposable QA requires explicit reset at
activation; SQL identity, registered node keys and permanent floors stay intact.

Acceptance: lost already-signed response with genuine directory advance,
phase2 crash/readback/reopen, head1 proposal/head2 issuance/head3 retry, same
account/nonce/request/threshold/ADH; exact object/publication/replica custody.
Real PostgreSQL/TestServer issuance must retain and replay the complete winner
without signing again after head advance. Reject old/missing/corrupt/mismatched
ADH or journal, unavailable provisioning, stale current authority/lifetimes,
bad signatures, capacity, cancellation and protected clock discontinuity.
No retained-expiry successor or physical contacts/messages/assets/groups claim
is inferred; DR72 per-generation coordination and object/publication successors
remain connected renewal gates. No production activation by this source change.
