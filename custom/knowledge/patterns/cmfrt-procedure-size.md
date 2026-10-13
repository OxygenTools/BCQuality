---
bc-version: [all]
domain: patterns
keywords: [procedure-size, long-procedure, split-procedure, local-procedure, readability, single-responsibility, refactor, do-procedure]
technologies: [al]
countries: [w1]
application-area: [all]
---

# A procedure body stays within 40 lines

## Description

A long procedure hides its steps. The reader must read every line to find where one step ends and the next starts, and a change to one step risks the others. The CMFRT reviews asked twice to split a procedure: a 72-line `DoCMFRTASSyncUserAccess` with 20 local variables (PR 14670) and a 126-line `DoCMFRTEKApplyReleaseOrderChecks` (PR 14647). After the split, the largest procedure in those files had 35 and 26 lines, and the reviewer accepted both. The limit below sits between those numbers.

## Best Practice

Keep each procedure body within **40 lines**: the lines between the procedure's `begin` and its matching `end`, blank and comment lines included. The `var` block does not count.

When a body grows past 40 lines, split it into local procedures, one for each step, and give each a name that says what the step does (`CMFRTEKLoadSelection`, `CMFRTEKAddPreviousSlices`). The procedure that remains reads as a list of those steps. Each new local procedure carries the CMFRT prefix (`cmfrt-naming-prefix`) and goes in the local-procedure section of the codeunit (`cmfrt-codeunit-member-order`).

More than about 15 local variables is a second signal: the procedure does more than one thing. Split it by concern, not by line count alone.

One exception: a flat `case` that only sends each value to one call can pass 40 lines, because every arm is one line and the arms do not depend on each other.

See sample: [`cmfrt-procedure-size.good.al`](cmfrt-procedure-size.good.al).

## Anti Pattern

A `Do…` procedure that loads data, filters it, decides, asks the user and writes, all in one body of 70 lines or more. A split that does not help is the same defect: helper procedures named `Part1` and `Part2`, or helpers that each take eight `var` parameters because the state was never grouped.

See sample: [`cmfrt-procedure-size.bad.al`](cmfrt-procedure-size.bad.al).

## See also

`custom/knowledge/architecture/cmfrt-one-codeunit-one-function.md` keeps a codeunit to one entry point. This article keeps each procedure inside it short.
