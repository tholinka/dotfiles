# General Instructions

- Do NOT put a copywrite header on any file, they are never required.
- Do NOT put "traces to", "FR-", "US-" or any other "feature" prefix in code comments.
- Prefer adding to existing files over creating new classes.
- While unit testing, there should be one file per source file under test, and the test file should be named after the class it is testing
- Prefer simple and easy to read over complex or hard to understand
- Prefer DRY. Avoid over-engineering. If a solution is simple and works, use it. If it needs to be more complex, make it more complex.
- Avoid small functions and utility classes. If a function is ony used in one place, it should be inlined. If a class is only used in one place, it should be inlined.
