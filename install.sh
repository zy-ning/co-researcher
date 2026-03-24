#!/bin/bash
# Copies skills to ~/.claude/skills/
# Usage: ./install.sh [--global]
# Default: copies to .claude/skills/ in current directory (project-local)
# --global: copies to ~/.claude/skills/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/skills"

if [ ! -d "$SRC" ]; then
  echo "Error: skills/ directory not found at $SRC" >&2
  exit 1
fi

DEST=".claude/skills"

case "${1:-}" in
  "")
    ;;
  --global)
    DEST="$HOME/.claude/skills"
    ;;
  *)
    echo "Usage: ./install.sh [--global]" >&2
    exit 1
    ;;
esac

mkdir -p "$DEST"
cp -r "$SRC"/* "$DEST/"
echo "Installed co-researcher skills to $DEST"
