---
bc-version: [all]
domain: patterns
keywords: [case, else, defensive-coding, unhandled-case, enum, option, silent-failure]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT CASE statement requires ELSE clause

## Description

Every `case` statement in CMFRT AL code must include an `else` clause. The rule is unconditional: even when every currently known value of the matched expression is enumerated, the `else` clause guards against future values being added to an enum, option field, or integer range. Without `else`, a new value passes through the `case` block silently — no error, no action — and the resulting silent no-op or data corruption is difficult to trace because the `case` appears correct at the time it was written.

## Best Practice

Always add an `else` clause to every `case` statement. When no meaningful action applies to unexpected values, the `else` clause should raise an error that identifies the unexpected value, log it, or call a dedicated handler procedure. The key outcome is that the unexpected case is detected at runtime rather than silently ignored.

See sample: `cmfrt-case-requires-else.good.al`.

## Anti Pattern

Writing a `case` statement that enumerates all currently known values and omits `else`. The code appears complete but becomes a silent failure mode the moment a new enum value is added by a future developer or by a base application update, because the added value simply falls through the entire `case` block.

See sample: `cmfrt-case-requires-else.bad.al`.
