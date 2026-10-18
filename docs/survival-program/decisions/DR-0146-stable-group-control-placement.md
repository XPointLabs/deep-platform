# DR-0146 — Stable GSR placement with current admission

Status: accepted correction to DR-0145; runtime qualification is separate
Date: 2026-10-18
Decision owner: Mr. X (delegated authority)

The first connected GSR candidate exposed a design defect: recomputing a stream's
replicas from every current PMT2 silently moves an existing CAS stream whenever
the operational publisher renews its view/selection epoch. A newly selected
replica need not have its predecessor. Routine renewal is not a handover.

GSR1 tag6 therefore fixes the exact verified historical PMT2 used solely for
placement facts. The DR-0145 rank/hash transcript is unchanged, but takes that
anchor's cohort, epoch, reference and view, not the latest PMT2. GSW1/GSQ1 tags3/4
name those placement facts. Full GSR1/inner identifiers remain absent on nodes;
the anchor view resolves uniquely inside independently verified retained history.

An anchor is NOT live authority. Every operation still needs current NETCODEC,
directory/time/floors, both selected replicas in the current admitted PMT cohort,
current identity/traffic keys and diverse three-hop routing. Carriage issue/expiry
are checked against current authenticated service time and the current signed
network ceiling, not the expired anchor's window. A missing anchor or removed
replica fails closed until a qualified successor/handover; no arbitrary old route.
Receipt verification rechecks the two exact anchor-derived signatures and original
request/body binding. It does not grant permission to dispatch an expired request.

No new wire fields, journal generation, migration or node-key change. Expired
unknown writes still remain explicit unresolved work, never reencrypted/reminted.
The failed GroupRevision0 candidate remains preserved, including its uncertain
write captured under the incorrect moving-placement allocation. It is not
rewritten or claimed recovered. The corrected allocation is tested in a separate
named group on the same mutually consented accounts, with its own archived runtime
and scenario. This is a pre-production allocation correction, not a successful
retry of the old candidate, device qualification or release acceptance.
