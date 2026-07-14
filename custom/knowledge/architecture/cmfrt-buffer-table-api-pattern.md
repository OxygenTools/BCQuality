---
bc-version: [all]
domain: architecture
keywords: [api, buffer, staging, oninsertrecord, api-page, inbound, creator, proc, codeunit-run]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT inbound API pages write to buffer tables

## Description

Inbound CMFRT API pages never source from real application tables. Each API page sources from a dedicated buffer (staging) table owned by the extension. The buffer row records the raw inbound payload plus a status field (Pending/Processing/Processed/Error) and an operation enum where applicable. A Proc codeunit picks up pending buffer rows and owns the `Codeunit.Run` error boundary; a Creator codeunit transfers buffer values into the real table via `Validate` calls. The API page's `OnInsertRecord` trigger contains no manual insert plumbing — the framework performs the default insert; the trigger only performs side effects such as request logging.

## Best Practice

For each inbound API: one buffer table (with status and error-message fields), one API page sourced from the buffer, one Proc codeunit that iterates pending rows and calls the Creator inside a `Codeunit.Run` boundary so one failing row does not abort the batch, and one Creator codeunit that fills and inserts the real record. `OnInsertRecord` bodies contain only logging or metadata capture and no `exit` statement, so the framework insert proceeds.

See sample: `cmfrt-buffer-table-api-pattern.good.al`.

## Anti Pattern

An API page sourced directly from a real table (Sales Header, Job, Ship-to Address), or an `OnInsertRecord` trigger that calls `Rec.Insert(true)` followed by `exit(false)` to suppress the framework insert. Direct-to-real-table APIs make inbound failures atomic with the HTTP request (no retry, no error queue), and the manual insert/exit boilerplate duplicates framework behaviour while hiding the insert from other trigger logic.

See sample: `cmfrt-buffer-table-api-pattern.bad.al`.
