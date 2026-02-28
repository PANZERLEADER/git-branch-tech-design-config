#!/usr/bin/env bash

set -euo pipefail

BASE_BRANCH="${1:-master}"
OUT_ROOT="${2:-doc/diff}"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "ERROR: current directory is not a git repository" >&2
  exit 1
fi

resolve_base_ref() {
  local branch="$1"
  if git show-ref --verify --quiet "refs/heads/${branch}"; then
    echo "${branch}"
    return 0
  fi
  if git show-ref --verify --quiet "refs/remotes/origin/${branch}"; then
    echo "origin/${branch}"
    return 0
  fi
  return 1
}

if ! BASE_REF="$(resolve_base_ref "$BASE_BRANCH")"; then
  echo "ERROR: base branch '${BASE_BRANCH}' not found locally or in origin" >&2
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
TS="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="${OUT_ROOT}/${SAFE_BRANCH}/${TS}"
mkdir -p "$OUT_DIR"

MERGE_BASE="$(git merge-base "$BASE_REF" HEAD)"
RANGE_DOTS="${BASE_REF}...HEAD"
RANGE_2DOT="${BASE_REF}..HEAD"

GIT_NO_COLOR="git -c color.ui=never"

$GIT_NO_COLOR diff --name-status "$RANGE_DOTS" > "$OUT_DIR/changed-files.name-status.txt"
$GIT_NO_COLOR diff --stat "$RANGE_DOTS" > "$OUT_DIR/changed-files.stat.txt"
$GIT_NO_COLOR diff "$RANGE_DOTS" > "$OUT_DIR/changes.patch"
$GIT_NO_COLOR log --oneline "$RANGE_2DOT" > "$OUT_DIR/commits.oneline.txt"
$GIT_NO_COLOR status --short > "$OUT_DIR/working-tree.status.txt"

cat > "$OUT_DIR/meta.md" <<META
# Diff Meta

- generated_at: $(date '+%Y-%m-%d %H:%M:%S %z')
- current_branch: ${CURRENT_BRANCH}
- base_branch_input: ${BASE_BRANCH}
- base_ref_used: ${BASE_REF}
- merge_base: ${MERGE_BASE}
- diff_range_three_dot: ${RANGE_DOTS}
- commit_range_two_dot: ${RANGE_2DOT}

## Files

- changed-files.name-status.txt
- changed-files.stat.txt
- changes.patch
- commits.oneline.txt
- working-tree.status.txt
META

echo "${OUT_DIR}"
