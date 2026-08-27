---
bc-version: [all]
domain: testing
keywords: [test-app, app-json, dependencies, manifest, test-libraries, library-variable-storage, symbols, alpackages, missing-dependency, symbolreference]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT test app declares a direct dependency on every test library it uses

## Description

A CMFRT test app's `app.json` must list, in `dependencies`, every app that defines an object its test source references — the production app under test and each Microsoft test library, one entry per defining app. Symbol resolution walks the whole dependency graph, so test code also compiles against apps reached transitively through a declared library. That makes an incomplete manifest look correct: the build is green because some other declared library happens to pull the real provider in, not because the manifest describes what the tests use.

`Tests-TestLibraries` is the usual carrier. It declares `System Application Test Library`, `Permissions Mock` and `Application Test Library`, and `Application Test Library` in turn declares `Any`, `Library Assert`, `Library Variable Storage` and `Business Foundation Test Libraries`. A test app that declares only `Tests-TestLibraries` therefore reaches `Library - Sales`, `Library - Marketing`, `Library - Utility`, `Permissions Mock` and `Library - Variable Storage` by accident. When one hop of that chain is not fetched into `.alpackages`, the compiler reports `Codeunit '<name>' is missing - Fix this by adding the correct dependency in app.json` for a codeunit the manifest never mentioned — which is exactly how `CMFRT_AdresMgmnt_Test` broke on `Library - Variable Storage`.

## Best Practice

Declare one `dependencies` entry per defining app. Two apps are habitually consumed transitively and must be declared explicitly whenever the tests touch them: `Library Variable Storage` (`5095f467-0a01-4b99-99d1-9ff1237d286f`), which defines `Library - Variable Storage`, and `Application Test Library` (`d852d5d2-a39d-4179-baeb-f99a19e32510`), which defines `Library - Marketing`, `Library - Sales` and `Library - Utility`. `Permissions Mock` (`40860557-a18d-42ad-aecb-22b7dd80dc80`) defines `Permissions Mock`. Take canonical names and IDs from https://microsoft.github.io/BCApps/ or from the manifests already in `.alpackages`, and pin `version` consistently with the sibling entries the app already carries.

Resolve a missing-codeunit error by identifying the app that *defines* the object, never by inferring an app name from the codeunit name. For each `.app` in `.alpackages`, skip to the first `PK` zip signature, open the archive and parse `SymbolReference.json`. Two details decide whether the lookup works: the top-level key is `Codeunits`, not `CodeUnits`, and objects nest under `Namespaces[]`, so the search must recurse instead of reading the root array only. A flat read misses every namespaced object, which is why a naive scan reports a definition as absent everywhere.

After editing the manifest, re-download symbols. Adding the dependency does not place the missing `.app` in `.alpackages`; until the package is fetched the same error persists and looks like the fix did not work.

See sample: `cmfrt-test-app-declare-library-dependencies.good.json`.

## Anti Pattern

A test manifest that declares only `Tests-TestLibraries`, `System Application Test Library`, `Test Runner`, `Library Assert`, `Any` and the production app while the test source calls into `Library - Variable Storage`, `Library - Sales`, `Library - Marketing`, `Library - Utility` or `Permissions Mock`. Nothing fails locally as long as every hop was fetched, so the omission survives review; it surfaces later as a missing-codeunit error naming an object the manifest never referenced, and it breaks whenever Microsoft reorganises the test-library graph or a symbol download skips one link.

Equally wrong is closing that error by guessing: adding a dependency on the app whose name most resembles the codeunit, or on whichever app a byte-grep of `.alpackages` matched. A grep hits *references* as well as definitions, so it routinely points at a consuming app rather than the defining one, and the added entry is then both wrong and harmless-looking, since the build still resolves the object transitively.

See sample: `cmfrt-test-app-declare-library-dependencies.bad.json`.
