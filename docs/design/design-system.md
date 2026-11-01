# UI foundation: design system

Status: design specification with implementation notes for the review prototype. Confirmed scope comes from the [product brief](../product-brief.md); decision ownership remains in the [decision log](../decision-log.md). Visual values remain subject to design approval. Web rendering has been reviewed; production architecture and native/accessibility acceptance remain pending.

## Confirmed requirements

- Editorial + Clean Minimal direction; calm, premium, book-focused presentation with restrained decoration.
- Android, iOS, and Web; accessible and responsive UI, with Persian/English and RTL/mixed-direction text support requested for this specification.
- Six MVP capabilities: list owned books, add, edit/delete, reading status, search/filter, and details. AI, authentication, sync, and ISBN scanning remain excluded.
- Architecture, state management, storage, navigation implementation, and token implementation remain pending. Component names here describe UI responsibilities, not required Dart classes or architectural layers.

## Visual identity — proposed

Use warm paper backgrounds, ink-like text, generous grouping space, and one muted green accent. Make book titles and covers the visual focus. Use typography and alignment for hierarchy; avoid ornamental gradients, simulated paper textures, heavy shadows, and decorative animation. Light theme first; dark theme is not specified or added to MVP scope.

## Color tokens — proposed

| Token | Hex | Role |
| --- | --- | --- |
| background | #FAF8F4 | Page canvas |
| surface | #FFFFFF | Fields, cards, raised content |
| text.primary | #242824 | Titles and body |
| text.secondary | #535B55 | Supporting text and field hints |
| accent | #285943 | Primary actions, links, selected filters |
| onAccent | #FFFFFF | Text on accent |
| accent.subtle | #EAF1EC | Selection and hover background |
| border.decorative | #D9DDD7 | Nonessential separators only |
| border.control | #707970 | Required control boundaries |
| focus | #285943 | Visible focus outline |
| semantic.error | #A12B32 | Error text and destructive intent |
| semantic.success | #285943 | Explicit success feedback |
| semantic.warning | #765014 | Caution text |
| semantic.info | #285A78 | Informational feedback |

Use primary/secondary/accent/semantic text on background or surface; onAccent only on accent. Semantic labels always include text, not color alone. Do not use decorative borders as the sole control boundary. Reading statuses use text and selection indicators rather than success/error meanings.

Target at least 4.5:1 for all ordinary text, including hints; this deliberately avoids reliance on large-text exceptions. Required control boundaries and focus indicators target 3:1 against adjacent colors. Verify actual rendered states, including hover, pressed, and focus, before implementation acceptance. These targets reference [W3C text contrast guidance](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html); a token calculation is not a conformance assessment.

## Typography — proposed

Use a legible text family with complete Persian shaping and Latin coverage for controls and body. Create editorial hierarchy through scale and weight first; a separate display face is optional and pending approval, not a required dependency.

| Token | Base size / line height (logical units) | Weight | Usage |
| --- | --- | --- | --- |
| title.page | 32 / 44 | 600 | Page heading |
| title.section | 24 / 36 | 600 | Section or empty-state heading |
| title.book | 18 / 28 | 600 | Book title |
| body | 16 / 26 | 400 | Main copy and inputs |
| label | 14 / 22 | 500 | Buttons and filters (Material label weight) |
| caption | 14 / 22 | 400 | Supporting metadata |

Allow height to grow with text scaling; never force these line heights as fixed container heights. Use regular tracking; do not letter-space Persian text. Avoid synthetic italics and all-caps requirements. Test joining, diacritics, Persian characters ی/ک, Latin, punctuation, and digits together.

UI direction follows the active locale; use logical start/end alignment and padding. Determine book-title paragraph direction from its content; isolate embedded Latin titles, numbers, and punctuation in Persian sentences. Do not reverse stored strings or force an entire book title to UI direction. Mirror directional navigation icons, not covers, text, or universal search/plus icons.

The prototype uses **Vazirmatn v33.003**, full Persian/Arabic + Latin variant, bundled locally at weights 400 (Regular), 500 (Medium), and 600 (SemiBold). `DesignTokens.fontFamily` selects it centrally through ThemeData; sizes and spacing remain unchanged. Font files, the SIL OFL 1.1 license, upstream source, and SHA-256 hashes are in [assets/fonts](../../assets/fonts/README.md). `pubspec.yaml` declares each weight and includes `OFL.txt` as an asset. There is no font package or application-level runtime font download.

The previous Web prototype downloaded Noto fallbacks after detecting missing Persian glyphs. A cache-cleared browser check with remote Noto requests held rendered the bundled font correctly. The selected-filter checkmark now uses the bundled Material icon font. Flutter's engine-default Roboto request and fallback for other unsupported characters remain possible; offline startup is not established. Typeface metrics change some line wrapping, without changing layout rules.

