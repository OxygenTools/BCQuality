---
kind: action-skill
id: cmfrt-standards-review
version: 1
title: CMFRT AL standards review
description: Reviews AL source changes for CMFRT company standards — naming, object IDs, permission sets, breaking-changes, events, patterns, and architecture.
inputs: [pr-diff, file-path]
outputs: [findings-report]
bc-version: [all]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT AL standards review

Reviews AL source changes against the CMFRT company standards defined in `custom/knowledge/`. This is a leaf action skill: it invokes no sub-skills. It is dispatched alongside `microsoft/skills/review/al-code-review.md` for every CMFRT project review.

An orchestrator invokes this skill with either a `pr-diff` (the standard PR-review entry point) or a `file-path` (single-file review). The skill produces a single JSON document conforming to the DO output contract.

## Source

Read the BCQuality knowledge index once (`knowledge-index.json` at the checkout root). Take every entry whose `layer` is `custom` as the candidate set — this covers all domains under `custom/knowledge/`: `naming`, `security`, `breaking-changes`, `events`, `patterns`, `architecture`, `testing`, and `ui`. Do not open individual article files at this step.

## Relevance

Apply frontmatter matching rules defined in READ against the task context:

- `bc-version` — from the target branch's `app.json` or orchestrator context; `unknown` if absent.
- `technologies` — `[al]`.
- `countries` — from `app.json` or orchestrator context; default `unknown`.
- `application-area` — union of application areas declared by changed objects; `unknown` if not determinable.

Discard candidates whose filter dimensions explicitly do not match. Retain conditionally applicable candidates (any dimension `unknown`); findings from those files MUST have `confidence` no higher than `medium` and the `message` MUST name the unknown dimension.

## Worklist

Narrow the relevant candidates to those that apply to the changes under review. Compute overlap against:

