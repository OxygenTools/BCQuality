---
bc-version: [all]
domain: naming
keywords: [naming, prefix, mandatory-prefix, handler-functions, confirmhandler, test-codeunit, attributes, al0112, al0499, platform-attribute]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT prefix applies to handler procedure names, never to handler attributes

## Description

A UI handler in a test codeunit has two independent names: the attribute above it, which is a fixed AL platform token, and the procedure name, which the developer chooses. The CMFRT prefix rule governs the second only. `appsourcecop.json` `mandatoryPrefix` scopes to object names, field names and public members — it says nothing about attributes, and no attribute is ever prefixed, renamed or abbreviated: not a handler attribute, not `[Test]`, `[HandlerFunctions]`, `[TransactionModel]`, `[Scope]` or `[TryFunction]`.

The handler attributes are a closed set of thirteen: `ConfirmHandler`, `MessageHandler`, `StrMenuHandler`, `PageHandler`, `ModalPageHandler`, `ReportHandler`, `RequestPageHandler`, `FilterPageHandler`, `SendNotificationHandler`, `RecallNotificationHandler`, `SessionSettingsHandler`, `HyperlinkHandler` and `HttpClientHandler`. Anything else in that position is not an attribute the compiler knows.

Prefixing the attribute costs one token and three errors. In `CMFRT_AdresMgmnt_Test` (ALOps build 76465) `[CMFRTAMConfirmHandler]` produced `AL0112: CMFRTAMConfirmHandler is not a valid attribute` on the declaration, and because the procedure then never registered as a handler, `AL0499: The handler function CMFRTAMConfirmHandler was not found` at every `[HandlerFunctions('CMFRTAMConfirmHandler')]` referencing it — two call sites, both reported as if the test methods were at fault.

## Best Practice

Write the platform attribute verbatim and put the prefix on the procedure name: `[ConfirmHandler]` above `procedure CMFRTAMConfirmGapWarning(Question: Text; var Reply: Boolean)`, referenced as `[HandlerFunctions('CMFRTAMConfirmGapWarning')]`. The prefix rule in `cmfrt-naming-prefix` is satisfied by the procedure name alone; the attribute is outside its scope.

Match the platform signature for the handler kind and declare the handler global — every documented handler signature requires it, so a `local procedure` is not a handler however it is attributed. `ConfirmHandler` takes `(Question: Text[1024]; var Reply: Boolean)`, and from runtime version 2.1 `Question: Text` is equally valid; `MessageHandler` takes `(Message: Text[1024])` or, from 2.1, `(Message: Text)`; `StrMenuHandler` takes `(Options: Text[1024]; var Choice: Integer; Instruction: Text[1024])`; `PageHandler` and `ModalPageHandler` take `(var Page: TestPage <id>)`, with `ModalPageHandler` also accepting `(var Page: Page <id>; var Response: Action)`; `ReportHandler` takes `(var Report: Report <id>)`; `RequestPageHandler` takes `(var RequestPage: TestRequestPage <id>)`; `SendNotificationHandler` and `RecallNotificationHandler` take `(TheNotification: Notification): Boolean`; `SessionSettingsHandler` takes `(var SessionSettings: SessionSettings): Boolean`; `FilterPageHandler` takes `(var Record: RecordRef): Boolean`; `HyperlinkHandler` takes `(Hyperlink: Text[1024])`. Verify the kind in use against https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-creating-handler-methods rather than copying a signature from memory.

AL0112 suppresses the remaining diagnostics on the declaration it lands on, so treat the attribute fix as step one, not the whole fix: rebuild and re-check the signature, the global scope, and that the handler is declared in the same test codeunit as the test method that lists it. Two cheap checks catch the whole class before a push — grep the test app for bracketed attributes whose name is not one of the thirteen above and not a non-handler platform attribute, and confirm every `HandlerFunctions('X')` resolves to a global `procedure X` carrying one of those attributes.

See sample: `cmfrt-handler-attributes-never-prefixed.good.al`.

## Anti Pattern

Applying the CMFRT prefix to the attribute — `[CMFRTAMConfirmHandler]`, `[CMFRTGDMessageHandler]`, `[CMFRTAMTest]` — on the reasoning that everything in a CMFRT extension carries the prefix. The compiler rejects the attribute outright, and the failure presents as a handler-resolution problem at the call sites rather than as a naming mistake at the declaration, so the reported line numbers point away from the actual defect.

The mirror-image error is dropping the prefix from the procedure name because the attribute must stay unprefixed — `[ConfirmHandler] procedure ConfirmHandler(...)` compiles, but an unprefixed member in a CMFRT extension violates `cmfrt-naming-prefix`. Also wrong: renaming the procedure without updating the `HandlerFunctions` string, and abbreviating an attribute to fit a name-length budget.

See sample: `cmfrt-handler-attributes-never-prefixed.bad.al`.
