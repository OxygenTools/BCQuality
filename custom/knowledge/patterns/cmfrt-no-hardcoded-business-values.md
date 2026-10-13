---
bc-version: [all]
domain: patterns
keywords: [hardcoded-value, business-value, literal, magic-string, setup-field, no-series, number-range, threshold, token, configuration]
technologies: [al]
countries: [w1]
application-area: [all]
---

# A business value lives in setup, not as a literal in code

## Description

A business value is a value that a consultant or a customer can want to change: a number range for generated codes, a placeholder token in a text template, a time threshold, a location or template code, a G/L account, a URL. When such a value is a literal in AL, a different value for one customer needs a code change and a release. When the same literal sits in several objects, the copies drift apart the first time someone changes one of them.

The CMFRT reviews show both forms. PR 14725 generated VAT clause codes from the literal range `'PVC0000000'..'PVC9999999'` and recognised a template variable by the literal token `'%99'`. PR 14573 put a 15-minute "stuck" threshold as a constant in six processing codeunits. In each case the reviewer asked for setup, and the fix added a setup field.

`cmfrt-initvalue-not-code-default` covers a different question: where the default of a setting that is already in setup lives. This article decides the earlier question: whether a value is a setting at all.

## Best Practice

Ask one question for each literal: can a consultant need a different value for one customer? When the answer is yes, the value is a setting.

- **Generated numbers** come from a No. Series. Put a `Code[20]` field with `TableRelation = "No. Series"` on the app's setup table, and get the next number with codeunit `"No. Series"` (`GetNextNo`). Do not build a number range from a prefix and a counter in code.
- **Thresholds, tokens, codes, accounts and URLs** come from a field on the app's setup table. Give the field its default as `cmfrt-initvalue-not-code-default` describes, and read it through one getter procedure on the setup table, so there is one read site for each value.
- **One value, one field.** When several objects need the value, they all call the same getter. They never keep their own copy.

These literals can stay in code: `0`, `1`, a blank text or code, platform identifiers (`Database::Customer`, `Page::"Sales Order"`, an enum value), and a technical identifier that an external contract fixes, such as a JSON key or an API field name, declared as a `Label` with `Locked = true`.

See sample: [`cmfrt-no-hardcoded-business-values.good.al`](cmfrt-no-hardcoded-business-values.good.al).

## Anti Pattern

A business value written as a literal: a code range in `SetRange` or `SetFilter`, a token that a parser looks for, a threshold in a date or time calculation, a location code or template name assigned to a field. Two variants survive review most often:

- The same literal copied into several codeunits, so one change needs several edits and a missed copy gives two behaviours.
- The literal moved into a `Label`, a constant-returning local procedure (`local procedure Token(): Text begin exit('%99'); end;`) or a `case` arm. The value is still hardcoded. It only moved.

See sample: [`cmfrt-no-hardcoded-business-values.bad.al`](cmfrt-no-hardcoded-business-values.bad.al).

## See also

- `custom/knowledge/patterns/cmfrt-initvalue-not-code-default.md` gives the setup field its default, once.
- `microsoft/knowledge/performance/batch-number-series-instead-of-getnextno-per-row.md` covers number series in a loop.
