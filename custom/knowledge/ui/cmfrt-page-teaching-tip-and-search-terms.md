---
bc-version: [21..]
domain: ui
keywords: [abouttitle, abouttext, teaching-tip, additionalsearchterms, search-terms, usagecategory, factbox, copilot, page-description]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT top-level pages describe themselves for users and Copilot

## Description

Copilot chat chooses a page for a question from the page caption, the teaching tip (`AboutTitle`, `AboutText`) and the search terms. The 2026-10 Copilot readiness scan of 95 CMFRT apps found 1 of 409 top-level pages with `AboutTitle` and `AboutText`, and 0 pages with `AdditionalSearchTerms`. Users and Copilot ask about a "project" or a "vorderingsstaat". The pages say "Job" and "Progress State". Without search terms, Copilot does not connect the two.

`microsoft/knowledge/style/abouttitle-abouttext-teaching-tips` asks for a teaching tip only when the other pages in the app have one. In a CMFRT app, every new top-level page needs one. This article takes precedence.

## Best Practice

- Give every new `Card`, `List`, `Document`, `ListPlus` and `Worksheet` page a `Caption`, an `AboutTitle` and an `AboutText`.
- `AboutTitle`: "About <entities>" for a list, "About <entity> details" for a card or a document.
- `AboutText`: two or three short sentences. Say what the page holds and what the user does with it. Do not give click-by-click steps.
- Give every page with a `UsageCategory` other than `None` an `AdditionalSearchTerms` value. List the synonyms from the glossary in `custom/knowledge/naming/cmfrt-caption-whole-words`, in English and in Dutch.
- Give every `CardPart` and `ListPart` a `Caption` that names the entity it shows.
- Use the `CMFRT <ABBR>` prefix in `Caption` only. `AboutTitle`, `AboutText` and `AdditionalSearchTerms` hold plain words.

See sample: [`cmfrt-page-teaching-tip-and-search-terms.good.al`](cmfrt-page-teaching-tip-and-search-terms.good.al).

## Anti Pattern

- A new top-level page with no `AboutTitle` or no `AboutText`.
- A searchable page (`UsageCategory` set) with no `AdditionalSearchTerms`.
- A page with no `Caption`, so the user sees the object name.
- An `AboutText` that lists clicks ("Choose New, then fill in …").
- A FactBox with no `Caption`.

See sample: [`cmfrt-page-teaching-tip-and-search-terms.bad.al`](cmfrt-page-teaching-tip-and-search-terms.bad.al).

## See also

`microsoft/knowledge/style/abouttitle-abouttext-teaching-tips` gives the Microsoft form of `AboutTitle` and `AboutText`. `custom/knowledge/naming/cmfrt-caption-whole-words` holds the glossary for the search terms. Role Center pages and modal dialogs do not support teaching tips and are out of scope.
