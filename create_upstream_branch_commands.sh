#!/usr/bin/env bash
set -euo pipefail

# Run from anywhere; this script uses absolute paths.
MESA_REPO="/home/username/projects/civ7linux/mesa-debug/src/mesa"
WORK_BRANCH="civ7-wsl2-dzn-fixes"

echo "Using repo: $MESA_REPO"
git -C "$MESA_REPO" fetch --all --tags
git -C "$MESA_REPO" checkout -B "$WORK_BRANCH" 16e15ee20514de1684b349e809fa9632e5afbe4d

echo
echo "Next manual steps:"
echo "1) Apply only upstream-ready edits (exclude local-only instrumentation if needed)."
echo "2) Commit in small logical chunks with Signed-off-by."
echo "3) Generate patch series:"
echo "   git -C \"$MESA_REPO\" format-patch -n origin/main --cover-letter"
echo "4) Fill templates in:"
echo "   /home/username/projects/civ7linux/patch-details/templates"

