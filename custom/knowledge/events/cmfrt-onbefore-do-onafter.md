---
bc-version: [all]
domain: events
keywords: [on-before, on-after, do-procedure, thin-shell, meth, is-handled, extraction, entry-point, reset]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT OnBefore → Do → OnAfter procedure shape

## Description

Global procedures in CMFRT Meth codeunits are thin shells: the body consists of firing `OnBefore<Name>` with `var IsHandled: Boolean`, calling a local `Do<Name>` procedure that holds all business logic and the `if IsHandled then exit;` guard, and firing `OnAfter<Name>`. Local variables that only serve the business logic (record buffers, labels, working values) live in the `Do` procedure, not in the shell. This keeps the event bracket structurally impossible to bypass — the `OnAfter` event cannot be skipped by an early `exit` inside business logic, because business logic and handled exits live one level down.

## Best Practice

Write every global Meth procedure as: declare `IsHandled` as a fresh local in the shell, fire `OnBefore`, call `Do<Name>(..., IsHandled)`, fire `OnAfter`. Do not write `IsHandled := false;` before the `OnBefore` call: AL initialises a local Boolean to `false`, so the shell's single raise already starts from a known state. A reset is needed only when the value can carry over (the variable is reused after an earlier raise, the raise sits in a loop, or the value comes from a parameter, field or global); see `microsoft/knowledge/events/reset-ishandled-only-when-the-value-can-carry-over`. In `Do<Name>`, place `if IsHandled then exit;` as the first executable statement, then execute business logic. When review finds a global procedure whose body mixes event calls with business logic, extract the logic into `Do<Name>` and move its private variables and labels along with it.

See sample: [`cmfrt-onbefore-do-onafter.good.al`](cmfrt-onbefore-do-onafter.good.al).

## Anti Pattern

A global procedure that keeps `if IsHandled then exit;` and business logic inline between the `OnBefore` and `OnAfter` calls. Inline bodies grow early `exit` paths that silently skip the `OnAfter` event, and their local variables and labels accumulate at the shell level where every branch can touch them. Equally wrong: declaring the event pair but never calling the events from the procedure (dead events), which advertises an extension point that never fires. Also wrong: `IsHandled := false;` on a fresh local right before the shell's one non-looping `OnBefore` call. The line changes nothing, and reviewers reject it as noise. Upstream samples that show this reset are not the house style.

See sample: [`cmfrt-onbefore-do-onafter.bad.al`](cmfrt-onbefore-do-onafter.bad.al).
