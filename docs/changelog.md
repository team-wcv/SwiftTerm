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
- Platform floors raised to iOS 15 / tvOS 15 / macOS 13 (visionOS 1 unchanged); availability checks
  that are always true at those floors are removed.
- Platform floors raised again to iOS 17 / macOS 14 (tvOS 15 / visionOS 1 unchanged).
- The iOS view sizes itself from scene traits: the backing scale comes from the trait collection,
  the alternate keyboard from the window bounds, and the accessory bar height and key widths from
  the size classes (regular width and height gets the larger metrics) instead of the device idiom.
- The iOS edit menu uses `UIEditMenuInteraction` only (the iOS 15 `UIMenuController` fallback is gone).
- Image scaling and stripes use `UIGraphicsImageRenderer` on iOS and no longer use `lockFocus` on macOS.

### Fixed

### Removed

- Fork patches that upstream now covers (see `reference/migration.md#fork-changes`).

### TODO

- Expose `Terminal.buffers` / `BufferSet` as public API (currently `normalBuffer` and `altBuffer` are internal)
