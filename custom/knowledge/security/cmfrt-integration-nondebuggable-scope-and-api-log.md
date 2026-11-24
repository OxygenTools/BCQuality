---
bc-version: [all]
domain: security
keywords: [integration, httpclient, nondebuggable, genericlog, api-log, external-call, credentials, response, telemetry, cmfrt]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT integration codeunits use NonDebuggable on sensitive procedures and log calls with GenericLOG

## Description

An integration codeunit sends calls to an external service with `HttpClient`. Two rules apply to it. The first rule is the scope of `[NonDebuggable]`. The second rule is where the app logs the calls.

Reviewers asked for both rules in pull requests. In PR 14938 (ZI_CMFRT_DocSign) a reviewer asked about the Dioss API procedures: "waarom staan deze niet als non-debuggable?" In the same PR he asked: "kunnen we hier de genapilog extensie gebruiken om de calls te loggen?" In PR 14970 (ZI_CMFRT_GeoDynamics) he asked: "ook hier functies non-debuggable zetten."

The decision of 24 November 2026 (issue 49) answers both questions. It applies to every new integration.

## Best Practice

**Scope of NonDebuggable.** Put `[NonDebuggable]` on each procedure that handles credentials, tokens or responses. This includes a procedure that reads setup credentials, builds a request with a token, or reads the response body. Do not put `[NonDebuggable]` on every procedure of the codeunit. A procedure that handles none of these stays debuggable. Then a developer can still investigate a failed integration.

**Logging.** Log each external call with the GenericLOG app (repo `CMFRT_GenericLOG`). Add the app as a dependency in `app.json`. Do not add new logging tables to the integration app. Do not rely on telemetry alone.

The GenericLOG repo is not part of this repository. This article does not show its API. Read the public procedures of `CMFRT_GenericLOG` before you write the log call. The sample shows only the NonDebuggable part.

See sample: [`cmfrt-integration-nondebuggable-scope-and-api-log.good.al`](cmfrt-integration-nondebuggable-scope-and-api-log.good.al).

## Anti Pattern

An integration procedure that builds a request with a token, reads a response or reads setup credentials, without `[NonDebuggable]`. Also wrong: an integration that writes its calls only to telemetry, or to a new log table in the integration app. Also wrong: `[NonDebuggable]` on every procedure of the codeunit, including procedures that handle no credential, token or response.

See sample: [`cmfrt-integration-nondebuggable-scope-and-api-log.bad.al`](cmfrt-integration-nondebuggable-scope-and-api-log.bad.al).

## Overrides

- `cmfrt-oauth2-token-via-central-tokenmeth` asks for `[NonDebuggable]` only on token procedures. This article is wider. It adds the procedures that handle credentials or responses. Both articles apply.
- `microsoft/security/nondebuggable-required-when-unwrapping-secrettext` asks for `[NonDebuggable]` only on a `SecretText.Unwrap` path. This article is wider for CMFRT integration codeunits. It overrides the Microsoft article there.
- The reviewer comment in PR 14970 asks for `[NonDebuggable]` on the functions of the whole codeunit. This article is narrower on purpose.

## See also

- `cmfrt-oauth2-token-via-central-tokenmeth.md` — how an integration gets its token.
