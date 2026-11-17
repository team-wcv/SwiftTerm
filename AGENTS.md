# AGENTS.md: SwiftTerm

team-wcv/SwiftTerm is the team's public fork of Miguel de Icaza's SwiftTerm, an xterm/VT100 terminal emulator in Swift. TerminalKit and the Orchestraitor app depend on it. General workflow (tickets, worktrees, `branch.md`, develop-only) follows the `orchestraitor` and `orc-git-workflow` skills. Commits end with the `X-Orchestraitor-Task`, `X-Orchestraitor-Plan` (or `none`) and `X-Agent-Platform` trailers in the final paragraph, and PRs squash-merge to `develop`.

## Scope

- **Owns:** the terminal emulator and its macOS and iOS views, plus the team's fixes on top of upstream.
- **Not here:** Orchestraitor terminal features (TerminalKit). Keep changes general enough to offer upstream where they could be.
- **Depends on:** nothing from team-wcv. **Used by:** TerminalKit, OrchestraitorApp.

## Rules

- This repo is public: never add a private dependency, secret, internal host name or reference to a private repo's contents.
- Public API changes (renamed or removed public symbols, changed signatures) reach TerminalKit and the App: name them in the PR, and for a breaking one ask the operator (an opt-in question, not a gate), keep working, and hold the merge until answered.

## Build and CI

- Swift tools 6.0; iOS 17, macOS 14, tvOS 15, visionOS 1.
- Before merging, run team-wcv/.github `scripts/swift-ci.sh -C <this checkout> --platforms macos,ios --receipt` (`--host auto` runs it on the least-loaded team Mac). It posts the `local-ci/swift` receipt merges need. Hosted CI is normally off for pushes and pull requests; dispatch it only with a reason and the `ci-run.sh` cost estimate in the ticket, and never change `CI_HOSTED` yourself. The rules are in team-wcv/repo-policy `docs/ci-cost-policy.md`.
- Unlike the kits, `build.yml` and `tag.yml` are inline: a public repo cannot call the org's private reusable workflows. Keep them in step with the shared Swift and tag-after-CI workflows by hand; they are listed in repo-policy `policies/inline-workflow-exceptions.json`. `build.yml`'s name and path are load-bearing for `tag.yml`.

## Releases

- `tag.yml` cuts the next `v` patch tag after a develop revision passes Build & Test. TerminalKit takes it by raising its `from:` floor in a release wave.
