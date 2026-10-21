---
bc-version: [all]
domain: patterns
keywords: [boolean, condition, comparison, assignment, readability, if-then, default-value, ishandled]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT code sets a Boolean with an explicit if, not from a comparison

## Description

AL lets you assign the result of a comparison to a Boolean in one statement, for example `IsSkipped := Item.Type = Item.Type::"Non-Inventory";`. The line holds two `=` signs with different meanings, and the reader must work out which value the variable gets in which case. CMFRT reviewers reject this form. Source: the review of PR 14836 (ZC_CMFRT_AquaSecurity), where the reviewer voted "waiting for author" on this line.

The explicit form `if <condition> then IsSkipped := true;` shows the case that sets the flag. It also matches how an event flag must work: a subscriber only sets a shared flag to `true` and never resets it to `false`. Microsoft gives the same rule for the database trigger setup flags in `microsoft/knowledge/events/database-trigger-setup-flags-may-only-be-set-to-true`.

The rule applies to every Boolean target: a local variable, a global, a `var` parameter and a Boolean field. It applies when the right side of `:=` holds a comparison: `=`, `<>`, `<`, `>`, `<=`, `>=` or `in [...]`. These forms are not in scope:

- `exit(A = B)`, because it is not an assignment.
- `Flag := Flag or IsTracked(TableId)`, because it holds no comparison.
- `Flag := Rec.FindFirst()` and other calls that return a Boolean.
- A page property expression such as `Visible = ShowDetails`.

## Best Practice

Write `if <condition> then <Flag> := true;`. When the false case also needs code, write `if <condition> then <Flag> := true else <Flag> := false;`, or use `case true of`.

Give the default value before the `if` only when the old value can carry over. That is the case for a `var` parameter that you own, a global, a field, and a variable that a loop uses again. A fresh local Boolean starts as `false`, so it needs no `:= false`. This agrees with `events/cmfrt-onbefore-do-onafter`. Never set an event `var` flag such as `IsHandled` to `false`, because that removes the `true` value of an earlier subscriber.

See sample: [`cmfrt-boolean-from-explicit-if.good.al`](cmfrt-boolean-from-explicit-if.good.al).

## Anti Pattern

A comparison on the right side of `:=` with a Boolean target, for example `IsSkipped := Item.Type = Item.Type::"Non-Inventory";` or `IsBlocked := Customer.Blocked in [Customer.Blocked::All, Customer.Blocked::Invoice];`. In a subscriber, `IsHandled := SalesHeader."No." = '';` is worse: it also sets the flag to `false` when another subscriber already set it to `true`.

See sample: [`cmfrt-boolean-from-explicit-if.bad.al`](cmfrt-boolean-from-explicit-if.bad.al).
