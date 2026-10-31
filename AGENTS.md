# Coding agent instructions

- Follow existing project conventions and use idiomatic Dart and Flutter.
- Apply SOLID pragmatically; prefer simple, readable, testable code over premature abstractions.
- Keep widgets focused on presentation and interaction wiring. Put business rules outside UI widgets.
- Add no unnecessary packages or architectural layers. Justify dependency changes with the need, alternatives, platform support, and maintenance impact.
- Use shared Design Tokens for colors, spacing, typography, radii, and other design values. Token definitions and their location are pending; do not scatter hardcoded values or build a token system without a relevant task.
- Respect Android, iOS, and Web compatibility. Avoid platform-specific APIs without an appropriate boundary and supported behavior on other targets.
- Never invent undocumented backend or protocol behavior. Authentication, sync, AI, and ISBN scanning are outside the MVP.
- Keep changes limited to the requested task. Do not introduce architecture scaffolding or resolve pending technical choices without a relevant request.
- Do not modify generated files unnecessarily; use their owning tool when regeneration is required.
- Run testing, analysis, and validation appropriate to the requested change; these are part of the task, not unrelated work.
- Never claim tests or checks passed unless executed. Report commands, results, and any skipped or blocked validation.
- Always report changed files and validation results.
- Never commit, push, or start unrelated tasks unless requested.

Read the [product brief](docs/product-brief.md), [engineering guidelines](docs/engineering-guidelines.md), and [decision log](docs/decision-log.md) before relevant work. Treat the brief as a draft and pending decisions as unresolved.
