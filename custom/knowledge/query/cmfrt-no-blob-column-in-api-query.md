---
bc-version: [all]
domain: query
keywords: [query, api, blob, column, querytype-api, calcfields, media, createinstream, empty-stream]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT API queries do not carry BLOB columns

## Description

A query column on a `Blob` field returns no content. A query reads rows with a join and does not run `CalcFields`. The BLOB stays empty, and no error tells the caller. A test with no data cannot show this defect, because an empty BLOB and a missing value look the same.

In PR 14910 (ZC_CMFRT_AquaSecurity) the reviewer asked about a BLOB column in `CMFRTAQAppItem.Query.al`: "een blob in een query ... wat ga je daar mee doen?". The query was an API query, so the consumer would receive an empty value.

In PR 14904 (ZC_CMFRT_Trafiroad) the reviewer found a related defect in a report extension: "volgens mij mis je nog een calcfields op je blob veld. Heb je dit getest? Idem voor de andere rapporten." This part is covered by the Microsoft article `data-modeling/calcfields-blob-before-reading-its-stream`. That article stays valid. This custom article adds the API query case and does not override it.

This article extends `data-modeling/pictures-must-use-media-not-blob` for the query case. Microsoft only recommends `Media` for pictures. At CMFRT, an API query never holds a `Blob` column, for any content.

## Best Practice

Do not add a `Blob` column to a query that an API reads. Use one of these two options:

1. Store the content in a `Media` field when it is a picture, and read it through the Media API.
2. Read the BLOB in a separate step. Get the record, call `CalcFields` on the BLOB field, and then call `CreateInStream`.

Every `CreateInStream` on a record field needs a `CalcFields` or `SetAutoCalcFields` on that field before it. A reviewer asks for it in every report, page and codeunit of the change, not only in the first file.

See sample: [`cmfrt-no-blob-column-in-api-query.good.al`](cmfrt-no-blob-column-in-api-query.good.al).

## Anti Pattern

A query with `QueryType = API` that has a `column` on a `Blob` field. The API returns an empty value and no error. A test that uses an empty table passes.

See sample: [`cmfrt-no-blob-column-in-api-query.bad.al`](cmfrt-no-blob-column-in-api-query.bad.al).

## References

- Microsoft `data-modeling/calcfields-blob-before-reading-its-stream` (agrees, not overridden)
- Microsoft `data-modeling/pictures-must-use-media-not-blob` (extended for API queries)
