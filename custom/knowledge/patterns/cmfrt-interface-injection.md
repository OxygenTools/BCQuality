---
bc-version: [all]
domain: patterns
keywords: [interface, injection, extensibility, implementation, handled, on-before, pluggable, override]
technologies: [al]
countries: [w1]
application-area: [all]
---

# CMFRT interface injection pattern

## Description

The CMFRT interface injection pattern makes any table-level operation pluggable by dependent extensions using a four-step structure. Step 1: define an AL `interface` with a single procedure matching the operation's signature. Step 2: add a parameterless entry-point procedure on the base table that instantiates the default implementation codeunit, fires an `OnBefore` integration event with `var Handled: Boolean`, exits early if `Handled` is true, and otherwise calls the overloaded form in Step 3. Step 3: add an overloaded procedure on the same table that accepts the interface as a parameter and delegates to it. Step 4: declare the `[IntegrationEvent(false, false)]` `OnBefore` event as a local procedure passing `var Handled: Boolean`. Dependent extensions subscribe to `OnBefore`, set `Handled := true`, and call the overloaded procedure with their own implementation codeunit.

## Best Practice

Apply this pattern whenever a calculation or operation might need different behaviour in different customer deployments. The separation between the parameterless entry-point and the interface-accepting overload means a subscriber can inject an alternative implementation without modifying the base table. The default implementation remains the fallback for all extensions that do not subscribe.

See sample: `cmfrt-interface-injection.good.al`.

## Anti Pattern

Placing the entire implementation directly inside the entry-point procedure with no interface and no `OnBefore` event. Monolithic entry points cannot be overridden by a subscriber without an AL override pattern, which is a breaking change for the overriding extension every time the base procedure is updated.

See sample: `cmfrt-interface-injection.bad.al`.
