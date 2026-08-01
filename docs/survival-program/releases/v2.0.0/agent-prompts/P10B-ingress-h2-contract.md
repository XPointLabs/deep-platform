# P10B — Managed ingress H2 wire contract

## Role/repository

Work only in `deep-protocol` before P10 server or P11 transport adapter implementation.

## Objective

Freeze the externally visible H2 opaque-frame API and accepted/durable error semantics.

## Contract

Define method/path, content type/version, maximum frame and header sizes, authentication/channel binding, replay/idempotency window, backpressure, cancellation/timeouts, status/error codes, readiness/capability document and compatibility negotiation. Reference pinned opaque bundle and mailbox presentation/receipt types.

`accepted`, `durable` and `delivered` are distinct: for Beta, `delivered` means recipient device acknowledgement only if that protocol is separately implemented; mailbox retrieval alone must not be mislabeled.

## Out of scope

ASP.NET implementation, proxy behavior, TLS deployment, UI and storage coordinator.

## Acceptance

Golden request/response/error fixtures cover size, replay, timeout, unsupported version and durable quorum receipt; P10/P11 consumers receive one immutable package/hash; unknown critical features fail closed.

