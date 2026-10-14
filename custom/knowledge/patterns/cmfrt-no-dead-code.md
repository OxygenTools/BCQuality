---
bc-version: [all]
domain: patterns
keywords: [dead-code, commented-out-code, empty-procedure, empty-trigger, snippet, myint, scaffold, cleanup, onvalidate]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT code ships no dead code

## Description

A CMFRT change does not ship code that does nothing. Three forms reach review:

- **Commented-out statements.** Old AL lines kept behind `//`.
- **An empty body.** A procedure or trigger whose `begin` is followed directly by `end`, such as an `OnValidate` trigger with no statements.
- **Snippet leftovers.** The `var myInt: Integer;` declaration and the empty body that the AL `tprocedure` snippet adds.

Git keeps the old code, so a commented-out block adds nothing that the history does not have. A reader cannot tell if the block is a fix in progress, a fallback or a mistake. An empty trigger has the same effect as no trigger, but it looks like behaviour that a later change removed, so the next reader opens the history to find out. PR 14643 shipped all three forms, and the review asked to remove each one.

## Best Practice

- Delete the lines that the change no longer needs. Git history keeps them.
- Delete an empty trigger.
- Delete an empty procedure, or give it its body in the same change.
- Delete every snippet leftover before the commit.

Some empty bodies are correct, because the platform or a signature makes them necessary:

- An event publisher (`[IntegrationEvent]`, `[BusinessEvent]`, `[InternalEvent]`) has an empty body by design.
- A test handler (`[MessageHandler]`, `[ConfirmHandler]`, `[ModalPageHandler]` and the other handler attributes) can have an empty body when it only accepts the dialog.
- An `[Obsolete]` procedure is out of scope. `cmfrt-never-delete-always-obsolete` decides what its body holds.
- An interface method that has nothing to do in one implementation can have an empty body. The body then holds a one-line comment that says why.

See sample: [`cmfrt-no-dead-code.good.al`](cmfrt-no-dead-code.good.al).

## Anti Pattern

Commented-out AL statements left in a changed file. An `OnValidate`, `OnRun` or other trigger with no statements. A procedure with no statements, and no event or handler attribute. A `myInt` variable, or any other declaration that the code does not use. An empty `begin` and `end` pair inside a procedure, such as `if Found then begin end;`.

See sample: [`cmfrt-no-dead-code.bad.al`](cmfrt-no-dead-code.bad.al).

## See also

`custom/knowledge/patterns/cmfrt-remediate-on-touch.md` decides if dead code that the change did not add is in scope. `custom/knowledge/patterns/cmfrt-case-requires-else.md` covers an empty `case` branch.
