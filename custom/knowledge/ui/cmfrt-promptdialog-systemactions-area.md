---
bc-version: [23..]
domain: ui
keywords: [promptdialog, systemaction, systemactions, copilot, generate, regenerate, attach, ok, cancel, promptguide]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT PromptDialog system actions go inside area(SystemActions)

## Description

A page with `PageType = PromptDialog` (runtime 12.1 and later) has a fixed set of buttons for the Copilot flow. AL calls them system actions. The names are `Generate`, `Regenerate`, `Attach`, `OK` and `Cancel`. You declare each one with a `systemaction(<Name>)` control.

A `systemaction` control is valid only inside `area(SystemActions)` of the `actions` section. AL has no `systemactions` keyword at the level of the page. A PromptDialog page has two action areas only: `SystemActions` and `PromptGuide`. The layout areas are a different set: `Prompt`, `Content` and `PromptOptions`.

The design document of a Copilot feature often shows the dialog as a sketch, and a sketch with a block named `systemactions` reads like real AL. When the code copies that sketch, the parser closes the page at that line. It then reads the rest of the file as new objects. The compiler gives many errors, for example AL0104, AL0107, AL0114 and AL0198. VS Code can also show an AL0197 "already declared" error on a different object that is correct, because the parser reads a later variable line of the page as a second declaration. The error list then points away from the real cause.

Source: [The PromptDialog page type](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-page-type-promptdialog), [Design the prompt mode](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/copilot-design-prompt-mode) and [Design the content mode](https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/copilot-design-content-mode).

## Best Practice

Put every system action in `area(SystemActions)` of the `actions` section. Write `actions { area(SystemActions) { systemaction(OK) { ... } systemaction(Cancel) { ... } } }`.

- Use only the names `Generate`, `Regenerate`, `Attach`, `OK` and `Cancel`.
- Put prompt guides in `area(PromptGuide)`, also in the `actions` section. Use no other action area on a PromptDialog page.
- `Caption`, `ToolTip` and `Enabled` apply to a system action. `Enabled` accepts a global Boolean variable of the page.
- Without a declaration, `OK` shows the caption **Keep it** and `Cancel` shows **Discard**. Declare them only to change the caption, the tooltip or `Enabled`.
- When a design document shows the dialog, write the actions in this AL form, not as a sketch.

See sample: [`cmfrt-promptdialog-systemactions-area.good.al`](cmfrt-promptdialog-systemactions-area.good.al).

## Anti Pattern

A `systemactions { ... }` block at the level of the page, or a `systemaction(...)` control outside `area(SystemActions)`. Also wrong: an action area other than `SystemActions` or `PromptGuide` on a PromptDialog page, or a system action name outside the fixed set.

The symptom is a set of parse errors on the page, and possibly an AL0197 error on another object in the same app. Before you analyze the AL0197 error, look for a `systemactions` block in the PromptDialog page.

See sample: [`cmfrt-promptdialog-systemactions-area.bad.al`](cmfrt-promptdialog-systemactions-area.bad.al).
