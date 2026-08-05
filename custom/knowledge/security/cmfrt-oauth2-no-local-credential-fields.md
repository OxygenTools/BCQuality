---
bc-version: [all]
domain: security
keywords: [oauth2, client-secret, client-id, tenant-id, credentials, setup-table, keyvault, isolatedstorage, cmfrt]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT extensions must not keep OAuth2 credentials in their own setup table

## Description

CMFRT extensions authenticate against external systems through the central OAuth2 configuration in the CMFRT System app (table `"CMFRT SY OAuth2 Config"`, maintained from the *Oauth2 Configuraties* page). That configuration is the only place where the Azure app registration details belong. The client secret itself is never persisted anywhere in Business Central: it is fetched from the Astena Key Vault at the moment a token is requested, using a Key Vault Code and Auth Token that live encrypted in IsolatedStorage, plus a Key Vault Source stored on the config record.

An extension that keeps its own `Client ID`, `Client Secret`, or `Tenant ID` fields therefore stores a credential that the platform never needs, in a table any user with setup permission can read and any AL code can read without a Key Vault round trip. It also produces two sources of truth: rotating the secret in the Key Vault leaves the copy in the setup table stale, and the extension keeps authenticating with the old value until someone notices.

## Best Practice

Register the extension's OAuth2 details once through the *AddEdit OAuth2 Configuration* wizard, and keep the extension's own setup table free of `Client ID`, `Client Secret`, and `Tenant ID` fields. The extension stores only what is specific to itself (endpoints, paths, file names, feature flags) and asks the central codeunit for a token when it needs one.

When migrating an extension that already has such fields, obsolete them rather than deleting them — see `custom/knowledge/breaking-changes/cmfrt-never-delete-always-obsolete.md` — and drop them from the setup page in the same change, so no user can enter a secret that is no longer read.

See sample: `cmfrt-oauth2-no-local-credential-fields.good.al`.

## Anti Pattern

A setup table or table extension that declares a client secret, client ID, or tenant ID field — typically `Text[250]` with `DataClassification = CustomerContent` — and a setup page that exposes them for a user to fill in. The secret is then readable in the database, in a page, in an export, and in any RapidStart package built from that table. `ExtendedDatatype = Masked` on the page control does not fix this: it hides the value in the UI while it stays in plain text in the record.

See sample: `cmfrt-oauth2-no-local-credential-fields.bad.al`.

## See also

- `cmfrt-oauth2-token-via-central-tokenmeth.md` — how the token is actually requested.
- `cmfrt-oauth2-setup-page-status-and-navigation.md` — what the setup page shows instead of the credential fields.
