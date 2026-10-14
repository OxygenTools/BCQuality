---
bc-version: [all]
domain: architecture
keywords: [codeunit, base-table, entry-point, coupling, architecture, cross-codeunit, subscriber, thin-shell, table-extension, table-procedure]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT calls to implementation codeunits from base table only

## Description

In the CMFRT extension architecture, only the base table calls a CMFRT implementation codeunit. No other AL object calls it directly. An event subscriber codeunit handles a platform or application event and calls an entry-point procedure of the base table. Pages and reports also call base-table procedures. The base table is then the one integration point for all business logic. Its `OnBefore` and `OnAfter` integration events fire each time, from every start point of a workflow.

## Best Practice

A subscriber codeunit that starts a CMFRT operation calls the base-table procedure for it. A page action that starts business logic also calls the base-table procedure. The implementation codeunit is an internal part of the base table. Do not declare it in a page, a report or a subscriber codeunit.

The base-table procedure is a thin shell. Its body holds one call into the implementation or `Meth` codeunit, with or without the `OnBefore` event and the handled exit around it. The same rule applies to a procedure in a table extension. Filters, `Mark` and `MarkedOnly`, a `case` on the result, `Page.Run` and the other steps of the logic go into the codeunit. There, the logic sits inside the `OnBefore`/`Do`/`OnAfter` bracket of `custom/knowledge/events/cmfrt-onbefore-do-onafter`. A procedure that only returns a value from the fields of the record, with no filter, loop or page, can stay in the table. In PR 14713 a table-extension procedure marked service orders, counted them and opened a page. The review asked to move all of it into a codeunit and keep only the call in the table extension.

See sample: [`cmfrt-calls-from-base-table-only.good.al`](cmfrt-calls-from-base-table-only.good.al).

## Anti Pattern

A page, a report, a subscriber codeunit or another object that calls an implementation codeunit directly. The direct call skips the integration events of the base table. A dependent extension that subscribes to those events does not see the operation. The call also couples the caller to the implementation. That link breaks when a change renames the implementation codeunit or replaces it behind the interface.

A table or table-extension procedure that holds the logic itself: it filters or marks records, branches on the result, or opens a page. The table then does the work of a codeunit, and the logic has no `OnBefore` or `OnAfter` event that a dependent extension can use.

See sample: [`cmfrt-calls-from-base-table-only.bad.al`](cmfrt-calls-from-base-table-only.bad.al).
