---
bc-version: [all]
domain: events
keywords: [ishandled, initialization, deterministic, onbefore, reset, integration-event, control-flow]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Reset IsHandled before publishing only when its value can carry over

## Description

A routine that raises an `OnBefore…` integration event with a `var IsHandled: Boolean` parameter passes that variable by reference, so a pre-existing `true` can affect the following control flow. AL [automatically initializes Boolean variables to `false`](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-variables#initialization), so a freshly declared local Boolean passed to one event is already deterministic. The same is true when control flow proves the variable is `false`; for example, reaching a second raise after `if IsHandled then exit;` proves that the first raise did not leave it `true`.

## Best Practice

Reset `IsHandled := false;` before a raise only when the value might otherwise carry over as `true`: the same variable is reused after an earlier raise without a control-flow proof that it is false, the value comes from an input parameter, field, or global, or earlier code seeds it. A reset on a guaranteed-false fresh local can be retained for readability, but its absence is not a correctness finding.

See sample: `initialize-ishandled-to-false-before-publishing.good.al`.

## Anti Pattern

Raising `OnBeforeX(…, IsHandled)` when the variable can still be `true` from an earlier raise or another source, so the new publisher call starts with stale state. Do not match a single raise using a fresh local Boolean, or a later raise reached only after `if IsHandled then exit;`.

See sample: `initialize-ishandled-to-false-before-publishing.bad.al`.
