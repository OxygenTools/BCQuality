---
bc-version: [all]
domain: naming
keywords: [file-name, filename, file-path, object-type, suffix, source-layout, naming-convention]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT AL source files are named `<ObjectName>.<ObjectType>.al`

## Description

One AL object per file, and the file name is derived mechanically from the object's own declared name: take the declared name, remove its spaces, append the AL object-type segment, append `.al`. Table `"CMFRT AM Address"` lives in `CMFRTAMAddress.Table.al`; page `"CMFRT GU Warranty Schema Card"` lives in `CMFRTGUWarrantySchemaCard.Page.al`; codeunit `"CMFRT IN CalculateIndexImpl"` lives in `CMFRTINCalculateIndexImpl.Codeunit.al`. An extension object carries its own prefixed name, not the name of the object it extends — `CMFRTGUPurchaseHeader.TableExt.al`, `CMFRTGUJobCard.PageExt.al`.

The object ID never appears in a file name. An ID-prefixed name (`Table2045085.CMFRT AM Address.al`) sorts the folder by a number nobody navigates by, breaks the file-to-object map every tool relies on, and goes stale the moment an object is renumbered. Spaces in a file name are the same defect from the other direction: they survive from the object name into paths, diffs and build logs, where they have to be quoted.

The type segment is matched case-insensitively. The house ships both `CMFRTINEdit.PermissionSet.al` and `CMFRTINObjects.permissionset.al`, and both are accepted; only the segment's spelling matters, not its casing.

This rule supersedes `microsoft/knowledge/style/file-name-object-type-pattern.md` by layer precedence — record that file in `suppressed` with `reason: "layer-precedence"` when both surface. The Microsoft article is correct but sits in domain `style`, which `cmfrt-standards-review` never sees, so the CMFRT form has to be stated here.

## Best Practice

Name the file `<DeclaredObjectNameWithoutSpaces>.<ObjectType>.al`. The object portion is PascalCase because the declared name is (`CMFRT <ABBR> <Name>` with the prefix's spaces removed); it contains no spaces, no underscores, no object ID and no dots. Use the AL object-type names for the segment — `Table`, `TableExt`, `Page`, `PageExt`, `Codeunit`, `Enum`, `EnumExt`, `Interface`, `PermissionSet`, `Report`, `ReportExt`, `Query`, `XmlPort`. Renaming an object is therefore always a two-part change: the declaration and the file name move together.

See sample: `cmfrt-al-file-name-pattern.good.al`.

## Anti Pattern

`Table2045085.CMFRT AM Address.al`, `Codeunit2045109.CMFRT AM Install.al`, `PageExtension2045118.CMFRT AM Ship-to Address.al` — the object type is written as a prefix carrying the object ID, the real name follows after a dot, and the spaces are kept. All 51 AL files on the rejected `claude/pbr13-54` branch were named this way, which is why the fix was a repo-wide rename rather than a review comment. Also wrong: omitting the type segment (`AddressLogic.al`), snake_case or lowercase object portions (`cmfrt_am_address.table.al`), and more than one object in a file.

See sample: `cmfrt-al-file-name-pattern.bad.al`.
