---
bc-version: [all]
domain: naming
keywords: [caption, camelcase, abbreviation, glossary, business-term, project, progress-statement, enum-value, copilot, translation]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT captions use whole words and the glossary term

## Description

A caption is the name that the user, the translator and Copilot see. The object or field name has a 30-character limit, so it is often shortened: `"CMFRT JO IgnoreManualPrice"`. The caption has no such limit, but the 2026-10 Copilot readiness scan found the short form in the caption too: 296 CamelCase field captions, 189 captions with ad-hoc abbreviations, and 74 CamelCase enum value captions. The translation layer removes the `CMFRT <ABBR>` prefix and keeps the rest, so en-US users see `IgnoreManualPrice`.

The scan also found one concept with up to four names. Copilot cannot match "show my open progress statements" to a page that says "Progress State", or "project" to a caption that says "Job". The glossary below gives one term for each concept.

## Best Practice

- After the `CMFRT <ABBR>` prefix, write whole words with spaces: `CMFRT JO Ignore Manual Price`, not `CMFRT JO IgnoreManualPrice`.
- Use only the abbreviations that the base application uses in captions: `No.`, `Qty.`, `VAT`, `G/L`, `(LCY)`, `%`, `ID`, `URL`. Write all other words in full: `Template`, not `Templ`. `Purchase Invoice`, not `Purch. Inv.`.
- Give a new caption, `ToolTip`, `AboutText` and `Label` the canonical term from the glossary. Put the synonyms in `AdditionalSearchTerms` (`custom/knowledge/ui/cmfrt-page-teaching-tip-and-search-terms`).
- Give an enum value a caption that names a state, in whole words: `Sent`, not `Send`. Model an event, such as an export to Excel, as a log entry or a date field, not as a status value.
- Do not change the caption of a released field to apply the glossary. A new caption text loses its existing translations. Correct a released term in the translation files.

**Glossary**

| Canonical term | Synonyms for search terms | Dutch | Main object |
|---|---|---|---|
| Project | job, werf | project | `Job` (base application) |
| Project Type | job type | projecttype | `CMFRT JO Job Type` |
| Project Step | job step, user task step | projectstap | `CMFRT JO JobStep` |
| Bill of Quantities | measure state, measurement sheet | meetstaat | `CMFRT MS Job Measure State`, `CMFRT LT MeasureState` |
| Execution Statement | execution state, subcontractor claim | uitvoeringsstaat | `CMFRT MS Execution State Header` |
| Progress Statement | progress state, billing statement, payment application, progress billing | vorderingsstaat | `CMFRT MS ProgressStateVersion` |
| Budget Change Order | change order, budget change | budgetwijziging | `CMFRT CH ChangeHeader` |
| Price Request | purchase quote request, request for quotation | prijsaanvraag | `CMFRT PR Price Request Code` |

Add a new concept to this table in the same PR that adds its first caption.

See sample: [`cmfrt-caption-whole-words.good.al`](cmfrt-caption-whole-words.good.al).

## Anti Pattern

- A caption that copies a CamelCase or shortened object name: `CMFRT GU WarrantySchema`, `CMFRT JO TransportOrderList`, `CMFRT BA PrimaryKey`.
- An ad-hoc abbreviation: `CMFRT AP Max. Deviation Purch. Inv. approval in Amt.`, `CMFRT BIS Source PS Line State No.`
- A new caption or tooltip with a synonym instead of the canonical term: "Measure State" for a new Bill of Quantities field.
- An enum value caption that is a verb or an event: `Send`, `Exported to Excel`.
- A released caption that changes only to apply the glossary.

See sample: [`cmfrt-caption-whole-words.bad.al`](cmfrt-caption-whole-words.bad.al).

## See also

`custom/knowledge/naming/cmfrt-caption-prefix` requires the `CMFRT <ABBR>` prefix in the caption. `custom/knowledge/naming/cmfrt-object-name-30-char-limit` limits the object name, not the caption. `custom/knowledge/ui/cmfrt-tooltip-explains-the-field` uses the glossary term in tooltips.
