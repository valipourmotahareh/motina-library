# Decision log

This is a lightweight record of confirmed direction and pending choices, not a set of fabricated architecture decisions. Rationale below explains the supplied constraints; it does not claim historical deliberations.

## Confirmed direction

| Decision | Rationale / basis |
| --- | --- |
| Flutter targeting Android, iOS, and Web; organization `com.motinadev` | Confirmed project targets and identity; preserve all three platforms. |
| Local-first MVP with future sync support in mind | Keep personal collection workflows usable without an account or network while considering future data evolution. |
| MVP: list owned books; add; edit/delete; manage reading status; search/filter; view details | Confirmed scope keeps the first version focused on personal library management. |
| AI, authentication, sync, and ISBN scanning excluded from MVP | Explicit scope boundary prevents expanding the initial implementation. |
| Editorial + Clean Minimal visual direction | Confirmed design direction guides later UI and token decisions. |
| Lightweight, pragmatic engineering for one engineer | Favor readable, testable code and avoid unnecessary dependencies and architectural layers. |

## Observed baseline

- Initial commit: `77cffaf59e8c27b6e854e35d14d8d0dab7fa35fb`.
- `lib/main.dart` currently displays Hello World; MVP implementation has not been established.
- `pubspec.yaml` declares Dart `^3.9.0`, Flutter, `flutter_test`, and `flutter_lints`; `analysis_options.yaml` includes Flutter lints.
- The initial README lists `flutter analyze`, `flutter test`, and `flutter build web`. These are commands to run, not recorded passing results. There is no Dart test suite yet.

These observations are not new architecture decisions.

## Decision ownership

The project maintainer owns product scope and approves product behavior. The implementing engineer proposes technical choices with concise tradeoffs; the maintainer accepts them before they are treated as settled. For this solo project these roles may be held by the same person. Coding agents may recommend choices but must not turn pending items into approved decisions without maintainer authorization.

## Pending decisions

| Topic | Status and next decision boundary |
| --- | --- |
| Architecture and code organization | Pending. Choose the smallest useful separation when implementing the first vertical feature. |
| State management | Pending. Evaluate actual UI/state needs before choosing an approach or package. |
| Database and persistence | Pending. Evaluate offline behavior, Android/iOS/Web support, data durability, and future schema evolution before implementation. |
| Navigation | Pending. Choose based on actual flows and Web navigation needs. |
| Design Tokens | Pending. Define shared values and location before expanding styled UI. |
| Book data and behavior | Pending. Fields, validation, duplicates, statuses, ordering, search/filter semantics, and delete interaction are TBD in the draft brief. |
| Platform baseline and quality targets | Pending. Exact Flutter pin, minimum platform versions, performance budgets, and accessibility verification targets need decisions. |
| Future sync | Pending and outside MVP. Backend, protocol, authentication, identity, conflicts, and migration strategy are unspecified. |

When resolving a topic, record the actual choice, reason, relevant tradeoffs, and scope here. Do not treat a pending item as approval to add scaffolding or dependencies.
