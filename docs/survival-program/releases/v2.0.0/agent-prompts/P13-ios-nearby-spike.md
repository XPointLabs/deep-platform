# P13 — iOS foreground nearby feasibility spike

## Role

You are the iOS/MAUI specialist. Work only in `C:\Work\DeepSession\XPointLabs\deep-client-maui` in a wave that does not overlap P12 hot files.

## Objective

Determine and implement the smallest honest foreground nearby flow on iOS. Produce evidence before any parity claim.

## Read first

`AGENTS.md`, P03/P11 contracts, current iOS lifecycle/CI, [Apple CoreBluetooth background rules](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html) and Multipeer documentation.

## In scope

- foreground advertise/discover/connect/send prototype;
- permission and state UX contracts;
- locked/background experiments with exact observed behavior and no SLA assumption;
- build/test lane proposal that makes iOS RC evidence mandatory;
- energy measurement on at least two supported iPhone generations;
- residual risk and product-claim matrix.

## Out of scope

Claims of continuous background mesh, private APIs, App Store bypass, Android, LoRa and protocol changes.

## Acceptance

Foreground small-bundle exchange is reproducible or the spike recommends a documented no-go; background limitations are evidenced; unsupported behavior is hidden/labelled; no permanent background execution is simulated in tests.

## Verification

Run applicable MAUI tests/builds and real-device evidence. If local iOS build/device is unavailable, stop with a precise external dependency—do not mark complete from Windows compilation alone.