- Changed AL object names, types, and IDs — weighted toward tables, table extensions, codeunits, interfaces, permission sets, and any object whose ID, name, or prefix is being set or changed. Match against the `naming` and `architecture` domain candidates. Files under the test app (`<AppName>_Test/`, or any codeunit with `Subtype = Test`) are in scope for `naming` exactly as production files are: prefix every test codeunit name, `[Test]` procedure, handler named in `[HandlerFunctions]`, and local helper. Do not skip a test-app file as "test code" — only the `architecture` and `events` candidates are production-only, and the `testing` candidates are conversely test-app-only.
- **Declared name length** — measure every object name, table field name, and enum value name in the diff. A name longer than 30 characters, or an unprefixed name whose length plus the 9-character `CMFRT <ABBR> ` prefix would exceed 30, matches the `naming` candidate `cmfrt-object-name-30-char-limit`. Worklist it by measuring the declared name directly: its `keywords` can never intersect the extracted tokens, because length is a property of the declaration rather than a token appearing in the source, so token overlap alone would never surface it. When a name breaches the budget *and* lacks the prefix, both `cmfrt-object-name-30-char-limit` and `cmfrt-naming-prefix` apply — cite the length article as the cause and the prefix article as the violated convention.
- **File path shape** — for every added, renamed or moved `.al` file in the diff, evaluate the *path* rather than its contents. Match the basename against `<ObjectName>.<ObjectType>.al` (the declared object name with its spaces removed, PascalCase, no object ID, type segment case-insensitive) → `naming/cmfrt-al-file-name-pattern`. Match every path segment under `src/` against the AL object-type names (`Table`, `TableExt`/`TableExtension`, `Page`, `PageExt`/`PageExtension`, `Codeunit`, `Enum`, `EnumExt`, `Interface`, `PermissionSet`, `Report`, `Query`, `XmlPort`, with or without a trailing `s`); a segment that equals one is the group-by-type anti-pattern → `architecture/cmfrt-feature-folder-layout`. Worklist both from the path directly: a path is a property of the declaration's location, never a token appearing in the source, so token overlap alone would never surface them. Severity `major` for either — a repo-wide rename after review is the cost. An install or upgrade codeunit (`Subtype = Install` / `Subtype = Upgrade`) outside `src/02 Install` / `src/05 Upgrade` is the same finding. Every added interface and its implementing codeunit are additionally matched against `naming/cmfrt-interface-int-impl-suffix`.
- Changed procedure signatures and parameter lists — especially global procedures being added, renamed, or extended. Match against `breaking-changes` and `events` candidates.
- Changed permission set objects and their `IncludedPermissionSets` chains. Match against `security` candidates.
- Credential and token shape: a `field(` whose name or caption contains `Secret`, `Client ID`, `Tenant ID`, `Password`, or `Auth Token`; a request URI containing `login.microsoftonline.com` or `/oauth2/token`; a request body assembling `grant_type=` or `client_secret=`; and any call to `CMFRTSYGetAccessToken` or `CMFRTSYConfigExists`. Match against the `security` candidates `cmfrt-oauth2-no-local-credential-fields`, `cmfrt-oauth2-token-via-central-tokenmeth`, and `cmfrt-oauth2-setup-page-status-and-navigation`. When the goal is specifically about credentials, secrets, tokens, or the Key Vault, `custom/skills/review/cmfrt-oauth2-secrets-review.md` is the narrower skill and Entry dispatches that instead.
- Tokens extracted from the diff: `ObsoleteState`, `ObsoleteReason`, `ObsoleteTag`, `Confirm`, `case`, `else`, `interface`, `implements`, `IntegrationEvent`, `OnBefore`, `OnAfter`, `Handled`, `IsHandled`, `IncludedPermissionSets`, `Assignable`, `procedure`, `local procedure`, `Validate`, `Init`, `Insert`, `OnInsertRecord`, `Buffer`, `Caption`, `ToolTip`, `Label`, `Comment`, `CopyStr`, `MaxStrLen`, `TryFunction`, `Codeunit.Run`, `field(`, `value(`, `Database::`, `Page::`, `Codeunit::`, `Enum::`, `extends`, `OnDelete`, `Delete`, `DeleteAll`, `TableRelation`, `OnAfterDeleteEvent`, `IsTemporary`, `Subtype = Test`, `Subtype = Install`, `Subtype = Upgrade`, `OnInstallAppPerCompany`, `AL Test Suite`, `Test Suite Mgt.`, `CreateTestSuite`, `SelectTestMethodsByRange`, `SelectTestMethodsByCodeunit`, `[Test]`, `[HandlerFunctions]`, `[ConfirmHandler]`, `[MessageHandler]`, `[ModalPageHandler]`, `Image`, `action(`, `group(`, `fileuploadaction(`, `cuegroup(`, `area(Processing)`, `RoleCenter`, `Secret`, `client_secret`, `grant_type`, `access_token`, `login.microsoftonline.com`, `IsolatedStorage`, `NonDebuggable`, `CMFRTSYGetAccessToken`, `CMFRTSYConfigExists`.
- Field-assignment shape: contiguous runs of `Record.Field := Value` statements on a non-buffer record variable inside a creator/method codeunit. Match against the `patterns` candidate `cmfrt-validate-not-assign`.
- Parent-child delete shape: a new or changed table whose primary key is another table's key plus a line/entry number, or that carries a `TableRelation` to a table the extension owns; any `OnDelete` trigger; and any `Delete`/`DeleteAll` call site. Match against the `patterns` candidate `cmfrt-ondelete-cascades-to-children`. The absence of a trigger is the defect here, so worklist it from the *parent* table declaration — a header with no `OnDelete` produces no token to match on. Treat `TableRelation` as evidence of a parent-child pair, never as evidence that the delete cascades.
- API page triggers: `PageType = API` combined with `SourceTable` on a base application table, or an `OnInsertRecord` body containing `Rec.Insert` or `exit(false)`. Match against the `architecture` candidate `cmfrt-buffer-table-api-pattern`.
- Test-app suite registration: any diff that adds or changes a codeunit with `Subtype = Test` in the test app (`<AppName>_Test/`). Match against the `testing` candidate `cmfrt-test-suite-install-codeunit`. This is an absence rule — a missing install codeunit produces no token to match on — so worklist it from the presence of test codeunits and then check the *whole test app*, not just the diff, for a codeunit with `Subtype = Install`. Report a finding when the test app contains no install codeunit at all, when the registration lives in a `Subtype = Upgrade` codeunit instead, when the suite is created without a preceding `Delete(true)` or without the `Commit()` between `CreateTestSuite` and `SelectTestMethods*`, or when registration is per-codeunit (`SelectTestMethodsByCodeunit`) rather than by range. A `SelectTestMethodsByRange` argument narrower than the test app's `app.json` `idRanges` is a `minor` finding, not a `major` one: it is correct today and goes stale silently. When `app.json` was not read, cap `confidence` at `medium` and say the declared range was not resolved. Scope this bullet to test-app files only — never report it against the production app.
- Handler attributes in test codeunits: every bracketed attribute in a test-app file and every `HandlerFunctions('...')` argument. Match against the `naming` candidate `cmfrt-handler-attributes-never-prefixed`. Report a finding when an attribute name is neither a non-handler platform attribute (`Test`, `HandlerFunctions`, `TransactionModel`, `Scope`, `TryFunction`, `Obsolete`, and the event/subscriber attributes) nor one of the thirteen handler attributes — `ConfirmHandler`, `MessageHandler`, `StrMenuHandler`, `PageHandler`, `ModalPageHandler`, `ReportHandler`, `RequestPageHandler`, `FilterPageHandler`, `SendNotificationHandler`, `RecallNotificationHandler`, `SessionSettingsHandler`, `HyperlinkHandler`, `HttpClientHandler` — and in particular when it is one of those thirteen carrying the CMFRT prefix (`[CMFRTAMConfirmHandler]`): severity `blocker`, since the platform rejects the attribute outright. Report separately when a `HandlerFunctions('X')` name resolves to no global `procedure X` carrying a handler attribute in the same test codeunit. A prefixed attribute cascades — expect one finding on the declaration and one per referencing test method — so cite the declaration as the cause and reference the call sites in the same `message` rather than emitting a duplicate per site. Do not read a missing prefix on the attribute as a `cmfrt-naming-prefix` violation; the prefix belongs to the procedure name only, and both articles must be applied to the same declaration.
- Test-app library dependencies: any diff that adds or changes a test-app file referencing a Microsoft test-library object (`Library - Variable Storage`, `Library - Sales`, `Library - Marketing`, `Library - Utility`, `Permissions Mock`, or any `Library - *` codeunit), and any change to the test app's `app.json` `dependencies`. Match against the `testing` candidate `cmfrt-test-app-declare-library-dependencies`. This is an absence rule — an undeclared dependency produces no token — so worklist it from the referenced library objects and then read the test app's whole `app.json`, not just the diff. Report a finding when a referenced library object's defining app has no direct `dependencies` entry: `Library Variable Storage` for `Library - Variable Storage`, `Application Test Library` for `Library - Marketing` / `- Sales` / `- Utility`, `Permissions Mock` for `Permissions Mock`. A declared `Tests-TestLibraries` entry is not a substitute — treat it as evidence of transitive resolution, never as a declaration. When the mapping from object to defining app was not resolved from `SymbolReference.json`, cap `confidence` at `medium` and say the defining app was inferred from the article's table rather than from the symbol packages. Scope to test-app files only.
- Image-bearing controls: every added or changed `action(`, `group(` inside an `actions` block, `fileuploadaction(`, and integer `field(` inside a `cuegroup(`. Match against the `ui` candidate `cmfrt-image-property-required`. A missing `Image` produces no token, so worklist it from the control declaration rather than from token overlap. Treat two platform limits as compliant rather than as findings: `Image` has no effect on navigation-bar or top-level action-bar actions of a `RoleCenter` page, and on page fields it is only valid for integer fields. When `Image` *is* set, the value is only verifiable against the icon library at https://aka.ms/bcicons or the app's symbol packages — if neither was consulted, report a suspected non-existent icon name at `confidence: medium` and say the name was not resolved.

