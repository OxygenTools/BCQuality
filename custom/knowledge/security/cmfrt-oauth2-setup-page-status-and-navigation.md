---
bc-version: [all]
domain: security
keywords: [oauth2, setup-page, configexists, status, navigation, action, onopenpage, onaftergetrecord, cmfrt]
technologies: [al]
countries: [w1]
application-area: [all]
---

# A CMFRT setup page shows whether its OAuth2 configuration exists and links to it

## Description

Once an extension's Azure credentials move to the central OAuth2 configuration, its own setup page no longer shows anything about the connection — and a user cannot tell whether the extension is ready to authenticate or whether an administrator still has to register it. The convention is that the setup page carries a read-only indicator computed from `CMFRTSYConfigExists` on codeunit `"CMFRT SY OAuth2 Token Meth"`, plus an action that navigates straight to the *Oauth2 Configuraties* page filtered on this extension's own action, so the user never has to search the list.

The indicator is a page-level variable, not a table field: the answer lives in the central configuration and would go stale the moment it were persisted. It is computed in `OnOpenPage` or `OnAfterGetRecord`, so it refreshes whenever the page is opened or the record changes.

## Best Practice

Declare a Boolean page variable, compute it with `CMFRTSYConfigExists(Enum::"CMFRT SY OAuth2 Action"::<own value>)` in `OnOpenPage` or `OnAfterGetRecord`, and bind it to a non-editable field with a caption stating whether OAuth2 is configured. Add an action that runs the central OAuth2 configuration page with a filter on the extension's own enum value, so a user who sees "not configured" can act on it immediately. Both the field and the action are read paths into the central configuration; the setup page never writes to it.

See sample: `cmfrt-oauth2-setup-page-status-and-navigation.good.al`.

## Anti Pattern

A setup page that says nothing about the OAuth2 configuration after the credential fields were removed, so the only way to find out whether authentication works is to trigger the feature and read the error. Equally wrong is persisting the answer in a table field — a `Boolean` "OAuth2 configured" column, updated once at registration time — which then keeps reporting *configured* after the configuration is deleted or its test starts failing.

See sample: `cmfrt-oauth2-setup-page-status-and-navigation.bad.al`.

## See also

- `cmfrt-oauth2-no-local-credential-fields.md` — the fields this indicator replaces.
