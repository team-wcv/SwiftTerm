<a id="overview"></a>
# Glossary

Terminal-specific terminology used in SwiftTerm and the broader terminal emulation domain.

<a id="terms"></a>
## Terms

### Alternate Screen
A separate buffer that applications (e.g., `vim`, `less`, `htop`) switch to so they can draw a full-screen UI without disturbing the normal scrollback. SwiftTerm manages this via `BufferSet` with normal and alternate `Buffer` instances.

### ANSI Colors
The original 8 (or 16 with bright variants) terminal colors defined by ANSI X3.64. Indices 0–7 are the dark colors; 8–15 are the bright variants. See also **256-Color** and **TrueColor**.

### 256-Color
An extended palette where indices 0–15 are ANSI colors, 16–231 form a 6×6×6 color cube, and 232–255 are a grayscale ramp. Activated by `TERM=xterm-256color`. SwiftTerm supports two derivation strategies: `.xterm` and `.base16Lab`.

### Buffer
The data structure holding terminal content. Each buffer contains rows of `BufferLine` objects (the visible screen plus scrollback), cursor state, scroll region, and tab stops. SwiftTerm uses `Buffer` (the class) inside a `BufferSet`.

### CSI (Control Sequence Introducer)
An escape sequence starting with `ESC [` (0x1B 0x5B). CSI sequences control cursor movement, text formatting (SGR), scrolling, and many other operations. Example: `ESC [ 1 ; 31 m` sets bold red text.

### DCS (Device Control String)
An escape sequence starting with `ESC P`. Used for protocol-level data transfer such as Sixel images and DECRQSS queries. Terminated by `ST` (String Terminator, `ESC \`).

### Escape Sequence
A series of bytes starting with ESC (0x1B) that instructs the terminal to perform an action beyond displaying characters. Categories include CSI, OSC, DCS, and simple ESC+character sequences.

### Grapheme Cluster
A user-perceived character that may consist of multiple Unicode code points (e.g., a base character plus combining marks, or an emoji sequence). SwiftTerm stores grapheme clusters in `CharData.code`.

### Kitty Graphics Protocol
A modern inline image protocol developed for the Kitty terminal. Supports chunked image transmission, image caching by ID, arbitrary placement with z-ordering, and Unicode placeholders. SwiftTerm implements this in `KittyGraphics.swift`.

### OSC (Operating System Command)
An escape sequence starting with `ESC ]`. OSC sequences carry application-level metadata: window title (OSC 0/2), hyperlinks (OSC 8), clipboard operations (OSC 52), working directory (OSC 7), and inline images (OSC 1337 for iTerm2).

### Pseudo-Terminal (PTY)
A pair of virtual terminal devices (primary and replica) that allow a process to interact as if connected to a real terminal. `LocalProcess` uses PTYs to connect child processes to the `Terminal` engine.

### Scrollback
Lines that have scrolled off the top of the visible screen but are retained in the buffer. Controlled by `TerminalOptions.scrollback`. Users can scroll back to view this history.

### SGR (Select Graphic Rendition)
The CSI sequence `ESC [ <params> m` that sets text attributes: colors, bold, italic, underline, etc. SwiftTerm maps SGR parameters to `Attribute` and `CharacterStyle`.

### Sixel
An inline graphics protocol originating from DEC terminals. Images are encoded as rows of six pixels tall, transmitted as DCS sequences. SwiftTerm decodes Sixel via `SixelDcsHandler`.

### ST (String Terminator)
The byte sequence `ESC \` (0x1B 0x5C) that terminates OSC, DCS, and other string-type escape sequences. BEL (0x07) is also accepted as a terminator for OSC sequences.

### TrueColor
24-bit RGB color support (16 million colors). Enabled via SGR sequences `38;2;R;G;B` (foreground) and `48;2;R;G;B` (background). Represented in SwiftTerm as `Attribute.Color.trueColor(red:green:blue:)`.

### VT100
The DEC VT100 terminal (1978) that established the de facto standard for terminal escape sequences. SwiftTerm emulates VT100 and its successors (VT220, VT320, VT520) plus Xterm extensions.

### Xterm
The standard X Window System terminal emulator. Xterm has extended the VT100 family with features like 256-color support, mouse reporting, bracketed paste, and the Kitty keyboard protocol. SwiftTerm targets Xterm compatibility as its primary goal.

<a id="ecosystem-glossary"></a>
## Ecosystem Terms

For Orchestraitor ecosystem terminology (agents, tasks, pillars, bastions), see the Orchestraitor ecosystem glossary.

<a id="see-also"></a>
## See Also

- [Architecture](../architecture/architecture.md) — How these concepts map to SwiftTerm's codebase
- [API Models](../api/models.md) — The types that implement these concepts
- [VT100.net](https://vt100.net/) — Comprehensive VT terminal documentation
