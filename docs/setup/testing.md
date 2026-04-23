<a id="overview"></a>
# Testing

How to run tests, understand the test structure, and use the fuzzer.

<a id="running-tests"></a>
## Running Tests

```bash
# Run all tests
swift test

# Run a specific test class
swift test --filter SwiftTermTests.BufferTests

# Run a specific test method
swift test --filter SwiftTermTests.BufferTests/testSomeMethod

# Verbose output
swift test --verbose
```

In Xcode, use **Product > Test** (Cmd-U) or run individual tests from the Test Navigator.

<a id="test-structure"></a>
## Test Structure

All tests live in `Tests/SwiftTermTests/`. The test target depends on the `SwiftTerm` library.

| File | Coverage |
|------|----------|
| `SwiftTermTests.swift` | General terminal behavior |
| `TerminalCoreTests.swift` | Core engine operations |
| `BufferTests.swift` | Buffer manipulation, scrollback |
| `ParserTests.swift` | Escape sequence parsing |
| `CsiParameterParsingTests.swift` | CSI parameter edge cases |
| `DcsTests.swift` | Device Control String handling |
| `OscTests.swift` | Operating System Command sequences |
| `SgrTests.swift` | Select Graphic Rendition (colors, styles) |
| `ColorTests.swift` | Color type and palette logic |
| `ColorQueryTests.swift` | Color query/response sequences |
| `ScreenTests.swift` | Screen operations (scroll, erase) |
| `ReflowTests.swift` | Line reflow on terminal resize |
| `ReflowPortedTests.swift` | Reflow tests ported from xterm.js |
| `HistoryTests.swift` | Scrollback history |
| `SearchTests.swift` | Text search functionality |
| `SelectionTests.swift` | Selection behavior |
| `UnicodeTests.swift` | Unicode rendering, combining characters, CJK |
| `ImageTests.swift` | Inline image protocol handling |
| `KittyGraphicsLifecycleTests.swift` | Kitty image lifecycle |
| `KittyTransmissionTests.swift` | Kitty image data transmission |
| `KittyCursorTests.swift` | Kitty cursor movement with images |
| `KittyRelativePlacementTests.swift` | Kitty relative image placement |
| `KittyUnicodeTests.swift` | Kitty Unicode placeholder rendering |
| `SynchronizedOutputTests.swift` | Synchronized output mode |
| `MeanTests.swift` | Statistical helpers |
| `PerformanceTest.swift` | Performance benchmarks |
| `FuzzerTests.swift` | Fuzzer integration |
| `TerminalTestHarness.swift` | Shared test utilities |
| `Memory.swift` | Memory measurement helpers |

<a id="test-harness"></a>
## Test Harness

`TerminalTestHarness.swift` provides shared utilities for creating `Terminal` instances with controlled options, feeding input, and asserting buffer state. Most test files use this harness to set up test scenarios.

<a id="fuzzer"></a>
## Fuzzer

SwiftTerm includes a fuzzing target at `Sources/SwiftTermFuzz/`:

```bash
# Build the fuzzer
swift build --target SwiftTermFuzz

# Run it (generates random terminal input)
swift run SwiftTermFuzz
```

The fuzzer generates random byte sequences and feeds them to a `Terminal` instance, testing for crashes, hangs, and undefined behavior in the parser and engine. `FuzzerTests.swift` in the test suite provides additional fuzz-like test cases.

<a id="performance"></a>
## Performance Tests

`PerformanceTest.swift` contains XCTest performance measurements. Run them in Xcode for baseline metrics or via:

```bash
swift test --filter SwiftTermTests.PerformanceTest
```

<a id="ci"></a>
## CI

Tests run on push and pull request via GitHub Actions. The CI matrix covers:

- macOS (latest Xcode)
- Linux (Swift toolchain)

Ensure `swift test` passes locally before opening a PR.

<a id="writing-tests"></a>
## Writing New Tests

1. Add your test file to `Tests/SwiftTermTests/`.
2. Import `SwiftTerm` and `XCTest`.
3. Use `TerminalTestHarness` to create terminals with controlled options.
4. Feed input with `terminal.feed(buffer:)` or `terminal.feed(text:)`.
5. Assert on buffer contents using `terminal.getLine(row:)` and `BufferLine.translateToString()`.

```swift
import XCTest
@testable import SwiftTerm

final class MyTests: XCTestCase {
    func testBasicOutput() {
        let terminal = Terminal(delegate: TestDelegate(), options: TerminalOptions(cols: 80, rows: 24))
        terminal.feed(text: "Hello\r\n")
        let line = terminal.getLine(row: 0)!
        XCTAssertEqual(line.translateToString(trimRight: true), "Hello")
    }
}
```
