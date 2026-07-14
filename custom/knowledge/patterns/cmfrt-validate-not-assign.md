---
bc-version: [all]
domain: patterns
keywords: [validate, assignment, onvalidate, field-population, buffer, creator, direct-assignment]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT populate real tables via Validate, not direct assignment

## Description

When CMFRT code populates fields on a real (non-buffer) table — Job, Sales Header, Sales Line, Job Planning Line, Ship-to Address, Transfer Header and the like — each field must be set with `Record.Validate(Field, Value)` so the field's `OnValidate` trigger logic runs. Direct assignment (`Record.Field := Value`) silently skips validation, dependent-field copying, posting-group checks, and any subscriber logic attached to the field. Two exceptions apply: primary-key and document-number fields that are set as part of record identity are assigned directly (validating them can renumber or re-key the record), and buffer/staging tables are always filled by direct assignment because they carry no business logic.

## Best Practice

In creator and method codeunits that transfer buffer values into real tables, call `Validate` for every business field: `Job.Validate(Description, Buffer."CMFRT AQ Description");`. Keep primary-key fields (`Job."No." := ...`, `SalesLine."Document No." := ...`) as direct assignments, set immediately after `Init()`. Fill buffer tables by direct assignment.

See sample: `cmfrt-validate-not-assign.good.al`.

## Anti Pattern

Filling a real table field-by-field with `:=`. The record is inserted with unvalidated data: posting-group checks never run, dependent fields (ship-to copies, cost fields, status transitions) stay empty or stale, and downstream extensions subscribed to `OnValidate` never fire. The defect surfaces later as inconsistent data that is hard to trace back to the skipped trigger.

See sample: `cmfrt-validate-not-assign.bad.al`.
