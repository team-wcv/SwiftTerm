<a id="overview"></a>
# API Views Reference

TerminalView and related view classes for macOS, iOS, and visionOS.

<a id="navigation"></a>
## Navigation

- [TerminalView (macOS)](#terminalview-macos)
- [TerminalView (iOS / visionOS)](#terminalview-ios)
- [LocalProcessTerminalView](#localprocessterminalview)
- [TerminalDebugView](#terminaldebugview)
- [TerminalAccessory](#terminalaccessory)
- [SwiftUITerminalView](#swiftuiterminalview)
- [TerminalViewDelegate](#terminalviewdelegate)
- [LocalProcessTerminalViewDelegate](#localprocessterminalviewdelegate)

---

<a id="terminalview-macos"></a>
## TerminalView (macOS)

**File**: `Sources/SwiftTerm/Mac/MacTerminalView.swift`
**Declaration**: `open class TerminalView: NSView, NSTextInputClient, NSUserInterfaceValidations, TerminalDelegate`
**Platform**: macOS 13+

An AppKit `NSView` that renders the terminal and handles keyboard/mouse input.

### Initialization

```swift
public init(frame: CGRect)
public required init?(coder: NSCoder)
```

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `terminalDelegate` | `TerminalViewDelegate?` | Delegate for view-level events |
| `font` | `NSFont` | Base font (bold/italic derived automatically) |
| `nativeForegroundColor` | `NSColor` | Default foreground |
| `nativeBackgroundColor` | `NSColor` | Default background |
| `selectedTextBackgroundColor` | `NSColor` | Selection highlight color |
| `caretColor` | `NSColor` | Cursor color |
| `caretTextColor` | `NSColor?` | Text color under the cursor |
| `optionAsMetaKey` | `Bool` | Option key sends ESC prefix (default: `true`) |
| `allowMouseReporting` | `Bool` | Forward mouse events to terminal (default: `true`) |
| `backspaceSendsControlH` | `Bool` | Backspace sends 0x08 instead of 0x7F |
| `customBlockGlyphs` | `Bool` | Use built-in box-drawing glyphs |
| `notifyUpdateChanges` | `Bool` | Enable `rangeChanged` delegate callbacks |
| `useBrightColors` | `Bool` | Use bright colors for bold text |

### Key Methods

| Method | Description |
|--------|-------------|
| `getTerminal() -> Terminal` | Access the underlying `Terminal` engine |
| `feed(byteArray:)` | Deliver data from a backend to the terminal |
| `feed(text:)` | Deliver a string to the terminal |
| `configureNativeColors()` | Apply OS-default colors |
| `resetFontSize()` | Revert to default font |
| `findNext(_:options:)` | Search forward |
| `findPrevious(_:options:)` | Search backward |
| `clearSearch()` | Clear search highlights |
| `getOptimalFrameSize() -> NSSize` | Frame size for current terminal dimensions |

---

<a id="terminalview-ios"></a>
## TerminalView (iOS / visionOS)

**File**: `Sources/SwiftTerm/iOS/iOSTerminalView.swift`
**Declaration**: `open class TerminalView: UIScrollView, UITextInputTraits, UIKeyInput, UIScrollViewDelegate, TerminalDelegate`
**Platform**: iOS 13+, visionOS 1+

A UIKit `UIScrollView` subclass that renders the terminal. Supports software keyboard, external keyboard input, and the `TerminalAccessory` input bar.

### Initialization

```swift
public init(frame: CGRect)
public required init?(coder: NSCoder)
```

### Key Properties

Same as macOS, with UIKit types:

| Property | Type | Description |
|----------|------|-------------|
| `terminalDelegate` | `TerminalViewDelegate?` | Delegate for view-level events |
| `font` | `UIFont` | Base font |
| `nativeForegroundColor` | `UIColor` | Default foreground |
| `nativeBackgroundColor` | `UIColor` | Default background |
| `optionAsMetaKey` | `Bool` | Option/Alt sends ESC prefix |
| `inputAccessoryView` | `UIView?` | Returns the `TerminalAccessory` bar |

### iOS-Specific Methods

| Method | Description |
|--------|-------------|
| `setFonts(normal:bold:italic:boldItalic:)` | Override individual font variants |
| `configureNativeColors()` | Apply OS-default colors |

---

<a id="localprocessterminalview"></a>
## LocalProcessTerminalView

**File**: `Sources/SwiftTerm/Mac/MacLocalTerminalView.swift`
**Declaration**: `open class LocalProcessTerminalView: TerminalView, TerminalViewDelegate, LocalProcessDelegate`
**Platform**: macOS only

A `TerminalView` subclass that manages a `LocalProcess` connected to a pseudo-terminal. The simplest way to embed a working terminal on macOS.

### Initialization

```swift
public init(frame: CGRect)
public required init?(coder: NSCoder)
```

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `process` | `LocalProcess!` | The managed local process |
| `processDelegate` | `LocalProcessTerminalViewDelegate?` | Delegate for process events |

### Key Methods

| Method | Description |
|--------|-------------|
| `startProcess(executable:args:environment:execName:)` | Launch a process (defaults to `/bin/bash`) |

### Delegate Pattern

`LocalProcessTerminalView` sets itself as the `TerminalView`'s delegate internally. User-facing events are forwarded to `processDelegate` (a `LocalProcessTerminalViewDelegate`). Do not override `terminalDelegate` directly.

---

<a id="terminaldebugview"></a>
## TerminalDebugView

**File**: `Sources/SwiftTerm/Mac/MacDebugView.swift`
**Declaration**: `public class TerminalDebugView: NSView`
**Platform**: macOS only

A diagnostic view that displays the raw buffer state (cursor position, yBase, yDisp, cell contents). Useful for debugging escape sequence handling.

### Initialization

```swift
public init(frame: CGRect, terminal: TerminalView)
```

### Key Methods

| Method | Description |
|--------|-------------|
| `update()` | Refresh the debug display |

---

<a id="terminalaccessory"></a>
## TerminalAccessory

**File**: `Sources/SwiftTerm/iOS/iOSAccessoryView.swift`
**Declaration**: `public class TerminalAccessory: UIInputView, UIInputViewAudioFeedback`
**Platform**: iOS, visionOS

An input accessory view providing Ctrl, Esc, Tab, arrow keys, and other common terminal keys above the iOS keyboard.

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `terminalView` | `TerminalView?` | The terminal view receiving input |
| `controlModifier` | `Bool` | Whether Ctrl is toggled on |

### Initialization

```swift
public init(frame: CGRect, inputViewStyle: UIInputView.Style, container: TerminalView)
```

---

<a id="swiftuiterminalview"></a>
## SwiftUITerminalView

**File**: `Sources/SwiftTerm/iOS/SwiftUITerminalView.swift`
**Platform**: iOS, visionOS

A SwiftUI wrapper around the UIKit `TerminalView` for use in SwiftUI-based iOS and visionOS applications.

---

<a id="terminalviewdelegate"></a>
## TerminalViewDelegate

**File**: `Sources/SwiftTerm/Apple/TerminalViewDelegate.swift`
**Declaration**: `public protocol TerminalViewDelegate: AnyObject`
**Platform**: macOS, iOS, visionOS

The primary delegate protocol for `TerminalView`. Implement this to handle user input, title changes, and other view-level events.

| Method | Required | Description |
|--------|----------|-------------|
| `send(source:data:)` | Yes | Forward user input to your backend |
| `sizeChanged(source:newCols:newRows:)` | Yes | Terminal resized |
| `setTerminalTitle(source:title:)` | Yes | Title change requested |
| `hostCurrentDirectoryUpdate(source:directory:)` | Yes | Working directory changed (OSC 7) |
| `scrolled(source:position:)` | Yes | Scroll position changed (0.0–1.0) |
| `requestOpenLink(source:link:params:)` | Yes | User clicked a hyperlink (OSC 8) |
| `bell(source:)` | Yes | Bell character received |
| `clipboardCopy(source:content:)` | Yes | OSC 52 clipboard write |
| `iTermContent(source:content:)` | Yes | Unhandled iTerm2 OSC 1337 |
| `rangeChanged(source:startY:endY:)` | Yes | Buffer rows changed (requires `notifyUpdateChanges`) |

---

<a id="localprocessterminalviewdelegate"></a>
## LocalProcessTerminalViewDelegate

**File**: `Sources/SwiftTerm/Mac/MacLocalTerminalView.swift`
**Declaration**: `public protocol LocalProcessTerminalViewDelegate: AnyObject`
**Platform**: macOS only

Delegate for `LocalProcessTerminalView`, receiving a subset of events relevant to local process management.

| Method | Description |
|--------|-------------|
| `sizeChanged(source:newCols:newRows:)` | Terminal resized |
| `setTerminalTitle(source:title:)` | Title change |
| `hostCurrentDirectoryUpdate(source:directory:)` | Working directory changed |
| `processTerminated(source:exitCode:)` | Child process exited |

---

<a id="see-also"></a>
## See Also

- [API Models](models.md) — Core types (`Terminal`, `Buffer`, `CharData`, etc.)
- [Configuration](../reference/configuration.md) — `TerminalOptions` and view customization
- DocC: `Sources/SwiftTerm/Documentation.docc/GettingStarted.md`
- DocC: `Sources/SwiftTerm/Documentation.docc/Customization.md`
