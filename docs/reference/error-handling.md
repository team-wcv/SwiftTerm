<a id="overview"></a>
# Error Handling

SwiftTerm uses **delegate callbacks** rather than Swift's `throw` mechanism. There are no custom error types or `DiagnosticError` conformances in the library.

<a id="design-rationale"></a>
## Design Rationale

Terminal emulation is a continuous stream-processing pipeline. Bytes flow in, state is updated, and the delegate is notified. There is no natural "call-and-return" boundary where throwing an error would be useful. Instead:

- **Malformed escape sequences** are silently ignored or partially processed, matching real terminal behavior (VT100, xterm, and others all discard invalid sequences rather than reporting errors).
- **Process lifecycle events** are delivered via delegate callbacks.
- **View-level events** (title changes, bell, clipboard, links) are delegate notifications, not error conditions.

<a id="engine-level"></a>
## Engine-Level Notifications (TerminalDelegate)

The `TerminalDelegate` protocol communicates state changes from the `Terminal` engine:

| Callback | When invoked |
|----------|--------------|
| `send(source:data:)` | Terminal needs to send data to the host |
| `bell(source:)` | Bell character (BEL, 0x07) received |
| `setTerminalTitle(source:title:)` | Application changed the window title |
| `sizeChanged(source:)` | Terminal dimensions changed by escape sequence |
| `bufferActivated(source:)` | Switched between normal and alternate screen |
| `selectionChanged(source:)` | Selection state changed |
| `colorChanged(source:idx:)` | A palette color was changed by the application |
| `hostCurrentDirectoryUpdated(source:)` | OSC 7 working directory update |

None of these throw. If your application needs to surface an error state (e.g. "process disconnected"), that logic belongs in your delegate implementation.

<a id="process-level"></a>
## Process-Level Notifications (LocalProcessDelegate)

For local process execution, `LocalProcessDelegate` reports:

| Callback | When invoked |
|----------|--------------|
| `processTerminated(_:exitCode:)` | The child process exited. `exitCode` is `nil` if the termination was caused by an I/O error. |
| `dataReceived(slice:)` | Data arrived from the child process |

Check `exitCode` to determine whether the process exited cleanly:

```swift
func processTerminated(_ source: LocalProcess, exitCode: Int32?) {
    if let code = exitCode, code != 0 {
        // Process exited with an error
    } else if exitCode == nil {
        // I/O error during communication
    }
}
```

<a id="view-level"></a>
## View-Level Notifications (TerminalViewDelegate)

The `TerminalViewDelegate` mirrors some engine events and adds view-specific ones:

| Callback | When invoked |
|----------|--------------|
| `send(source:data:)` | User typed input that should be forwarded |
| `bell(source:)` | Bell received — play a sound, flash the screen, etc. |
| `requestOpenLink(source:link:params:)` | User clicked a hyperlink |
| `clipboardCopy(source:content:)` | Application requested clipboard write (OSC 52) |

<a id="transport-errors"></a>
## Transport-Level Errors

SwiftTerm does not handle networking. If you connect the terminal to an SSH session, socket, or other transport, error handling for connection failures, timeouts, and authentication belongs in your transport layer.

For the Orchestraitor ecosystem, **TerminalKit** wraps SwiftTerm with transport layers and provides its own error types for connection-level issues. See the TerminalKit documentation for:

- `ConnectionError` — SSH/transport connection failures
- `AuthenticationError` — Credential and key issues
- Session timeout and reconnection handling

<a id="summary"></a>
## Summary

| Layer | Error mechanism | Where to look |
|-------|----------------|---------------|
| Terminal engine | Silent discard (matches VT100/xterm behavior) | Parser state machine in `EscapeSequenceParser.swift` |
| Process lifecycle | `exitCode` in `processTerminated` delegate | `LocalProcess.swift` |
| View events | Delegate callbacks | `TerminalViewDelegate` protocol |
| Transport/networking | Not in SwiftTerm | TerminalKit or your transport layer |
