<a id="overview"></a>
# Ecosystem Map

> **You are here**: SwiftTerm is an upstream dependency of TerminalKit, which connects it to the Orchestraitor ecosystem.

<a id="position"></a>
## Where SwiftTerm Fits

SwiftTerm is a **pure terminal emulator library** — it parses escape sequences, manages buffers, and provides platform views. It has no knowledge of networking, SSH, or orchestration. Those concerns live in higher layers.

```mermaid
graph TD
    subgraph "Pillar: Devices"
        ST["SwiftTerm<br/><i>Terminal emulator engine</i><br/><i>AppKit + UIKit views</i>"]
        TK["TerminalKit<br/><i>Transport layers (SSH, UDP)</i><br/><i>Session management</i>"]
        OA["OrchestraitorApp<br/><i>macOS/iOS client</i><br/><i>Multi-session UI</i>"]
    end

    ST --> TK
    TK --> OA

    style ST fill:#e1f5fe,stroke:#0277bd
    style TK fill:#f3e5f5,stroke:#7b1fa2
    style OA fill:#e8f5e9,stroke:#2e7d32
```

<a id="dependency-chain"></a>
## Dependency Chain

| Layer | Package | Responsibility |
|-------|---------|----------------|
| **SwiftTerm** | `SwiftTerm` | VT100/Xterm emulation, buffer management, escape sequence parsing, AppKit/UIKit views, headless mode |
| **TerminalKit** | `TerminalKit` | Wraps SwiftTerm with SSH, UDP, and other transports; manages sessions, reconnection, and credential handling |
| **OrchestraitorApp** | `OrchestraitorApp` | End-user macOS/iOS application; multi-tab terminal UI, Orchestraitor agent integration, settings |

<a id="boundary"></a>
## What SwiftTerm Does Not Do

SwiftTerm intentionally excludes:

- **Networking**: No SSH, TCP, UDP, or WebSocket code. See TerminalKit for transport layers.
- **Authentication**: No credential storage or key management.
- **Session persistence**: No reconnection or session save/restore.
- **Agent orchestration**: No awareness of Orchestraitor tasks, agents, or workflows.
- **Multi-tab management**: Single terminal instance per view; tab management belongs to the host application.

This boundary keeps SwiftTerm reusable as a standalone library for any Swift application that needs terminal emulation.

<a id="ecosystem-pillar"></a>
## Ecosystem Pillar: Devices

In the Orchestraitor ecosystem, SwiftTerm belongs to the **Devices** pillar — the set of packages that provide on-device user interfaces and local compute capabilities.

```mermaid
graph LR
    subgraph "Devices Pillar"
        direction TB
        ST["SwiftTerm"]
        TK["TerminalKit"]
        OA["OrchestraitorApp"]
    end

    subgraph "Platform Pillar"
        direction TB
        ORC["Orchestraitor<br/>Backend"]
        MSG["Messessager"]
    end

    OA -- "tasks, status" --> ORC
    OA -- "agent comms" --> MSG
```

<a id="for-contributors"></a>
## For Contributors

- Changes to SwiftTerm's public API may require corresponding updates in **TerminalKit**.
- If you modify delegate protocols or view signatures, check downstream consumers.
- SwiftTerm's DocC catalog (`Sources/SwiftTerm/Documentation.docc/`) should be updated for any public API change.
- These docs (`docs/`) should be updated for architectural or structural changes.
