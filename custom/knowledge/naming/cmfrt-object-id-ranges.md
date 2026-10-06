---
bc-version: [all]
domain: naming
keywords: [object-id, id-range, numbering, product-extension, customer-extension, range, field-id, enum-value-id, field, value]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT object ID ranges

## Description

CMFRT object IDs are partitioned into two non-overlapping numeric ranges by deployment scope. Product extensions — features delivered to all customers under the CMFRT product — use IDs from `2045081` to `2046580`. Customer-specific extensions — functionality tailored to a single customer deployment — use IDs from `55000` to `55999`. The range applies to member IDs as well as object IDs: table fields and enum values declared by the extension take IDs from the same licensed range (for example `field(55011; ...)`, `value(55000; ...)`), even on tables the extension owns. Always pick the next free ID in the correct range. A removed object's ID must never be recycled; the platform retains historical references to deleted object IDs and recycling causes silent conflicts with upgrade and telemetry systems.

## Best Practice

Before adding any AL object, identify whether the feature is product-wide or customer-specific, look up the highest currently allocated ID in the correct range across the extension's source, and assign the next sequential ID. Record ID allocations in the pull request description so reviewers can confirm the range and sequence without scanning all object files. Member IDs follow the same rule. Number a table's fields and an enum's values from the range as well: a blank or "none" member of a new enum is `value(55000; "… None")` (or the first free product-range ID), and the field that uses the enum sets `InitValue` to it (see `patterns/cmfrt-initvalue-not-code-default`). When AL Object ID Ninja is unavailable, or returns IDs that are already used, member IDs still come from the range: take the next free ID after the highest `field(`/`value(` already declared in that object.

See sample: [`cmfrt-object-id-ranges.good.al`](cmfrt-object-id-ranges.good.al).

## Anti Pattern

Assigning an ID outside both ranges, choosing a round-number ID that has no relation to the next free slot, reusing an ID from a previously removed object, or numbering table fields or enum values outside the licensed range (for example `field(10; ...)` on a customer-range table). Two variants are common. One is a new enum that starts at `value(0; …)` because existing rows hold ordinal 0, or because 0 "is the blank value". The other is an out-of-range enum copied from older code in the same repo, where the released original stays in place but must not serve as a template. ID conflicts between extensions produce runtime application errors that are difficult to reproduce and trace, because the conflict may only manifest when both extensions are installed in the same environment.

See sample: [`cmfrt-object-id-ranges.bad.al`](cmfrt-object-id-ranges.bad.al).
