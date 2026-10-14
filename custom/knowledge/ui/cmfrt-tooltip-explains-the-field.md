---
bc-version: [all]
domain: ui
keywords: [tooltip, boilerplate, specifies-the-value, copilot, explain-field, enum-value, user-assistance, glossary]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT tooltips explain the field, not repeat its name

## Description

Copilot in Business Central reads the tooltip of a field to explain the field and to pick the right page for a question. Copilot ignores a field with no tooltip. A tooltip that only repeats the caption gives Copilot nothing to use. The 2026-10 Copilot readiness scan of 95 CMFRT apps found that 97.6% of the visible fields have a tooltip, but 80% of them are the generated text "Specifies the value of the X field". Only 11.5% explain something. The "Ask Copilot" link on such a field returns the caption again.

`custom/knowledge/naming/cmfrt-caption-prefix` decides where the tooltip goes: on the table field, inherited by the pages. This article decides what the tooltip says.

## Best Practice

- Start a field tooltip with "Specifies". Start an action tooltip with an imperative verb ("Create", "Send", "Calculate").
- Answer a question that the caption does not answer: what the value is used for, which values are valid, or what changes when the user sets it.
- For an enum or Option field, describe each value: "Open: lines can change. Approved: ready to post."
- For a Boolean field, say what happens when it is selected, and give the default.
- For a `CustomField` field with `CaptionClass = 'CmfrtCustField,…'`, the caption comes from the custom-field setup, but the tooltip is fixed. Say that the company defines the meaning: "Specifies a value that your company defines. The custom-field setup gives the field its name."
- Use the business term from the glossary in `custom/knowledge/naming/cmfrt-caption-whole-words`, not the AL name.
- Keep it under 200 characters, in one or two sentences, with no line breaks.
- Write only behavior that the code has. Read the code before you write the tooltip.

See sample: [`cmfrt-tooltip-explains-the-field.good.al`](cmfrt-tooltip-explains-the-field.good.al).

## Anti Pattern

- The generated text: `Specifies the value of the CMFRT JO Date field`, `Shows the value of the …`, `Specifies the CMFRT CLP Model field.`
- A `CustomField` tooltip that names the AL field: `Specifies the value of the CMFRTCustomField01 field`.
- A tooltip that holds the `CMFRT <ABBR>` prefix, a CamelCase AL name (`ProgressStateVersion`), a field number, or `Rec.`.
- A tooltip whose words are all in the caption: caption `Maintenance Validity`, tooltip `Maintenance Validity`.
- An action tooltip under 30 characters that only names the action: `Imports IFC file!`
- An enum field tooltip that does not name its values.

See sample: [`cmfrt-tooltip-explains-the-field.bad.al`](cmfrt-tooltip-explains-the-field.bad.al).

## See also

`custom/knowledge/naming/cmfrt-caption-prefix` puts the `Caption` and `ToolTip` on the table field. `microsoft/knowledge/style/tooltip-required-on-page-fields` covers the missing tooltip. `custom/knowledge/patterns/cmfrt-remediate-on-touch` decides when an existing tooltip in a changed object gets the fix.
