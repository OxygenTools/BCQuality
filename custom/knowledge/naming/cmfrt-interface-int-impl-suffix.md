---
bc-version: [all]
domain: naming
keywords: [interface, implementation, suffix, int, impl, injection, seam]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT interfaces end in `Int`, their implementations in `Impl`

## Description

An interface and the codeunit implementing it are named as a pair: the interface carries the `Int` suffix, the implementation the matching `Impl` suffix, and the descriptive part between prefix and suffix is identical. `CMFRT_Indexation` ships `"CMFRT IN CalculateIndexInt"` with `"CMFRT IN CalculateIndexImpl"`, `"CMFRT IN IndexationFormulaInt"` with `"CMFRT IN IndexationFormulaImpl"`, `"CMFRT IN IndexParameterInt"` with `"CMFRT IN IndexParameterImpl"`. The suffix is glued to the descriptive part with no space, so the pair reads as one name in a dependency list and sorts adjacently in a folder listing.

Never an `I`-prefix. `"CMFRT AM IFind Overlap"` puts the marker where the reader is still parsing the mandatory `CMFRT <ABBR> ` prefix, sorts the interface away from its implementation, and leaves the implementing codeunit (`"CMFRT AM Find Overlap"`) with no marker at all — so nothing in either name says which of the two is the seam.

## Best Practice

Name the interface `"CMFRT <ABBR> <Descriptive>Int"` and its default implementation `"CMFRT <ABBR> <Descriptive>Impl"`, keeping `<Descriptive>` byte-identical between them. The file names follow from `cmfrt-al-file-name-pattern`: `CMFRTINCalculateIndexInt.Interface.al` and `CMFRTINCalculateIndexImpl.Codeunit.al`.

Count the 21-character descriptive budget from `cmfrt-object-name-30-char-limit` **with the suffix included** — `Int` costs 3 of it and `Impl` costs 4, so the shared descriptive part has at most 17 characters before the pair stops fitting. `"CMFRT IN RecordIndxValTrgrsInt"` is exactly 30, and its counterpart had to ship as `...TrgrsImp` because `Impl` would have been 31. Abbreviate the descriptive part to make room, never the suffix, and use base-application abbreviation forms (`Cust.`, `Vend.`, `Mgt.`) rather than ad-hoc dotted contractions: `Cur.Desig.` and `Rel.Doc.` have no precedent in the house repos, and a dot in an object name also leaks into its file name.

See sample: `cmfrt-interface-int-impl-suffix.good.al`.

## Anti Pattern

An `I`-prefixed interface — `"CMFRT AM IFind Overlap"`, `"CMFRT AM IGet Cur.Desig."`, `"CMFRT AM ICollect Rel.Doc"`, `"CMFRT AM ICopy To Ship-to"` — paired with an unsuffixed implementation such as `"CMFRT AM Find Overlap"`. Also wrong: an interface with no suffix at all, a `...Int` interface whose implementation is named anything but the matching `...Impl`, and planning the descriptive name at the full 21 characters and then discovering the suffix does not fit.

See sample: `cmfrt-interface-int-impl-suffix.bad.al`.
