---
bc-version: [all]
domain: testing
keywords: [test-suite, install-codeunit, al-test-suite, test-registration, test-app, test-discovery, ci]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT test app ships an install codeunit that registers its test suite

## Description

Every CMFRT test app must contain exactly one codeunit with `Subtype = Install` whose `OnInstallAppPerCompany` trigger creates the app's AL Test Suite and registers the app's test codeunits into it. Publishing a test app does not populate the `AL Test Suite` / `AL Test Method Line` tables by itself — without this codeunit the suite exists only if a developer opens the AL Test Tool and adds the codeunits by hand. That manual step is invisible in source control, is not repeated on a fresh container or a rebuilt sandbox, and silently drops any test codeunit added after the suite was last populated. An automated run then reports a green result over an empty or stale suite.

## Best Practice

Add one install codeunit per test app, named `CMFRT <ABBR> Test Install`, holding no logic other than suite registration. In `OnInstallAppPerCompany`: delete the suite if it already exists (`ALTestSuite.Delete(true)`), call `TestSuiteMgt.CreateTestSuite(SuiteCode)`, `Commit()`, re-`Get` the suite, then `TestSuiteMgt.SelectTestMethodsByRange(ALTestSuite, ...)`. Deleting first makes reinstall and upgrade idempotent, so the suite always reflects the codeunits actually shipped rather than an accumulated history. The `Commit()` is required: `CreateTestSuite` writes the header that `SelectTestMethodsByRange` then reads back.

Pass the test app's full object ID range as declared in its `app.json` `idRanges`, not a hand-maintained span of the IDs that happen to exist today. A subset range is correct only until the next test codeunit is added, and nothing fails when it goes stale — the new tests are simply never selected. Keep the suite code a locked `Label` and truncate it with `CopyStr(..., 1, MaxStrLen(ALTestSuite.Name))`, since `Name` is `Code[10]`.

See sample: `cmfrt-test-suite-install-codeunit.good.al`.

## Anti Pattern

A test app that ships test codeunits and no install codeunit. Nothing in the app registers a suite, so `AL Test Suite` stays empty after publish and the AL Test Runner has nothing to execute. The failure mode is silence, not an error: a pipeline that runs the named suite finds zero test methods and passes.

The near-miss variants fail the same way. Registering only some codeunits by explicit `SelectTestMethodsByCodeunit` calls means every new test codeunit needs an edit to the install codeunit and is skipped until someone remembers. Omitting the `Delete(true)` leaves a suite from a previous version in place, so renamed or removed test codeunits linger as broken lines. Omitting the `Commit()` makes `SelectTestMethodsByRange` operate on a suite the transaction has not yet written. Putting the registration in a `Subtype = Upgrade` codeunit instead of an install one skips it entirely on the first install, which is exactly the case a fresh CI container hits.

See sample: `cmfrt-test-suite-install-codeunit.bad.al`.
