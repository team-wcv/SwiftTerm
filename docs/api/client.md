<a id="overview"></a>
# Client / Transport Note

SwiftTerm is a **terminal emulator library**, not a network client.

<a id="what-swiftterm-provides"></a>
## What SwiftTerm Provides

SwiftTerm handles:

- VT100/Xterm escape sequence parsing and state management
- Screen buffer maintenance (normal, alternate, scrollback)
- Platform-native views (AppKit `NSView` on macOS, UIKit `UIScrollView` on iOS/visionOS)
- Local process execution via pseudo-terminals (`LocalProcess`, `HeadlessTerminal`)

SwiftTerm does **not** include any networking, SSH, or remote transport code.

<a id="for-network-terminals"></a>
## For Network-Connected Terminals

If you need to connect a terminal to a remote host, use **TerminalKit**, which wraps SwiftTerm with transport layers:

- **SSH** — Full SSH session management with key and password authentication
- **UDP** — Lightweight transport for custom protocols

TerminalKit manages the data flow between the network and SwiftTerm's `feed(byteArray:)` / `send(source:data:)` interface.

<a id="diy-wiring"></a>
## DIY Wiring

If you prefer to wire SwiftTerm to your own transport, the pattern is straightforward:

1. Implement `TerminalViewDelegate.send(source:data:)` to forward user input bytes to your transport.
2. Call `TerminalView.feed(byteArray:)` when data arrives from the remote end.
3. Handle resize notifications in `TerminalViewDelegate.sizeChanged(source:newCols:newRows:)`.

See the DocC article `SSHIntegration.md` for a worked example with swift-nio-ssh.

<a id="see-also"></a>
## See Also

- [API Models](models.md) — Public types for the terminal engine
- [API Views](views.md) — TerminalView and delegate patterns
- DocC: `Sources/SwiftTerm/Documentation.docc/SSHIntegration.md`
