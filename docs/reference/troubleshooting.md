<a id="overview"></a>
# Troubleshooting

Common issues when using SwiftTerm and how to resolve them.

<a id="character-rendering"></a>
## Character Rendering

### CJK / Full-Width Characters Display Incorrectly

**Symptom**: Chinese, Japanese, or Korean characters overlap or leave gaps.

**Cause**: The font does not have proper glyphs for wide characters, or the width table is out of sync.

**Fix**:
- Use a font with full CJK coverage (e.g., SF Mono, Menlo, or a Nerd Font patched variant).
- SwiftTerm uses built-in Unicode width data (`UnicodeWidthData.swift`). If a character's width is wrong, it may need a width table update.

### Emoji / Combining Characters Render Incorrectly

**Symptom**: Emoji appear as two separate characters, or combining marks are displaced.

**Cause**: The terminal sees emoji as sequences of code points. If the grapheme cluster boundaries don't match the width calculations, rendering breaks.

**Fix**:
- Ensure you are feeding complete UTF-8 byte sequences. Splitting a multi-byte character across two `feed(byteArray:)` calls can cause transient rendering glitches.
- SwiftTerm handles grapheme clusters internally, but some very new emoji sequences may not be recognized yet.

### Box-Drawing Characters Look Wrong

**Symptom**: Lines in TUI applications (e.g., `tmux`, `htop`) have gaps or misaligned segments.

**Fix**:
- Enable `customBlockGlyphs = true` on `TerminalView`. SwiftTerm includes pixel-perfect renderers for box-drawing (U+2500–U+257F) and block elements (U+2580–U+259F) that are more accurate than most font glyphs.
- Enable `antiAliasCustomBlockGlyphs = true` if the custom glyphs look too jagged.

<a id="escape-sequences"></a>
## Escape Sequences

### Application Not Detecting Terminal Features

**Symptom**: An application doesn't use colors, mouse, or other features even though SwiftTerm supports them.

**Cause**: The application checks the `TERM` environment variable.

**Fix**:
- Ensure `TerminalOptions.termName` is set to `"xterm-256color"` (the default). Some applications require specific `TERM` values to enable features.
- For `LocalProcess`, the `TERM` variable is set automatically. For custom transports, pass it via `Terminal.getEnvironmentVariables(termName:trueColor:)`.

### Sixel Images Not Rendering

**Symptom**: Sixel-encoded images appear as garbled text.

**Cause**: Sixel support might not be advertised, or the `TerminalDelegate` image callbacks are not implemented.

**Fix**:
- Ensure `TerminalOptions.enableSixelReported` is `true` (the default).
- If using a custom front-end (not the built-in views), implement `createImageFromBitmap(source:bytes:width:height:)` on your `TerminalDelegate`.

### OSC 8 Hyperlinks Not Working

**Symptom**: Clickable links in terminal output don't respond to clicks.

**Cause**: The `requestOpenLink` delegate method is not implemented, or the link detection is not wired.

**Fix**:
- Implement `TerminalViewDelegate.requestOpenLink(source:link:params:)`. The default AppKit implementation opens URLs with `NSWorkspace`.

<a id="keyboard-input"></a>
## Keyboard Input

### Option Key Not Sending Meta/Escape

**Symptom**: Option+key combinations insert accented characters instead of sending ESC+key to the terminal.

**Fix**:
- Set `terminalView.optionAsMetaKey = true`. This makes Option behave as the Meta key, sending ESC + the key code. This is required for terminal applications like Emacs, vim with Meta bindings, etc.

### Backspace Not Working Correctly

**Symptom**: Backspace doesn't delete, or deletes the wrong character, or sends `^H` visibly.

**Cause**: Mismatch between what the terminal sends (DEL 0x7F vs BS 0x08) and what the application expects.

**Fix**:
- Toggle `terminalView.backspaceSendsControlH`. Some remote systems expect Control-H (0x08); others expect DEL (0x7F, the default).

### iOS: Missing Control/Escape Keys

**Symptom**: Cannot send Ctrl+C, Escape, or Tab on the iOS software keyboard.

**Fix**:
- The `TerminalAccessory` input bar provides these keys. Access it via `terminalView.inputAccessoryView` (cast to `TerminalAccessory`).
- For external keyboards, Ctrl and Escape should work natively. The `controlModifier` property on `TerminalAccessory` tracks the Ctrl state.

<a id="performance"></a>
## Performance

### Slow Rendering with Large Output

**Symptom**: The terminal becomes sluggish when processing large amounts of output (e.g., `cat` on a large file).

**Fix**:
- Reduce `scrollback` in `TerminalOptions`. Large scrollback buffers consume memory and slow down operations that traverse the buffer.
- The terminal processes data synchronously in `feed(buffer:)`. If you're feeding data on the main thread, large chunks will block the UI. Consider batching or using a background queue.

### Kitty Image Cache Memory Usage

**Symptom**: Memory usage grows when displaying many Kitty protocol images.

**Fix**:
- Reduce `TerminalOptions.kittyImageCacheLimitBytes`. The default is 320 MB, which is generous. For constrained environments, lower it.
- Kitty images are cached for re-display (e.g., when scrolling). The cache evicts oldest entries when the limit is reached.

<a id="process-management"></a>
## Process Management (macOS)

### LocalProcess Not Starting

**Symptom**: `startProcess()` doesn't launch a shell, or the process exits immediately.

**Cause**: App sandbox restrictions.

**Fix**:
- `LocalProcessTerminalView` requires the app sandbox to be **disabled**. In Xcode, go to **Signing & Capabilities** and remove the App Sandbox entitlement.
- If you must keep the sandbox, use `TerminalView` with a custom data source instead of `LocalProcessTerminalView`.

### Process Exiting with nil Exit Code

**Symptom**: `processTerminated(source:exitCode:)` is called with `exitCode: nil`.

**Cause**: An I/O error occurred on the pseudo-terminal file descriptor, not a clean process exit.

**Fix**:
- This can happen if the PTY is closed unexpectedly. Check for other processes or signal handlers that might close the file descriptor.

<a id="search"></a>
## Search

### Search Not Finding Results

**Symptom**: `findNext()` returns no matches for text that is visible on screen.

**Fix**:
- Check `SearchOptions`: `caseSensitive` defaults to `false`, but `wholeWord` and `regex` default to `false` too. Ensure your search term isn't being treated as regex if it contains special characters.
- Search operates on the buffer content, which may differ from what's rendered (e.g., combining characters, wide characters).

<a id="see-also"></a>
## See Also

- [Configuration](configuration.md) — All configurable options
- [Error Handling](error-handling.md) — How SwiftTerm communicates errors
- [Glossary](glossary.md) — Terminal terminology
- DocC: `Customization.md` — Fonts, colors, input behavior
