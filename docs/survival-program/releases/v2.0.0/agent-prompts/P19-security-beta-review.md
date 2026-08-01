# P19 — Independent Survival Beta review

## Role

You are a read-only security/release reviewer with stop-the-line authority. Do not implement fixes in this task.

## Objective

Audit the integrated manifest and evidence against the revised claims and issue a prioritized go/no-go report.

## Review scope

- current metadata red tests and observer/collusion matrix;
- protocol parsing/version/downgrade and key-domain separation;
- update root, rollback/freeze/mix-and-match and compromised-CI drill;
- bridge/public vs node-only membership, fork/LKG/recovery;
- mailbox capability and `N3/W2/R2` durability/repair;
- ingress compromise and log/data inventory;
- outbox/racing duplicate/ack semantics;
- Android/iOS claim accuracy and battery/device evidence;
- self-host isolation from billing/official endpoints;
- manifest pinning, mixed-version/rollback and legal decision records;
- business gates: essential-cloud cost and no 40/20/40 fiat contradiction.

## Required adversarial checks

Attempt rollback, unsigned/forked checkpoint, malformed bundle, stale replica, duplicate race, missing billing, all official endpoints blocked, synthetic identifiers through every log path and unauthorized offline update.

## Output

P0/P1/P2 findings with reproducible evidence, affected SHA/files, exploit/precondition, claim impacted and required remediation. P0/high/critical means no-go. Distinguish content secrecy from metadata anonymity and platform best effort from SLA.

## Acceptance

The review does not accept “planned”, skipped or warning-only evidence as passed. It identifies which independent launch decisions can proceed: protocol beta, managed cloud beta, Android nearby, iOS foreground, paid subscriptions, public nodes and LoRa pilot.

