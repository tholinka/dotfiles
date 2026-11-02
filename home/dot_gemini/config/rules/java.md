---
trigger: glob
description: 'Rules for working with Java'
globs: '*.java'
---

- Always read the Global Instructions.
- Always use `mvn` directly, never use `mvnw`.
- Prefer the various `Utils` helpers over manually checks, `Objects.nonNull`, `CollectionUtils.isNotEmpty`, `StringUtils.isNotBlank`, `Strings.CI.equalsAny`, etc.
- Prefer `import`'s over bare package paths, convert existing bare package paths to imports when touching that line.
- Prefer functional programming over imperative programming. User `map`, `filter`, `reduce`, etc instead of for loops and if statements.
- Prefer using method references over lambdas when possible.
