# chore/kit-ci-repin-sigpipe

- Repo: team-wcv/SwiftTerm
- Scope: replace the inline `xcodebuild -version | head -1` Xcode check with
  capture-then-parse (SIGPIPE under pipefail, exit 134). Workflow file only.
- Task: 6ab813e5f0a5544bbf2098ae (umbrella 6ab81063f0a5544bbf209583)
- PR: TBD
