# feature/6ab81063-w129-menu

- **Repo:** team-wcv/SwiftTerm
- **Scope:** W1-29 leftover non-Duo half — remove the iOS 15 `UIMenuController` fallback in favor of `UIEditMenuInteraction` only; raise package floors to iOS 17 / macOS 14 (do not go above). Keep `swiftLanguageModes: [.v5]`. No Duo-sim. No TerminalKit / OrchestraitorApp edits. Do not sign W1-28 or W1-29.
- **Task:** 6ab81063f0a5544bbf209583
- **Plan:** 4285a8d2-54ad-497d-b6ed-c53f8b9be9c6
- **PR:** none yet
- **Base tip:** `5c4c4c84380a64bc23856307f026666d72ef5138`
- **Who-name:** `w129-menu` via `buildslot-smbp`

## State

- Done: feature worktree from `origin/develop`; `UIMenuController` fallback removed; floors set to iOS 17 / macOS 14.
- Next: gate `xcodebuild -version` (27.0 / 27A266a) then `swift test --jobs 4` on smbp; open PR; remove this file in the commit immediately before merge.
- Load protocol: local load ≥ 12 → no timing claim.
