# Sprint 01 — foundations

Duration: 2 weeks. Exit outcome: one versioned encrypted bundle contract and a mechanically enforced free/cloud boundary.

## FND-01: architecture decision — two planes

Repositories: `deep-protocol`, `deep-client-shared`, `xnode`.

Create an ADR defining:

- free plane: direct, BLE, Wi-Fi, LoRa adapter and self-hosted transports;
- managed plane: official ingress, replicated mailbox/blob storage, TURN and push;
- allowed dependencies: managed adapters may depend on quota capabilities; core message/session code and free adapters may not;
- failure semantics: billing/chain outage can reject new managed uploads but never local/P2P delivery or key access.

Acceptance: an architecture dependency test fails if a free transport assembly references a billing/wallet namespace.

## FND-02: transport-independent encrypted bundle

Define a versioned bundle in `deep-protocol` with canonical serialization and golden vectors. Minimum logical fields:

```text
version, bundleId, createdAtBucket, expiresAtBucket,
payloadType, encryptedHeader, ciphertext, replayTag
```

Keep routing metadata outside the signed plaintext identity domain where possible. Do not place payer, plan, token balance or transport name inside the bundle. Specify size limits and LoRa fragmentation compatibility without forcing LoRa constraints on normal attachments.

Acceptance:

- the same bundle bytes can be sent through an in-memory direct adapter and current routed adapter;
- malformed version/length/replay fields are rejected;
- golden vectors are deterministic across supported platforms;
- no outer field exposes raw sender and recipient together; document any unavoidable remaining metadata.

## FND-03: transport contracts

Introduce narrow interfaces in `deep-client-shared`; exact naming may follow local conventions:

```csharp
public interface IMessageTransport
{
    TransportKind Kind { get; }
    ValueTask<TransportReceipt> SendAsync(EncryptedBundle bundle, CancellationToken ct);
    IAsyncEnumerable<EncryptedBundle> ReceiveAsync(CancellationToken ct);
}

public interface IManagedResourceAuthorizer
{
    ValueTask<ResourceCapability?> GetCapabilityAsync(ResourceClass resource, CancellationToken ct);
}
```

Only managed adapters may receive `IManagedResourceAuthorizer`. Do not put it in the common transport interface.

## FND-04: threat and privacy model

Document adversaries: ISP/DPI, blocked IP/DNS/SNI, malicious ingress, compromised node minority, storage theft, payment processor, malicious peer, device seizure and radio observer. Record protected data, residual metadata and recovery goals. Treat “unobservable existence” as an aspiration, not a guaranteed property.

## FND-05: test gates

- unit/golden-vector tests in `deep-protocol`;
- dependency test in `deep-client-shared`;
- in-memory free-plane E2E test with every official endpoint disabled;
- compatibility test around current RPC envelope.

Run repository-prescribed restore/build/test commands from each `AGENTS.md`. A sprint is not done with skipped tests or an undocumented breaking format change.

## Out of scope

Production storage replication, subscription issuance, LoRa radio code and reward contract changes.

