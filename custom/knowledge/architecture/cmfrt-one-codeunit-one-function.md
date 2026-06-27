---
bc-version: [all]
domain: architecture
keywords: [codeunit, single-responsibility, entry-point, interface, architecture, coupling]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT one codeunit one global function

## Description

In the CMFRT extension architecture, each implementation codeunit exposes exactly one global procedure. That procedure is the codeunit's entry point and corresponds directly to the single interface the codeunit implements. Helper logic is placed in local procedures within the same codeunit and is never exposed as additional global procedures. This rule enforces single responsibility at the AL codeunit boundary: one codeunit, one concern, one interface, one entry point.

## Best Practice

Create one implementation codeunit per functional concern. If a codeunit accumulates a second global procedure that has a distinct concern, extract that procedure into its own codeunit with its own interface. Keep local procedures `local` so callers outside the codeunit cannot bypass the interface contract.

See sample: `cmfrt-one-codeunit-one-function.good.al`.

## Anti Pattern

Placing multiple global procedures in a single implementation codeunit. A multi-entry-point codeunit mixes concerns, prevents the interface injection pattern from being applied independently to each concern, and grows into a difficult-to-test utility class. Callers that skip the base-table entry point and call implementation procedures directly bypass integration events and violate the architecture.

See sample: `cmfrt-one-codeunit-one-function.bad.al`.
