---
bc-version: [all]
domain: architecture
keywords: [codeunit, base-table, entry-point, coupling, architecture, cross-codeunit, subscriber]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT calls to implementation codeunits from base table only

## Description

In the CMFRT extension architecture, all calls to implementation codeunits must originate from the base-table object. No AL object other than the base table may call a CMFRT implementation codeunit directly. Event subscriber codeunits handle platform or application events and call the base table's entry-point procedures — not the implementation codeunit directly. Pages and reports call base-table procedures. This keeps the base table as the single integration point for all business-logic calls and ensures that `OnBefore`/`OnAfter` integration events fire consistently regardless of where a workflow begins.

## Best Practice

When a subscriber codeunit handles an event and needs to trigger a CMFRT operation, it calls the relevant base-table procedure. When a page action initiates business logic, it calls the base-table procedure. The implementation codeunit is an internal detail of the base table and should never appear in `using` clauses or variable declarations of pages, reports, or subscriber codeunits.

See sample: `cmfrt-calls-from-base-table-only.good.al`.

## Anti Pattern

Calling an implementation codeunit directly from a page, report, subscriber codeunit, or any object other than the base table. Direct calls bypass the base table's integration events, making the operation invisible to dependent extensions that subscribed to those events. This also creates hidden coupling between the caller and the implementation, which breaks when the implementation codeunit is renamed or replaced under the interface.

See sample: `cmfrt-calls-from-base-table-only.bad.al`.
