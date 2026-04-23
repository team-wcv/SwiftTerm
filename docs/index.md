<a id="overview"></a>
# SwiftTerm Documentation

VT100/Xterm terminal emulator library for Swift — macOS, iOS, visionOS, Linux, and Windows.

> SwiftTerm also has **DocC documentation** under `Sources/SwiftTerm/Documentation.docc/`.
> Build it with `swift package generate-documentation` or browse the articles directly.
> These docs complement the DocC catalog; they do not duplicate it.

<a id="navigation"></a>
## Navigation

- [Quick Start](setup/quick-start.md)
- [Architecture](architecture/architecture.md)
- [Ecosystem Map](architecture/ecosystem-map.md)
- [API Models](api/models.md)
- [API Views](api/views.md)
- [Configuration](reference/configuration.md)
- [Troubleshooting](reference/troubleshooting.md)

<a id="quick-entry-points"></a>
## Quick Entry Points

| Goal | Where to look |
|------|---------------|
| Add SwiftTerm to your project | [Quick Start](setup/quick-start.md) |
| Understand the engine internals | [Architecture](architecture/architecture.md) |
| See where SwiftTerm fits in the ecosystem | [Ecosystem Map](architecture/ecosystem-map.md) |
| Browse all public types | [API Models](api/models.md) |
| Work with TerminalView | [API Views](api/views.md) |
| Connect via SSH or other transports | [Client / Transport Note](api/client.md) |
| Tune options, colors, cursor style | [Configuration](reference/configuration.md) |
| Run and write tests | [Testing](setup/testing.md) |
| Fix rendering or input issues | [Troubleshooting](reference/troubleshooting.md) |
| Understand error flow | [Error Handling](reference/error-handling.md) |
| Look up terminal jargon | [Glossary](reference/glossary.md) |
| Sync from upstream fork | [Migration](reference/migration.md) |
| Review recent changes | [Changelog](changelog.md) |

<a id="documentation-surface-map"></a>
## Documentation Surface Map

### DocC Articles (Sources/SwiftTerm/Documentation.docc/)

| Article | Coverage |
|---------|----------|
| `Documentation.md` | Library overview, topic groups |
| `GettingStarted.md` | SPM setup, platform embedding, headless usage |
| `Customization.md` | Fonts, colors, cursor, input behavior, search |
| `GraphicsSupport.md` | Sixel, iTerm2, Kitty graphics protocols |
| `SSHIntegration.md` | Wiring TerminalView to SSH channels |
| `HeadlessUsage.md` | Scripting with HeadlessTerminal, termcast |

### These Docs (docs/)

| Directory | Files |
|-----------|-------|
| `architecture/` | [architecture.md](architecture/architecture.md), [ecosystem-map.md](architecture/ecosystem-map.md) |
| `api/` | [client.md](api/client.md), [models.md](api/models.md), [views.md](api/views.md) |
| `setup/` | [quick-start.md](setup/quick-start.md), [testing.md](setup/testing.md) |
| `reference/` | [configuration.md](reference/configuration.md), [error-handling.md](reference/error-handling.md), [troubleshooting.md](reference/troubleshooting.md), [glossary.md](reference/glossary.md), [migration.md](reference/migration.md) |

<a id="code-surface-map"></a>
## Code Surface Map

| Source path | Role |
|-------------|------|
| `Sources/SwiftTerm/Terminal.swift` | Core emulator engine |
| `Sources/SwiftTerm/EscapeSequenceParser.swift` | VT100/Xterm escape sequence state machine |
| `Sources/SwiftTerm/Buffer.swift` | Screen buffer (normal + alternate) |
| `Sources/SwiftTerm/BufferLine.swift` | Single line of terminal content |
| `Sources/SwiftTerm/CharData.swift` | Per-cell character + attribute data |
| `Sources/SwiftTerm/Colors.swift` | ANSI / 256-color / TrueColor palette |
| `Sources/SwiftTerm/TerminalOptions.swift` | Startup configuration |
| `Sources/SwiftTerm/HeadlessTerminal.swift` | UI-free terminal for scripting |
| `Sources/SwiftTerm/LocalProcess.swift` | Pseudo-terminal process management |
| `Sources/SwiftTerm/Mac/` | macOS AppKit views |
| `Sources/SwiftTerm/iOS/` | iOS/visionOS UIKit views |
| `Sources/SwiftTerm/Apple/` | Shared AppKit/UIKit rendering |
| `Sources/SwiftTerm/SixelDcsHandler.swift` | Sixel graphics decoder |
| `Sources/SwiftTerm/KittyGraphics.swift` | Kitty graphics protocol |
| `Sources/Termcast/` | Terminal session recording CLI |
| `Sources/SwiftTermFuzz/` | Fuzzing harness |
| `Tests/SwiftTermTests/` | Unit and integration tests |

<a id="agent-navigation"></a>
## Agent Navigation

- **Entry point for understanding the engine**: [Architecture](architecture/architecture.md)
- **Entry point for using the library**: [Quick Start](setup/quick-start.md) or DocC `GettingStarted.md`
- **Entry point for ecosystem context**: [Ecosystem Map](architecture/ecosystem-map.md)
- **Key protocols**: `TerminalDelegate` (engine), `TerminalViewDelegate` (views), `LocalProcessDelegate` (process)
- **Key classes**: `Terminal`, `TerminalView`, `HeadlessTerminal`, `LocalProcess`, `Buffer`