A candidate enters the worklist when its `keywords` intersect the extracted tokens, or when its topic (from the index `path`, `title`, and `description`) matches the type of change in the diff. Read an article's full body only after it enters the worklist.

Resolve layer-precedence conflicts per READ. Since all candidates are in the `custom` layer, no cross-layer conflict arises unless a `microsoft` or `community` file shares a concern; in that case the `custom` file takes precedence and the lower-precedence file is recorded in `suppressed` with `reason: "layer-precedence"`.

When no custom knowledge survives filtering, emit `outcome: "no-knowledge"`. When the worklist is empty because no candidates matched the diff, emit `outcome: "completed"` with an empty `findings` array.

## Action

For each worklist entry, evaluate the diff against its `## Best Practice` and `## Anti Pattern` sections. Emit findings as follows:

- Clear Anti Pattern match: severity `major` or `blocker`. Use `blocker` only when the knowledge file explicitly states the pattern violates a platform-level guarantee. Otherwise `major`.
- Code that contradicts a Best Practice without being a full anti-pattern: severity `minor`.
- File is clearly applicable but no violation is detectable: severity `info` citing the file.

Set `confidence` to `high` for unambiguous token or structural matches, `medium` for heuristic matches or when any frontmatter dimension was `unknown`, and `low` for advisory-only applicability.

