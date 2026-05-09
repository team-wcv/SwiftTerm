# AGENTS.md

This repository follows the team-wcv ecosystem agent guidance defined in `~/.agents/AGENTS.md` (operator-local canonical) and mirrored to [`team-wcv/.github/AGENTS.md`](https://github.com/team-wcv/.github/blob/develop/AGENTS.md) (remote canonical).

## Repo-specific notes

`team-wcv/SwiftTerm` is a **kit-tier Swift package** — xterm/VT100 terminal emulator in Swift, public mirror of the upstream MigueldeIcaza fork; consumed by `TerminalKit` and downstream OrchestraitorApp surfaces.

- Built with Swift Package Manager. The canonical CI shape is the org reusable [`team-wcv/.github/.github/workflows/swift-kit-ci.yml@v1`](https://github.com/team-wcv/.github/blob/develop/.github/workflows/swift-kit-ci.yml). Per-repo workflows MUST stay thin callers — adding inline build logic puts this repo on the inline-workflow-drift list (see [`team-wcv/repo-policy/policies/inline-workflow-exceptions.json`](https://github.com/team-wcv/repo-policy/blob/develop/policies/inline-workflow-exceptions.json)).
- Public API surface is consumed by `OrchestraitorApp` and downstream Swift kits; bump `Package.swift` `swiftLanguageVersions`, `platforms`, and any exported symbol list only with cross-repo coordination — see the `swift-package-workflow` skill (`~/.agents/skills/swift-package-workflow/SKILL.md`) for local override + staging-vs-production release lanes.
- **Public API changes require G6 deliberation.** Renaming exported types or functions, removing public symbols, or changing public method signatures is a kit-tier API change and MUST land alongside an explicit `deliberaitor_ask_question` decision (gate G6, `kit_api_change_gate`). Agents MUST NOT ship API changes to this repo without that gate resolved.
- Use `swift build && swift test` locally before pushing. Branch model: `feature/<task-id>-<short-desc>`, `fix/<task-id>-<short-desc>`, squash-merge to `develop`; promotion to `main` follows the kit-tier release lane and the kit-tier required-checks contract ([`docs/kit-required-checks.md`](https://github.com/team-wcv/repo-policy/blob/develop/docs/kit-required-checks.md)).
- All commits in this repo MUST carry the standard `X-Orchestraitor-Task` / `X-Orchestraitor-Plan` / `X-Agent-Platform` trailers per the org `commit-msg` hook.

## See also

- Remote canonical AGENTS.md: <https://github.com/team-wcv/.github/blob/develop/AGENTS.md>
- Operator-local canonical: `~/.agents/AGENTS.md`
- Plan: `/Users/JJ/.cursor/plans/ecosystem_repo_standardization_aeee88ba.plan.md`
- Swift package workflow skill: `~/.agents/skills/swift-package-workflow/SKILL.md`
- Kit-tier required checks: [`team-wcv/repo-policy/docs/kit-required-checks.md`](https://github.com/team-wcv/repo-policy/blob/develop/docs/kit-required-checks.md)
- Kit outliers (current exceptions): [`team-wcv/repo-policy/docs/kit-outliers.md`](https://github.com/team-wcv/repo-policy/blob/develop/docs/kit-outliers.md)
