---
bc-version: [all]
domain: patterns
keywords: [confirm, confirmmanagement, dialog, user-confirmation, test, automation, testability]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT use ConfirmManagement instead of Confirm

## Description

CMFRT AL code must use the `"Confirm Management"` codeunit to prompt the user for confirmation instead of calling the `Confirm` built-in function directly. `"Confirm Management"` wraps `Confirm` and resolves confirmation dialogs without displaying UI during automated test runs, making test behaviour deterministic. The `Confirm` built-in always renders a modal dialog regardless of execution context, which causes automated tests to hang waiting for user input.

## Best Practice

Declare `ConfirmManagement: Codeunit "Confirm Management";` as a local variable and call `ConfirmManagement.GetResponseOrDefault(QuestionLbl, true)`. The codeunit suppresses the dialog automatically in test context. Use a `Label` for the question text so it is translatable.

See sample: `cmfrt-use-confirmmanagement.good.al`.

## Anti Pattern

Calling `if Confirm(QuestionText, true) then` directly. Direct `Confirm` calls are not interceptable by the test framework: the modal dialog appears during automated test runs, causing the test to stall indefinitely or fail with a UI-interaction error. Tests that hit a `Confirm` call cannot be run in a CI pipeline without manual intervention.

See sample: `cmfrt-use-confirmmanagement.bad.al`.
