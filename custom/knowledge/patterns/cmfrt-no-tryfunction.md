---
bc-version: [all]
domain: patterns
keywords: [tryfunction, try-method, error-trap, codeunit-run, httpclient, json, evaluate, error-handling, getlasterrortext]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT code does not use [TryFunction]

## Description

CMFRT code does not declare `[TryFunction]` methods. The rule has no exception: not for a write, not for a read, and not for pure computation (decision of 12 October 2026).

A try method catches the error but does not roll back what the method wrote (`microsoft/knowledge/performance/use-tryfunction-for-error-catching-not-rollback.md`). A method that starts as a read gains a `Validate` and a `Modify` in a later change, and then a caught error leaves a half-written record. A try method also catches every error inside it, so a permission error or a programming error looks like the business failure the caller expected. The reviews rejected the attribute twice: around a SharePoint metadata call (PR 14468) and around `Validate` plus `Modify` on a service line (PR 14456).

## Best Practice

Choose the primitive by what can fail:

- **A step that writes** runs in its own codeunit, called as `if not Codeunit.Run(...) then`. That gives the step its own rollback boundary. Put a loop over records inside the worker and call `Run` once: a second `Codeunit.Run` after the first one wrote needs a `Commit()` first. `cmfrt-codeunit-run-not-tryfunction` owns the `Commit()` rule around that call.
- **An HTTP call** checks the return value of `HttpClient.Send` and then `HttpResponseMessage.IsSuccessStatusCode` before it reads the body (`microsoft/knowledge/web-services/handle-httpclient-platform-failure-before-response-access.md`).
- **JSON** reads through the methods that return a Boolean: `JsonObject.Get`, `JsonObject.SelectToken`, `JsonToken.IsValue`.
- **Text to a value** uses `if not Evaluate(Value, Text) then`. `Evaluate` returns a Boolean when the code uses its result.
- **Validation that must report every error** uses `ErrorBehavior::Collect` (`microsoft/knowledge/error-handling/collect-validation-errors-with-errorbehavior.md`).
- **A calculation that can fail** checks its inputs first. When that is not possible, it runs in a small codeunit through `Codeunit.Run`.

See sample: [`cmfrt-no-tryfunction.good.al`](cmfrt-no-tryfunction.good.al).

## Anti Pattern

Any `[TryFunction]` in a CMFRT object, in the production app or the test app. The two common forms are a try method around `Validate` and `Modify`, where a caught error keeps the partial write, and a try method around an HTTP or JSON call, where every failure becomes the same `false`.

See sample: [`cmfrt-no-tryfunction.bad.al`](cmfrt-no-tryfunction.bad.al).

## See also

This article takes precedence over `microsoft/knowledge/performance/use-tryfunction-for-error-catching-not-rollback.md`, which recommends `[TryFunction]` for interop and parsing. A review records that article in `suppressed` with `reason: "layer-precedence"`. `custom/knowledge/patterns/cmfrt-codeunit-run-not-tryfunction.md` covers the `Codeunit.Run` boundary in buffer sweeps.
