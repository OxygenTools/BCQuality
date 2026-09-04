---
bc-version: [all]
domain: patterns
keywords: [codeunit-run, tryfunction, error-trap, commit, write-transaction, getlasterrortext, clearlasterror, buffer, sweep]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT traps row-worker errors with Codeunit.Run and keeps the Commit that makes it legal

## Description

When a CMFRT sweep processes buffer rows one at a time, the error boundary is `Codeunit.Run` with its return value captured — `if not Worker.Run(Rec) then`. The row's own outcome write must survive the worker's failure, which means the worker needs its own rollback boundary, and `Codeunit.Run` is the only primitive that provides one. `[TryFunction]` is not an alternative here: per `microsoft/knowledge/performance/use-tryfunction-for-error-catching-not-rollback.md`, a try method catches the error but does not unwind anything, so a half-written row survives the catch. The attribute does appear in house code as a local trap around pure computation (evaluating a user-supplied formula, for instance); that use is out of scope for this article and is not what a row worker needs.

Once `Codeunit.Run` is the boundary and the caller has already written to the database, the platform rule applies: "If you're already in a transaction you must commit first before calling `Codeunit.Run`." So in this pattern the `Commit()` before the `Run` is correct code, not a finding. This supersedes `microsoft/knowledge/performance/codeunit-run-requires-prior-commit-inside-transaction.md` for the sweep case — record it in `suppressed` with `reason: "layer-precedence"`. That article's alternatives (keep the outer scope read-only, or defer all logging until after the loop) are unavailable to a sweep whose entire purpose is to record each row's outcome as it goes, and whose next run must not re-process a row whose outcome was already produced.

## Best Practice

Capture the result inline — `if not Worker.Run(Rec) then ... else ...` — rather than in a boolean tested later. `Clear` the codeunit variable before each `Run` so nothing carries over between calls. Read `GetLastErrorText()` immediately in the failure branch and call `ClearLastError()` straight after, so a later catch cannot inherit the message.

Place the `Commit()` immediately before the `Run` and **say in a comment why it is there** — name the platform rule, or the functional guarantee the commit protects when that is the real reason it must stay. A bare `Commit()` draws the same review question on every pull request; a commit whose comment cites only the platform rule while its actual justification is functional draws it twice.

Where the surrounding work is a loop over buffer rows, `cmfrt-buffer-status-loop-shape` owns the loop's shape.

A worker that only reads — a `Get`/`Error` validator holding read permissions only — gains no rollback boundary from `Codeunit.Run`, because it has nothing to unwind. The choice of primitive for such a worker is therefore not governed by this article, and a try method is an acceptable trap there. What does not change is the platform rule, which keys on the *caller's* open write transaction rather than on what the callee writes: a caller that has already written and still calls `Codeunit.Run` needs the `Commit()` regardless of the worker being read-only. Dropping the `Codeunit.Run` is what removes the commit, and that is a judgement about the worker, not about the commit.

See sample: `cmfrt-codeunit-run-not-tryfunction.good.al`.

## Anti Pattern

Using `[TryFunction]` as the boundary around a row worker: the compiler accepts it, the error is caught, and the row's partial writes stay. Removing the `Commit()` that makes `Codeunit.Run` legal on the strength of the Microsoft-layer articles — that also compiles, and fails at runtime on the first row. Leaving such a `Commit()` with no comment at all, so the next reviewer asks the question again. Reading `GetLastErrorText()` without a following `ClearLastError()`.

See sample: `cmfrt-codeunit-run-not-tryfunction.bad.al`.

## See also

`custom/knowledge/patterns/cmfrt-buffer-status-loop-shape.md` owns the loop shape this pattern is normally embedded in.
