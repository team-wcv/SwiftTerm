<a id="overview"></a>
# Migration & Upstream Sync

SwiftTerm is a **team-wcv maintained fork** of [migueldeicaza/SwiftTerm](https://github.com/migueldeicaza/SwiftTerm). This document covers the sync policy and what changes from the upstream fork.

<a id="fork-relationship"></a>
## Fork Relationship

| | Upstream | Fork |
|--|---------|------|
| **Repo** | `migueldeicaza/SwiftTerm` | `team-wcv/SwiftTerm` |
| **Maintainer** | Miguel de Icaza | team-wcv |
| **Primary consumers** | Community (Secure Shellfish, La Terminal, CodeEdit, etc.) | TerminalKit, OrchestraitorApp |

The fork tracks the upstream **1.x release line**. The last sync merged upstream `v1.20.0` (2026-09-26),
the final 1.x release. Upstream `main` is SwiftTerm 2.0 (Swift 6 language mode, `getTerminal()` removed),
which is an API migration for TerminalKit rather than a sync.

<a id="sync-policy"></a>
## Upstream Sync Policy

1. **Periodic merge**: Upstream changes are merged into the fork's `develop` branch on a regular cadence (typically when upstream publishes notable fixes or features).
2. **Cherry-pick for urgency**: Critical bug fixes from upstream may be cherry-picked between full syncs.
3. **Conflict resolution**: Fork-specific changes take precedence in conflicts. Upstream changes are adapted to fit fork conventions.
4. **No force-push**: The fork maintains a linear merge history. Upstream syncs are merge commits, not rebases.

<a id="fork-changes"></a>
## What Changes from Upstream

### Documentation

- **DocC catalog** (`Sources/SwiftTerm/Documentation.docc/`): Maintained and expanded by team-wcv. Upstream may not have all articles present in the fork.
- **docs/ directory**: Fork-only. Not present in upstream.

### Code Changes

Fork-specific changes are kept minimal to reduce merge friction. Current divergences from upstream `v1.20.0`:

| Change | Files | Why it is still carried |
|--------|-------|-------------------------|
| Absolute `savedY` (from e1e09d0) | `Buffer.swift`, `Terminal.swift`, `BufferTests.swift` | Upstream still saves a viewport row but trims and reflows `savedY` as an absolute row, so DECSC/DECRC drift once scrollback exists. |
| iOS dirty-row invalidation (reworks cd6fb70) | `Apple/AppleTerminalView.swift` | Upstream repaints the whole iOS view on every update when the Metal renderer is off. |
| iOS pan-to-wheel in mouse mode (iOS half of 3542889) | `iOS/iOSTerminalView.swift` | Upstream's line-accurate wheel (#600) is macOS only; iOS still sends a button-1 drag. |
| Shader source bundled with `.copy` | `Package.swift` | `.process` needs the separately installed Metal Toolchain (Xcode 26+) on every build; the renderer compiles the source at runtime. |
| Floors iOS 17 / macOS 14 (tvOS 15 / visionOS 1) and dead availability checks removed | `Package.swift`, `iOS/*`, `Mac/MacTerminalView.swift`, `LocalProcess.swift` | Aligns with program floors; removes the iOS 15 `UIMenuController` path. To be offered upstream. |
| Scene traits instead of the main screen and device idiom | `iOS/iOSTerminalView.swift`, `iOS/iOSAccessoryView.swift` | Correct metrics on foldables, iPad split view and external displays. To be offered upstream. |
| `UIEditMenuInteraction` edit menu only, image renderers instead of deprecated image contexts | `iOS/iOSTerminalView.swift`, `Mac/MacTerminalView.swift` | Deprecated APIs. To be offered upstream. |

Fork patches dropped at the v1.20.0 sync because upstream now covers them: the Shift-Tab `SendData` fix
(upstream #473), the macOS scroll-wheel reports (upstream #600 and DECSET 1007), the 16.67 ms throttle
removal (upstream displays immediately after user input), the `layoutSubviews` repaint removal (it left
scrolled-in rows unpainted), the smoke-test script and the benchmark-dependency removal (upstream gates
the benchmark target off).

All fork-specific code changes are tagged with comments referencing the divergence reason when non-obvious.

### Package Configuration

- The `Package.swift` dependency URLs may differ (team-wcv forks vs. upstream references).
- Platform version requirements may be adjusted to match OrchestraitorApp's deployment targets.

<a id="updating-from-upstream"></a>
## How to Update from Upstream

### Adding the Upstream Remote

```bash
git remote add upstream https://github.com/migueldeicaza/SwiftTerm.git
git fetch upstream
```

### Merging Upstream Changes

```bash
# Ensure you're on main
git checkout main

# Fetch and merge upstream
git fetch upstream
git merge upstream/main

# Resolve any conflicts
# - Prefer fork changes for docs/, Documentation.docc/, and CI config
# - Prefer upstream for core engine changes unless they conflict with fork fixes

# Run tests
swift test

# Push
git push origin main
```

### Reviewing What Changed

```bash
# See commits since last sync
git log main..upstream/main --oneline

# See file-level diff
git diff main...upstream/main --stat
```

<a id="contributing-upstream"></a>
## Contributing Back to Upstream

When fork changes are general-purpose improvements:

1. Create a branch from the fork change.
2. Rebase onto `upstream/main`.
3. Open a PR against `migueldeicaza/SwiftTerm`.
4. Once merged upstream, the next sync will reconcile the histories.

<a id="version-pinning"></a>
## Version Pinning

SwiftTerm does not publish tagged releases with semantic versions. Consumers (TerminalKit) pin to a branch or commit hash:

```swift
// Pin to branch
.package(url: "https://github.com/team-wcv/SwiftTerm.git", branch: "main")

// Pin to specific commit
.package(url: "https://github.com/team-wcv/SwiftTerm.git", revision: "abc1234")
```

When a stable release process is adopted, this document will be updated with version tagging conventions.

<a id="see-also"></a>
## See Also

- [Ecosystem Map](../architecture/ecosystem-map.md) — Where SwiftTerm fits in the dependency chain
- [Changelog](../changelog.md) — Track fork-specific changes
