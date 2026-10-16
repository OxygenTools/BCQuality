---
bc-version: [all]
domain: upgrade
keywords: [upgrade-tag, upgrade-codeunit, subtype-upgrade, upgrade-tag-definitions, on-get-per-company-upgrade-tags, on-get-per-database-upgrade-tags, has-upgrade-tag, set-upgrade-tag, event-subscriber, 05-upgrade]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT keeps upgrade code and its upgrade tags in one codeunit

## Description

An upgrade step has three parts: the code that changes the data, the tag that marks the step as done, and the `OnGetPerCompanyUpgradeTags` or `OnGetPerDatabaseUpgradeTags` subscriber that marks the step as done for a new company. The sample of `microsoft/knowledge/upgrade/register-upgrade-tags-with-subscribers` puts the tag getter and the subscriber in a separate "Upgrade Tag Definitions" codeunit. CMFRT does not use that split. With two codeunits, the reader opens both to see if a step is complete, and a new tag can get its getter without its subscriber.

In October 2026, PR 14791 (ZC_CMFRT_Lippens) added codeunit 55003 "CMFRT LI Upgrade" and a second codeunit 55002 "CMFRT LI Upgrade Tags" with the tag getter and the subscriber. The reviewer voted -5: "upgrade en upgrade tags zetten wij in 1 codeunit, geen 2". The agent took the split from the Microsoft sample.

An event subscriber is valid in a `Subtype = Upgrade` codeunit. The base application uses this: codeunit 104059 "Serv. Upgrade BaseApp" (`Subtype = Upgrade`) holds its tag getters, its `OnGetPerCompanyUpgradeTags` subscriber and an `OnCompanyInitialize` subscriber. In the DevGIT.AL repos, 24 upgrade codeunits also hold their tag subscriber.

This article takes precedence over `register-upgrade-tags-with-subscribers` for the place of the tag. The content rules of that article still apply: set the tag after the work, and seed it from the install codeunit when a first install must skip the step.

## Best Practice

Give each app one `Subtype = Upgrade` codeunit, `"CMFRT <ABBR> Upgrade"`, in `src/05 Upgrade/` (`architecture/cmfrt-feature-folder-layout`). Put all of these in that codeunit, in the order of `patterns/cmfrt-codeunit-member-order`:

1. The `OnUpgradePerCompany` and `OnUpgradePerDatabase` triggers. A trigger only calls the helpers (`microsoft/knowledge/upgrade/triggers-call-helpers-not-implementations`).
2. One `internal procedure CMFRT<ABBR>Get<Change>Tag(): Code[250]` for each tag. It is not `local`, because the install codeunit can call it to seed the tag.
3. One `local procedure` for each change. It exits when `HasUpgradeTag` is true, and it calls `SetUpgradeTag` as its last statement.
4. The `OnGetPerCompanyUpgradeTags` and `OnGetPerDatabaseUpgradeTags` subscribers, which add each tag of their scope.

With one upgrade codeunit, the order of the steps is the order of the calls in the trigger. Two upgrade codeunits run in an order that is not fixed (`microsoft/knowledge/upgrade/install-and-upgrade-codeunits-have-no-order`).

Scope for a released app:

- 12 apps already have a separate tag codeunit, for example `"CMFRT BA UpgradeTagDefinitions"` in CMFRT_Base. Do not move their tag getters only for this rule. A moved public procedure is a breaking change, and the test app of CMFRT_Base calls that codeunit (`breaking-changes/cmfrt-never-delete-always-obsolete`). In such an app, add a new tag to the existing tag codeunit, so the app keeps one place for its tags.
- When the tag codeunit and the upgrade codeunit are both unreleased, merge them before the release.

See sample: [`cmfrt-upgrade-tags-in-upgrade-codeunit.good.al`](cmfrt-upgrade-tags-in-upgrade-codeunit.good.al).

## Anti Pattern

A new codeunit without `Subtype = Upgrade`, often named "Upgrade Tags" or "Upgrade Tag Definitions", that holds the tag getters and the `OnGet…UpgradeTags` subscriber of the upgrade codeunit next to it. This is the shape of the Microsoft sample and of PR 14791 before the fix. A second `Subtype = Upgrade` codeunit in the same app is the same finding.

See sample: [`cmfrt-upgrade-tags-in-upgrade-codeunit.bad.al`](cmfrt-upgrade-tags-in-upgrade-codeunit.bad.al).
