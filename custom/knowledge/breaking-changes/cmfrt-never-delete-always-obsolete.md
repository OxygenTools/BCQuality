---
bc-version: [all]
domain: breaking-changes
keywords: [obsolete, delete, remove, rename, local-procedure, breaking-change, backward-compatibility, obsolete-state, obsolete-reason, obsolete-attribute]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT never delete — always obsolete

## Description

In a CMFRT extension the following AL members must never be physically deleted: global and local procedures, table fields, page fields, enum values, and entire objects. Removing any of these breaks dependent extensions and upgrade paths without a compiler warning. A local procedure is in the list too, also when nothing calls it any more. This is a house rule, stricter than the platform: AppSourceCop `AS0018` allows the removal of a local procedure, because no other extension can call it. The reviews asked both ways (remove in PR 14602, `Obsolete` in PR 14582), and the decision of 12 October 2026 chose `Obsolete`: one rule for every procedure is simpler to apply and to check than a rule that depends on the access modifier.

A rename is a delete plus an add. A released field, procedure, object or enum value keeps its name: a dependent extension, an upgrade codeunit, a report layout or a configuration package can refer to the old name. The required approach is to retain the member, mark it with `ObsoleteState = Pending` when deprecation begins, and promote to `ObsoleteState = Removed` in a subsequent release after dependents have migrated. All obsoleted members are placed at the end of their containing object so that active code is never mixed with retired code.

## Best Practice

When a member is no longer needed, keep it in place, add `ObsoleteState = Pending`, `ObsoleteReason = '<explanation>'`, and `ObsoleteTag = '<task-id>'`. In a later release, promote to `ObsoleteState = Removed`. A procedure, global or local, takes the attribute form instead: `[Obsolete('<explanation>', '<task-id>')]` above the procedure. For fields, add the replacement field first, then obsolete the original. For procedures, add the replacement first, then obsolete the original.

To give a released member a new name, never edit the name in place. Add a new member with the new name, obsolete the old one with a reason that names the new one, and move the data with an upgrade codeunit when the member is a field. The same applies to a new type or a shorter length.

See sample: [`cmfrt-never-delete-always-obsolete.good.al`](cmfrt-never-delete-always-obsolete.good.al).

## Anti Pattern

Deleting a global or local procedure, table field, page field, enum value, or entire AL object from the extension source. Editing the name of a released field, procedure, object or enum value in place is the same defect: to every reference outside the change, the old name is gone. Physical deletion produces compiler errors in every dependent extension that referenced the removed member, and for table fields it causes data loss and upgrade failures in existing customer databases.

See sample: [`cmfrt-never-delete-always-obsolete.bad.al`](cmfrt-never-delete-always-obsolete.bad.al).
