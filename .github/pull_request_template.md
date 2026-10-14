## Article

- Slug: `custom/knowledge/<domain>/<slug>.md`
- [ ] The `.bad.al` and `.good.al` samples are added or updated.

## cmfrt-lint

The lint lives in PlaybookConfig: `claudefiles/skills/cmfrt-lint/`. Skip this section when the PR does not add, rename or remove a `custom/` article, and does not change what an article flags.

- [ ] The article is in one list in `cmfrt-lint-selftest.sh`: LINTED, COMPILER or REVIEWER. PlaybookConfig PR: !____
- [ ] For a LINTED article: `cmfrt-lint.sh` has the rule, and the selftest gives `PASS` against this branch.
- [ ] `bcquality-commit.txt` moves to the merge commit of this PR, after the PlaybookConfig PR merges.
