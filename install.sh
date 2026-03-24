#!/bin/bash
# Copies skills to ~/.claude/skills/
# Usage: ./install.sh [--global]
# Default: copies to .claude/skills/ in current directory (project-local)
# --global: copies to ~/.claude/skills/

set -e

DEST=".claude/skills"
if [ "$1" = "--global" ]; then
  DEST="$HOME/.claude/skills"
fi

mkdir -p "$DEST"
cp -r skills/* "$DEST/"
echo "Installed to $DEST"