# branch: fix/views-terminalview-ios-anchor

## Why

EcosystemDocs `pnpm build` reports one broken anchor in the mirrored SwiftTerm
docs:

- `/repos/swiftterm/docs/api/views#terminalview-ios`

The page `docs/api/views.md` uses HTML `<a id="...">` anchors for in-page
navigation, but Docusaurus's broken-anchor validator only honors
heading-derived slugs and explicit `{#slug}` heading annotations. The
"Navigation" list links to `#terminalview-ios`, which is targeted via
`<a id="terminalview-ios"></a>` above the `## TerminalView (iOS / visionOS)`
heading. The heading's natural Docusaurus slug is `terminalview-ios--visionos`
(the macOS heading happens to slug to `terminalview-macos`, which is why only
the iOS link is flagged).

## Fix

Add an explicit `{#terminalview-ios}` to the `## TerminalView (iOS / visionOS)`
heading so Docusaurus recognizes the slug used by the Navigation link.

## Scope

Single-file edit to `docs/api/views.md`. Existing `<a id="...">` HTML anchors
are left in place to preserve compatibility with any consumer (e.g. raw GitHub
rendering) that still relies on them.

## Out of scope

- Pushing the branch or opening a PR (per task instructions).
- Reworking the broader `<a id="...">` pattern across other docs files.
