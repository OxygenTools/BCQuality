---
bc-version: [all]
domain: architecture
keywords: [folder, directory, src-layout, feature-folder, grouping, install, upgrade, project-structure]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT groups src/ by feature, never by object type

## Description

`src/` is organised around what the code does, not what kind of AL object it is. A feature folder holds that feature's table, its pages, its interface and its implementation codeunits side by side, so a developer opening one folder sees the whole concern. `CMFRT_Indexation/src` ships `IndexationFormula/`, `IndexationParameter/`, `IndexationValue/` and `RecordIndexation/` exactly that way. A small app may keep its objects flat directly under `src/` — `CMFRT_Guarantee` does — which is the same principle with one implicit feature.

Two lifecycle folders start with a number and are reserved: `02 Install` holds the `Subtype = Install` codeunit, `05 Upgrade` holds the `Subtype = Upgrade` codeunit. The numeric prefix keeps them at the top of the listing and out of the feature namespace; both names are fixed and are not renamed or renumbered per app.

Cross-cutting folders that are not object types are welcome alongside the feature folders — `Permissions/`, `License/`, `BaseAppExt/` for extensions of base application objects, `Subscribers/` for event subscriber codeunits. They group by role, which is the same kind of answer as a feature.

## Best Practice

Name each folder under `src/` after the feature or the cross-cutting role it contains, and put the install and upgrade codeunits in `src/02 Install` and `src/05 Upgrade`. The enforceable half of this rule is the negative one, and it needs no judgement: **a folder under `src/` whose name equals an AL object type is always a violation** — `Table`, `TableExtension`/`TableExt`, `Page`, `PageExtension`/`PageExt`, `Codeunit`, `Enum`, `EnumExtension`/`EnumExt`, `Interface`, `PermissionSet`, `Report`, `ReportExtension`, `Query`, `XmlPort`, with or without a trailing `s`. "Is this folder a feature?" is a judgement call; "is this folder an object type?" is not, and both a reviewer and CI can check the latter.

See sample: `cmfrt-feature-folder-layout.good.al`.

## Anti Pattern

`src/Table/`, `src/Page/`, `src/Codeunit/`, `src/Enum/`, `src/Interface/`, `src/PageExtension/`, `src/TableExtension/`, `src/PermissionSet/` — the layout of the rejected `claude/pbr13-54` branch. Grouping by type scatters one feature across eight folders, so no folder answers a question anyone asks, and the folder tells the reader only what the file's own type segment already said. The install codeunit landing in `src/Codeunit/` instead of `src/02 Install/` is the same finding: the lifecycle folders exist precisely so install and upgrade are not buried among the feature codeunits.

See sample: `cmfrt-feature-folder-layout.bad.al`.
