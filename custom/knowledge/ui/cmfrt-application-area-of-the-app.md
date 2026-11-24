---
bc-version: [all]
domain: ui
keywords: [applicationarea, page-extension, control, field, action, subform, feature-visibility, all, basic]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT controls use the ApplicationArea of the app

## Description

The `ApplicationArea` property decides which users see a control. A CMFRT app has its own ApplicationArea value. A new control in a CMFRT app must use that value. It must not use `All` or `Basic`. Those values do not tie the control to the app.

The value is the ApplicationArea of the app that owns the control. In the AquaSecurity app (ZC_CMFRT_AquaSecurity) the value is `CMFRTBouwApplicationArea`. Read the value from the existing controls of your app. Do not guess it.

In PR 14998 (AquaSecurity) the reviewer wrote this comment on a new control of the posted receipt subform page extension (`CMFRTAQPostPurchRcptSubf.PageExt.al:11`): "Applicationarea = CMFRTBouwApplicationArea". The developer then fixed the lift pages, the transfer order subform and the posted receipt subform. One comment led to changes in many files. Check all new controls before you open the PR.

This article overrides no Microsoft or Community article. The Microsoft and Community articles do not give a value for `ApplicationArea`. The Microsoft samples show `ApplicationArea = All`. They show it to demonstrate other rules. They are not a rule for a CMFRT app. The Community article `set-usagecategory-on-searchable-entry-points` asks for an object-level `ApplicationArea` only. This article adds the value for a CMFRT control.

## Best Practice

- Set `ApplicationArea` to the value of the app on every new field, action, part and group that the app adds. This includes controls in page extensions, subforms and posted-document pages.
- Copy the value from an existing control of the same app. Use the same value on all pages of the app.
- Do not change the `ApplicationArea` of a standard control. `custom/knowledge/patterns/cmfrt-remediate-on-touch` lists that change as not allowed without a ticket.
- Use the same value on a control that you move to a new page.

See sample: [`cmfrt-application-area-of-the-app.good.al`](cmfrt-application-area-of-the-app.good.al).

## Anti Pattern

- A new control with `ApplicationArea = All` or `ApplicationArea = Basic` in a CMFRT app.
- A new control with no `ApplicationArea`.
- A value that differs between the pages of one app.
- A value that belongs to another app.

See sample: [`cmfrt-application-area-of-the-app.bad.al`](cmfrt-application-area-of-the-app.bad.al).

## See also

`custom/knowledge/patterns/cmfrt-remediate-on-touch` decides when an existing control in a changed object gets the fix. `custom/knowledge/security/cmfrt-license-feature-gate` shows a page with the app value.
