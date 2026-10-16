---
bc-version: [all]
domain: architecture
keywords: [dependencies, app-json, propagate-dependencies, transitive, direct-dependency, manifest, symbols, cross-app-reference]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT code uses an object of another app only through a direct dependency

## Description

AL code can use an object of another app only when the compiler sees that app. A direct entry in the `dependencies` of `app.json` makes the app visible. The `propagateDependencies` property of `app.json` opens a second, indirect path. Microsoft Learn describes it in the app.json reference: when A depends on B and B depends on C, A cannot use the types of C by default. When B sets `"propagateDependencies": true`, A can use them without a direct dependency on C. The property applies to all direct dependencies of B, with no option to exclude one.

CMFRT_GDW shows the gap. Its `app.json` declares CMFRT Base, CMFRT Calc and CMFRT Service. Its code uses the table `"CMFRT JO Comfort Job Setup"` of CMFRT Job: a table extension, a record variable in `"CMFRT GDW Price Check Mgt."` and two permission-set lines. GDW compiles because CMFRT Calc and CMFRT Service both declare CMFRT Job and both set `"propagateDependencies": true`.

The risk sits outside GDW. If CMFRT Calc and CMFRT Service both remove CMFRT Job from their `dependencies`, or both remove the flag, the GDW build fails with no change in GDW. The manifest of GDW also hides the need: a reader of its `app.json` does not see that GDW uses CMFRT Job. In the DevGIT.AL repos, 57 `app.json` files set `"propagateDependencies": true`, CMFRT Base, CMFRT Job, CMFRT Calc and CMFRT Service among them. Thus this indirect path is open in most CMFRT builds, and a missing declaration does not break the build today.

## Best Practice

Give every app whose objects the code uses a direct entry in `dependencies`. Name the app that defines the object, not an app that passes it on. Add the entry in the same change that adds the first reference: a variable, a table or page extension, an event subscriber or a permission-set line.

Find the defining app with `al_search_objects` of `al-mcp-server`, or from `SymbolReference.json` in `.alpackages`. `testing/cmfrt-test-app-declare-library-dependencies` shows that lookup. Do not infer the app from the object name alone. Copy `id`, `name`, `publisher` and `version` from the manifest of that app.

Base Application and System Application come through the `application` property and need no entry. An app that sets `propagateDependencies` for its own consumers is not a finding. This rule is about the consumer. The test app follows the same rule for test libraries in `testing/cmfrt-test-app-declare-library-dependencies`.

See sample: [`cmfrt-declare-direct-dependencies.good.al`](cmfrt-declare-direct-dependencies.good.al).

## Anti Pattern

Code that uses an object of an app that is not in `dependencies`, and that compiles only because a declared app sets `propagateDependencies`. CMFRT_GDW uses `"CMFRT JO Comfort Job Setup"` but declares only CMFRT Base, CMFRT Calc and CMFRT Service. The build passes, so a review of the build result alone does not show the gap.

Also wrong: a fix that sets `propagateDependencies` on a dependency to make the consumer compile. The consumer declares its own dependency.

See sample: [`cmfrt-declare-direct-dependencies.bad.al`](cmfrt-declare-direct-dependencies.bad.al).
