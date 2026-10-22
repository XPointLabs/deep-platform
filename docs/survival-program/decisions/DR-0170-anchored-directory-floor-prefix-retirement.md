# DR-0170 — anchored native directory-floor prefix retirement

Date: 2026-10-23. Owner: Mr. X. Status: accepted lifecycle correction;
source, connected and release qualification remain separate.

Repeated native authentication of every historical directory-floor tip is
O(history) inside each operation lease check. The independent protected anchor
already pins the exact committed monotonic revision/head. It may authorize
retirement of a fully authenticated prefix strictly below itself, not resetting
or renumbering revisions, dropping the current floor, or caching permissions.

The acquisition owner authenticates the complete retained contiguous chain,
its signed network/genesis/authority closure, independent anchor and index.
Recovery may finish authenticated pending successors through the existing
owner. Before any deletion, the actual current tip, anchor and index must all
authenticate and exactly match the committed record after durable publication.
Delete at most64 older tips in ascending revision order, flushing each deletion
before the next. Failure stops maintenance; the remaining suffix stays
contiguous. Never delete the current tip, pending descendants, anchor, index,
Data Protection keys, replay counters or mailbox/acquisition custody.

Every observation still rereads and Unprotects EVERY retained native record,
checks actual path/permissions/EOF, canonical filename/authenticated revision,
network/genesis, signed authority and strict generation/hash joins. A suffix
may start above zero only when the actual independent anchor is contained in
that suffix; ordinary observations additionally require anchor/index at its
exact latest tip. Missing/corrupt active custody, interior gaps and journal-only
rollback refuse. Observations never repair or collect. Complete-history audit
of deliberately retired files is no longer claimed; those files grant neither
replay exclusion nor freshness. No current signed lifetime or cryptography changes.

DHF2 framing, protection purpose, identities, floor numbers and wire formats
remain unchanged; there is one current lifecycle, not a legacy reader. A cold
owner fully authenticates an existing uncollected chain before retirement.
Older binaries requiring a revision-zero prefix cannot read compacted custody:
rollback requires a coherent pre-upgrade journal+independent anchor+key-ring
snapshot, never restoring the journal alone or resetting accounts. Coordinated
rollback of both journal and anchor remains outside this local threat boundary;
live threshold freshness remains independent. Initial activation is local only.

Normative owner: ACCOUNT-DIRECTORY, native floor lifecycle section. Required
qualification includes advanced counter preservation/reopen, actual native
reads and revocation, bounded/interrupted retirement, pending successor crashes,
missing/corrupt/linked custody, interior gaps, journal-only rollback and retained
three-CLI delivery measurements. No1–2s, full/package/device/release claim follows
from a focused gate or one successful CLI delivery round.
