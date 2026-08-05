---
kind: action-skill
id: cmfrt-oauth2-secrets-review
version: 1
title: CMFRT OAuth2 and secret-handling review
description: Reviews AL source changes for the CMFRT central OAuth2 standard — no local client secrets, access tokens through CMFRT SY OAuth2 Token Meth, and the setup-page status and navigation convention.
inputs: [pr-diff, file-path]
outputs: [findings-report]
bc-version: [all]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT OAuth2 and secret-handling review

Reviews AL source changes against the CMFRT standard for authenticating against external systems: credentials live in the central OAuth2 configuration of the CMFRT System app and the client secret stays in the Astena Key Vault, extensions obtain access tokens through codeunit `"CMFRT SY OAuth2 Token Meth"`, and each extension's setup page reports and links to its own configuration.

This is a leaf action skill: it invokes no sub-skills. It is the narrow skill for a credential, secret, token, or Key Vault goal; `custom/skills/review/cmfrt-standards-review.md` covers the same articles as part of a broad CMFRT review, and `microsoft/skills/review/al-security-review.md` covers platform secret handling. Running all three on the same diff is expected — deduplicate by knowledge-file `id` in the consuming report, not here.

An orchestrator invokes this skill with either a `pr-diff` or a `file-path`. The skill produces a single JSON document conforming to the DO output contract.

## Source

Read the BCQuality knowledge index once (`knowledge-index.json` at the checkout root). The candidate set is every entry whose `domain` is `security` and whose `layer` is enabled, plus any entry whose `keywords` contain `oauth2`, `client-secret`, `credentials`, `keyvault`, or `access-token`. Do not open individual article files at this step.

The `custom` candidates carry the CMFRT mechanism itself — `cmfrt-oauth2-no-local-credential-fields`, `cmfrt-oauth2-token-via-central-tokenmeth`, and `cmfrt-oauth2-setup-page-status-and-navigation`. The `microsoft` candidates carry the platform facts the mechanism rests on (`IsolatedStorage` scope and encryption, `SecretText`, `[NonDebuggable]`, OAuth2 over API keys). Both are in scope; precedence is resolved at Worklist.

## Relevance

Apply frontmatter matching rules defined in READ against the task context:

- `bc-version` — from the target branch's `app.json` or orchestrator context; `unknown` if absent.
- `technologies` — `[al]`.
- `countries` — from `app.json` or orchestrator context; default `unknown`.
- `application-area` — union of application areas declared by changed objects; `unknown` if not determinable.

Discard candidates whose filter dimensions explicitly do not match. Retain conditionally applicable candidates (any dimension `unknown`); findings from those files MUST have `confidence` no higher than `medium` and the `message` MUST name the unknown dimension.

## Worklist

Narrow the relevant candidates to those that apply to the changes under review. Compute overlap against:

