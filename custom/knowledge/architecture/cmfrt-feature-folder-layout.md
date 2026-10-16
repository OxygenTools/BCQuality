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

Five folders under `src/` can carry a number. The numbers form one fixed scheme. Each number has the same meaning in every CMFRT app:

| Folder | Content | Number |
|---|---|---|
| `01 BaseAppExt` | extensions of base application objects | only in a numbered repo |
| `02 Install` | the `Subtype = Install` codeunit | always |
| `03 Setup` | the setup tables and setup pages of the app | only in a numbered repo |
| `04 Subscribers` | the event subscriber codeunits | only in a numbered repo |
| `05 Upgrade` | the `Subtype = Upgrade` codeunit, with its upgrade tags and their subscribers (`upgrade/cmfrt-upgrade-tags-in-upgrade-codeunit`) | always |

A repo is numbered when its `src/` already holds `01 BaseAppExt`, `03 Setup` or `04 Subscribers`. Any other repo uses the bare names `BaseAppExt/`, `Setup/` and `Subscribers/`. The numbers keep these folders at the top of the listing and out of the feature namespace.

In the DevGIT.AL repos, `01 BaseAppExt` is in 61 repos, `02 Install` in 52, `04 Subscribers` in 51, `05 Upgrade` in 27 and `03 Setup` in 23. The bare names are in 37 (`BaseAppExt`), 49 (`Subscribers`) and 9 (`Setup`) repos.

Other cross-cutting folders that are not object types are welcome alongside the feature folders, for example `Permissions/` and `License/`. They never take a number. They group by role, which is the same kind of answer as a feature.

## Best Practice

Name each folder under `src/` after the feature or the cross-cutting role it contains, and put the install and upgrade codeunits in `src/02 Install` and `src/05 Upgrade`. The enforceable half of this rule is the negative one, and it needs no judgement: **a folder under `src/` whose name equals an AL object type is always a violation** — `Table`, `TableExtension`/`TableExt`, `Page`, `PageExtension`/`PageExt`, `Codeunit`, `Enum`, `EnumExtension`/`EnumExt`, `Interface`, `PermissionSet`, `Report`, `ReportExtension`, `Query`, `XmlPort`, with or without a trailing `s`. "Is this folder a feature?" is a judgement call; "is this folder an object type?" is not, and both a reviewer and CI can check the latter.

Give a number only to a folder of the scheme, and only its own number. Before you add a `BaseAppExt`, `Setup` or `Subscribers` folder, look at `src/`. In a numbered repo, add `01 BaseAppExt`, `03 Setup` or `04 Subscribers`. In any other repo, add the bare name.

See sample: [`cmfrt-feature-folder-layout.good.al`](cmfrt-feature-folder-layout.good.al).

## Anti Pattern

`src/Table/`, `src/Page/`, `src/Codeunit/`, `src/Enum/`, `src/Interface/`, `src/PageExtension/`, `src/TableExtension/`, `src/PermissionSet/` — the layout of the rejected `claude/pbr13-54` branch. Grouping by type scatters one feature across eight folders, so no folder answers a question anyone asks, and the folder tells the reader only what the file's own type segment already said. The install codeunit landing in `src/Codeunit/` instead of `src/02 Install/` is the same finding: the lifecycle folders exist precisely so install and upgrade are not buried among the feature codeunits.

A number outside the scheme: `05 Logic`, `05 API`, `06 API`, `07 Permissions`, `08 Dev Tools`, `09 Health Check`, `02 Reports`, `02 Setup`, `03 Intake`, `04 Audit`, `01 Enums`. Each one gives a scheme number a second meaning, or adds a number that no other app knows. A misspelled scheme name, such as `04 Subcribers`, is the same finding. Each of these names is in one or two DevGIT.AL repos. A numbered `01 BaseAppExt` next to a bare `Subscribers/` mixes the two forms in one repo.

See sample: [`cmfrt-feature-folder-layout.bad.al`](cmfrt-feature-folder-layout.bad.al).
