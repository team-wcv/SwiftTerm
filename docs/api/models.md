<a id="overview"></a>
# API Models Reference

Complete reference for SwiftTerm's public types. For DocC-generated documentation with full member listings, build with `swift package generate-documentation`.

<a id="navigation"></a>
## Navigation

- [Terminal](#terminal)
- [Buffer](#buffer)
- [BufferLine](#bufferline)
- [CharData](#chardata)
- [Attribute](#attribute)
- [CharacterStyle](#characterstyle)
- [Color](#color)
- [Position](#position)
- [TerminalOptions](#terminaloptions)
- [CursorStyle](#cursorstyle)
- [SearchOptions](#searchoptions)
- [Ansi256PaletteStrategy](#ansi256palettestrategy)
- [EscapeSequenceParser](#escapesequenceparser)
- [Protocols](#protocols)

---

<a id="terminal"></a>
## Terminal

**File**: `Sources/SwiftTerm/Terminal.swift`
**Declaration**: `open class Terminal`

The core terminal emulator engine. Processes incoming byte streams, maintains buffer state, and notifies its delegate of changes. Thread-safe when accessed from a single queue.

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `cols` | `Int` | Current column count |
| `rows` | `Int` | Current row count |
| `buffer` | `Buffer` | Active buffer (normal or alternate) |
| `options` | `TerminalOptions` | Configuration snapshot |
| `hostCurrentDirectory` | `String?` | Last reported working directory (OSC 7) |
| `mouseMode` | `MouseMode` | Current mouse reporting mode |

### Key Methods

| Method | Description |
|--------|-------------|
| `feed(buffer:)` | Feed raw bytes into the terminal for processing |
| `feed(text:)` | Feed a string (convenience wrapper) |
| `resize(cols:rows:)` | Resize the terminal dimensions |
| `getBufferAsData()` | Extract visible buffer content as `Data` |
| `getLine(row:)` | Get a specific `BufferLine` by row index |
| `getText(start:end:)` | Extract text from a region using `Position` values |
| `installPalette(colors:)` | Install a custom 256-color palette |
| `getEnvironmentVariables(termName:trueColor:)` | Build environment variables for child processes (static) |
| `resetToInitialState()` | Full terminal reset |

### Nested Types

- `Terminal.MouseMode` — enum: `off`, `x10`, `vt200`, `buttonEventTracking`, `anyEvent`
- `Terminal.WindowManipulationCommand` — enum for xterm window control sequences

---

<a id="buffer"></a>
## Buffer

**File**: `Sources/SwiftTerm/Buffer.swift`
**Declaration**: `public final class Buffer`

Represents the visible terminal content plus scrollback. The terminal maintains two buffers (normal and alternate), exposed via the `buffer` property and the `isCurrentBufferAlternate` flag.

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `x` | `Int` | Cursor column (0-based) |
| `y` | `Int` | Cursor row (0-based, relative to `yBase`) |
| `yBase` | `Int` | Index of the first visible row in `lines` |
| `yDisp` | `Int` | Index of the first displayed row (scrollback offset) |
| `lines` | `CircularBufferLineList` | All lines including scrollback |
| `scrollTop` | `Int` | Top of the scroll region |
| `scrollBottom` | `Int` | Bottom of the scroll region |

### Key Methods

| Method | Description |
|--------|-------------|
| `getLine(row:)` | Get a `BufferLine` for a viewport row |
| `translateBufferLineToString(lineIndex:trimRight:)` | Extract a line as a string |

---

<a id="bufferline"></a>
## BufferLine

**File**: `Sources/SwiftTerm/BufferLine.swift`
**Declaration**: `public final class BufferLine`

A single row of terminal content. Stores an array of `CharData` cells plus optional image attachments.

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `isWrapped` | `Bool` | Whether this line is a continuation of the previous |
| `images` | `[TerminalImage]?` | Inline images attached to this line |

### Nested Types

- `BufferLine.RenderLineMode` — enum: `single`, `doubleWidth`, `doubledTop`, `doubledDown`

### Key Methods

| Method | Description |
|--------|-------------|
| `translateToString(trimRight:startCol:endCol:)` | Convert line content to a string |
| `count` | Number of cells in the line |
| subscript `[index]` | Access a `CharData` cell by column |

---

<a id="chardata"></a>
## CharData

**File**: `Sources/SwiftTerm/CharData.swift`
**Declaration**: `public struct CharData`

Represents a single terminal cell: a character, its display attribute, and its width.

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `code` | `Character` | The Unicode grapheme cluster |
| `attribute` | `Attribute` | Foreground, background, and style |
| `width` | `Int8` | Display width: 1 (normal) or 2 (CJK/full-width) |

### Constants

| Constant | Description |
|----------|-------------|
| `CharData.Null` | Empty cell with default attribute |

---

<a id="attribute"></a>
## Attribute

**File**: `Sources/SwiftTerm/CharData.swift`
**Declaration**: `public struct Attribute: Equatable, Hashable`

Foreground color, background color, and character style for a terminal cell.

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `fg` | `Attribute.Color` | Foreground color |
| `bg` | `Attribute.Color` | Background color |
| `style` | `CharacterStyle` | Style flags (bold, italic, underline, etc.) |

### Nested Type: Attribute.Color

```swift
public enum Color: Equatable, Hashable {
    case ansi256(code: UInt8)
    case trueColor(red: UInt8, green: UInt8, blue: UInt8)
    case defaultColor
    case defaultInvertedColor
}
```

### Constants

| Constant | Description |
|----------|-------------|
| `Attribute.empty` | Default foreground + inverted background, no style |

---

<a id="characterstyle"></a>
## CharacterStyle

**File**: `Sources/SwiftTerm/CharData.swift`
**Declaration**: `public struct CharacterStyle: OptionSet, Hashable`

Bitmask of text rendering styles.

| Flag | Raw Value | Description |
|------|-----------|-------------|
| `.none` | 0 | No styling |
| `.bold` | 1 | Bold weight |
| `.underline` | 2 | Underline |
| `.blink` | 4 | Blinking text |
| `.inverse` | 8 | Swapped foreground/background |
| `.invisible` | 16 | Hidden text |
| `.dim` | 32 | Faint/dim rendering |
| `.italic` | 64 | Italic |
| `.crossedOut` | 128 | Strikethrough |

---

<a id="color"></a>
## Color

**File**: `Sources/SwiftTerm/Colors.swift`
**Declaration**: `public class Color: Hashable`

Represents a color in 16-bit RGB. Used for the terminal palette (ANSI 16, 256-color, and TrueColor).

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `red` | `UInt16` | Red component (0–65535) |
| `green` | `UInt16` | Green component (0–65535) |
| `blue` | `UInt16` | Blue component (0–65535) |

### Palette Generation

`Color` provides static palette arrays (`vgaColors`, `paleColors`) and methods for generating 256-color palettes from a base-16 set.

---

<a id="position"></a>
## Position

**File**: `Sources/SwiftTerm/Position.swift`
**Declaration**: `public struct Position: Equatable`

A (column, row) pair used for cursor position, selection bounds, and search results.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `col` | `Int` | Column index |
| `row` | `Int` | Row index |

### Methods

| Method | Description |
|--------|-------------|
| `Position.compare(_:_:)` | Ordering comparison returning `.before`, `.after`, or `.equal` |

---

<a id="terminaloptions"></a>
## TerminalOptions

**File**: `Sources/SwiftTerm/TerminalOptions.swift`
**Declaration**: `public struct TerminalOptions`

Configuration for terminal startup. Values are read once at initialization.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `cols` | `Int` | 80 | Initial columns |
| `rows` | `Int` | 25 | Initial rows |
| `convertEol` | `Bool` | `false` | LF also acts as CR |
| `termName` | `String` | `"xterm-256color"` | TERM environment variable |
| `cursorStyle` | `CursorStyle` | `.blinkBlock` | Initial cursor style |
| `screenReaderMode` | `Bool` | `false` | Accessibility mode |
| `scrollback` | `Int` | 500 | Scrollback buffer lines |
| `tabStopWidth` | `Int` | 8 | Tab stop interval |
| `enableSixelReported` | `Bool` | `true` | Advertise Sixel support |
| `kittyImageCacheLimitBytes` | `Int` | 320 MB | Kitty image cache limit |
| `ansi256PaletteStrategy` | `Ansi256PaletteStrategy` | `.base16Lab` | 256-color derivation |

See [Configuration](../reference/configuration.md) for detailed usage.

---

<a id="cursorstyle"></a>
## CursorStyle

**File**: `Sources/SwiftTerm/TerminalOptions.swift`
**Declaration**: `public enum CursorStyle`

| Case | Description |
|------|-------------|
| `.blinkBlock` | Blinking block cursor |
| `.steadyBlock` | Non-blinking block cursor |
| `.blinkUnderline` | Blinking underline cursor |
| `.steadyUnderline` | Non-blinking underline cursor |
| `.blinkBar` | Blinking bar (I-beam) cursor |
| `.steadyBar` | Non-blinking bar cursor |

---

<a id="searchoptions"></a>
## SearchOptions

**File**: `Sources/SwiftTerm/SearchOptions.swift`
**Declaration**: `public struct SearchOptions: Equatable`

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `caseSensitive` | `Bool` | `false` | Case-sensitive matching |
| `regex` | `Bool` | `false` | Interpret search term as regex |
| `wholeWord` | `Bool` | `false` | Match whole words only |

---

<a id="ansi256palettestrategy"></a>
## Ansi256PaletteStrategy

**File**: `Sources/SwiftTerm/Colors.swift`
**Declaration**: `public enum Ansi256PaletteStrategy: Sendable`

| Case | Description |
|------|-------------|
| `.xterm` | Traditional xterm 6x6x6 cube + grayscale ramp |
| `.base16Lab` | LAB-interpolated palette from base-16 colors |

---

<a id="escapesequenceparser"></a>
## EscapeSequenceParser

**File**: `Sources/SwiftTerm/EscapeSequenceParser.swift`

The VT100/Xterm state machine parser. This is an internal class — not part of the public API — but it is central to understanding the architecture. The parser uses a transition table to map `(state, input byte)` pairs to `(action, next state)` tuples.

See [Architecture](../architecture/architecture.md#parser-pipeline) for the state diagram.

---

<a id="protocols"></a>
## Protocols

### TerminalDelegate

**File**: `Sources/SwiftTerm/Terminal.swift`

The engine-level delegate. Implemented by views (`TerminalView`) or headless consumers (`HeadlessTerminal`).

| Method | Description |
|--------|-------------|
| `send(source:data:)` | Forward data to the connected process/transport |
| `showCursor(source:)` / `hideCursor(source:)` | Cursor visibility changes |
| `setTerminalTitle(source:title:)` | Window title change |
| `sizeChanged(source:)` | Terminal dimensions changed by escape sequence |
| `bell(source:)` | Bell character received |
| `scrolled(source:yDisp:)` | Scroll position changed |
| `linefeed(source:)` | Newline generated |
| `bufferActivated(source:)` | Normal/alternate buffer switch |
| `selectionChanged(source:)` | Selection state changed |
| `isProcessTrusted(source:)` | Whether buffer read-back is allowed |
| `createImageFromBitmap(source:bytes:width:height:)` | Sixel image decoded |
| `createImage(source:data:width:height:preserveAspectRatio:)` | iTerm2/Kitty image |
| `colorChanged(source:idx:)` | Palette color changed |
| `hostCurrentDirectoryUpdated(source:)` | OSC 7 working directory |

### TerminalImage

**File**: `Sources/SwiftTerm/Terminal.swift`

Protocol for image objects stored on `BufferLine`. Implementations are platform-specific (AppKit `NSImage`, UIKit `UIImage`).

| Property/Method | Description |
|-----------------|-------------|
| `col: Int` | Column position |
| `row: Int` | Row position |

### LocalProcessDelegate

**File**: `Sources/SwiftTerm/LocalProcess.swift`

| Method | Description |
|--------|-------------|
| `processTerminated(_:exitCode:)` | Process exited |
| `dataReceived(slice:)` | Data received from the process |
| `getWindowSize()` | Return desired `winsize` |

### TerminalViewDelegate

**File**: `Sources/SwiftTerm/Apple/TerminalViewDelegate.swift`

See [API Views](views.md#terminalviewdelegate) for the full listing.

### LocalProcessTerminalViewDelegate

**File**: `Sources/SwiftTerm/Mac/MacLocalTerminalView.swift`

See [API Views](views.md#localprocessterminalviewdelegate) for the full listing.
