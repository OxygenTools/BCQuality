---
bc-version: [all]
domain: events
keywords: [eventsubscriber, internalevent, manual-binding, bindsubscription, own-app, process-context, parameter, flag, indirection]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT no event subscriber on an event of the own app

## Description

An app that raises an event and subscribes to that same event itself builds a detour. The code calls a procedure, the procedure raises the event, and a subscriber in the same app runs. A direct call or a parameter does the same job, and a reader can follow it. The pattern appears when the app passes process context to its own code through a manually bound flag: a codeunit with `Access = Internal` and `EventSubscriberInstance = Manual` that subscribes to an `[InternalEvent]` of the same app and sets a Boolean. In PR 14773 (ZC_CMFRT_GDW) the codeunit "CMFRT GDW Batt. Line Sync Flag" had this shape. The reviewer wrote: "waarom een eventsubscriber op een functie in GDW ext zelf, beetje heel raar niet?" The developer removed it. The Microsoft article `microsoft/knowledge/events/expose-process-context-via-manually-bound-flag` recommends the shape, so an agent that follows it writes the detour again.

This article overrides `microsoft/knowledge/events/expose-process-context-via-manually-bound-flag` for context that only the own app reads. The Microsoft article stays valid for context that another app must read.

## Best Practice

Inside one app, pass the context as a parameter of the procedure that needs it. The caller knows the context, so the caller hands it over. Add a `Boolean` parameter, or an enum when the context has more than two values. Do not add an event, a subscriber or a binding for it.

Keep the manually bound flag only when another app must read the context. In that case, publish the query as the Microsoft article describes: a public procedure that raises an `[InternalEvent]` and an `Access = Internal` subscriber that sets the flag. The other app calls the public procedure. It never subscribes to the event of your app.

To decide, ask one question: which app reads the answer? If only the own app reads it, use a parameter. If a dependent app reads it, use the bound flag.

A subscriber on an event of the own app is also valid when the event is the extension point itself. An example is an `[IntegrationEvent]` that a dependent app or a test app is meant to subscribe to. The article does not apply to that case.

See sample: [`cmfrt-no-subscriber-on-own-event.good.al`](cmfrt-no-subscriber-on-own-event.good.al).

## Anti Pattern

An `[EventSubscriber]` whose publisher is declared in the same app, where the subscriber exists to carry context between two pieces of code of that app. Typical shape: a manual-instance codeunit that sets a Boolean, a `BindSubscription` call before the shared code, and an `[InternalEvent]` publisher that no other app can see. The flag has no reader outside the app, so the event, the subscriber and the binding add three objects and no value. A reader must search for the subscriber to learn why the code behaves differently.

See sample: [`cmfrt-no-subscriber-on-own-event.bad.al`](cmfrt-no-subscriber-on-own-event.bad.al).
