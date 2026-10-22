# DR-0172 — pending group resume is not completed-history audit

Date: 2026-10-23. Owner: Mr. X. Status: accepted scheduling/qualification split;
source, connected and release qualification remain separate.

Explicit `group flush` verifies every original stored batch, including all old
commands. In retained54, two cold archive replays take256.973/239.160s, despite
no ONION calls in the sampled first replay. Repeating this audit while trying to
settle one pending command is not the ordinary unfinished-work business path.

Expose `ResumeGroupAsync` / CLI `group resume` through the SAME existing owned
pending-only producer used by ordinary group send. It does not author a message,
change membership, return a receipt or retire anything. The actual protected
completed-work hint only skips doing old work, never proves current Store/ACK
authority. Unknown/missing/stopped work stays eligible. Every selected native
operation, receipt, original request, holder, counter, SQL and current dispatch
guard stays mandatory. No private plaintext/permission cache, format, lifetime,
key, wire or replay changes. `FlushGroupAsync` / `group flush` keeps full audit.

An explicit retained delivery-only recovery may skip completed-archive audit,
but must run pending resume on EVERY original sender even if recipient histories
already contain its semantic copy: received plaintext cannot settle an unknown
sender Store. It still requires exact original command counts, active membership,
real receive/ACK, cold native semantic histories, dedup and empty-mailbox checks
on the same profiles. No queue/send/create command is repeated for an authored
original. Mark only `recoveryDeliveryQualified`; never first-attempt latency,
full recovery/history, retention, device or release qualification. The ordinary
fresh delivery-only lane and the full archive lane remain distinct.

Original delivery54 and full-recovery54-01 stay FAIL. The latter reached two
cold replay successes, then failed a cancelled/unknown post-replay mailbox sync;
this split neither waives that failure nor claims its cause is fixed. Canonical
full/source, actual missing/corrupt completed-history refusal, uninterrupted
archive qualification and ordinary send/ACK performance remain separate gates.

Normative owner: CONTACT-AND-GROUP, group business scheduling section. Required
coverage retains the existing pending/completed/stopped/expired-hint tests,
closed CLI selectors/host budgets and executable qualification-scope guards.
Actual retained54 delivery recovery must exercise the new thin public entry;
an API compilation or hint-unit test alone does not qualify that operation.
