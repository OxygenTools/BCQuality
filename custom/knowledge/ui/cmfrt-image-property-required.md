---
bc-version: [all]
domain: ui
keywords: [ui, image, icon, bcicons, page-field, page-action, action-group, fileuploadaction, cuegroup, aw0005]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT Image property is required on page controls that support it

## Description

The `Image` property is the icon Business Central renders for a control. It applies to exactly four targets: page fields, page actions, page action groups, and page file upload actions (`fileuploadaction`, available from runtime version 13.0). On page fields it is only valid for fields of an integer data type, which in practice means cue fields inside a `cuegroup` control. Every CMFRT extension must set `Image` on each of those controls, and the value must be an icon that actually exists in the current Business Central icon library.

The icon names are not free text and they are not stable across releases: icons are added and retired, so a name that a developer remembers from an older version, or invents because it reads plausibly, is not necessarily in the library. The authoritative list is https://aka.ms/bcicons. In Visual Studio Code, pressing Ctrl+Space on the `Image` line lists the icons the current symbol packages actually offer.

## Best Practice

Set `Image` on every page action, every action group, every `fileuploadaction`, and every integer cue field the extension adds or changes. Pick the value from https://aka.ms/bcicons — or from the Ctrl+Space completion list in VS Code, which reflects the app's own symbol packages — and choose the icon whose meaning matches the operation (`Import` for an import, `Calculate` for a recalculation) rather than the first icon that looks decorative. Microsoft's UICop analyzer raises `AW0005` ("Actions should use the Image property") for the omission on actions, so leaving it out also means shipping with an analyzer finding.

Two platform limits are not violations of this rule and must not be reported as such: on `RoleCenter` pages, `Image` has no effect on navigation-bar actions or top-level action-bar actions — only on subgroups and their child actions — and on page fields `Image` is only valid for integer fields.

See sample: `cmfrt-image-property-required.good.al`.

## Anti Pattern

Adding an action, action group, `fileuploadaction`, or cue field with no `Image`, which leaves the control with a default or blank icon and makes the CMFRT feature visibly inconsistent with the rest of the action bar. Equally wrong is setting `Image` to a guessed or remembered name that is not in the current icon library instead of verifying it against https://aka.ms/bcicons.

See sample: `cmfrt-image-property-required.bad.al`.
