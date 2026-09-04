---
bc-version: [all]
domain: patterns
keywords: [buffer, staging, status, loop, setcurrentkey, setfilter, findset, codeunit-run, commit, extensible-enum]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT buffer-row processing loops have a fixed shape

## Description

Processing the pending rows of a buffer (staging) table is the recurring CMFRT shape: iterate the rows, run a worker per row behind `Codeunit.Run`, write the outcome back on the row. It appears in every module that owns an inbound interface, so the shape is fixed and reads the same everywhere. The status set is narrowed by a filter **before** the loop rather than by an `if` guard inside it, the loop sorts on the primary key, and the outcome branch is a flat `if not Worker.Run(Rec) then ... else ...` with no captured boolean.

Two details are load-bearing rather than cosmetic: the sort key, which decides whether it is safe to filter on the field the loop writes, and the position of any side-effect write relative to the `Commit()`.

The per-row `Commit()` is deliberate and supersedes `microsoft/knowledge/performance/avoid-commit-inside-loops.md` by layer precedence — record that file in `suppressed` with `reason: "layer-precedence"`. A sweep is not one atomic batch: each row's outcome must be durable on its own, so a failure on row 40 neither discards the 39 outcomes already produced nor causes them to be processed twice on the next run. The commit is also what makes the next row's `Codeunit.Run` legal — see `cmfrt-codeunit-run-not-tryfunction`.

## Best Practice

- **Filter the status before the loop**, stated positively: `SetFilter("... Status", '%1|%2', Status::New, Status::Error)`. Buffer status enums are declared `Extensible = true`, so an excluding filter such as `<>Processed` silently picks up a value a later extension adds.
- **`SetCurrentKey` the primary key.** The loop writes the status field, which normally also sits in a grouping key; sorting on the primary key ties the cursor to the entry number rather than to the field being written, so a row cannot move out from under the loop. Filtering on that written field is then safe as long as every outcome the loop writes stays inside the filter — check that explicitly and say so in a comment.
- **Read without `FindSet(true)`** when a `Codeunit.Run` follows inside the loop: a locking read opens the write transaction before the first iteration, which the `Run` cannot nest inside. Each row is locked by its own `Modify` instead.
- **Branch flat.** Repeat the `Modify` in both branches rather than hoisting it out behind a boolean flag — the flag costs a variable and two tests to save one line.
- **A side-effect write that accompanies a failure** — a User Task, a notification, a log row — goes inside the failure branch, after the `Modify` and before the `Commit()`. Such an insert re-opens the write transaction the `Commit()` exists to close for the next iteration's `Codeunit.Run`, so placing it after the commit breaks the following row rather than the current one.

See sample: `cmfrt-buffer-status-loop-shape.good.al`.

## Anti Pattern

Reading the full set and skipping rows with an `if` inside the loop. `SetFilter(..., '<>%1', Status::Processed)` on an extensible status enum. Sorting on the grouping key that contains the status field the loop writes, which lets rows move out from under the cursor as they are updated. Capturing the `Run` result in a local boolean and testing it twice. `FindSet(true)` ahead of an in-loop `Codeunit.Run`. Placing the notifier or log write after the `Commit()`.

See sample: `cmfrt-buffer-status-loop-shape.bad.al`.

## See also

`custom/knowledge/patterns/cmfrt-codeunit-run-not-tryfunction.md` owns the choice of error-trap primitive and the commit obligation that follows from it.
`custom/knowledge/architecture/cmfrt-buffer-table-api-pattern.md` owns the buffer table and API page this loop consumes.
