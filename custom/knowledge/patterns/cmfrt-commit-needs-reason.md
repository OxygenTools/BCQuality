---
bc-version: [all]
domain: patterns
keywords: [commit, transaction, write-transaction, rollback, comment, error-status, codeunit-run]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT code gives every Commit() a reason

## Description

Every explicit `Commit()` in CMFRT code has a comment that says why the transaction must end at that point. The comment is on the line above the `Commit()` or at the end of the same line.

A `Commit()` ends the write transaction. An error after it does not roll back the writes before it, so the commit changes what the user sees when the process fails. A reader cannot see from the code which of those writes must survive, or if the commit is only a leftover. The review asks the same question each time: "commit, without comment?" (PR 14521, a `Commit()` after the `Modify` of an error status).

## Best Practice

Put the reason on the line above the `Commit()`. Name one of these:

- **A platform rule.** `Codeunit.Run` with a return value, or `RunModal`, inside an open write transaction needs the commit first. `cmfrt-codeunit-run-not-tryfunction` owns that case.
- **A write that must survive a later error.** An error status, a log row or an outcome row that the next step or the next run reads.
- **A separate unit of work.** A batch that commits after each document, so that one failure does not undo the documents that already passed.

A comment that only repeats the code, such as `// Commit`, is not a reason.

See sample: [`cmfrt-commit-needs-reason.good.al`](cmfrt-commit-needs-reason.good.al).

## Anti Pattern

A `Commit()` with no comment. A `Commit()` whose comment repeats the code. A `Commit()` that has no reason at all and stays because removing it looks risky. Remove that commit and test the failure path.

See sample: [`cmfrt-commit-needs-reason.bad.al`](cmfrt-commit-needs-reason.bad.al).

## See also

`custom/knowledge/patterns/cmfrt-codeunit-run-not-tryfunction.md` covers the `Commit()` before a `Codeunit.Run` in a buffer sweep. `microsoft/knowledge/performance/avoid-commit-inside-loops.md` covers a commit inside a loop. This article adds the comment to both.
