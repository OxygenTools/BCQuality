---
bc-version: [all]
domain: patterns
keywords: [setloadfields, partial-record, get, findfirst, findset, modify, rename, delete, transferfields, review-all-reads]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT check SetLoadFields on every read

## Description

A reviewer checks every new `Get`, `FindFirst` and `FindSet` for `SetLoadFields`. The check does not stop at the obvious read-only lookups. In PR 14970 (ZI_CMFRT_GeoDynamics) the reviewer wrote: "setloadfields gelieve overal nog eens te controleren". The developer added `SetLoadFields` on the read-only lookups. The developer left it out where the code modifies, renames or deletes the record.

This article adds a review step. It does not override a Microsoft article. The two Microsoft articles keep their rules and their exceptions:

- `microsoft/knowledge/performance/use-setloadfields-for-partial-records` says when a read needs `SetLoadFields`.
- `microsoft/knowledge/performance/skip-setloadfields-on-write-and-transferfields` says when a read must not have it.

## Best Practice

Treat each new `Get`, `FindFirst` and `FindSet` as one decision. Read the whole path of the record variable, including the helpers that receive it. Then choose one of these results:

- The code reads only a few fields. Call `SetLoadFields` with those fields before the read.
- The code calls `Insert`, `Delete`, `Rename` or `TransferFields` on the record, or copies it into a temporary record. Do not call `SetLoadFields`.
- The code calls `Modify` and changes only loaded fields. `SetLoadFields` is allowed. The Microsoft article states that `Modify` is not on the list of full-load operations. A `Modify` is not a reason to skip `SetLoadFields` alone.
- A Microsoft exception applies, for example a small table or a setup table. Leave the read as it is.

Do not report statement order. Do not report a read that a Microsoft exception covers.

See sample: [`cmfrt-setloadfields-on-every-read.good.al`](cmfrt-setloadfields-on-every-read.good.al).

## Anti Pattern

Two defects are common:

- A read that only looks at a few fields has no `SetLoadFields`. The developer fixed the lookups named in the review and did not check the other reads.
- A read that feeds `Delete`, `Rename` or `TransferFields` has `SetLoadFields`. The platform loads the missing fields for each row. That costs more than one full read.

See sample: [`cmfrt-setloadfields-on-every-read.bad.al`](cmfrt-setloadfields-on-every-read.bad.al).
