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

Read the BCQuality knowledge index once (`knowledge-index.json` at the checkout root). Take every entry whose `layer` is `custom` as the candidate set — this covers all domains under `custom/knowledge/`: `naming`, `security`, `breaking-changes`, `events`, `patterns`, and `architecture`. Do not open individual article files at this step.

## Relevance

Apply frontmatter matching rules defined in READ against the task context:

- `bc-version` — from the target branch's `app.json` or orchestrator context; `unknown` if absent.
- `technologies` — `[al]`.
- `countries` — from `app.json` or orchestrator context; default `unknown`.
- `application-area` — union of application areas declared by changed objects; `unknown` if not determinable.

Discard candidates whose filter dimensions explicitly do not match. Retain conditionally applicable candidates (any dimension `unknown`); findings from those files MUST have `confidence` no higher than `medium` and the `message` MUST name the unknown dimension.

## Worklist

Narrow the relevant candidates to those that apply to the changes under review. Compute overlap against:

- Changed AL object names, types, and IDs — weighted toward tables, table extensions, codeunits, interfaces, permission sets, and any object whose ID, name, or prefix is being set or changed. Match against the `naming` and `architecture` domain candidates.
- Changed procedure signatures and parameter lists — especially global procedures being added, renamed, or extended. Match against `breaking-changes` and `events` candidates.
- Changed permission set objects and their `IncludedPermissionSets` chains. Match against `security` candidates.
- Tokens extracted from the diff: `ObsoleteState`, `ObsoleteReason`, `ObsoleteTag`, `Confirm`, `case`, `else`, `interface`, `implements`, `IntegrationEvent`, `OnBefore`, `OnAfter`, `Handled`, `IsHandled`, `IncludedPermissionSets`, `Assignable`, `procedure`, `local procedure`, `Validate`, `Init`, `Insert`, `OnInsertRecord`, `Buffer`, `Caption`, `ToolTip`, `Label`, `Comment`, `CopyStr`, `MaxStrLen`, `TryFunction`, `Codeunit.Run`, `field(`, `value(`.
- Field-assignment shape: contiguous runs of `Record.Field := Value` statements on a non-buffer record variable inside a creator/method codeunit. Match against the `patterns` candidate `cmfrt-validate-not-assign`.
- API page triggers: `PageType = API` combined with `SourceTable` on a base application table, or an `OnInsertRecord` body containing `Rec.Insert` or `exit(false)`. Match against the `architecture` candidate `cmfrt-buffer-table-api-pattern`.

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
