# DR-0059 — DID2 initial contact through the owned mailbox Store

Status: accepted local composition contract; connected/live/device evidence pending
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

Extend DR56's single owned Store engine to the actual retained sender DPH2.
The initial business entry accepts only the logical contact intent, verified
permanent-contact candidate and account-bound source. Never accept caller DPH2,
initial-state keys, holder, receipt, SQL connection or a success assertion.

Derive the key-free session scope from the reconciled sender source and actual
protected catalog. Require exact source session/metadata commitment, phase-2
catalog registration, completed initial-key retirement and active mutable
messaging custody. Refresh the permanent contact independently outside the
lookup lease through an actual new non-consuming read from its verified address,
not a renewed proof over an expired old read. The dispatch lease rechecks those actual sources and current
own/peer endpoint bindings. A missing or changed source rejects, not repair.

Derive the owned operation32 from SHA-256 of
`Deep/Local/DID2/InitialMailboxIntent/1`, a zero separator and the exact intent32.
The owner alone reads the original retained DPH2; ordinary sends still read only
actual direction-1 committed DPE2 rows. Both use DR56's mandatory send journal,
counter floor, exact MAU2 preparation, original lifetime, unchanged grant/path,
selected-entry ONION transport and independent two-node durable receipt checks.
The source kind is selected only by the corresponding private account entry,
never by ciphertext prefix or by falling back after an ordinary-send failure.

Re-read the actual retained source and stable active custody before callback
and after the outcome. Key retirement does not delete the historical ciphertext
needed for exact initial dispatch/retry. A retained source does not create a new
session, re-open a spent prekey, or mint an initial secret. No wire, SQL schema or
protected send-root shape changes; the actual envelope/body commitments close
the source binding. There is no legacy dispatcher or adapter.

The recipient remains DR58's authenticated DPH2 consumer and semantic-before-ACK
engine. Connected initial Store/reopen/receipt and Retrieve/import/Hello/ACK,
remote attachments, group consumers, matched live authority and physical
Windows/USB Android still gate activation and release.
