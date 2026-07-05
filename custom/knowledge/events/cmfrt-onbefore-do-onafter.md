---
bc-version: [all]
domain: events
keywords: [on-before, on-after, do-procedure, thin-shell, meth, is-handled, extraction, entry-point]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT OnBefore → Do → OnAfter procedure shape

## Description

Global procedures in CMFRT Meth codeunits are thin shells: the body consists of firing `OnBefore<Name>` with `var IsHandled: Boolean`, exiting if handled, calling a local `Do<Name>` procedure that holds all business logic, and firing `OnAfter<Name>`. Local variables that only serve the business logic (record buffers, labels, working values) live in the `Do` procedure, not in the shell. This keeps the event bracket structurally impossible to bypass — the `OnAfter` event cannot be skipped by an early `exit` inside business logic, because business logic lives one level down.

## Best Practice

Write every global Meth procedure as: reset `IsHandled`, fire `OnBefore`, `if IsHandled then exit;`, call `Do<Name>(...)`, fire `OnAfter`. When review finds a global procedure whose body mixes event calls with business logic, extract the logic into `Do<Name>` and move its private variables and labels along with it.

See sample: `cmfrt-onbefore-do-onafter.good.al`.

## Anti Pattern

A global procedure whose business logic sits inline between the `OnBefore` and `OnAfter` calls. Inline bodies grow early `exit` paths that silently skip the `OnAfter` event, and their local variables and labels accumulate at the shell level where every branch can touch them. Equally wrong: declaring the event pair but never calling the events from the procedure (dead events), which advertises an extension point that never fires.

See sample: `cmfrt-onbefore-do-onafter.bad.al`.
