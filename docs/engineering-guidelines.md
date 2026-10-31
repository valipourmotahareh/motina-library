# Engineering guidelines

These standards fit a small Flutter application maintained by one engineer. They do not select an architecture or require additional layers.

## Naming and code style

- Use `lower_snake_case` for Dart files, `UpperCamelCase` for types, and `lowerCamelCase` for members and variables. Use names that describe intent.
- Follow Dart formatting and the existing `flutter_lints` configuration. Run `dart format` on changed Dart files and `flutter analyze` for implementation changes.
- Prefer focused functions and explicit behavior; comment on reasons and constraints rather than restating code.

## Separation of concerns

- Widgets render state and handle interaction wiring; keep validation rules, persistence, and business decisions outside UI widgets.
- Apply SOLID only where it improves clarity or testability. Extract responsibilities when needed; do not create empty interfaces, speculative repositories, or mandatory layers.
- Architecture, state management, database, and navigation are pending. Document a justified choice when a task requires one.

## Error handling

- Handle expected validation and storage failures at the appropriate boundary. Give users actionable feedback and preserve their input where practical.
- Await writes before reporting success. Do not swallow exceptions or replace failed reads with misleading empty collections.
- Keep diagnostic context useful without logging credentials or unnecessary personal data. Avoid blanket catches that hide programming errors.

## Dependencies

- Prefer existing SDK capabilities. Explain why a package is needed, alternatives considered, maintenance and license implications, and Android/iOS/Web compatibility before changing dependencies.
- Keep application dependency resolution reproducible with `pubspec.lock`; do not edit generated or resolved files by hand unnecessarily.
- Do not upgrade unrelated dependencies as part of a feature or documentation change.

## Responsive, adaptive, and accessible UI

- Use available space and content constraints rather than assuming a phone-sized screen. Check narrow and wide layouts and increased text size.
- Respect platform input differences: touch, keyboard, pointer, focus, and scrolling. Keep Web free of unsupported unconditional native APIs.
- Use shared Design Tokens for visual constants. Token values and implementation are pending; follow the Editorial + Clean Minimal direction without scattering hardcoded styles.
- Label interactive controls, preserve logical focus order, provide visible focus, and support screen readers. Do not convey status through color alone; check contrast and touch target usability.

## Testing and validation

- Add unit tests for meaningful business rules and data transformations, and widget tests for important interactions, validation, and empty/error states as features are implemented.
- Keep tests deterministic and independent of live services; avoid tests that merely mirror implementation details.
- Use `flutter analyze`, `flutter test`, and `flutter build web` as applicable. No Dart tests exist in the initial project; do not describe a missing test suite as passing.
- Validate affected behavior on the relevant platforms, including Android and iOS when native behavior is involved. State untested platforms explicitly.
- For documentation-only changes, check links, consistency, scope, and the changed file list; Flutter builds are not required.

## Git workflow and pull request review

- Start from clean `main`, verify it against the remote, and work on a focused branch. Keep unrelated changes out of the diff.
- Never commit or push unless requested. Never rewrite published history or force push without explicit authorization.
- Before requesting review, inspect the diff for generated artifacts, secrets, unintended native changes, and dependency churn.
- Describe the problem, resulting behavior, relevant decisions, and actual validation in the PR. Mark remaining limits honestly.
- A solo review can be a deliberate self-review: check scope, readability, error paths, accessibility, platform support, tests, and documentation before merging.

## Definition of Done

- Requested behavior or documentation is complete and matches the agreed scope; unresolved product choices remain explicit.
- The diff is focused, readable, and free of unnecessary packages, abstractions, generated changes, and secrets.
- Required checks pass before the work is considered ready to merge. If a check fails or cannot run, record the blocker and leave readiness pending unless the maintainer explicitly accepts the limitation.
- Tests cover meaningful changed behavior where appropriate; relevant platform and accessibility checks are recorded.
- Documentation and decision records reflect actual changes. The handoff lists changed files, validation results, and remaining risks.
- Commit, push, review, and merge occur only within the authorized task; they are not implicit requirements of a local documentation handoff.
