---
bc-version: [all]
domain: patterns
keywords: [label, local-scope, global-var, comment-attribute, placeholder, translation, strsubstno]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT Labels are local with documented placeholders

## Description

`Label` variables in CMFRT code are declared in the `var` section of the one procedure that uses them, not in the codeunit's global `var` section. Every label whose text contains `%1`-style placeholders carries a `Comment` attribute documenting each placeholder (`Comment = '%1 = Job No.'`). Global label sections accumulate text that no procedure references anymore, and undocumented placeholders leave translators guessing what will be substituted.

## Best Practice

Declare each label local to the procedure (usually the `Do<Name>` procedure) that passes it to `Error`, `Message`, `Confirm Management`, or `StrSubstNo`. Add `Comment` naming every placeholder. When review moves logic into a `Do` procedure, move its labels with it.

See sample: `cmfrt-labels-local-scope.good.al`.

## Anti Pattern

Labels declared in the codeunit-level `var` section, or placeholder labels without a `Comment` attribute. Global labels outlive their callers as dead text, are shared between unrelated procedures, and their missing placeholder documentation produces mistranslations that only surface in localized builds.

See sample: `cmfrt-labels-local-scope.bad.al`.
