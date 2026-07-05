---
bc-version: [all]
domain: naming
keywords: [caption, prefix, enum-value, field-caption, tooltip, table-level, page-override, translation]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT caption prefix and table-level captions

## Description

Captions in a CMFRT extension follow the same prefix rule as names: every field caption and every enum value caption carries the `CMFRT <ABBR>` prefix — for example `Caption = 'CMFRT AQ FS Journal Template Name'` on a field and `Caption = 'CMFRT AQ Pending'` on an enum value. Captions and tooltips are defined once, on the table field (or enum value), never overridden on pages. Pages inherit the table-level `Caption` and `ToolTip`, so the text is maintained in one place and every page showing the field stays consistent.

## Best Practice

Set `Caption` with the full `CMFRT <ABBR>` prefix and `ToolTip` on the table field definition. On pages, declare only `ApplicationArea` for the field — no `Caption`, no `ToolTip`. Give every enum value a prefixed caption matching its prefixed value name.

See sample: `cmfrt-caption-prefix.good.al`.

## Anti Pattern

An unprefixed caption (`Caption = 'Pending'`, `Caption = 'FS Journal Template Name'`), or a page field that repeats or overrides the table-level `Caption`/`ToolTip`. Unprefixed captions are indistinguishable from base-application text for users and translators, and duplicated page-level text drifts from the table definition the first time either copy is edited.

See sample: `cmfrt-caption-prefix.bad.al`.
