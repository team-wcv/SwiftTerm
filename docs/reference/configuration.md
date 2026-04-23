<a id="overview"></a>
# Configuration Reference

Terminal options, colors, cursor styles, and buffer sizing.

> For code examples and interactive customization, see DocC `Customization.md` at
> `Sources/SwiftTerm/Documentation.docc/Customization.md`.

<a id="terminaloptions"></a>
## TerminalOptions

`TerminalOptions` configures the terminal engine at initialization. These values are read once when the `Terminal` (or `HeadlessTerminal`) is created.

```swift
let options = TerminalOptions(
    cols: 120,
    rows: 40,
    scrollback: 10_000,
    tabStopWidth: 4,
    cursorStyle: .steadyBar,
    termName: "xterm-256color",
    ansi256PaletteStrategy: .base16Lab
)
```

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `cols` | `Int` | 80 | Initial column count |
| `rows` | `Int` | 25 | Initial row count |
| `convertEol` | `Bool` | `false` | When `true`, LF also performs CR |
| `termName` | `String` | `"xterm-256color"` | Value for the `TERM` environment variable |
| `cursorStyle` | `CursorStyle` | `.blinkBlock` | Initial cursor appearance |
| `screenReaderMode` | `Bool` | `false` | Enable accessibility mode |
| `scrollback` | `Int` | 500 | Number of scrollback lines retained |
| `tabStopWidth` | `Int` | 8 | Default tab stop interval |
| `enableSixelReported` | `Bool` | `true` | Advertise Sixel support to querying applications |
| `kittyImageCacheLimitBytes` | `Int` | 335,544,320 (320 MB) | Memory limit for cached Kitty images (clamped to 4 GB) |
| `ansi256PaletteStrategy` | `Ansi256PaletteStrategy` | `.base16Lab` | How to derive colors 16–255 from the base-16 palette |

Use `TerminalOptions.default` for standard defaults.

<a id="cursor-styles"></a>
## Cursor Styles

The `CursorStyle` enum controls cursor appearance. The initial style comes from `TerminalOptions`, but running applications can override it via escape sequences.

| Style | Description |
|-------|-------------|
| `.blinkBlock` | Blinking filled rectangle |
| `.steadyBlock` | Non-blinking filled rectangle |
| `.blinkUnderline` | Blinking underline |
| `.steadyUnderline` | Non-blinking underline |
| `.blinkBar` | Blinking vertical bar (I-beam) |
| `.steadyBar` | Non-blinking vertical bar |

```swift
let options = TerminalOptions(cursorStyle: .steadyBar)
```

<a id="colors"></a>
## Colors

### View-Level Colors

On `TerminalView`, set native colors for the default foreground and background:

```swift
// macOS
terminalView.nativeForegroundColor = NSColor.white
terminalView.nativeBackgroundColor = NSColor.black

// iOS
terminalView.nativeForegroundColor = UIColor.white
terminalView.nativeBackgroundColor = UIColor.black
```

Additional view properties:

| Property | Description |
|----------|-------------|
| `selectedTextBackgroundColor` | Selection highlight |
| `caretColor` | Cursor fill color |
| `caretTextColor` | Text color under the cursor (optional) |

### ANSI Palette

Install a custom 256-color palette on the `Terminal` instance:

```swift
let terminal = terminalView.getTerminal()
terminal.installPalette(colors: myPalette) // Array of exactly 256 Color values
```

The first 16 entries are the standard ANSI colors, 16–231 form the 6x6x6 color cube, and 232–255 are the grayscale ramp. The `Ansi256PaletteStrategy` controls how colors 16–255 are derived:

- `.xterm` — Traditional xterm color cube
- `.base16Lab` — LAB-space interpolation from the base-16 colors (default, produces more perceptually uniform results)

### Color Type

The `Color` class stores RGB in 16-bit components (0–65535):

```swift
let c = Color(red: 65535, green: 0, blue: 0) // bright red
```

<a id="buffer-size"></a>
## Buffer Size

### Initial Dimensions

Set `cols` and `rows` in `TerminalOptions`. After initialization, resize with:

```swift
terminal.resize(cols: newCols, rows: newRows)
```

When using `TerminalView`, the view resizes the terminal automatically as the view's frame changes.

### Scrollback

The `scrollback` option controls how many lines above the visible area are retained. Larger values consume more memory. Each `BufferLine` holds one `CharData` per column, and each `CharData` is approximately 16 bytes.

Rough memory estimate:

```
memory ≈ (scrollback + rows) × cols × 16 bytes
```

For 10,000 scrollback lines at 120 columns: ~19 MB.

<a id="input-behavior"></a>
## Input Behavior

These view-level properties control keyboard and mouse handling:

| Property | Default | Description |
|----------|---------|-------------|
| `optionAsMetaKey` | `true` | Option key sends ESC prefix instead of special characters |
| `allowMouseReporting` | `true` | Forward mouse events to the terminal |
| `backspaceSendsControlH` | `false` | Send 0x08 instead of 0x7F for backspace |

<a id="rendering-options"></a>
## Rendering Options

| Property | Default | Description |
|----------|---------|-------------|
| `customBlockGlyphs` | varies | Use SwiftTerm's built-in box-drawing and block-element renderers |
| `antiAliasCustomBlockGlyphs` | varies | Anti-alias the custom glyphs |
| `useBrightColors` | varies | Use bright palette colors for bold text |

<a id="see-also"></a>
## See Also

- [API Models — TerminalOptions](../api/models.md#terminaloptions) — Struct definition
- [API Models — CursorStyle](../api/models.md#cursorstyle) — Enum cases
- [API Views](../api/views.md) — View properties and methods
- DocC: `Customization.md` — Detailed customization walkthrough with code examples
