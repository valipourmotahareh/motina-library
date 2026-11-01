# Library Home specification

Status: proposed interaction and layout specification. Read the [design system](design-system.md) for token values and component contracts and the [product brief](../product-brief.md) for confirmed scope. A Web prototype now exists; the acceptance targets below are not claims of completed production behavior.

## Confirmed requirements versus proposals

Confirmed: owned-book list, add, edit/delete, reading status, search/filter, and details; local-first Android/iOS/Web support; Editorial + Clean Minimal direction. Persian/English, RTL, keyboard access, and responsive layouts are requirements for this design task.

Proposed: the following hierarchy, grid, component states, filtering interaction, and acceptance targets. They are reviewable defaults, not approvals of pending product behavior. Open choices appear at the end. No new product features, navigation packages, or data fields are selected.

## Implemented prototype boundary

- Local immutable fixtures in `lib/prototype/demo_books.dart` supply eight books and provisional reading statuses. Search matches title/author substrings case-insensitively; it combines with one status filter. This is demo behavior, not the final product search contract.
- Add displays an explicit prototype explanation. Cards have no details navigation; edit/delete, persistence, backend, and sync are not implemented. A labeled review control switches to the empty-library view without deleting data.
- Actual title metadata wraps fully; only decorative cover lettering can ellipsize. Original typographic mock covers and neutral missing-cover placeholders use no external artwork.
- Vazirmatn v33.003 (SIL OFL 1.1) is bundled at 400/500/600, as recorded in the [design system](design-system.md). The UI is Persian-first with forced RTL; full localization is pending.

## Page hierarchy and interaction

1. Header: one page heading, proposed English copy “My library”, and the primary Add book action.
2. Search: labeled SearchField below the heading; full available width up to the search maximum token.
3. Filters: ReadingStatusFilter below search; All selected initially, then approved reading statuses. Wrap into multiple rows when needed.
4. Collection region: result summary, then book grid or the applicable state. Announce updated result counts politely without moving keyboard focus.

Keep one visible primary Add book action on populated/no-results views. On very narrow widths move it below the heading; do not replace it with an unlabeled plus. In the empty-library view the empty-state button is the primary action and the header duplicate is omitted. No floating action button, sidebar, sort menu, account control, or bottom navigation is required by this spec.

Activating Add opens the eventual add-book flow. Successful save returns to the collection with the change reflected; cancel returns without adding data. Opening a card shows book details, where edit/delete and reading-status management can be reached as part of those existing MVP flows. Exact forms and details layout are outside these two specs. Restore collection query, filter, scroll, and relevant focus on return where possible. After deletion return focus to the next remaining card, otherwise the collection heading or empty-state action.

Proposed search interaction: update results while typing against local data after composition ends; Enter must also yield the current results. Search and one status filter apply together; All removes the status restriction. Clear search removes only the query; “Clear search and filters” resets both. Do not add server calls. Searchable fields, normalization (including Persian/Arabic variants), timing, and matching rules need product approval before implementation. Preserve raw input; never change user data to normalize a query.

## Grid and responsive layout — proposed

Let A be available content width after safe areas and page insets, capped at 1200 logical units. With default text size, choose columns as max(1, floor((A + 16) / (160 + 16))). Divide remaining width evenly, with 16-unit gaps; keep partial final rows aligned to logical start. Below 160 available units use one column without horizontal overflow. Width is a constraint, not a device classification.

The implemented `ResponsiveGrid` owns column and item-width calculations using available parent width, not a device breakpoint. Its minimum width scales using Flutter's TextScaler sampled at 16 logical units. LibraryHome supplies 160 minimum item width, 16 horizontal gap, and 32 run gap. It accepts generic children and leaves filtering, empty states, and scrolling with the screen. All children are eagerly built; large-collection performance remains unvalidated.

Use variable-height rows sized to their tallest card; do not impose a fixed card height. At large text sizes increase the effective minimum width to fit labels or reduce to one column. If a fixed-height grid implementation would clip text, choose a wrapping/row layout that allows content to grow instead. This is a behavior requirement, not a package or architecture choice.

| Usage scenario | Expected adaptation, determined by actual available space |
| --- | --- |
| Small phone | At 320 viewport width with 16-unit insets, A=288: one column. Header action stacks if title and action cannot fit. Search fills the column; filters wrap. |
| Standard phone | At 400 viewport width with 16-unit insets, A=368: two columns at default type size; fall back to one for large text or longer localized labels. |
| Tablet | Multiple columns as permitted by the formula; header action shares a row only when content fits. No new pane or navigation mode. |
| Desktop Web | Center capped content; formula allows at most six columns at the default minimum width. Search stays capped at 560. Keyboard, pointer, browser zoom, and resizing preserve access. Narrow desktop windows behave like any narrow viewport. |

These are illustrative width checks, not hardcoded phone/tablet breakpoints. Use 24-unit insets only when content still fits comfortably; at wider widths extra space becomes outer margins. Safe areas, virtual keyboards, landscape, and browser zoom reduce usable space and must trigger reflow. Scroll the document vertically; avoid nested horizontal scrolling for chips or the grid.

## Content and state behavior

