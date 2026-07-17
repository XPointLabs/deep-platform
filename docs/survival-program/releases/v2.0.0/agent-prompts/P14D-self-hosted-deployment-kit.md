# P14D — Self-hosted deployment and isolation kit

## Role/repository

Work only in `deep-devops` after P14C operator contracts are pinned. Do not implement product node runtime.

## Objective

Provide reproducible local/community deployment, update, backup/rotation and evidence for an independent network profile.

## In scope

- compose/profile consuming real XNode images and independent genesis;
- operator preflight, health/readiness, backups and recovery drill;
- profile-generator invocation without exposing roots;
- multi-admin ceremony documentation;
- compatibility/support window and signed update path;
- isolation test environment with all official Deep endpoints/billing blocked.

## Out of scope

Node runtime, client UI, production root custody and central operator dashboard with social metadata.

## Acceptance

Fresh authorized environment deploys, produces a verifiable profile and passes P15B isolated send/store/read; restart/backup/rotation drill is reproducible; strict evidence contains no private keys.