- **Credential-shaped declarations** — any `field(` in a table or tableextension whose name, caption, or tooltip contains `Secret`, `Client Secret`, `Client ID`, `Tenant ID`, `Password`, `Api Key`, or `Auth Token`, and any page control bound to one. Match against `cmfrt-oauth2-no-local-credential-fields`. Worklist this from the declaration: the defect is the field existing at all, so it is present in the diff even when no code reads it. `ExtendedDatatype = Masked` on the page control is not a mitigation and MUST NOT downgrade the finding.
- **Hand-rolled token requests** — a request URI containing `login.microsoftonline.com`, `/oauth2/token`, or `/oauth2/v2.0/token`; a request body assembling `grant_type=`, `client_id=`, or `client_secret=`; or a JSON read of `access_token`. Match against `cmfrt-oauth2-token-via-central-tokenmeth`.
- **Central-codeunit call sites** — every call to `CMFRTSYGetAccessToken`, `CMFRTSYConfigExists`, `CMFRTSYRegisterOAuth2Config`, `CMFRTSYUpdateOAuth2Config`, or `CMFRTSYDeleteOAuth2Config`. Check three things at each `CMFRTSYGetAccessToken` site: the Boolean return is tested rather than discarded (the token arrives in the `var` parameter), the enclosing procedure is `[NonDebuggable]`, and the enum value passed belongs to the extension under review — a value naming another extension will fail at runtime on the caller-module check, not at compile time, so it is a real defect and not a style question.
- **`enumextension` against a closed enum** — an `enumextension` whose target is `"CMFRT SY OAuth2 Action"`. The enum is declared `Extensible = false`, so this does not compile; report it as a `blocker` and point at adding the value to the enum in the CMFRT System app instead.
- **Token or secret persistence** — an access token, client secret, or Key Vault auth token assigned to a table field, written with `IsolatedStorage.Set` by the consuming extension, or logged through telemetry or a `Message`. Match against `cmfrt-oauth2-token-via-central-tokenmeth` and the Microsoft `security` and `privacy` candidates.
- **Setup surface** — a setup table or setup page belonging to an extension that calls `CMFRTSYGetAccessToken` anywhere in the diff or already does so in the file under review. Match against `cmfrt-oauth2-setup-page-status-and-navigation`, and check for both a `CMFRTSYConfigExists`-computed indicator and a navigation action to the central configuration page. A persisted Boolean "OAuth2 configured" field is the anti-pattern half of that article, not a compliant indicator.

A candidate enters the worklist when its `keywords` intersect the extracted tokens, or when its topic (from the index `path`, `title`, and `description`) matches the type of change in the diff. Read an article's full body only after it enters the worklist.

Resolve layer-precedence conflicts per READ: `custom` over `community` over `microsoft`. When a Microsoft `security` article and a CMFRT article cover the same concern on the same location — for example a stored secret, which Microsoft's `secrets-isolated-storage` and CMFRT's `cmfrt-oauth2-no-local-credential-fields` both reject — emit the CMFRT finding and record the Microsoft file in `suppressed` with `reason: "layer-precedence"`. Microsoft articles that cover a concern no CMFRT article addresses are reported normally.

When no knowledge survives filtering, emit `outcome: "no-knowledge"`. When the worklist is empty because no candidates matched the diff, emit `outcome: "completed"` with an empty `findings` array. When the diff contains no AL changes that touch credentials, tokens, HTTP authentication, or a setup surface, emit `outcome: "not-applicable"`.

## Action

For each worklist entry, evaluate the diff against its `## Best Practice` and `## Anti Pattern` sections. Severity is assigned as follows:

- A client secret, Key Vault auth token, or access token that is persisted or transmitted outside the central mechanism — `blocker`. So is an `enumextension` against the closed action enum, because the app does not compile.
- A hand-rolled token request, a `CMFRTSYGetAccessToken` call whose Boolean result is discarded, a token-carrying procedure that is not `[NonDebuggable]`, or a client ID or tenant ID kept in the extension's own setup table — `major`.
- A missing configuration indicator or missing navigation action on the setup page, or a credential field that is being obsoleted correctly but is still bound to a page control — `minor`.
- An article that is clearly applicable with no violation detectable — `info`, citing the file.

Set `confidence` to `high` for unambiguous token or structural matches, `medium` for heuristic matches or when any frontmatter dimension was `unknown`, and `low` for advisory-only applicability. A judgement that depends on code outside the diff — whether the enum value belongs to this extension, whether a setup page elsewhere already carries the indicator — is `medium` at best, and the `message` MUST say what was not visible.

Emit `findings[].suggested-code` whenever the fix is small, local, and mechanical — adding `[NonDebuggable]`, wrapping a discarded call in `if not ... then Error(...)`, adding `ObsoleteState = Pending` with a reason to a credential field, or removing a page control bound to one. Replacing a hand-rolled token request with a `CMFRTSYGetAccessToken` call usually spans a whole procedure and its variable block: set `suggested-code-omission-reason` instead of emitting a partial rewrite.

