---
bc-version: [all]
domain: patterns
keywords: [maxstrlen, copystr, truncation, magic-number, field-length, overflow, string]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT use MaxStrLen in CopyStr, never a literal length

## Description

When CMFRT code truncates a text value to fit a field, the length argument of `CopyStr` must be `MaxStrLen(TargetRecord.TargetField)`, never a numeric literal. The field is the single source of truth for its own length; a hardcoded number silently diverges the moment the field is widened or the code is copied to a field of a different size, producing either needless truncation or a runtime overflow error.

## Best Practice

Write `Rec."CMFRT AQ User ID" := CopyStr(UserId(), 1, MaxStrLen(Rec."CMFRT AQ User ID"));`. The expression stays correct through any future field-length change and documents intent: truncate to whatever fits the target.

See sample: `cmfrt-maxstrlen-copystr.good.al`.

## Anti Pattern

`CopyStr(UserId(), 1, 50)` — the literal encodes the field length at the time of writing. Widening the field leaves data truncated at the stale length; narrowing it turns the assignment into a runtime "length exceeds" error that only fires on long values in production.

See sample: `cmfrt-maxstrlen-copystr.bad.al`.
