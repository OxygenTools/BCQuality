---
bc-version: [all]
domain: events
keywords: [integration-event, on-before, on-after, extensibility, event-publisher, global-procedure, handled]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT OnBefore and OnAfter for every global procedure

## Description

Every global procedure in a CMFRT extension must be bracketed by a paired `OnBefore<ProcedureName>` and `OnAfter<ProcedureName>` integration event declared in the same object. Both events are `[IntegrationEvent(false, false)]` local procedures. The `OnBefore` event passes the procedure's key input variables and a `var Handled: Boolean` parameter. The entry procedure checks `Handled` on return from `OnBefore` and exits without executing its body if a subscriber has already handled the operation. The `OnAfter` event passes the key output variables so subscribers can react to the completed result.

## Best Practice

Declare both events at the time the global procedure is written, not as a later addition. Place the `OnBefore` call at the top of the procedure body before any logic, and the `OnAfter` call at the bottom after the last statement. Follow the naming convention `OnBefore<ProcedureName>` and `OnAfter<ProcedureName>` exactly so event consumers can locate publishers by convention.

See sample: `cmfrt-onbefore-onafter-all-globals.good.al`.

## Anti Pattern

Publishing a global procedure without both `OnBefore` and `OnAfter` integration events, or adding events only after a downstream extension explicitly requests an extension point. A global procedure with no event bracket is a black box: dependent extensions cannot inject logic around it without an AL override, which is a breaking pattern. Adding events later is itself a non-breaking change but causes unnecessary churn and review cycles.

See sample: `cmfrt-onbefore-onafter-all-globals.bad.al`.
