#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_DIR="$HOME/.codex"

mkdir -p "$CODEX_DIR/skills"
cp -R "$SCRIPT_DIR/skills/"* "$CODEX_DIR/skills/"

echo "Installed skills to: $CODEX_DIR/skills"
echo "Available skill: branch-tech-design-workflow"
