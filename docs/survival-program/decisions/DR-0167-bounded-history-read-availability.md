# DR-0167 — bounded read-only history availability

Date: 2026-10-22. Owner: Mr. X. Status: accepted bounded scheduling correction;
source, connected and release qualification remain separate.

Registry can return authenticated HTTPS503 while actual NTS time is unavailable.
The client already falls back from a503 proof response to signed history catchup.
Immediately failing that history request on the same short availability gap
unnecessarily aborts a page before its receive/ACK endpoint acquisition completes.

One history catchup may repeat at most ONE read-only POST across ALL its pages,
only after503 with explicit positive Retry-After of at most5 seconds. Dispose the failed
response, respect that delay and the original caller cancellation/deadline, then
send the SAME owned canonical request bytes to the SAME closed HTTPS endpoint.
No retry for429, other rejects, absent/invalid/long hints, timeout or malformed
content. A second503 remains a refusal; another page gets no renewed budget.

Retry-After is scheduling metadata, never trusted time or permission. A returned
body remains untrusted until the existing source-bound history signature,
consistency, rollback/fork and durable floor checks succeed. Current proof
acquisition still mints its own fresh nonce afterwards and rechecks actual floors
and authenticated time, even when valid history contains no newer head. An empty
history page cannot suppress that one fresh proof attempt or replace its authority;
another503/429 still refuses. No stored or captured request/loan lifetime is renewed;
no private business command, grant, ciphertext, counter or journal is reminted.
NTS quorum/families, sample age, uncertainty, TLS and all effect fences are unchanged.
There is no format, protocol-version, key, account or reset change.

Qualification separates raw transport scheduling tests from genuine signed
history/floor tests and real three-CLI receive/ACK. Transport retries/non-success
remain visible in numeric receipts; first CLI attempt is not a claim of zero
network retries, sustained external NTS availability or release acceptance.
