<a id="overview"></a>
# Quick Start

Add a terminal emulator to your Swift application with SwiftTerm.

> For deeper tutorials, see the DocC articles in `Sources/SwiftTerm/Documentation.docc/GettingStarted.md`.

<a id="add-dependency"></a>
## Add the SPM Dependency

In your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/team-wcv/SwiftTerm.git", branch: "main")
]
```

Add `"SwiftTerm"` to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["SwiftTerm"]
)
```

Or in Xcode: **File > Add Package Dependencies** and enter the repository URL.

The SwiftTerm library has **zero external dependencies**.

<a id="platforms"></a>
## Platform Support

| Platform | Minimum | View type |
|----------|---------|-----------|
| macOS | 13.0 | `NSView` (`TerminalView`) |
| iOS | 13.0 | `UIScrollView` (`TerminalView`) |
| visionOS | 1.0 | `UIScrollView` (`TerminalView`) |
| tvOS | 13.0 | Core engine only |
| Linux | — | Core engine + `LocalProcess` |
| Windows | — | Core engine only |

<a id="macos-local"></a>
## macOS: Local Process Terminal

The fastest path to a working terminal on macOS:

```swift
import SwiftTerm
import AppKit

class ViewController: NSViewController, LocalProcessTerminalViewDelegate {
    var terminalView: LocalProcessTerminalView!

    override func viewDidLoad() {
        super.viewDidLoad()
        terminalView = LocalProcessTerminalView(frame: view.bounds)
        terminalView.processDelegate = self
        terminalView.autoresizingMask = [.width, .height]
        view.addSubview(terminalView)
        terminalView.startProcess()
    }

    func sizeChanged(source: LocalProcessTerminalView, newCols: Int, newRows: Int) {}
    func setTerminalTitle(source: LocalProcessTerminalView, title: String) {
        view.window?.title = title
    }
    func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {}
    func processTerminated(source: TerminalView, exitCode: Int32?) {}
}
```

<a id="macos-custom"></a>
## macOS: Custom Data Source

For SSH or other backends, use `TerminalView` directly:

```swift
class MyController: NSViewController, TerminalViewDelegate {
    var terminalView: TerminalView!

    override func viewDidLoad() {
        super.viewDidLoad()
        terminalView = TerminalView(frame: view.bounds)
        terminalView.terminalDelegate = self
        view.addSubview(terminalView)
    }

    func send(source: TerminalView, data: ArraySlice<UInt8>) {
        // Forward to your backend (SSH, socket, etc.)
    }

    // When data arrives from the backend:
    func onDataReceived(_ data: ArraySlice<UInt8>) {
        terminalView.feed(byteArray: data)
    }

    func sizeChanged(source: TerminalView, newCols: Int, newRows: Int) {}
    func setTerminalTitle(source: TerminalView, title: String) {}
    func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {}
    func scrolled(source: TerminalView, position: Double) {}
    func clipboardCopy(source: TerminalView, content: Data) {}
    func rangeChanged(source: TerminalView, startY: Int, endY: Int) {}
}
```

<a id="ios"></a>
## iOS: Embedding a Terminal

On iOS, `TerminalView` is a `UIScrollView` subclass. The pattern is the same as the custom data source above, with `UIViewController` and `UIColor`/`UIFont` types.

Since iOS cannot spawn local processes, connect to a remote host via SSH or another transport. See DocC `SSHIntegration.md` for a worked example.

<a id="headless"></a>
## Headless: Scripting and Testing

Run commands and inspect terminal output without any UI:

```swift
import SwiftTerm

let semaphore = DispatchSemaphore(value: 0)

let headless = HeadlessTerminal(options: TerminalOptions(cols: 80, rows: 24)) { exitCode in
    semaphore.signal()
}

headless.process.startProcess(executable: "/usr/bin/env", args: ["ls", "-la"])
semaphore.wait()

let data = headless.terminal.getBufferAsData()
print(String(data: data, encoding: .utf8) ?? "")
```

See DocC `HeadlessUsage.md` for sending input, custom sizes, and the `termcast` recording tool.

<a id="core-engine"></a>
## Using the Core Engine Directly

For fully custom rendering or non-Apple platforms:

```swift
import SwiftTerm

class MyDelegate: TerminalDelegate {
    func send(source: Terminal, data: ArraySlice<UInt8>) {
        // Forward user responses to the data source
    }
    // Implement other delegate methods as needed...
}

let delegate = MyDelegate()
let terminal = Terminal(delegate: delegate, options: TerminalOptions(cols: 80, rows: 25))

// Feed data into the terminal
terminal.feed(buffer: Array("Hello, terminal!\r\n".utf8)[...])

// Read buffer content
if let line = terminal.getLine(row: 0) {
    print(line.translateToString(trimRight: true))
}
```

<a id="next-steps"></a>
## Next Steps

- [Configuration](../reference/configuration.md) — Customize options, colors, cursor
- [API Models](../api/models.md) — Full type reference
- [API Views](../api/views.md) — View classes and delegate patterns
- DocC: `Customization.md` — Fonts, colors, input behavior
- DocC: `GraphicsSupport.md` — Sixel, iTerm2, Kitty inline images
- DocC: `SSHIntegration.md` — Wiring to SSH
