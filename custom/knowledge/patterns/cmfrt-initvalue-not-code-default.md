---
bc-version: [all]
domain: patterns
keywords: [initvalue, default-value, hardcoded-fallback, setup-singleton, upgrade-codeunit, type-default, duration]
technologies: [al]
countries: [w1]
application-area: [all]
---

# A configurable default belongs in `InitValue`, never as a fallback constant in code

## Description

A setting the user can configure carries a default: the value the feature uses until someone changes it. That default has exactly one correct home — the `InitValue` property on the table field that stores the setting. The tempting alternative is a guard at the point of use: read the field, and if it comes back zero or blank, substitute a constant. That works on the first run and is wrong from then on, because the default now exists twice. The next person to tune it edits one copy, the two disagree, and which one wins depends on whether the tenant's row happens to hold the type default.

The worked case is table `CMFRT AQ Setup` and a `Duration` field holding how long a buffer entry may sit in `Processing` before the Process Pending action treats it as stuck. The first implementation defaulted to 15 minutes inside the getter. Review rejected it: the default goes on the field.

Moving it there exposes the part that is easy to miss. `InitValue` applies when the platform inserts a *new* record; it does not back-fill rows that already exist. A setup singleton exists in every live environment already, so a field added this way lands there as the **type default** — `0` for `Duration`, blank for `Code`, `false` for `Boolean` — not as the `InitValue`. The property looks like it solved the problem and has only solved it for new tenants. `InitValue` also takes a compile-time literal, not an expression: `InitValue = 900000;` compiles, `InitValue = 15 * 60 * 1000;` does not, which is a real trap on `Duration` because the readable form is the expression.

## Best Practice

Declare the default once, as `InitValue` on the table field, with a literal. Code that reads the setting reads it and does nothing else — no comparison against zero, no substitution. Comment the literal with the unit and the human-readable value (`// 900000 ms = 15 minutes`) so the next reader does not have to divide.

Then decide, explicitly, what the **type default** means for the rows that already exist, and record the decision in the design document, the PR description, or a code comment. Three resolutions are legitimate:

- **Ship an upgrade codeunit that back-fills the existing rows.** This is the default answer whenever the type default is unsafe, and it is the only one that leaves every environment in the same state. `DataTransfer.AddConstantValue` under an upgrade tag is the standard shape; `microsoft/knowledge/upgrade/initvalue-does-not-update-existing-rows` owns the mechanics.
- **Give the type default an explicit, safe meaning** — for example `0` = feature disabled — and enforce that meaning at the point of use. This is a design decision about the field's semantics, documented in its `ToolTip`, not a fallback in disguise: the code branches on a *documented state*, not on a value it treats as missing.
- **Accept the zero-state and write a deployment note.** Defensible only when someone will genuinely set the value before the behaviour first runs, and only when it is written down.

Judging safety is concrete: substitute the type default into the expression that consumes the field and read what happens. In the worked case `0` made `SystemModifiedAt < CurrentDateTime - 0` true for every `Processing` row, so the first Process Pending run after upgrade would have reset live entries — unsafe, and the upgrade codeunit is the correct answer. That ticket chose the third resolution instead, with a deployment note, because the deploy window made it acceptable; that is an exception someone signed off on, not the pattern to copy.

See sample: [`cmfrt-initvalue-not-code-default.good.al`](cmfrt-initvalue-not-code-default.good.al).

## Anti Pattern

The `if X = 0 then X := <constant>;` guard, in the getter or at the point of use. It puts a second copy of the default in code, and it hides that the setting is unconfigured: the setup page shows a blank field that behaves as fifteen minutes, so the page lies about the system's state and no one can tell a deliberate zero from an unset one. The same shape with `''`, `false`, or a blank date is the same defect.

Adding `InitValue` and declaring the migration handled is the half-migrated variant, and it is the one that survives review. New tenants get the intended default; every environment that already had the setup row runs on the type default indefinitely, and nothing in the code or the page says so. `InitValue` present with no recorded decision about existing rows is an incomplete change, not a complete one.

Fixing the getter by moving the constant into a `Label`, a setup-less helper procedure, or a `case` arm is the same anti pattern relocated. The test is whether the default appears anywhere other than the field declaration.

See sample: [`cmfrt-initvalue-not-code-default.bad.al`](cmfrt-initvalue-not-code-default.bad.al).

## See also

`microsoft/knowledge/upgrade/initvalue-does-not-update-existing-rows.md` supplies the back-fill mechanics and the `DataTransfer` shape, and is cited rather than restated here. This article **narrows** one of its exemptions: that article lists new fields on configuration or setup tables as a case needing no upgrade code, on the reasoning that such tables have no meaningful existing data. For a CMFRT setup singleton that is not true — the row exists in every live environment — so a new configurable field on a setup table is in scope here and the decision must still be made and recorded. That exemption sits in the microsoft article's `## Description`, which is non-normative, so this is a narrowing rather than a precedence conflict: nothing in its `## Best Practice` or `## Anti Pattern` is contradicted, and a consumer should cite both articles rather than suppress either.

`custom/knowledge/naming/cmfrt-caption-prefix.md` applies the same "declare it once on the table field" principle to `Caption` and `ToolTip`.

`custom/knowledge/patterns/cmfrt-remediate-on-touch.md` is the companion case of a change that looks complete and is not.