Prototype UI direction is explicitly RTL; book titles use a simple first-strong-character direction heuristic. Locale-driven UI direction, comprehensive bidi handling, native font rendering, and final Persian copy still require validation. Decorative cover lettering is fitted artwork without text scaling; the full title below remains scalable and accessible.

## Spacing and layout tokens — proposed

| Group | Values in logical units | Use |
| --- | --- | --- |
| space | 4, 8, 12, 16, 24, 32, 48 | Internal gaps through section spacing |
| page inset | 16 minimum; 24 when space permits | Respect safe areas; add inset after them |
| grid gap | 16 | Between cards |
| card minimum width | 160 at default text scale | Reduce column count before shrinking content |
| content maximum width | 1200 | Center the page on wide viewports |
| search maximum width | 560 | Avoid excessively long search fields |
| radius | 4 cover; 8 card/control | Restrained rounding |
| stroke | 1 boundary; 2 focus with 2 gap | Keep focus visible and unclipped |
| elevation | 0 for page, cards, fields | Prefer border and spacing; overlays use platform behavior if needed |
| interactive minimum | 48 by 48 | Shared touch/pointer target, expandable for labels |

No fixed card height or fixed grid child aspect ratio: cover slot is 2:3; metadata grows. Grid layout and text-scale fallback are specified in [Library Home](library-home.md). Keep a single page scroll axis; no fixed controls that obscure content or keyboard focus.

## Reusable component contracts — proposed

These contracts describe intended behavior. Current prototype cards are non-interactive, Add only explains that it is unimplemented, and no storage/loading/error flows are simulated. See [Library Home](library-home.md) for the implemented boundary.

| Component | Content and behavior | States and rules |
| --- | --- | --- |
| BookCard | Cover, title, reading-status text; optional author only if later approved in the book schema. One primary action opens details. | Normal, hover, pressed, keyboard focus, cover missing/failed. Whole card has one accessible action; no nested edit/delete controls. No color-only status. |
| SearchField | Visible label “Search books”, search icon, editable query, clear action when nonempty. | Empty, focused, populated, disabled during unavailable collection. Hint supplements label. Clear preserves focus. Never overwrite text during Persian IME composition. Query semantics remain pending. |
| ReadingStatusFilter | Single selection among All and the eventual approved statuses; selection is visible and announced. | Selected/unselected, hover, pressed, focus, disabled. Wrap labels instead of clipping; each target at least 48. Status names are not defined here. |
| PrimaryButton | Text action with optional supporting icon; label describes outcome. | Normal, hover, pressed, focus, disabled, busy when an action is actually pending. Prevent duplicate activation; busy state preserves label width and announces progress. Disabled controls are not the only explanation of an error. |
| EmptyLibraryView | Brief heading, explanation, and Add book action when local collection is successfully loaded and empty. | Never used for loading, failed reads, or filtered-out results. No fake covers, recommendations, or onboarding steps. |
| BookCoverPlaceholder | Neutral 2:3 slot with simple book symbol when no usable cover exists. | Same geometry for absent, loading, or failed cover; title remains outside. Decorative in card semantics to avoid duplicate announcements. No retry loop or new image acquisition feature. |

Use accent for primary buttons; on hover/press retain readable labels and add a border or subtle state change, with a distinct focus ring. Fields/cards can use accent.subtle hover fill with unchanged text colors. Selected filters use accent/onAccent plus a check indicator. Unselected filters use surface/text.primary/border.control. Disabled controls retain legible text and expose disabled semantics; no opacity treatment that hides content. Do not rely on hover for access to any action. Respect reduced motion; no animation is required.

Covers are optional display content only if the eventual model supplies them; this spec does not introduce cover upload, download, scanning, or a new data requirement.

## Verification and unresolved questions

`ResponsiveGrid` is implemented in `lib/widgets/responsive_grid.dart`. It accepts generic children, minimum item width, horizontal spacing, and run spacing; uses bounded parent constraints and Flutter text scaling; and preserves variable-height rows. It owns no book data, filtering, empty state, or scrolling. LibraryHome composes it with shared tokens. This is a UI composition decision, not a finalized production architecture.

The grid eagerly builds all children through Wrap. It suits the eight-book demo; virtualization and collection-size budgets remain future decisions. Page scrolling has not been redesigned.

Token contrast calculations can validate listed color pairs only. Rendered verification must still cover fonts, focus visibility, touch targets, semantics, text scaling, and all component states on the supported platforms. Proposed UX acceptance tests are in [Library Home](library-home.md).

Pending approval: palette/type/spacing values; localization scope and copy; status vocabulary; book fields and cover source; any platform-specific interaction adjustments. Maintainer approval is required before proposals become settled decisions. No changes to the existing decision log are implied.
