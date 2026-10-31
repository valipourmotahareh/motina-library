# Motina Library

Motina Library is a personal library application built with Flutter for Android, iOS, and the web.

## Product goals

Help people organize books they own, track reading status, and find a book in their collection. The product is local-first, with future sync support in mind. Its visual direction is Editorial + Clean Minimal.

## Planned MVP

- List owned books.
- Add books.
- Edit and delete books.
- Manage reading status.
- Search and filter books.
- View book details.

AI, authentication, sync, and ISBN scanning are outside the MVP.

## Development status

The Flutter project is initialized and the initial commit is published on `main`. The current application displays a Hello World screen; the MVP features above are planned. There are no Dart unit or widget tests yet. No test coverage, CI, or release status is asserted here.

Architecture is not finalized. State management, database, navigation, and Design Token implementation choices remain pending. See the [decision log](docs/decision-log.md).

## Getting started

Install a Flutter SDK that satisfies the Dart SDK constraint `^3.9.0` in `pubspec.yaml`; an exact Flutter version has not been pinned. Set up Android tooling for Android development, or macOS with Xcode for iOS. Use a Flutter-supported browser for Web development.

From the repository root, run:

```sh
flutter doctor
flutter pub get
flutter devices
flutter run
```

Choose an available target when prompted, or use `flutter run -d <device-id>`. For Web with Chrome installed, use `flutter run -d chrome`.

## Validation

Run these commands as applicable:

```sh
flutter analyze
flutter test
flutter build web
```

`flutter test` needs Dart tests to be added before it can provide useful test validation. These commands are instructions, not a claim that they passed. Platform-specific validation should accompany relevant Android and iOS changes.

## Roadmap

1. Establish product and engineering documentation; resolve the pending implementation decisions when needed.
2. Implement local book management and reading status.
3. Add search, filters, details, and focused tests; refine responsive and accessible UI.
4. Validate the MVP on Android, iOS, and Web.

Future sync may be considered after the MVP. No delivery dates are committed.

## Repository structure

```text
AGENTS.md                       Coding agent rules
README.md                       Project entry point
docs/product-brief.md           Draft scope and acceptance criteria
docs/engineering-guidelines.md  Development standards
docs/decision-log.md            Confirmed and pending decisions
lib/                           Flutter application (currently main.dart)
android/                       Android host project
ios/                           iOS host project and native test scaffold
web/                           Web host assets
pubspec.yaml                   Package metadata and dependencies
pubspec.lock                   Resolved dependency versions
analysis_options.yaml          flutter_lints configuration
```

Package name: `motina_library`. Organization: `com.motinadev`. Repository: [valipourmotahareh/motina-library](https://github.com/valipourmotahareh/motina-library).
