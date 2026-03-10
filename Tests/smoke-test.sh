#!/bin/bash
# SwiftTerm-fork Smoke Test Suite
# Validates Swift package structure, sources, tests, and platform dirs.
# Usage: ./smoke-test.sh [--build]

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/../../Orchestraitor/tests/lib/test-helpers.sh" 2>/dev/null \
  || source "$SCRIPT_DIR/../../../Orchestraitor/tests/lib/test-helpers.sh" 2>/dev/null \
  || { echo "Cannot find test-helpers.sh"; exit 1; }

DO_BUILD=false
for arg in "$@"; do
  [[ "$arg" == "--build" ]] && DO_BUILD=true
done

# ═══════════════════════════════════════════════════════════════════════════════
section "Package Manifest"
# ═══════════════════════════════════════════════════════════════════════════════

check_file "$PROJECT_DIR/Package.swift" "Package.swift exists"
check_grep "$PROJECT_DIR/Package.swift" "swift-tools-version" "swift-tools-version declared"
check_grep "$PROJECT_DIR/Package.swift" "SwiftTerm" "SwiftTerm product declared"

# ═══════════════════════════════════════════════════════════════════════════════
section "Package.resolved (Tracked Dependency Lock)"
# ═══════════════════════════════════════════════════════════════════════════════

check_file "$PROJECT_DIR/Package.resolved" "Package.resolved exists"

if [[ -f "$PROJECT_DIR/.gitignore" ]]; then
  if grep -q "Package.resolved" "$PROJECT_DIR/.gitignore" 2>/dev/null; then
    fail "Package.resolved not gitignored" "found in .gitignore"
  else
    pass "Package.resolved not gitignored"
  fi
else
  pass "Package.resolved not gitignored (no .gitignore)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "Root Files"
# ═══════════════════════════════════════════════════════════════════════════════

check_file "$PROJECT_DIR/README.md" "README.md exists"
check_file "$PROJECT_DIR/LICENSE" "LICENSE exists"

if [[ -f "$PROJECT_DIR/SECURITY.md" ]]; then
  pass "SECURITY.md exists"
else
  skip "SECURITY.md not found"
fi

if [[ -f "$PROJECT_DIR/CODE_OF_CONDUCT.md" ]]; then
  pass "CODE_OF_CONDUCT.md exists"
else
  skip "CODE_OF_CONDUCT.md not found"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "Sources/SwiftTerm — Core"
# ═══════════════════════════════════════════════════════════════════════════════

check_dir "$PROJECT_DIR/Sources/SwiftTerm" "Sources/SwiftTerm/ exists"
check_min_files "$PROJECT_DIR/Sources/SwiftTerm" "*.swift" 20 "SwiftTerm has ≥20 Swift files"

for f in Terminal.swift Buffer.swift LocalProcess.swift EscapeSequences.swift Pty.swift Colors.swift; do
  check_file "$PROJECT_DIR/Sources/SwiftTerm/$f" "Sources/SwiftTerm/$f"
done

for f in CharData.swift CircularList.swift HeadlessTerminal.swift SearchEngine.swift; do
  if [[ -f "$PROJECT_DIR/Sources/SwiftTerm/$f" ]]; then
    pass "Sources/SwiftTerm/$f"
  else
    skip "Sources/SwiftTerm/$f (optional)"
  fi
done

# ═══════════════════════════════════════════════════════════════════════════════
section "Sources/SwiftTermFuzz"
# ═══════════════════════════════════════════════════════════════════════════════

check_dir "$PROJECT_DIR/Sources/SwiftTermFuzz" "Sources/SwiftTermFuzz/ exists"
check_file "$PROJECT_DIR/Sources/SwiftTermFuzz/main.swift" "SwiftTermFuzz/main.swift"

# ═══════════════════════════════════════════════════════════════════════════════
section "Sources/Termcast"
# ═══════════════════════════════════════════════════════════════════════════════

