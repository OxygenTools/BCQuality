---
bc-version: [all]
domain: naming
keywords: [naming, prefix, cmfrt, object-name, procedure-name, field-name, abbreviation, test-app, test-codeunit, handler-functions]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT naming prefix

## Description

Every object, field, and procedure in a CMFRT extension must carry the `CMFRT XXX` prefix, where `XXX` is the product or customer abbreviation (for example `GD` for Geodynamics, `BA` for Batch Automation, `JO` for Jobs). The prefix applies to tables, table extensions, pages, page extensions, codeunits, interfaces, reports, enum values, and to all global and local procedures. Object and field names use the three-part form `CMFRT <ABBR> <Descriptive Name>` with spaces. Procedure names use the concatenated form `CMFRT<ABBR><ProcedureName>` with no spaces.

The rule is identical in the companion test app (`<AppName>_Test`). Test codeunits, and every procedure inside them, carry the same prefix: `[Test]` procedures, `[HandlerFunctions]` handlers, `[MessageHandler]`/`[ConfirmHandler]`/`[ModalPageHandler]` procedures, `[Scope('OnPrem')]` helpers, and local setup or assertion helpers. The test app is not exempt because it ships as its own extension and its members collide the same way.

## Best Practice

Name every object `"CMFRT <ABBR> <Name>"` — for example `"CMFRT GD Job"` or `"CMFRT GD POI"`. Name every field `"CMFRT <ABBR> <FieldName>"` — for example `"CMFRT GD POI ID"`. Name every procedure `CMFRT<ABBR><ProcedureName>` — for example `CMFRTGDCalculatePOIDistance`. The procedure name must be self-describing: a reader must understand what the procedure does without reading its body. Local procedures follow the same rule.

In the test app, name test codeunits `"CMFRT <ABBR> <Name> Tests"` and prefix every procedure the same way — `CMFRTGDLinkJobToPOISetsPOIId` rather than `LinkJobToPOISetsPOIId`. When renaming a handler procedure, update the `[HandlerFunctions]` attribute string in the same change: the attribute references the handler by name and a stale reference fails at runtime, not at compile time.

See sample: `cmfrt-naming-prefix.good.al`.

## Anti Pattern

Naming objects, fields, or procedures without the CMFRT prefix — for example `procedure CalculateDiscount()` or `field(50000; "Amount"; Decimal)`. Unprefixed members collide with base application fields, break the reviewer's ability to identify extension-owned members, and violate the astena naming convention enforced across all CMFRT extensions.

Treating the test app as exempt is the same violation — an unprefixed `[Test] procedure LinkJobToPOI()` or an unprefixed handler in `<AppName>_Test/src/` is a finding, not a stylistic preference.

See sample: `cmfrt-naming-prefix.bad.al`.