- **Book title:** show up to three lines with an ellipsis at default scale; accessible name retains the full title. Details exposes the full wrapping title. Long unbroken strings may wrap at available boundaries; do not insert characters into stored text. At large text size allow more lines or full wrapping rather than clipping. No tooltip-only access to text.
- **Mixed-language text:** UI follows locale direction; card order starts at logical start. Title paragraph follows content direction, with bidi isolation for embedded runs and numbers. Reading order and keyboard order match the visual sequence. Covers never mirror.
- **Missing/failed cover:** use BookCoverPlaceholder without changing card geometry; omit duplicate cover descriptions from assistive output. Missing cover is not a collection error.
- **Empty library:** only after a successful read of zero books. Proposed copy: “Your library starts here” / “Add a book you own.” Show Add book. Search and filters may be omitted until a book exists.
- **No results:** collection exists but active criteria match nothing. Proposed copy: “No matching books” with “Clear search and filters”. Keep search, filters, and header Add book available. Do not imply stored books were deleted.
- **Initial local read:** show a clearly labeled loading state only while a read is pending; never briefly show an empty-library claim first. Avoid simulated progress percentages.
- **Read failure:** show “Could not load your library” with a retry action. Do not present empty results as success; keep query/filter input available but disable applying it until data is available. Do not enable writes while collection availability is unknown unless separately designed to be safe.
- **Failure with prior data:** retain the last successfully loaded content and show a nonblocking error/retry message; identify that it may be out of date. Announce errors without repeatedly stealing focus. Do not invent backend error codes.

English examples above describe intended copy; the implemented prototype uses provisional Persian text. Native-language editorial review remains pending.

## Keyboard and assistive interaction — proposed

Tab follows header action, search, clear-search control when present, filters in reading order, then cards/results actions. Shift+Tab reverses. Each filter is an ordinary focusable selection button with an announced selected state; do not claim radio-group semantics without implementing its arrow-key contract. Enter/Space activate buttons/cards; the search field retains ordinary text-editing behavior. No global shortcuts are required.

Show focus with the design-system ring and keep it visible when scrolling. No keyboard trap. Announce heading, field label, card title/status, selected filters, loading/error state, and result summary meaningfully. Group card content into one actionable semantic item. After closing add/details restore focus to the invoking control when it still exists. Proposed Web browser Back returns from details/add without trapping users; route and URL strategy remain pending.

## Proposed UX acceptance criteria

These are verifiable implementation acceptance targets, not passing results. Confirmed scope is listed above; tests below apply after the corresponding proposal is accepted.

| Area | Verification scenario | Expected result |
| --- | --- | --- |
| Visual consistency | Compare populated, empty, error, focus, and selected states | Shared tokens used; no unexplained style variants; required text contrast at least 4.5:1 and boundaries/focus at least 3:1 against adjacent backgrounds. |
| Responsive layout | Resize continuously from 320 to 1440 logical units and test intermediate widths and landscape | No page-level horizontal overflow, clipped controls, overlapping content, or inaccessible actions; column count follows actual fit. |
| Scaling | Test 200% text scaling on native targets and Web reflow at 320 CSS-pixel equivalent width, including 400% browser zoom from 1280 | All actions and content remain reachable; layout can reduce to one column; title truncation has a full-title alternative in details and semantics. |
| Input accessibility | Complete search, filter, clear, add entry/cancel, and details return using keyboard only | Visible unobscured focus, logical order, no trap, and reliable focus restoration. |
| Screen readers | Inspect with TalkBack, VoiceOver, and an available Web screen reader in later implementation | Labels, selected states, card actions, and result/error announcements are useful; no repeated decorative cover output. |
| Text stress | Render long Persian, English, mixed text such as “کتاب Flutter 3 — جلد ۲”, digits, diacritics, and an unbroken title | Correct joining and punctuation order; no overflow or mirrored covers; complete title available without hover. |
| Local states | Exercise zero books, no matches, delayed read, failed read, retry, and unavailable cover | Distinct truthful states; no false empty-library success; retry preserves criteria; cover fallback preserves geometry. |
| Navigation | Open a card and return; add then save/cancel; delete from details when implemented | Correct record/collection updates; saved query/filter/scroll preserved where possible; cancelled add makes no record; focus has a valid destination. |
| Scope | Review visible actions | No AI, account, sync, scanning, recommendations, or unapproved sort/export controls introduced. |

Accessibility references: [W3C contrast guidance](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html) and [W3C reflow guidance](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html). These are selected targets, not a claim of full WCAG compliance. Numeric palette checks alone do not validate a visual design.

## Open questions and handoff

Maintainer review is needed for tokens and layout proposals, Persian copy and locale policy, title/author fields, reading-status vocabulary/order, initial collection ordering, search matching and timing, cover availability, and delete safety interaction. Navigation mechanism, persistence, and state management remain pending in the existing decision log. Before Flutter implementation, resolve only choices needed for the next requested slice and record approved decisions through the normal project process.

Prior browser review covered 320×640, 375×812, 430×932, 768×1024, 1280×800, and 1920×1080 at Flutter text scales 1.0, 1.5, and 2.0 before font bundling. After bundling, cold-load and layout review covered 320×640, 375×812, and 1280×800 at the same scales. Local screenshots are review artifacts, not published GitHub assets. Native devices, virtual keyboards, full keyboard-only flows, screen readers, and full accessibility conformance remain unvalidated. Proposed error and navigation acceptance criteria are future targets, not implemented or passing features.
