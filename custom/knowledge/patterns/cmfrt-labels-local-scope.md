---
bc-version: [all]
domain: patterns
keywords: [label, local-scope, global-var, comment-attribute, placeholder, translation, strsubstno, locked, text-literal, call-code]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT Labels are local with documented placeholders

## Description

`Label` variables in CMFRT code are declared in the `var` section of the one procedure that uses them, not in the codeunit's global `var` section. Every label whose text contains `%1`-style placeholders carries a `Comment` attribute documenting each placeholder (`Comment = '%1 = Job No.'`). Global label sections accumulate text that no procedure references anymore, and undocumented placeholders leave translators guessing what will be substituted.

## Best Practice

Declare each label local to the procedure (usually the `Do<Name>` procedure) that passes it to `Error`, `Message`, `Confirm Management`, or `StrSubstNo`. Add `Comment` naming every placeholder. When review moves logic into a `Do` procedure, move its labels with it.

A technical text literal also goes in a local `Label` with `Locked = true`. Examples are a call code such as `'V1'`, a path, or a JSON key. Do not pass these as text literals to a procedure call, an assignment or a comparison. PR 14938 (DocSign) shows the case. The reviewer wrote "strings in labels !!" on a codeunit that already used locked labels for paths and JSON keys, but still passed call codes as text literals. A `Locked` label has no `Comment` attribute, because nobody translates it.

This rule overrides the allowance in `patterns/cmfrt-no-hardcoded-business-values` that a technical identifier "can stay in code". The identifier still stays out of setup. It now also stays out of a bare literal. It agrees with `microsoft/knowledge/style/label-locked-for-non-translatable`.

See sample: [`cmfrt-labels-local-scope.good.al`](cmfrt-labels-local-scope.good.al).

## Anti Pattern

Labels declared in the codeunit-level `var` section, placeholder labels without a `Comment` attribute, or a technical text literal such as `'V1'` in code instead of a locked label. Global labels outlive their callers as dead text, are shared between unrelated procedures, and their missing placeholder documentation produces mistranslations that only surface in localized builds.

See sample: [`cmfrt-labels-local-scope.bad.al`](cmfrt-labels-local-scope.bad.al).

## Related

`patterns/cmfrt-no-object-level-vars` states the same local-scope rule for every other variable type and lists the structural exceptions where object scope is required. This article stays the more specific case: it additionally requires the `Comment` placeholder attribute. Cite this article for a global `Label`, the general one for anything else.
