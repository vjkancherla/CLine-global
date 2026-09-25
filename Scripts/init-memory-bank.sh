#!/usr/bin/env bash
# Scaffold a memory bank. Idempotent: never overwrites an existing file.
# Usage: init-memory-bank.sh [project-dir]

set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

MB="memory-bank"
TODAY="$(date +%F)"
NAME="$(basename "$(pwd)")"
CREATED=()

mkdir -p "$MB/journal" "docs/decisions"

new() {  # new <path> <heredoc-on-stdin>
  if [ -e "$1" ]; then return 0; fi
  mkdir -p "$(dirname "$1")"
  cat > "$1"
  CREATED+=("$1")
}

# --- deterministic detection -------------------------------------------------

STACK="TODO"
CMDS="- Install: TODO
- Build: TODO
- Test all: TODO
- Test single file: TODO
- Lint: TODO
- Run locally: TODO"

if [ -f package.json ]; then
  STACK="Node.js"
  if command -v node >/dev/null 2>&1; then
    STACK="Node.js $(node -v 2>/dev/null || echo '')"
    DETECTED=$(node -e '
      try {
        const s = require("./package.json").scripts || {};
        const pick = (...k) => { for (const x of k) if (s[x]) return x; return null; };
        const line = (label, key) => `- ${label}: ` + (key ? `\`npm run ${key}\`` : "TODO");
        console.log("- Install: `npm install`");
        console.log(line("Build", pick("build")));
        console.log(line("Test all", pick("test")));
        console.log("- Test single file: TODO");
        console.log(line("Lint", pick("lint","eslint")));
        console.log(line("Run locally", pick("dev","start","serve")));
      } catch (e) { process.exit(1); }
    ' 2>/dev/null) && CMDS="$DETECTED"
  fi
elif [ -f pyproject.toml ]; then
  STACK="Python"
  CMDS="- Install: \`pip install -e .\`
- Build: TODO
- Test all: \`pytest\`
- Test single file: \`pytest path/to/test_x.py\`
- Lint: TODO
- Run locally: TODO"
elif [ -f Cargo.toml ]; then
  STACK="Rust"
  CMDS="- Install: \`cargo build\`
- Build: \`cargo build --release\`
- Test all: \`cargo test\`
- Test single file: \`cargo test <name>\`
- Lint: \`cargo clippy\`
- Run locally: \`cargo run\`"
elif [ -f go.mod ]; then
  STACK="Go"
  CMDS="- Install: \`go mod download\`
- Build: \`go build ./...\`
- Test all: \`go test ./...\`
- Test single file: \`go test ./path -run TestX\`
- Lint: TODO
- Run locally: \`go run .\`"
fi

# --- hot files ---------------------------------------------------------------

new "$MB/activeContext.md" <<EOF
# Active Context

Updated: $TODAY

## Current focus
TODO — one line.

## Recent changes
none — memory bank just initialised.

## Next step
TODO — one concrete action.

## Active decisions
none

## Blocked
none
EOF

new "$MB/progress.md" <<EOF
# Progress

Updated: $TODAY

## Working
TODO — verified means run, not written.

## Remaining
TODO

## Known issues
none

## Status
TODO — one line.
EOF

# --- cold files --------------------------------------------------------------

new "$MB/projectbrief.md" <<EOF
# Project Brief

## Purpose
TODO — what $NAME does, in two lines.

## Requirements
TODO — source of truth for scope.

## Out of scope
TODO — what this explicitly does not do.

## Success criteria
TODO — how to tell it is done.
EOF

new "$MB/productContext.md" <<EOF
# Product Context

## Problem
TODO

## Users
TODO

## Behaviour
TODO
EOF

new "$MB/techContext.md" <<EOF
# Tech Context

## Stack
$STACK

## Commands
$CMDS

## Dependencies
TODO — non-obvious ones and why.

## Constraints
TODO

## Do not touch
TODO — generated files, vendored code, tool-managed directories.
EOF

new "$MB/systemPatterns.md" <<EOF
# System Patterns

## Architecture
TODO — components and how they relate.

## Patterns
TODO — conventions to follow.

## Decisions
none yet — see \`docs/decisions/\`
EOF

new "docs/decisions/0000-template.md" <<'EOF'
# NNNN. Title

Date: YYYY-MM-DD
Status: accepted

## Context
What forced a decision.

## Decision
What was chosen.

## Consequences
What this makes easy, what it makes hard, what it rules out.
EOF

# --- report ------------------------------------------------------------------

if [ ${#CREATED[@]} -eq 0 ]; then
  echo "Memory bank already present. Nothing created."
else
  printf 'Created %d file(s):\n' "${#CREATED[@]}"
  printf '  %s\n' "${CREATED[@]}"
fi

echo
echo "Detected stack: $STACK"
echo "Remaining TODO markers:"
grep -rn "TODO" "$MB" docs/decisions 2>/dev/null | grep -v 0000-template || echo "  none"
