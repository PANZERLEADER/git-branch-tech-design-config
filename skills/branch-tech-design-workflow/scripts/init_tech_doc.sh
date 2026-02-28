#!/usr/bin/env bash

set -euo pipefail

TEMPLATE_PATH="${1:-/Users/stuka/IdeaProjects/simi/simi-server/实现方案/XXXXX-技术设计方案模版.md}"
OUT_DIR="${2:-doc/技术方案}"
OUT_FILE="${3:-}"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "ERROR: current directory is not a git repository" >&2
  exit 1
fi

if [ ! -f "$TEMPLATE_PATH" ]; then
  echo "ERROR: template file not found: $TEMPLATE_PATH" >&2
  exit 1
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
SAFE_BRANCH="$(printf '%s' "$CURRENT_BRANCH" | sed 's#[^A-Za-z0-9._-]#_#g')"
TODAY="$(date +%Y%m%d)"

mkdir -p "$OUT_DIR"

if [ -z "$OUT_FILE" ]; then
  OUT_FILE="${OUT_DIR}/${TODAY}-${SAFE_BRANCH}-技术设计方案.md"
fi

cp "$TEMPLATE_PATH" "$OUT_FILE"

TMP_FILE="$(mktemp)"
{
  echo "<!-- generated_by: branch-tech-design-workflow -->"
  echo "<!-- generated_at: $(date '+%Y-%m-%d %H:%M:%S %z') -->"
  echo "<!-- current_branch: ${CURRENT_BRANCH} -->"
  echo "<!-- template: ${TEMPLATE_PATH} -->"
  echo
  cat "$OUT_FILE"
} > "$TMP_FILE"

mv "$TMP_FILE" "$OUT_FILE"

echo "$(cd "$(dirname "$OUT_FILE")" && pwd)/$(basename "$OUT_FILE")"
