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

One exception exists: the subscriber pair. In some customer repos, `"CMFRT <ABBR> CduSubscribers"` holds thin `[EventSubscriber]` shells, and each shell calls `"CMFRT <ABBR> CduSubscribersImpl"` directly. Each global procedure of the Impl codeunit runs `OnBefore<Name>`, then `Do<Name>(..., IsHandled)`, then `OnAfter<Name>`. A dependent extension thus still gets an event before and after the step. The domain logic sits in a dedicated `... Mgt.` or `... Check` codeunit. In ZC_CMFRT_GDW, codeunit 55003 "CMFRT GDW CduSubscribers" calls codeunit 55000 "CMFRT GDW CduSubscribersImpl".

In October 2026, 8 DevGIT.AL repos have a `CduSubscribersImpl` codeunit: ZC_CMFRT_Deloof, ZC_CMFRT_EnergyKing, ZC_CMFRT_GDW, ZC_CMFRT_Potrell, ZC_CMFRT_Woodstoxx, ZC_CMFRT_Zzed, CMFRT_Lite_Adv and CMFRT_MSDetail. All of them except CMFRT_MSDetail also have the `CduSubscribers` codeunit. The pair codeunits hold 102 subscribers: 40 on Microsoft objects and 62 on CMFRT objects. ZC_CMFRT_Potrell and CMFRT_Lite_Adv use the pair only for CMFRT events.

## Best Practice

A subscriber codeunit that starts a CMFRT operation calls the base-table procedure for it. A page action that starts business logic also calls the base-table procedure. The implementation codeunit is an internal part of the base table. Do not declare it in a page, a report or a subscriber codeunit.

The base-table procedure is a thin shell. Its body holds one call into the implementation or `Meth` codeunit, with or without the `OnBefore` event and the handled exit around it. The same rule applies to a procedure in a table extension. Filters, `Mark` and `MarkedOnly`, a `case` on the result, `Page.Run` and the other steps of the logic go into the codeunit. There, the logic sits inside the `OnBefore`/`Do`/`OnAfter` bracket of `custom/knowledge/events/cmfrt-onbefore-do-onafter`. A procedure that only returns a value from the fields of the record, with no filter, loop or page, can stay in the table. In PR 14713 a table-extension procedure marked service orders, counted them and opened a page. The review asked to move all of it into a codeunit and keep only the call in the table extension.

A repo that already has a `CduSubscribersImpl` codeunit keeps the subscriber pair. Put every new subscriber of that repo into the pair, on a Microsoft event or on a CMFRT event. The shell calls the Impl codeunit, and the Impl procedure follows the `OnBefore`/`Do`/`OnAfter` shape. Do not convert the pair to the base-table form inside a feature ticket. Do not add a third form. A new repo, or a repo without `CduSubscribersImpl`, uses the base-table entry point. A reviewer reports no finding for a subscriber that follows the pair in a repo that has it.

See sample: [`cmfrt-calls-from-base-table-only.good.al`](cmfrt-calls-from-base-table-only.good.al).

## Anti Pattern

A page, a report, a subscriber codeunit or another object that calls an implementation codeunit directly. The direct call skips the integration events of the base table. A dependent extension that subscribes to those events does not see the operation. The call also couples the caller to the implementation. That link breaks when a change renames the implementation codeunit or replaces it behind the interface.

In a repo with the subscriber pair, a new subscriber outside the pair is also wrong, for example a separate subscriber codeunit that calls a `Mgt.` codeunit directly. The repo then has a third form. A new repo that starts the pair has the finding of the first paragraph, because its subscriber calls an implementation codeunit directly.

A table or table-extension procedure that holds the logic itself: it filters or marks records, branches on the result, or opens a page. The table then does the work of a codeunit, and the logic has no `OnBefore` or `OnAfter` event that a dependent extension can use.

See sample: [`cmfrt-calls-from-base-table-only.bad.al`](cmfrt-calls-from-base-table-only.bad.al).
