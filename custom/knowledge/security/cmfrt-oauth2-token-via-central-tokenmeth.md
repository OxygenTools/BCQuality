---
bc-version: [all]
domain: security
keywords: [oauth2, access-token, bearer, httpclient, token-endpoint, client-credentials, enum, nondebuggable, cmfrt]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT extensions request access tokens through CMFRT SY OAuth2 Token Meth

## Description

A CMFRT extension never builds its own OAuth2 token request. It calls `CMFRTSYGetAccessToken` on codeunit `"CMFRT SY OAuth2 Token Meth"` (CMFRT System app), passing the enum value of `enum "CMFRT SY OAuth2 Action"` that identifies its own extension and purpose. The codeunit resolves the matching configuration, retrieves the client secret from the Astena Key Vault, posts to the Azure AD v2.0 token endpoint and returns the access token, ready to be sent as a bearer token.

The enum value is what binds a configuration to an extension. `CMFRTSYGetAccessToken` reads the calling module with `NavApp.GetCallerModuleInfo` and compares it with the extension ID recorded when the configuration was registered; a caller that is not that extension gets an error. A token can therefore never be obtained from another extension's configuration, which is exactly why every extension and purpose needs its own enum value instead of sharing one.

Two mechanics differ from what the functional manual suggests and are worth knowing before writing code: `enum 2046088 "CMFRT SY OAuth2 Action"` is declared `Extensible = false`, so a new value is added to that enum in the CMFRT System app — an `enumextension` in the consuming app does not compile. And the procedure signature is `CMFRTSYGetAccessToken(ConfigCode: Enum "CMFRT SY OAuth2 Action"; var AccessToken: Text): Boolean` — the token comes back in the `var` parameter and the return value reports success, so the call must be tested rather than assigned.

## Best Practice

Add one enum value per extension and purpose with a descriptive caption, then call `CMFRTSYGetAccessToken` with it and handle a `false` return as a failure path. Keep the procedures that carry the token marked `[NonDebuggable]`, in line with the central codeunit, so the value cannot be read out of a debugger session. Send the token as `Authorization: Bearer <token>` and let it go out of scope afterwards: an access token is short-lived and must never be written to a table. If the same token is needed repeatedly within one session, cache it in a single-instance codeunit in memory.

See sample: `cmfrt-oauth2-token-via-central-tokenmeth.good.al`.

## Anti Pattern

A hand-rolled token request: composing an `x-www-form-urlencoded` body with `client_id` and `client_secret` read from a setup table, posting it to `login.microsoftonline.com/<tenant>/oauth2/token` with an `HttpClient`, and parsing `access_token` out of the response. Besides duplicating logic that is centrally maintained and tested, it reintroduces the stored secret, it usually targets the v1 endpoint with a `resource` parameter instead of v2.0 with a `scope`, it bypasses the extension-ownership check, and it is not `[NonDebuggable]`, so both secret and token are visible while debugging.

See sample: `cmfrt-oauth2-token-via-central-tokenmeth.bad.al`.

## See also

- `cmfrt-oauth2-no-local-credential-fields.md` — why the secret is not in the setup table to begin with.
