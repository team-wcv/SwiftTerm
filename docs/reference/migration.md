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

The fork tracks the upstream `main` branch and periodically merges changes.

<a id="sync-policy"></a>
## Upstream Sync Policy

1. **Periodic merge**: Upstream changes are merged into the fork's `main` branch on a regular cadence (typically when upstream publishes notable fixes or features).
2. **Cherry-pick for urgency**: Critical bug fixes from upstream may be cherry-picked between full syncs.
3. **Conflict resolution**: Fork-specific changes take precedence in conflicts. Upstream changes are adapted to fit fork conventions.
4. **No force-push**: The fork maintains a linear merge history. Upstream syncs are merge commits, not rebases.

<a id="fork-changes"></a>
## What Changes from Upstream

### Documentation

- **DocC catalog** (`Sources/SwiftTerm/Documentation.docc/`): Maintained and expanded by team-wcv. Upstream may not have all articles present in the fork.
- **docs/ directory**: Fork-only. Not present in upstream.

### Code Changes

Fork-specific changes are kept minimal to reduce merge friction. Current divergences:

- **Bug fixes** that have been submitted as upstream PRs but not yet merged.
- **Build configuration** tweaks for the team-wcv CI pipeline.
- **Minor API additions** needed by TerminalKit that are not yet upstreamed.

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
