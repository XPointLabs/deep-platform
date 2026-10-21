# DR-0160 — offline additive NTS source succession

Date: 2026-10-21. Owner: Mr. X. Status: accepted authoring scope; matching
source, retained activation, and connected qualification remain separate.

The existing DTS1 grammar already permits two through eight exact source entries
and requires two authenticated sources in two signed failure families. A two-entry
deployment has no availability redundancy. Missing UDP observations must never
authorize an expired anchor, a lower quorum, wider uncertainty, OS-clock time,
unverified endpoint/pin, or replacement of a protected floor.

Extend the existing offline same-key renewal authoring entry point with an
explicit optional successor source-list input. No compatibility overload or new
wire/magic/suite/schema generation is introduced. Ordinary renewal without that
input retains its exact old source list. An explicit update is additive: retain
every old canonical source tuple byte-for-byte, add at least one new source,
stay within the existing eight-entry bound, and require at least three distinct
signed failure families. Keys, genesis, thresholds, source age, interval width,
and old source-radius bounds remain unchanged. Existing independent root-signing
and complete paired XNA1/DTS1 successor verification are mandatory.

Snapshot and canonically validate the entire proposed list before root callbacks;
caller mutation must not change signed inputs. Offline developer preparation
captures a closed explicit public input file, authenticates ceremony time using
the RETAINED signed source list, and rereads the exact file/source bundle before
sealing the candidate. No environment-variable/runtime policy override, online
root mount, provisional source, genesis replacement, or reader fallback exists.
The pre-mailbox operational preparation and retained activation path publishes
the complete signed successor; a raw file edit is not activation. Mailbox-enabled
custody remains guarded out: coordinated role-volume/journal and node-floor
rollover is separate unfinished work, not permission to bypass that guard.

Observation consumers accept two through the exact configured source count,
verify unique known IDs and at least two configured failure families, and
intersect every accepted authenticated interval. Actual radius plus monotonic
acquisition age must fit each signed source radius; source age and interval
conflict checks remain mandatory. A third healthy source must not be rejected
merely because an earlier local reader assumed exactly two responses.

Separately, timeout of an established authenticated NTS session is not a failed
key exchange. It may retry the same session on the next ordinary bounded poll,
without new queries inside that poll. It neither resets nor increments retained
KE exponential backoff; session discard/authentication failure still enforces
KE backoff, and only authenticated Next Protocol success resets it. No missing
response becomes time evidence and signed freshness is unchanged.

After an observation-quorum miss, Registry schedules the next ordinary poll
within two seconds (or sooner for a shorter signed source age), rather than
waiting the entire healthy polling interval after a slow failed acquisition.
Observer restart retains its ten-second delay so restarting cannot reset KE
backoff. No observer timeout or retained lower-floor comparison is removed.

Qualification must cover canonical additive succession, hostile or mutated
inputs before signer access, three healthy sources, one absent source with two
independent survivors, duplicate/unknown/same-family/conflicting intervals,
unchanged stale-anchor refusal and lower-floor continuity. Connected tests keep
the same accounts and node volumes; they do not relabel a failed first attempt.
