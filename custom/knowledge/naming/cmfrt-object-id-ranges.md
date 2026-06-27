---
bc-version: [all]
domain: naming
keywords: [object-id, id-range, numbering, product-extension, customer-extension, range]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT object ID ranges

## Description

CMFRT object IDs are partitioned into two non-overlapping numeric ranges by deployment scope. Product extensions — features delivered to all customers under the CMFRT product — use IDs from `2045081` to `2046580`. Customer-specific extensions — functionality tailored to a single customer deployment — use IDs from `55000` to `55999`. Always pick the next free ID in the correct range. A removed object's ID must never be recycled; the platform retains historical references to deleted object IDs and recycling causes silent conflicts with upgrade and telemetry systems.

## Best Practice

Before adding any AL object, identify whether the feature is product-wide or customer-specific, look up the highest currently allocated ID in the correct range across the extension's source, and assign the next sequential ID. Record ID allocations in the pull request description so reviewers can confirm the range and sequence without scanning all object files.

See sample: `cmfrt-object-id-ranges.good.al`.

## Anti Pattern

Assigning an ID outside both ranges, choosing a round-number ID that has no relation to the next free slot, or reusing an ID from a previously removed object. ID conflicts between extensions produce runtime application errors that are difficult to reproduce and trace, because the conflict may only manifest when both extensions are installed in the same environment.

See sample: `cmfrt-object-id-ranges.bad.al`.
