---
bc-version: [all]
domain: patterns
keywords: [remediate-on-touch, legacy, pre-existing, brownfield, standards-drift, tooltip, diff-scope]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Modifying a legacy object brings that object up to the current CMFRT standard

## Description

Most CMFRT objects were written before the `custom/` standards layer existed, so they carry patterns that today's rules reject. A change to such an object that only avoids *new* violations leaves the object half-compliant: the added declaration follows the current rule while the declarations beside it, of the same kind, still follow the old one. The next reader cannot tell which shape is the house convention, and the object never converges — each ticket adds one compliant line to a file that stays non-compliant.

The worked case is `ToolTip`. `naming/cmfrt-caption-prefix` already settles where it belongs: captions and tooltips are defined once on the table field and never overridden on a page, which is why a page field added today correctly carries no page-level `ToolTip`. The page's other fields still declare theirs inline, and those inline declarations are themselves `cmfrt-caption-prefix` violations — never reported, because the added field contributes no `ToolTip` token and a diff-scoped review never puts the untouched lines in its worklist. The same gap exists for every mechanical `custom/` rule and every object type.

## Best Practice

When you modify an existing object, evaluate the whole object body against the `custom/` rules your change already put in scope, and fix the pre-existing violations that are mechanical and non-breaking in the same change. Two limits bound this. Its **scope** is the object being modified — the single `.al` file — never the folder, the module, or the app. Its **eligibility** is mechanical and non-breaking. State the widened scope in the report and the PR description — which rule, how many declarations, why the diff is larger than the ticket — so the reviewer reads the extra lines as deliberate rather than as scope creep.

Remediate only what cannot break a dependent or a translation contract:

- **Property additions and in-place value corrections** — `Image`, `DataClassification`, `ApplicationArea`, a missing `else` arm, `MaxStrLen` for a literal length, `Validate` for a direct field assignment, `ConfirmManagement` for `Confirm(`, a `Comment` on a `Label`, an object-level `var` declaration moved into the procedure that uses it.
- **Moving a page-control `Caption`/`ToolTip` to its source table field**, when the field belongs to a table or table extension *this app owns* and `app.json` targets runtime 13.0 or later — table-field `ToolTip` needs runtime 13.0, so read the runtime before moving anything. A control bound to a base or dependency field cannot receive the property there; its page-level declaration is legitimate and stays. The move re-keys the property's `Translations/*.g.xlf` trans-unit, so expect the existing translation to be orphaned.

Leave alone, and report as debt instead:

- Anything that renames or removes a public identifier — an object, field, procedure, enum value, or permission set. That is a breaking-changes matter with its own obsoletion procedure, not a cleanup.
- File renames and moves. Correct for a new file; a repo-wide rename inside a feature ticket is not.
- Anything needing a design decision — splitting a codeunit, introducing an interface, choosing an event signature, writing tooltip text where none exists anywhere.

Apply a budget. When the count of pre-existing violations is large enough that remediation would dominate the change, remediate none of them and report the rule, the count, and the object so the debt is visible and can be ticketed. Half a migration is worse than none: it leaves the same two-shapes ambiguity the rule exists to remove.

See samples: `cmfrt-remediate-on-touch.good.al`, `cmfrt-remediate-on-touch.bad.al`.

## Anti Pattern

Adding a compliant declaration beside non-compliant ones of the same kind and calling the change complete — the half-compliant object. The reviewer sees a clean diff, the file stays wrong, and the inconsistency now looks intentional.

The two opposite failures are equally wrong. Widening the change into a rename, a file move, an obsoletion, or a neighbouring object turns a feature ticket into an unreviewable refactor and can break dependents. And remediating an arbitrary subset of a long object leaves both shapes in the file anyway, having spent the diff for nothing.

Silently absorbing the extra lines is a third failure: a widened diff the report and PR description do not mention reads as scope creep, and the reviewer spends the review re-deriving why the untouched lines changed.

## See also

`custom/knowledge/naming/cmfrt-caption-prefix.md` owns the caption and tooltip placement rule the tooltip case enforces; this article adds only the obligation to migrate a legacy object on touch.
`microsoft/knowledge/ui/bound-page-field-inherits-source-field-tooltip.md` supplies the runtime 13.0 inheritance mechanics and is not contradicted by it.
