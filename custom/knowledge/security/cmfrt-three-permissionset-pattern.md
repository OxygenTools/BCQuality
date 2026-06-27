---
bc-version: [all]
domain: security
keywords: [permissionset, permission-set, objects, read, edit, assignable, included-permission-sets, authorization]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT three-permission-set pattern

## Description

Every CMFRT functional module must ship exactly three permission set objects: an Objects set, a Read set, and an Edit set. The Objects set lists every AL object the module owns — tables, pages, codeunits, reports, interfaces — with `X` (execute) access. The Read set includes the Objects set via `IncludedPermissionSets` and grants `tabledata = R` on each table. The Edit set includes the Read set and grants `tabledata = IMD` on each writable table. All three sets have `Assignable = true`. Names follow the pattern `"CMFRT <ABBR> Objects"`, `"CMFRT <ABBR> Read"`, and `"CMFRT <ABBR> Edit"`.

## Best Practice

Define the sets in the strict composition chain Objects ← Read ← Edit so that object access is declared once and inherited. When a new table is added to the module, update the Objects set and the tabledata entries in Read and Edit — there is no risk of the object access drifting between roles because the chain is the single source of truth for it.

See sample: `cmfrt-three-permissionset-pattern.good.al`.

## Anti Pattern

Shipping fewer than three permission sets, omitting `IncludedPermissionSets` and enumerating the same object list in each set by hand, or granting `RIMD` access in a flat set that cannot be composed. Flat role sets that enumerate objects independently drift apart when tables are added or removed, and the resulting authorization gap is invisible until a user reports an access error in production.

See sample: `cmfrt-three-permissionset-pattern.bad.al`.
