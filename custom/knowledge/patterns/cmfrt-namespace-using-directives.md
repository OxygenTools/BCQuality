---
bc-version: [23..]
domain: patterns
keywords: [namespace, using, using-directive, object-resolution, qualified-name, symbol-lookup, compile-error, base-application]
technologies: [al]
countries: [w1]
application-area: [all]
---

# Populate the using directives for every namespace a file references

## Description

BCQuality already covers *declaring* a namespace: `appsource/two-level-namespace-replaces-object-affix-not-extension-member-affix.md` (a two-level namespace as the collision strategy) and `breaking-changes/namespace-is-part-of-published-object-identity.md` (a published namespace is part of object identity). Neither covers *consuming* one, which is where the practical failures happen.

AL resolves a simple object name only within the file's own namespace and the namespaces that file imports with `using`. From BC24 the W1 base application is itself fully namespaced, so the moment a file declares `namespace`, it loses the flat global view it had before: every reference to a base-application or third-party object needs either a `using` for that object's namespace or a fully qualified reference. Two failures dominate:

- **Missing directive.** The file declares a namespace and references `Customer`, `Item`, or `Type Helper` with no matching `using`. The compiler reports that the name does not exist in the current context, which reads like a typo rather than a missing import.
- **Invented namespace.** A `using` is written from the object's functional area rather than looked up (`Microsoft.Sales` for `Customer`, `Microsoft.Jobs` for `Job`). This fails on the namespace itself and is the worse of the two, because a wrong-but-plausible import looks deliberate to the next reader.

Namespaces are also **not stable across versions** — the base application was namespaced in BC24 and the layout is refined between releases, so a directive that is correct on one version can be wrong on another. A namespace can never be inferred from an object's name or functional area; it has to be read from the symbols the app actually compiles against.

## Best Practice

Every file that declares a namespace or references an object outside its own namespace carries a complete, verified `using` list:

- **Order and placement.** `namespace <Root>.<Area>;` is the first statement in the file. The `using` directives follow it immediately, one per imported namespace, before the object declaration — nothing else in between. A file with no namespace declaration may still carry `using` directives.
- **Resolve, never infer.** Read each object's actual namespace from the symbol packages the app compiles against (for example the AL MCP server's object lookup over `.alpackages`, or the object's own source) for the BC version in `app.json`. If the namespace cannot be resolved, fully qualify the reference instead of guessing an import.
- **Per-file scope.** Directives apply only to the file containing them. Adding a `using` to one file does nothing for its siblings — each new file starts from zero.
- **Own namespace needs no import.** Objects in the same namespace resolve without a directive; never import the file's own namespace.
- **Every reference counts, not just variables.** Extension targets (`tableextension … extends Customer`), attribute arguments (`[EventSubscriber(ObjectType::Table, Database::Customer, …)]`), and object references (`Page::"Customer Card"`, `Codeunit::"Type Helper"`, `Enum::"…"`) all require the namespace to be imported.
- **Qualify, do not import, to resolve ambiguity.** When two imported namespaces expose the same simple name, the reference is ambiguous and adding a third `using` cannot fix it — write the fully qualified name.
- **Keep the list minimal.** Every directive must tie to a reference in that file. Never copy a `using` block wholesale from another file.

This article does not define the CMFRT namespace shape. If the app has no agreed root namespace, agree one before adding namespaces to new files — per `breaking-changes/namespace-is-part-of-published-object-identity.md` it becomes part of published object identity and cannot be reorganized afterwards.

See sample: `cmfrt-namespace-using-directives.good.al`.

## Anti Pattern

A file that declares `namespace` and then references base-application objects with no `using` at all, or with a list that covers only some of them. A `using` invented from the object's functional area instead of looked up. A `using` block copied from a neighbouring file, importing namespaces the file never references. Importing the file's own namespace. Adding another `using` to resolve an ambiguous simple name instead of qualifying the reference.

See sample: `cmfrt-namespace-using-directives.bad.al`.
