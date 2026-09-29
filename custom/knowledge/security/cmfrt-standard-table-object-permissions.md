---
bc-version: [all]
domain: security
keywords: [permissions, permissionset, tabledata, standard-table, base-application, object-permissions, indirect-permissions, codeunit]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT standard-table permissions belong on the object, not in the permission set

## Description

A CMFRT app's permission sets grant `tabledata` only on tables the app itself declares. When a codeunit, report or page reads or writes a standard Microsoft table (Base Application, System Application, platform: `Reservation Entry`, `Item Ledger Entry`, `Sales Line`, `Customer`, ...), the grant goes on **that object's own `Permissions` property**, scoped to the operations its body performs. A table extension adds fields to the standard table but does not change who owns it: the `tabledata` grant is still on the standard table and follows the same rule.

The user's own rights on standard tables come from the Microsoft permission sets the customer assigns (`D365 BASIC`, `D365 SALES DOC, EDIT`, ...). The object-level property lets the CMFRT code perform its specific operation on top of that, so the extension never widens what a user can do with a standard table outside the CMFRT code path.

## Best Practice

Declare the standard-table access on the object that performs it, lowercase (indirect) and limited to the letters its body actually uses: a codeunit that deletes reservation entries carries `Permissions = tabledata "Reservation Entry" = rimd;`, a report that only reads item ledger entries carries `tabledata "Item Ledger Entry" = r`.

The Objects / Read / Edit permission sets (see `cmfrt-three-permissionset-pattern`) keep listing only the app's own objects and tables. When a change starts touching another standard table, update the `Permissions` property of the object doing it; the permission sets need no change.

See sample: [`cmfrt-standard-table-object-permissions.good.al`](cmfrt-standard-table-object-permissions.good.al).

## Anti Pattern

Adding `tabledata "Reservation Entry" = RIMD` (or any standard table) to a CMFRT Read or Edit permission set because a codeunit in the app modifies it. Every user holding that set can now read and change reservation entries directly through any page, API or configuration package, not only through the CMFRT code. The grant is also detached from the code that needs it: when the codeunit stops touching the table, nobody removes the line from the set.

Reviewers flag any `tabledata` entry in a CMFRT permission set or permission set extension whose table is not declared in the app, and any codeunit, report or page that reads or writes a standard table the user would not otherwise reach without declaring it in its own `Permissions`.

See sample: [`cmfrt-standard-table-object-permissions.bad.al`](cmfrt-standard-table-object-permissions.bad.al).

## See also

- `cmfrt-three-permissionset-pattern`: the shape of the app's own permission sets.
- `indirect-permissions-for-elevated-access` (microsoft layer): how direct and indirect letters differ.
