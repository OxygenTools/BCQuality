---
bc-version: [all]
domain: patterns
keywords: [initvalue, default-value, hardcoded-fallback, setup-singleton, upgrade-codeunit, type-default, al0844]
technologies: [al]
countries: [w1]
application-area: [all]
---

# A configurable default is declared once at creation, never as a fallback constant in code

## Description

A setting the user can configure carries a default: the value the feature uses until someone changes it. That default belongs in exactly one place, on the record's creation path. The tempting alternative is a guard at the point of use: read the field, and if it comes back zero or blank, substitute a constant. That works on the first run and is wrong from then on, because the default now exists twice. The next person to tune it edits one copy, the two disagree, and which one wins depends on whether the tenant's row happens to hold the type default.

Where on the creation path depends on the field's type, and this is the part that fails at compile. **`InitValue` is not available on every field type.** The compiler restricts it, diagnostic `AL0844`: *"The property 'InitValue' can only be used if the field's type is one of these values: 'BigInteger, Boolean, Char, Code, Date, DateFormula, DateTime, Decimal, Enum, Integer, Label, Option, String, Text, Time, TextConst'."* `Duration`, `Blob`, `Media`, `MediaSet`, `Guid`, `RecordId` and `TableFilter` are absent from that list, so `InitValue` on such a field is illegal outright — not a wrong literal, an ineligible type. The accompanying `AL0294` ("the type of property value does not match the field's type") is a knock-on and no literal fixes it. Microsoft's `InitValue` documentation does not mention the restriction, which is why this reaches a build rather than a review.

The second trap applies to eligible types. `InitValue` takes a compile-time literal, not an expression: `InitValue = 15;` compiles, `InitValue = 15 * 60;` does not.

The third is that `InitValue` applies when the platform inserts a *new* record and does not back-fill rows that already exist. A setup singleton exists in every live environment already, so a field added this way lands there as the **type default** — `0` for a numeric, blank for `Code`, `false` for `Boolean` — not as the `InitValue`. The property looks like it solved the problem and has only solved it for new tenants.

## Best Practice

Check the field's type against the `AL0844` list before reaching for `InitValue`. Then declare the default once:

- **Type on the list** — `InitValue` on the table field, as a literal. Comment it with its unit (`// 15 minutes`).
- **Type not on the list** — assign the default on the record's creation path, immediately after `Init()` and before any `OnBefore` or insert event, so a subscriber can still override it. A read-time getter is the wrong home: it fires on every read and cannot distinguish an unconfigured field from a deliberate zero.
- **New field whose type blocks `InitValue`** — consider changing the type or unit instead. A `Duration` in milliseconds becomes an `Integer` in minutes with `InitValue = 15;`, which is legal, more readable on the setup page, and free of schema cost while the field is unshipped. The unit conversion then lives in one getter; converting a stored unit is not a hardcoded default and does not reoffend. This is usually cheaper than working around the restriction.

Code that reads the setting reads it and does nothing else — no comparison against zero, no substitution.

Then decide, explicitly, what the **type default** means for rows that already exist, and record the decision in the design document, the PR description, or a code comment. Three resolutions are legitimate:

- **Ship an upgrade codeunit that back-fills the existing rows.** The default answer whenever the type default is unsafe, and the only one that leaves every environment in the same state. `DataTransfer.AddConstantValue` under an upgrade tag is the standard shape; `microsoft/knowledge/upgrade/initvalue-does-not-update-existing-rows` owns the mechanics.
- **Give the type default an explicit, safe meaning** — for example `0` = feature disabled — and enforce it at the point of use. A design decision about the field's semantics, documented in its `ToolTip`, not a fallback in disguise: the code branches on a *documented state*, not on a value it treats as missing.
- **Accept the zero-state and write a deployment note.** Defensible only when someone will genuinely set the value before the behaviour first runs, and only when it is written down.

Judging safety is concrete: substitute the type default into the expression that consumes the field and read what happens. In the worked case `0` made `SystemModifiedAt < CurrentDateTime - 0` true for every `Processing` row, so the first Process Pending run after upgrade would have reset live entries — unsafe, and the upgrade codeunit is the correct answer. That ticket chose the third resolution, with a deployment note, because the deploy window made it acceptable; an exception someone signed off on, not the pattern to copy.

See sample: [`cmfrt-initvalue-not-code-default.good.al`](cmfrt-initvalue-not-code-default.good.al).

## Anti Pattern

Reaching for `InitValue` without checking the field's type against the `AL0844` list. It reads as correct and passes review; it fails at compile, and on a `Duration` field no choice of literal rescues it. This is the defect that produced the rule: `InitValue = 900000;` on a `Duration` broke the build.

The `if X = 0 then X := <constant>;` guard, in the getter or at the point of use. It puts a second copy of the default in code, and it hides that the setting is unconfigured: the setup page shows a blank field that behaves as fifteen minutes, so the page lies about the system's state and no one can tell a deliberate zero from an unset one. The same shape with `''`, `false`, or a blank date is the same defect — and note that an ineligible field type is not a licence to fall back to it; the creation path is still available.

Adding `InitValue` and declaring the migration handled is the half-migrated variant, and it is the one that survives review. New tenants get the intended default; every environment that already had the setup row runs on the type default indefinitely, and nothing in the code or the page says so. `InitValue` present with no recorded decision about existing rows is an incomplete change.

Fixing the getter by moving the constant into a `Label`, a setup-less helper procedure, or a `case` arm is the same anti pattern relocated. The test is whether the default appears anywhere other than the field declaration or the creation path.

See sample: [`cmfrt-initvalue-not-code-default.bad.al`](cmfrt-initvalue-not-code-default.bad.al).

## See also

`microsoft/knowledge/upgrade/initvalue-does-not-update-existing-rows.md` supplies the back-fill mechanics and the `DataTransfer` shape, and is cited rather than restated here. This article **narrows** one of its exemptions: that article lists new fields on configuration or setup tables as a case needing no upgrade code, on the reasoning that such tables have no meaningful existing data. For a CMFRT setup singleton that is not true — the row exists in every live environment — so a new configurable field on a setup table is in scope here and the decision must still be made and recorded. That exemption sits in the microsoft article's `## Description`, which is non-normative, so this is a narrowing rather than a precedence conflict: nothing in its `## Best Practice` or `## Anti Pattern` is contradicted, and a consumer should cite both articles rather than suppress either.

`custom/knowledge/naming/cmfrt-caption-prefix.md` applies the same "declare it once on the table field" principle to `Caption` and `ToolTip`.

`custom/knowledge/patterns/cmfrt-remediate-on-touch.md` is the companion case of a change that looks complete and is not.
