#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./create_upstream_branch_commands.sh /path/to/mesa
# or set MESA_REPO env var.
MESA_REPO="${1:-${MESA_REPO:-}}"
WORK_BRANCH="dzn-wsl2-stability-fixes"
BASE_COMMIT="16e15ee20514de1684b349e809fa9632e5afbe4d"

if [[ -z "${MESA_REPO}" ]]; then
  echo "Usage: $0 /path/to/mesa (or set MESA_REPO)" >&2
  exit 2
fi

if [[ ! -d "$MESA_REPO/.git" ]]; then
  echo "Not a git repo: $MESA_REPO" >&2
  exit 2
fi

echo "Using repo: $MESA_REPO"
git -C "$MESA_REPO" fetch --all --tags
git -C "$MESA_REPO" checkout -B "$WORK_BRANCH" "$BASE_COMMIT"

echo
 echo "Next manual steps:"
echo "1) Apply only upstream-ready edits (exclude investigation-only instrumentation if needed)."
echo "2) Commit in small logical chunks with Signed-off-by."
echo "3) Generate patch series: git -C '$MESA_REPO' format-patch -n origin/main --cover-letter"
