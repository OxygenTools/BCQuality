---
bc-version: [all]
domain: naming
keywords: [naming, object-name, field-name, length, 30-characters, prefix, cmfrt, abbreviation, budget]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT names must fit the 30-character limit including the prefix

## Description

Business Central limits object names and table field names to 30 characters. The CMFRT convention in `cmfrt-naming-prefix.md` uses part of them for the prefix `CMFRT <ABBR> `. The budget for the descriptive name is **30 - len("CMFRT <ABBR> ")**:

| Prefix | Prefix length | Budget |
|---|---|---|
| `CMFRT AM ` | 9 | 21 |
| `CMFRT GDW ` | 10 | 20 |
| `CMFRT HRMT ` | 11 | 19 |

`CMFRT` comes from `mandatoryPrefix` in `appsourcecop.json`. Take `<ABBR>` from the names of the objects that the module already declares, never from the repo name. ZC_CMFRT_Lippens, for example, uses `LI`. The abbreviation does not always have two letters: `GDW`, `DAG` and `WDS` have three, `HRMT` has four. A budget of 21 for every module lets a name with a three-letter abbreviation pass the count and fail at 31 characters. Each budget is tighter than the general guidance in `microsoft/knowledge/style/object-name-30-char-limit.md`, which assumes a 3–4-character AppSource affix and reports a budget of about 26.

The failure is almost never a name that is obviously too long. It is a descriptive name chosen at a comfortable length, which then breaks the moment the mandatory prefix is applied — the name compiles while unprefixed, so the problem surfaces late, either at review (where it violates `cmfrt-naming-prefix.md`) or at publish. Plan each name inside the budget from the start. Do not shorten it afterwards.

## Best Practice

Count the full shipping name — prefix included — before committing to it. For every declared object name, table field name, and enum value name:

- `length(name) > 30` — over the platform limit; it will not publish.
- `length(descriptive part) > 30 - len("CMFRT <ABBR> ")` for the `CMFRT <ABBR> <Name>` form — the prefix cannot be added without breaching 30, so either the name or the prefix has to give, and the prefix is not negotiable.
- Measure a name that still misses its prefix as `length(name) + len("CMFRT <ABBR> ")`: + 9 for `AM`, + 10 for `GDW`.

Spaces and the trailing `.` of an established abbreviation count toward the total. Aim for 12–18 characters of descriptive name so a later rename (adding `Entry`, `Line`, or `Buffer`) still fits. When abbreviation is genuinely needed, use abbreviations the base application already established (`Cust.`, `Vend.`, `Gen. Jnl.`, `Mgt.`, `WHSE`) rather than ad-hoc contractions — `CMFRT GD POI Distance` is readable, `CMFRT GD POIDstCalcJnl` is not.

Procedure names are not bound by the 30-character platform limit and must stay self-describing per `cmfrt-naming-prefix.md` — never abbreviate a procedure name to save characters it does not need.

See sample: [`cmfrt-object-name-30-char-limit.good.al`](cmfrt-object-name-30-char-limit.good.al).

## Anti Pattern

A prefixed name over 30 characters (`"CMFRT GD Point Of Interest Entry"` is 32). A descriptive name chosen at or near 30 characters while unprefixed, so that applying `CMFRT <ABBR> ` is impossible — this reads as a prefix violation but the root cause is the length budget. Abbreviating past comprehensibility to buy room for the prefix, which trades a publish-time failure for a permanently unreadable object name. A budget of 21 in a module with a three-letter abbreviation: `"CMFRT GDW Purchase Price Review"` has a 21-character descriptive part and is 31 in total.

See sample: [`cmfrt-object-name-30-char-limit.bad.al`](cmfrt-object-name-30-char-limit.bad.al).
