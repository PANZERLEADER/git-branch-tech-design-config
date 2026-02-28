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

sanitize_branch_for_path() {
  local branch="$1"
  local safe="$branch"

  # Keep non-ASCII branch names readable (e.g. Chinese), only replace path-risk chars.
  safe="${safe//\//__}"
  safe="${safe//\\/__}"
  safe="${safe//$'\n'/_}"
  safe="${safe//$'\r'/_}"
  safe="${safe//$'\t'/_}"
  safe="$(printf '%s' "$safe" | sed -E 's/[:*?"<>|]/_/g; s/[[:space:]]+/_/g; s/_+/_/g; s/^_+//; s/_+$//')"

  if [ -z "$safe" ]; then
    safe="branch"
  fi

  printf '%s' "$safe"
}

SAFE_BRANCH="$(sanitize_branch_for_path "$CURRENT_BRANCH")"
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
