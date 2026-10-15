#!/bin/bash
set -euo pipefail

# Only run in Claude Code cloud sessions
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"

# Install dependencies for whichever manifests exist (idempotent, non-interactive)
if [ -f package.json ]; then
  npm install
fi

if [ -f requirements.txt ]; then
  pip install -r requirements.txt
elif [ -f pyproject.toml ]; then
  pip install -e .
fi

if [ -f Gemfile ]; then
  bundle install
fi

if [ -f go.mod ]; then
  go mod download
fi

if [ -f Cargo.toml ]; then
  cargo fetch
fi
