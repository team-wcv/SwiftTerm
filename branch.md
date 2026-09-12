---
branch: chore/6aa497fb-develop-only-ci
created: 2026-09-11
owner: codex-watch-rollout
status: active
scope: "Run expensive Swift build/test only after develop integration; gate automatic tags on successful CI"
orchestraitor:
  ticket: 6aa497fb6024b8c5ef1c6be8
  plan: a2a598fd-ed67-459d-b1a3-1a710546a414
pr:
  state: pending
  url: null
---

- User authorized develop-only build/test triggers across kits and App.
- Preserve SDK/platform jobs, cheap PR checks, and separate release/documentation workflows.
- Validation is static only; no macOS build, workflow dispatch, merge, branch-rule mutation, or product-code change.
- Hold first push/PR until coordinated shared after-CI tag integration is included.
