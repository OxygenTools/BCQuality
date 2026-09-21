---
bc-version: [all]
domain: security
keywords: [license, licence, entitlement, feature-gate, license-check, check-if-in-license, enum-extension, non-debuggable, page-editable, product-app]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT product apps gate their pages behind a licence feature check

## Description

Every CMFRT **product** app registers itself as one feature value in the shared Astena licence system and asks that system, on each page the app itself declares, whether the current tenant is entitled to the feature. The app carries two objects for this in `src/License/` — an `enumextension` on `"CMFRT LIF Feature"` and a thin `"CMFRT <ABBR> License Check"` wrapper codeunit — and each page opens with a guard that sets `CurrPage.Editable`. An unlicensed tenant still *sees* the screens; it cannot *change* anything.

The entitlement logic itself (Azure Function call, local cache, notifications) lives in the base app **CMFRT License** (`app.json` dependency, AppId `9a6eb00d-c62e-443d-b405-a4c3128a6f16`, publisher Astena). The product app supplies only its feature identity and the calling context.

Applies to an app whose `app.json` declares `"publisher": "Astena"` and a `"name"` beginning `CMFRT ` — the multi-customer product line, in `CMFRT_*` and `ZI_CMFRT_*` repos alike. For such an app, a missing `CMFRT License` dependency is itself the first finding. It does **not** apply to single-customer PTE work, to the `CMFRT License` app itself (it is the provider), or to page extensions: a `pageextension` never owns the page it extends — its own or another app's — and must not seize `CurrPage.Editable` from it. A cue tile added by such an extension is gated implicitly, by the gate on the page it drills down into.

## Best Practice

**One feature value**, in `src/License/CMFRT<ABBR>FeatureExtension.EnumExt.al`. Extend `"CMFRT LIF Feature"` with exactly one `value` whose ordinal equals the enumextension's own object ID and whose name is the `app.json` `name` verbatim. The ordinal is the key the licence service answers on, so it must be unique across the whole Astena line: allocate it inside the app's own `idRanges`, and never reuse a value another CMFRT app publishes. Name both files after the objects they hold (`naming/cmfrt-al-file-name-pattern`); several repos carry a copied `CMFRT<other-abbr>…` file name from the app they were cloned from, which is a defect, not the template.

**One wrapper codeunit**, in `src/License/CMFRT<ABBR>LicenseCheck.Codeunit.al`. Public `CMFRT<ABBR>IsInLicense(Feature; ObjectId: Text): Boolean` following the house OnBefore → Do → OnAfter shape (`events/cmfrt-onbefore-do-onafter`), with the `Do` procedure registering `'callerFeature'` and `'callerObject'` through `LicenseController.AddAdditionalCustInfo` before calling `CheckIfInLicense(Feature)`. `[NonDebuggable]` goes on both procedures and on the `"CMFRT LIF License Controller"` variable — the whole chain is shielded from the AL debugger, and dropping the attribute on one link defeats the rest. The codeunit holds no conditional logic of its own: it exists so every call site reports consistent context, and so other Astena modules can override the verdict through the two integration events without touching the base app.

**The guard, first thing in each own page's `OnOpenPage`**, between the `// License section - Start` / `// License section - Stop` marker comments the house template uses: assign `CurrPage.Editable` from `CMFRT<ABBR>IsInLicense`, passing `CurrPage.ObjectId()` — never a literal, since the licence side logs it as `callerObject`. Gate every page the app declares: Card, List, ListPart sub-pages and FactBoxes, API pages, setup pages. Keep the markers; they are how the pattern is found across some 500 pages.

**Never `Error`, never refuse to open.** A missing entitlement makes the page read-only and nothing else. The base app owns whatever notification the user sees; a product app that raises its own error or closes the page contradicts the shared contract.

**Declare the check codeunit in the Objects permission set** (`security/cmfrt-three-permissionset-pattern`) — without `codeunit "CMFRT <ABBR> License Check" = X` the guard fails for exactly the users it is meant to let through.

**Hand the new ordinal to the licence side.** A feature value not registered with the Astena licence service answers `false`, so the app ships read-only until someone registers it. This is an out-of-band human step: name it explicitly, with ordinal and feature name, in the design document and the ticket close-out.

See sample: [`cmfrt-license-feature-gate.good.al`](cmfrt-license-feature-gate.good.al).

### Variable scope, and the legacy form

The guard declares a stateless helper instance, so it is local to `OnOpenPage`, per `patterns/cmfrt-no-object-level-vars`. `[NonDebuggable]` is valid on a local declaration — the wrapper codeunit itself uses it that way on `LicenseController`.

The `IsInLicense` boolean moves to object scope only when a control or action actually binds it (`Enabled = IsInLicense`) — exception 4 of the no-object-level-vars article, and only then. A page-scope `IsInLicense` that nothing but the next line reads is not that exception.

Roughly 500 existing pages carry the older form, with `LicenseCheck` and `IsInLicense` both in the page's `var` block inside the same markers. That form is behaviourally identical and is **not** a finding on its own; when such a page is modified for other reasons, `patterns/cmfrt-remediate-on-touch` makes the localization a mechanical, non-breaking clean-up.

The wrapper's `Do` procedure takes `var ObjectId` and `var Handled`, matching the signatures of the two events it sits between. A few apps declare them by value; do not churn those, and do not copy the by-value shape into a new app.

## Anti Pattern

A CMFRT product app with no licence module at all, or with the module present and pages that never call it — the app then ships fully editable to tenants that never bought it, and nothing in the build catches it. Equally wrong: calling `"CMFRT LIF License Controller".CheckIfInLicense` straight from a page, which discards the `callerFeature`/`callerObject` context and the two override events; declaring several feature values, or an ordinal that does not match the enumextension's object ID; `Error`-ing or closing the page when the check returns `false`; gating a page through a `pageextension`; and omitting `[NonDebuggable]` anywhere on the chain.

See sample: [`cmfrt-license-feature-gate.bad.al`](cmfrt-license-feature-gate.bad.al).

## Related

- `security/cmfrt-three-permissionset-pattern` — the Objects set must grant the check codeunit.
- `events/cmfrt-onbefore-do-onafter` — the shape the wrapper's public procedure follows.
- `patterns/cmfrt-no-object-level-vars` — why the helper instance is local; exception 4 for a bound `IsInLicense`.
- `patterns/cmfrt-remediate-on-touch` — how to treat the legacy object-scope form in a page you are already editing.
