---
bc-version: [all]
domain: testing
keywords: [testnbr, issuenbr, testnbr-ledger, jira-key, issue-number]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT test procedure opens with the TESTNBR / ISSUENBR / SCENARIO header

## Description

Every `[Test]` procedure in a CMFRT test app opens with a fixed comment header: `[TESTNBR]`, `[ISSUENBR]` and `[SCENARIO]` as the first three comments after `begin`, followed by `[GIVEN]`, `[WHEN]` and `[THEN]` marking the sections of the body. `[TESTNBR]` is the test's identity across the whole CMFRT estate: one counter is shared by every CMFRT test app, so a number identifies exactly one test in exactly one app. `[ISSUENBR]` ties the test to the Jira ticket that required it. Together they let a failing test in a pipeline log be traced to its ticket without opening the source.

The convention is house-wide — about 1,676 `[TESTNBR]` lines across the CMFRT test apps — but it is defined nowhere else, so an agent working in a new or empty test app has nothing to copy and writes tests without it. This article takes precedence over `microsoft/knowledge/testing/test-feature-scenario-tags.md` for CMFRT test apps and restates the `[SCENARIO]`/`[GIVEN]`/`[WHEN]`/`[THEN]` rules it inherits from that article.

## Best Practice

Write the header as the first comments inside the procedure body, after `begin` and after the `var` block, in this order:

- `// [TESTNBR] 01919` — exactly five digits, zero-padded. Unique across **all** CMFRT test apps, not only the current one.
- `// [ISSUENBR] P25034-115` — the Jira key of the ticket the test was written for; the work slug when there is no ticket.
- `// [SCENARIO] …` — one falsifiable business claim in plain language that complements the procedure name rather than repeating it.
- `// [GIVEN] …`, `// [WHEN] …`, `// [THEN] …` — placed directly above the setup, the single action under test, and the assertions they describe. A long `[GIVEN]` may continue on the next comment line without repeating the tag.

Take `[TESTNBR]` values only from the shared TestNbrRegistry ledger through the `testnbr` skill (`~/.claude/skills/testnbr/`), one number per new `[Test]` procedure, passing the ticket key and the app name. The ledger is the only authority on which numbers are free; the skill's own documentation describes how a number is taken. If the skill fails, stop and report the failure — never fall back to another source. An existing test keeps its number when it is edited, renamed or moved to another codeunit; a deleted test's number is not reused.

A codeunit-level `[FEATURE]` comment is optional in CMFRT test apps (almost none use it) and is not a finding when absent.

See sample: [`cmfrt-test-procedure-header.good.al`](cmfrt-test-procedure-header.good.al).

## Anti Pattern

A `[Test]` procedure with no `[TESTNBR]`/`[ISSUENBR]` lines, or with the header moved below the setup code. The test runs, but it cannot be traced to a ticket and it holds no place in the shared numbering, so the next test written anywhere in the estate may take a number this one should have had.

A `[TESTNBR]` that is not five zero-padded digits. The current test apps contain unpadded values (`458`, `1364`), six-digit values (`001047`), per-app series (`SP-030`, `SP-031`, …) and placeholders (`TBD`). Each breaks sorting and lookup against the ledger.

A `[TESTNBR]` picked by hand: asking the user for a number, taking the highest number in the current code plus one, reading the next free value from the old shared Excel workbook, or inventing a number when the `testnbr` skill fails. The code of one app cannot show numbers already taken in another, and two developers working in parallel both see the same maximum. This is how the existing estate came to hold 60 five-digit values that occur on more than one test.

See sample: [`cmfrt-test-procedure-header.bad.al`](cmfrt-test-procedure-header.bad.al).
