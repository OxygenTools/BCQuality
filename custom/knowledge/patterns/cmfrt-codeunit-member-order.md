---
bc-version: [all]
domain: patterns
keywords: [codeunit, member-order, procedure-order, local-procedure, integrationevent, businessevent, event-publisher, structure, readability]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT codeunit members follow a fixed order: globals, locals, event publishers

## Description

Every CMFRT codeunit declares its members in one fixed order, top to bottom:

1. Triggers (`OnRun`).
2. Global procedures: every procedure without an access modifier, plus `internal` procedures. These make up the codeunit's API.
3. `local` procedures, which include the `Do…` body of the OnBefore/Do/OnAfter triple and any event subscribers.
4. Event publishers: every `[IntegrationEvent]` and `[BusinessEvent]` procedure, at the end of the codeunit.

A reader opening the file sees the API first and the extension points last. That placement is what makes publishers easy to find by position, just as the `OnBefore<Name>`/`OnAfter<Name>` naming makes them easy to find by name. When a publisher is added in the middle of the codeunit, next to the procedure that raises it, that navigation no longer works. A codeunit edited that way many times ends up with its API, helpers and extension points interleaved.

The rule is about the order of member declarations. Where the event *calls* go inside a procedure body is covered by `events/cmfrt-onbefore-onafter-all-globals` and `events/cmfrt-onbefore-do-onafter`.

## Best Practice

Keep the four groups in the order above. Add a new global procedure after the last existing global, its `Do…` local after the last existing local, and its `OnBefore…`/`OnAfter…` publishers after the last existing publisher, so each group grows in place. Within a group, keep publishers in the order of the procedures that raise them, `OnBefore…` before `OnAfter…`.

See sample: [`cmfrt-codeunit-member-order.good.al`](cmfrt-codeunit-member-order.good.al).

## Anti Pattern

Declaring a publisher, or a `local` helper, directly under the global procedure that uses it, so publishers, locals and globals alternate through the file. Also adding a new global procedure after the existing event publishers at the end of the codeunit, which splits the API group in two.

See sample: [`cmfrt-codeunit-member-order.bad.al`](cmfrt-codeunit-member-order.bad.al).
