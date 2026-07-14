---
bc-version: [all]
domain: breaking-changes
keywords: [obsolete, delete, remove, breaking-change, backward-compatibility, obsolete-state, obsolete-reason]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT never delete — always obsolete

## Description

In a CMFRT extension the following AL members must never be physically deleted: global procedures, table fields, page fields, enum values, and entire objects. Removing any of these breaks dependent extensions and upgrade paths without a compiler warning. The required approach is to retain the member, mark it with `ObsoleteState = Pending` when deprecation begins, and promote to `ObsoleteState = Removed` in a subsequent release after dependents have migrated. All obsoleted members are placed at the end of their containing object so that active code is never mixed with retired code.

## Best Practice

When a member is no longer needed, keep it in place, add `ObsoleteState = Pending`, `ObsoleteReason = '<explanation>'`, and `ObsoleteTag = '<task-id>'`. In a later release, promote to `ObsoleteState = Removed`. For fields, add the replacement field first, then obsolete the original. For procedures, add the replacement first, then obsolete the original. Provide an upgrade codeunit procedure whenever a field rename or type change requires data migration.

See sample: `cmfrt-never-delete-always-obsolete.good.al`.

## Anti Pattern

Deleting a global procedure, table field, page field, enum value, or entire AL object from the extension source. Physical deletion produces compiler errors in every dependent extension that referenced the removed member, and for table fields it causes data loss and upgrade failures in existing customer databases.

See sample: `cmfrt-never-delete-always-obsolete.bad.al`.