Emit `findings[].suggested-code` whenever the fix is small, local, and mechanical — for example: adding an `else` clause to a bare `case`, replacing a `Confirm(` call with `ConfirmManagement.GetResponseOrDefault(`, adding `ObsoleteState = Pending` to a deleted member, correcting a naming or caption prefix, rewriting `Record.Field := Value` as `Record.Validate(Field, Value)` (except primary-key/document-no. fields and buffer tables), or replacing a literal `CopyStr` length with `MaxStrLen(Target.Field)`. The payload must be a literal replacement for the lines in `location` with no diff markers or commentary. If the fix is mechanical-looking but spans non-contiguous lines or requires context not visible in the diff, set `suggested-code-omission-reason` instead.

After evaluating all worklist entries, consider whether the diff exhibits a CMFRT standards violation the agent recognises from general AL knowledge that no custom knowledge file covers. Hold such candidates to the precision bar in `skills/do.md` (*Agent findings*): emit only concrete, material violations a CMFRT reviewer would agree are wrong. Encode as agent findings with `references: []`, `id` prefixed `agent:`, `confidence` capped at `medium`, `severity` capped at `minor`.

Outcome selection:

- `completed` — every worklist item evaluated, including when `findings` is empty.
- `no-knowledge` — no custom knowledge survived Source, Relevance, and configuration filtering.
- `not-applicable` — no AL changes in the diff or `technologies` filter rejected the task.
- `partial` — time or token budget exhausted before worklist completion; set `outcome-reason`.
- `failed` — unrecoverable error; set `outcome-reason`.

## Output

Output conforms to the DO output contract. Example — naming and event violations found:

```json
{
  "skill": { "id": "cmfrt-standards-review", "version": 1 },
  "outcome": "completed",
  "summary": {
    "counts": { "blocker": 0, "major": 1, "minor": 1, "info": 0 },
    "coverage": { "worklist-size": 3, "items-evaluated": 3 }
  },
  "findings": [
    {
      "id": "custom/knowledge/naming/cmfrt-naming-prefix.md",
      "severity": "major",
      "message": "Procedure 'CalculateDiscount' on codeunit 2045710 has no CMFRT prefix. Rename to 'CMFRTBACalculateDiscount' to comply with the CMFRT naming convention.",
      "location": { "file": "src/Sales/Discount.Codeunit.al", "line": 8 },
      "references": [{ "path": "custom/knowledge/naming/cmfrt-naming-prefix.md" }],
      "confidence": "high",
      "suggested-code": "    procedure CMFRTBACalculateDiscount(ItemNo: Code[20]; Qty: Decimal): Decimal"
    },
    {
      "id": "custom/knowledge/events/cmfrt-onbefore-onafter-all-globals.md",
      "severity": "minor",
      "message": "Global procedure 'CMFRTBACalculateDiscount' has no OnBefore/OnAfter integration events. Add both events to allow dependent extensions to intercept or react to this operation.",
      "location": { "file": "src/Sales/Discount.Codeunit.al", "line": 8 },
      "references": [{ "path": "custom/knowledge/events/cmfrt-onbefore-onafter-all-globals.md" }],
      "confidence": "high",
      "suggested-code-omission-reason": "Event declarations span multiple non-contiguous locations in the file."
    }
  ],
  "suppressed": []
}
```