check_dir "$PROJECT_DIR/Sources/Termcast" "Sources/Termcast/ exists"
check_file "$PROJECT_DIR/Sources/Termcast/main.swift" "Termcast/main.swift"
check_file "$PROJECT_DIR/Sources/Termcast/TermcastRecorder.swift" "Termcast/TermcastRecorder.swift"
check_file "$PROJECT_DIR/Sources/Termcast/TermcastPlayer.swift" "Termcast/TermcastPlayer.swift"

if [[ -f "$PROJECT_DIR/Sources/Termcast/AsciicastFormat.swift" ]]; then
  pass "Termcast/AsciicastFormat.swift"
else
  skip "Termcast/AsciicastFormat.swift (optional)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "Sources/CaptureOutput"
# ═══════════════════════════════════════════════════════════════════════════════

if [[ -d "$PROJECT_DIR/Sources/CaptureOutput" ]]; then
  pass "Sources/CaptureOutput/ exists"
  check_min_files "$PROJECT_DIR/Sources/CaptureOutput" "*.swift" 1 "CaptureOutput has ≥1 Swift file"
else
  skip "Sources/CaptureOutput/ (optional)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "Platform Directories"
# ═══════════════════════════════════════════════════════════════════════════════

check_dir "$PROJECT_DIR/Sources/SwiftTerm/Mac" "Sources/SwiftTerm/Mac/"
check_dir "$PROJECT_DIR/Sources/SwiftTerm/iOS" "Sources/SwiftTerm/iOS/"
check_dir "$PROJECT_DIR/Sources/SwiftTerm/Apple" "Sources/SwiftTerm/Apple/"

check_min_files "$PROJECT_DIR/Sources/SwiftTerm/Mac" "*.swift" 3 "Mac/ has ≥3 Swift files"
check_min_files "$PROJECT_DIR/Sources/SwiftTerm/iOS" "*.swift" 3 "iOS/ has ≥3 Swift files"
check_min_files "$PROJECT_DIR/Sources/SwiftTerm/Apple" "*.swift" 2 "Apple/ has ≥2 Swift files"

# ═══════════════════════════════════════════════════════════════════════════════
section "Tests"
# ═══════════════════════════════════════════════════════════════════════════════

check_dir "$PROJECT_DIR/Tests/SwiftTermTests" "Tests/SwiftTermTests/ exists"
check_min_files "$PROJECT_DIR/Tests/SwiftTermTests" "*.swift" 10 "SwiftTermTests has ≥10 test files"

# ═══════════════════════════════════════════════════════════════════════════════
section "Dependencies in Package.swift"
# ═══════════════════════════════════════════════════════════════════════════════

check_grep "$PROJECT_DIR/Package.swift" "swift-argument-parser" "Depends on swift-argument-parser"
check_grep "$PROJECT_DIR/Package.swift" "swift-docc-plugin" "Depends on swift-docc-plugin"

# ═══════════════════════════════════════════════════════════════════════════════
section "Swift Package Resolve (optional)"
# ═══════════════════════════════════════════════════════════════════════════════

if command -v swift &>/dev/null; then
  if timeout 60 swift package resolve --package-path "$PROJECT_DIR" &>/dev/null; then
    pass "swift package resolve succeeds"
  else
    skip "swift package resolve failed or timed out"
  fi
else
  skip "swift not available"
fi

# ═══════════════════════════════════════════════════════════════════════════════
section "Swift Build (--build flag only)"
# ═══════════════════════════════════════════════════════════════════════════════

if $DO_BUILD; then
  if command -v swift &>/dev/null; then
    if timeout 120 swift build --package-path "$PROJECT_DIR" 2>&1 | tail -5; then
      pass "swift build succeeds"
    else
      fail "swift build" "build failed"
    fi
  else
    skip "swift not available"
  fi
else
  skip "swift build (pass --build to enable)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
finish "SwiftTerm-fork"
