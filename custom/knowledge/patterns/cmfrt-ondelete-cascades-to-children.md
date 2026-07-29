---
bc-version: [all]
domain: patterns
keywords: [ondelete, delete, deleteall, cascade, header-line, parent-child, referential-integrity, orphan, onafterdeleteevent, istemporary]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Cascade a parent delete to every dependent table

## Description

Business Central has **no declarative cascade delete**. `TableRelation` validates that a referenced record exists — it never deletes anything, and it does not stop a parent from being deleted while children remain. The only two mechanisms are:

- the parent table's `OnDelete` trigger, for a table the extension owns;
- a subscriber to the base table's `OnAfterDeleteEvent`, for a parent owned by the base application or another publisher, where an `OnDelete` trigger cannot be added.

Both are opt-in, so a header table written without one leaves orphaned lines behind and nothing reports it. The orphans are invisible until a later read filters on a document number that no longer has a header, at which point the data is already inconsistent and the cause is long gone.

The cascade is also only as good as its callers: `Delete(true)` runs the parent's `OnDelete` trigger, while `Delete()` and `Delete(false)` skip it entirely. Page deletes and `DeleteAll(true)` pass `true` for you; AL code has to pass it explicitly. A correct `OnDelete` trigger plus one `Delete(false)` call site still produces orphans.

## Best Practice

Every table that owns dependent records cascades to **all** of them:

- **Owned parent table** — implement `OnDelete` on the parent. For each dependent table: filter on the child's key fields (so the delete is index-supported), then call `DeleteAll(true)`. Passing `true` runs each child's own `OnDelete`, which is what cascades to grandchildren — comment lines, attachments, tracking entries. `DeleteAll(false)` deletes the lines but silently orphans everything hanging off them.
- **Base-application parent** — subscribe to that table's `OnAfterDeleteEvent` and delete the extension's own children there, following `events/cmfrt-onbefore-onafter-all-globals.md`. Guard with `if Rec.IsTemporary() then exit;` so a temporary buffer never triggers a live delete (see `community/knowledge/security/guard-bulk-operations-with-istemporary.md`). Cascade regardless of the `RunTrigger` parameter: an orphaned child row is worse than an unexpected cleanup.
- **Enumerate every dependent table, not just the lines.** Comments, attachments, dimensions, tracking, and buffer or log tables keyed on the parent all need a filter and a `DeleteAll(true)`.
- **Filter before deleting, always.** An unfiltered `DeleteAll` inside `OnDelete` wipes the whole child table for every parent deleted.
- **Cascade downward only.** A child's `OnDelete` must never delete its parent — the parent's `OnDelete` is already running and the two triggers will recurse.
- **Pass `true` at every delete call site** for a parent that has an `OnDelete` trigger. `Delete()` and `Delete(false)` on such a parent are defects, not optimizations.

An `if not Child.IsEmpty() then` guard before `DeleteAll` is unnecessary: `DeleteAll` on an empty filtered set is already a no-op, so the guard only adds a round trip. It is harmless, but not the reason the pattern works.

**This article deliberately overrides `microsoft/knowledge/performance/use-deleteall-for-filtered-bulk-deletion.md`** for parent-child cleanup. That article is about purpose-built staging tables with no delete logic, where `DeleteAll(false)` is eligible for a set-based SQL delete. In a cascade the child's `OnDelete` *is* the logic being relied on, so correctness wins: use `true`. Per `custom > microsoft` precedence, a review must not cite the performance article to justify `false` here. Note also that `DeleteAll(true)` has no performance advantage over `Delete(true)` in a loop — the reason to prefer it is that it is one clear statement, not speed.

See sample: `cmfrt-ondelete-cascades-to-children.good.al`.

## Anti Pattern

A header table with no `OnDelete` trigger at all, leaving lines in the database after the header is gone. `DeleteAll(false)` on the lines, which deletes them but orphans their comments and tracking. Relying on `TableRelation` to clean up, which it never does. Calling `Delete()` or `Delete(false)` on a parent from AL, bypassing the trigger that does the cascade. Cascading to the lines table only while other dependent tables keyed on the same header are left behind. An unfiltered `DeleteAll` inside `OnDelete`. A child `OnDelete` that deletes its own parent.

See sample: `cmfrt-ondelete-cascades-to-children.bad.al`.
