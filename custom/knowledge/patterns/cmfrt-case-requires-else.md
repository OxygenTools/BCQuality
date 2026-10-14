---
bc-version: [all]
domain: patterns
keywords: [case, else, defensive-coding, unhandled-case, enum, option, silent-failure, empty-branch]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT CASE statement requires ELSE clause

## Description

Every `case` statement in CMFRT AL code has an `else` clause. The rule has no exception. The `else` clause is necessary even when the `case` lists every value that exists today, because a later change can add a value to an enum, an option field or an integer range. Without `else`, the new value goes through the `case` block with no error and no action. The result is a silent no-op or wrong data, and nobody can easily find the cause, because the `case` looked correct when someone wrote it.

## Best Practice

Add an `else` clause to every `case` statement. When no action applies to an unexpected value, the `else` clause raises an error that names the value, writes a log entry, or calls a procedure that handles it. The unexpected value must show at runtime. It must not pass silently.

No branch is empty. A branch that holds only `;` looks like a missing statement, and the review asks about it ("empty case?", PR 14526). Put the values that need no action together in one branch. When no code follows the `case`, that branch uses `exit` with a one-line comment that says why. When code follows the `case`, test those values before the `case` instead.

See sample: [`cmfrt-case-requires-else.good.al`](cmfrt-case-requires-else.good.al).

## Anti Pattern

A `case` statement that lists every value known today and has no `else`. The code looks complete. When a developer or a base application update adds a new enum value, that value goes through the whole `case` block with no action, and the failure is silent.

A branch that holds only `;`, with or without a comment, so that the values pass the `else` without an error.

See sample: [`cmfrt-case-requires-else.bad.al`](cmfrt-case-requires-else.bad.al).
