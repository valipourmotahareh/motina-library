# Product brief

Status: draft based on confirmed project direction. No earlier approved product brief was found. The criteria below describe intended behavior, not implemented features.

## Vision and target users

Provide a focused personal library for people who want to organize books they own and manage reading status. More specific audience research and personas are TBD. Use an Editorial + Clean Minimal visual direction.

## MVP scope

1. List owned books.
2. Add books.
3. Edit and delete books.
4. Manage reading status.
5. Search and filter books.
6. View book details.

AI, authentication, sync, and ISBN scanning are out of MVP scope.

## User flows and functional acceptance criteria

| Flow | Intended acceptance criteria | Unresolved details |
| --- | --- | --- |
| Open collection | Show locally saved owned books; show a clear empty state when none exist. | Ordering and list presentation TBD. |
| Add a book | Open entry form, submit valid data, and see the saved book in the collection. Invalid input receives actionable feedback. Cancelling creates no book. | Fields, required values, and duplicate policy TBD. |
| Edit a book | Open an existing book, save valid changes, and see updated values in its list and details. Cancelling preserves saved data. | Editable fields TBD. |
| Delete a book | Remove the selected book from local storage and subsequent list/detail views; make the consequence clear and guard against accidental loss. | Confirmation or undo interaction TBD. |
| Change reading status | Assign a supported status and show the saved value consistently after reopening the app. | Status vocabulary and transitions TBD. |
| Search and filter | Show books matching the active query and filters, communicate no results, and allow clearing criteria to return to the collection. | Search fields, matching rules, filters, and combination semantics TBD. |
| View details | Open a selected book and show its saved information and reading status; return to the collection. | Detail fields and navigation behavior TBD. |

## Non-functional requirements

- Support Android, iOS, and Web with responsive layouts and accessible controls.
- Keep core MVP operations usable without authentication or a network connection.
- Persist successful changes locally across app restarts using the eventual storage choice. Exact browser persistence guarantees and platform limitations are TBD.
- Surface storage failures clearly; do not present failed writes as successful or silently discard user data.
- Keep the implementation readable and testable for a single engineer. Specific performance budgets, minimum OS/browser versions, and accessibility verification targets are TBD.
- Avoid exposing personal collection data or secrets in logs or source control. Backup, export, and data recovery policy are TBD, not committed MVP features.

## Local-first and future sync constraints

Local storage is the MVP source of truth. Core flows must not require an account, backend, or network. When designing persistence, assess how identity and schema changes could affect future sync, and record the chosen tradeoffs before implementation. Do not add a sync engine, speculative protocol, remote service, or extra layers now.

Sync transport, backend, authentication, conflict resolution, cross-device identity, and migration strategy are TBD. Future sync support is a direction, not a promised delivery milestone.
