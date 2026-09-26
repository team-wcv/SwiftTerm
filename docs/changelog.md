# Changelog

All notable changes to SwiftTerm will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

This project does not yet follow strict semantic versioning but aims for source-compatible releases.

## [Unreleased]

### Added

### Changed

- Synced with upstream SwiftTerm `v1.20.0` (merge base was 54a5066, 2026-02-18). Tools 6.0,
  `swiftLanguageModes: [.v5]`, platforms iOS 14 / macOS 11 / tvOS 13 / visionOS 1. Brings the
  opt-in Metal renderer, bidi, OSC 8, Alternate Scroll Mode and the build-info plugin.
- The Metal shader source is bundled with `.copy` instead of `.process`, so builds do not need the
  Metal Toolchain component.
- iOS invalidates only the changed rows, at content coordinates (reworks cd6fb70).

### Fixed

### Removed

- Fork patches that upstream now covers (see `reference/migration.md#fork-changes`).

### TODO

- Expose `Terminal.buffers` / `BufferSet` as public API (currently `normalBuffer` and `altBuffer` are internal)