After evaluating all worklist entries, consider whether the diff exhibits a credential-handling violation the agent recognises from general AL knowledge that no knowledge file covers. Hold such candidates to the precision bar in `skills/do.md` (*Agent findings*): encode them with `references: []`, `id` prefixed `agent:`, `confidence` capped at `medium`, `severity` capped at `minor`.

Outcome selection:

- `completed` — every worklist item evaluated, including when `findings` is empty.
- `no-knowledge` — no knowledge survived Source, Relevance, and configuration filtering.
- `not-applicable` — no AL changes, or nothing in the diff touches credentials, tokens, HTTP authentication, or a setup surface.
- `partial` — time or token budget exhausted before worklist completion; set `outcome-reason`.
- `failed` — unrecoverable error; set `outcome-reason`.

## Output

Output conforms to the DO output contract. Example — a stored secret and a hand-rolled token request found:

```json
{
  "skill": { "id": "cmfrt-oauth2-secrets-review", "version": 1 },
  "outcome": "completed",
  "summary": {
    "counts": { "blocker": 1, "major": 1, "minor": 1, "info": 0 },
    "coverage": { "worklist-size": 3, "items-evaluated": 3 }
  },
  "findings": [
    {
      "id": "custom/knowledge/security/cmfrt-oauth2-no-local-credential-fields.md",
      "severity": "blocker",
      "message": "Field 'CMFRT CC Client Secret' stores a client secret in table 2045129. The secret belongs in the Astena Key Vault and is retrieved by 'CMFRT SY OAuth2 Token Meth'; obsolete this field and remove it from the setup page.",
      "location": { "file": "src/CMFRTCCJob/CMFRTCCAzureAppSetup.Table.al", "line": 16 },
      "references": [{ "path": "custom/knowledge/security/cmfrt-oauth2-no-local-credential-fields.md" }],
      "confidence": "high",
      "suggested-code": "        field(2045110; \"CMFRT CC Client Secret\"; Text[250])\n        {\n            Caption = 'Client Secret';\n            DataClassification = CustomerContent;\n            ObsoleteState = Pending;\n            ObsoleteReason = 'Secrets are retrieved from the Astena Key Vault, never stored.';\n            ObsoleteTag = '26.0';\n        }"
    },
    {
      "id": "custom/knowledge/security/cmfrt-oauth2-token-via-central-tokenmeth.md",
      "severity": "major",
      "message": "Procedure 'CMFRTCCGetTokenFromMGraph' builds its own token request against login.microsoftonline.com using the stored client secret. Call CMFRTSYGetAccessToken on codeunit 'CMFRT SY OAuth2 Token Meth' with this extension's enum value instead.",
      "location": { "file": "src/CMFRTCCSales/CMFRTCCExcelHelp.Codeunit.al", "line": 75 },
      "references": [{ "path": "custom/knowledge/security/cmfrt-oauth2-token-via-central-tokenmeth.md" }],
      "confidence": "high",
      "suggested-code-omission-reason": "The replacement rewrites the whole procedure body and its variable block."
    },
    {
      "id": "custom/knowledge/security/cmfrt-oauth2-setup-page-status-and-navigation.md",
      "severity": "minor",
      "message": "Page 2045129 is the setup page for an extension that requests OAuth2 tokens but shows no configuration status and offers no navigation to the central OAuth2 configuration. Add a Boolean computed from CMFRTSYConfigExists in OnOpenPage or OnAfterGetRecord, plus a navigation action.",
      "location": { "file": "src/CMFRTCCJob/CMFRTCCAzureAppSetup.Page.al", "line": 1 },
      "references": [{ "path": "custom/knowledge/security/cmfrt-oauth2-setup-page-status-and-navigation.md" }],
      "confidence": "medium",
      "suggested-code-omission-reason": "The indicator spans a page variable, two triggers and a local procedure."
    }
  ],
  "suppressed": [
    {
      "path": "microsoft/knowledge/security/secrets-isolated-storage.md",
      "reason": "layer-precedence",
      "superseded-by": "custom/knowledge/security/cmfrt-oauth2-no-local-credential-fields.md"
    }
  ]
}
```
