---
bc-version: [all]
domain: breaking-changes
keywords: [overload, parameter, signature, procedure, breaking-change, backward-compatibility, arity]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT add parameter via overload

## Description

When a CMFRT extension procedure requires an additional parameter, the original procedure signature must not be changed. A second procedure with the same name and an extended parameter list is added alongside the original. AL resolves same-name procedures by parameter count at the call site, so both coexist without conflict. The original signature is retained indefinitely and is only marked obsolete after all known callers have migrated to the new overload.

## Best Practice

Keep the existing procedure unchanged and add a new procedure of the same name with the extra parameter appended. The original procedure may delegate to the new overload with a sensible default value for the added parameter, or it may keep its own implementation when the semantics differ. Both forms are valid. The `ObsoleteState = Pending` marker on the original should only be added once all callers have been confirmed to use the new overload.

See sample: `cmfrt-add-parameter-via-overload.good.al`.

## Anti Pattern

Adding a parameter to an existing procedure's parameter list in place, even when the intention is to add a trailing parameter that callers can ignore. AL does not support optional parameters or default values for procedure arguments. Any in-place signature change is a breaking change: every caller must be updated simultaneously and any dependent extension that was not recompiled fails at runtime.

See sample: `cmfrt-add-parameter-via-overload.bad.al`.
