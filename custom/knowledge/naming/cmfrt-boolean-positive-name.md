---
bc-version: [all]
domain: naming
keywords: [boolean, setup, setup-field, field-name, enabled, disabled, polarity, double-negative, initvalue, tooltip]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT Boolean setup fields have a positive name

## Description

A Boolean field on a setup table turns a feature on or off. A CMFRT setup field gets the name of the state that it turns on: `CMFRT NS ABR Posting Enabled`, not `CMFRT NS ABR Posting Disabled`. A negative name gives the user a double negative. To start the posting, the user must clear a field that says "Disabled". The code has the same problem: `if not NSSetup."CMFRT NS ABR Posting Disabled" then` is harder to read than `if NSSetup."CMFRT NS ABR Posting Enabled" then`. In PR 14444 a new setup field had the name "ABR posting disabled", and the review proposed "enabled".

This rule applies to a new field on a setup or configuration table. A released field keeps its name. `custom/knowledge/breaking-changes/cmfrt-never-delete-always-obsolete` decides how to replace it. A status field on a master or document record, such as `Blocked` on a customer, keeps the name that the base application uses.

## Best Practice

- Give a Boolean setup field the name of the state that it turns on: `… Enabled`, `Allow …`, `Use …` or `Post …`.
- Write the `ToolTip` for the selected state, and say what the default is.
- Before you flip the polarity, check the effect on the existing data. A new field is `false` on every setup record that exists before the upgrade. When the feature works today, a positive name with a `false` value turns the feature off. Then set `InitValue = true` for new records, and set the field to `true` on the existing setup record in an upgrade codeunit. `custom/knowledge/patterns/cmfrt-initvalue-not-code-default` gives the steps for the existing rows.

See sample: [`cmfrt-boolean-positive-name.good.al`](cmfrt-boolean-positive-name.good.al).

## Anti Pattern

A Boolean setup field with a name for the inactive state: `… Disabled`, `Skip …`, `Do Not …`, `No …` or `Block …`. Each `if not` on such a field is a double negative. A user who wants the feature must clear a box.

A field that has a positive name, `InitValue = true` and no upgrade step. New companies get the feature, but on existing companies the field is `false`, and the feature stops after the upgrade.

See sample: [`cmfrt-boolean-positive-name.bad.al`](cmfrt-boolean-positive-name.bad.al).

## See also

`custom/knowledge/patterns/cmfrt-initvalue-not-code-default` owns the default value of a new setup field and the upgrade step for existing records. `custom/knowledge/naming/cmfrt-caption-prefix` sets the `Caption` and `ToolTip` on the table field.
