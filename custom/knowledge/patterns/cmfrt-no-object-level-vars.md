---
bc-version: [all]
domain: patterns
keywords: [global-var, object-level-var, local-scope, parameter-passing, singleinstance, dto, codeunit-run, page-binding, event-subscriber-instance]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT variables are declared local to the procedure that uses them

## Description

CMFRT AL objects do not carry object-level (global) `var` declarations for working state. Every variable is declared in the `var` section of the procedure that uses it, and a variable a second procedure needs is passed as a parameter (`var` when the callee writes back), never shared through object scope. Object-scope declarations outlive their callers as dead state, are silently shared between unrelated procedures, and hide the real data flow between them.

Reuse frequency is not an exemption. A helper codeunit instance or label used by ten procedures is declared ten times — the duplication is the intended outcome, not a smell. Neither is house convention: `microsoft/` samples and most published BC test code hoist helper instances to object scope, and this article supersedes them under layer precedence (`custom > microsoft`). The only exemptions are the structural ones listed below, where the platform or the object's declared job requires object scope.

This generalizes `patterns/cmfrt-labels-local-scope`, which states the same rule for `Label` and additionally requires the `Comment` placeholder attribute. Cite the labels article for a global `Label`; cite this one for every other type.

## Best Practice

Declare each variable in the `var` block of the procedure that references it. To hand state to another procedure in the same object, add a parameter — `var` if the callee must write back. Keep the repo's declaration order inside each block (Record, then Report/Codeunit/XmlPort/Page/Query, then other complex and simple types, then `Label` last); CodeCop enforces it.

Before localizing a `Codeunit` variable, confirm the callee is stateless or `SingleInstance`. Two procedures each declaring `X: Codeunit Foo` get **separate instances**: if callers were relying on shared object-level state inside `Foo`, localizing breaks it silently. That is the caller-side face of exception 2 — keep the declaration at object scope and say why.

See sample: `cmfrt-no-object-level-vars.good.al`.

### Legitimate exceptions

Object scope is correct — and localizing is a defect — in exactly these cases. Each is structural: the platform or the object's declared purpose requires it.

1. **`SingleInstance = true` codeunits.** The object-level state *is* the feature: caches, rate limiters, session-scoped buffers and `Dictionary` members.
2. **DTO / context codeunits passed `var` between objects.** Their fields are the payload the getters and setters exist to expose. These *are* the parameter-passing mechanism this rule asks for, so they satisfy its intent rather than violating it.
3. **`Codeunit.Run` isolation boundaries.** Object-level state is the only way in and out of `OnRun`. A `[TryFunction]` is not a substitute — it does not roll back the database write. See `patterns/cmfrt-codeunit-run-not-tryfunction`.
4. **Variables bound to a property or a control source expression** on a Page, Report request page, or XmlPort — `StyleExpr = EnabledStyleTxt`, `Visible = ShowDetails`, `field(SchemaJsonControl; SchemaJson)`. AL resolves these against object scope only.
5. **Test-handler communication.** `[ConfirmHandler]`, `[MessageHandler]`, `[ModalPageHandler]` and the other handler attributes have platform-fixed signatures that admit no extra parameters, so object scope is the only channel between a `[Test]` method and its handler. `Library - Variable Storage` is not `SingleInstance`, so it must stay object-level for the enqueue to reach the handler. This covers the storage variable the handlers actually read — not every helper the test codeunit happens to reuse: `Assert`, test-library and setup codeunits are localized per test method like any other working variable.
6. **`EventSubscriberInstance = Manual` subscribers accumulating across firings.** Counters and `Handled` flags that handlers increment and tests read back through getters. Localizing makes them permanently zero.

Heuristic: **localize it if the object is a stateless service** — a helper instance, a label, a working variable. **Keep object scope only when the object's declared job is to hold or isolate state**: `SingleInstance`, a DTO, a `Run` boundary, a page/report/xmlport binding, a test handler channel, or a manual subscriber instance.

### Before applying the rule wholesale

Moving a translatable label from object to procedure scope changes its trans-unit ID, and a label shared by N procedures becomes N trans-units. A generated `Translations/*.g.xlf` regenerates cleanly (verify by diffing the sorted `<source>` sets — no source string should be lost), but a repo carrying **hand-maintained** translation files will orphan those entries. Check which kind the repo has first.

## Anti Pattern

Stateless helper codeunit instances, labels and working variables hoisted to the object's `var` section so several procedures can reach them, in an object that is not `SingleInstance`, not a DTO, not a `Run` boundary, not a page/report/xmlport binding, and not a manual subscriber instance.

See sample: `cmfrt-no-object-level-vars.bad.al`.
