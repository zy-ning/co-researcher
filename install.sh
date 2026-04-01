#!/bin/bash
# oh-my-coresearcher installer
#
# Remote (preferred):
#   curl -fsSL https://raw.githubusercontent.com/zy-ning/co-researcher/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/zy-ning/co-researcher/main/install.sh | bash -s -- --global
#
# Local (from cloned repo):
#   ./install.sh [--global]

set -euo pipefail

REPO="zy-ning/co-researcher"
BRANCH="main"
ARCHIVE="https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"

case "${1:-}" in
  --global) GLOBAL=true ;;
  "")       GLOBAL=false ;;
  *)        echo "Usage: install.sh [--global]" >&2; exit 1 ;;
esac

if $GLOBAL; then
  SKILLS_DEST="$HOME/.claude/skills"
  TEMPLATES_DEST="$HOME/.claude/co-researcher/templates"
  CLAUDE_DIR="$HOME/.claude/co-researcher"
else
  SKILLS_DEST="$PWD/.claude/skills"
  TEMPLATES_DEST="$PWD/templates"
  CLAUDE_DIR="$PWD"
fi

# Detect local vs remote invocation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-/dev/null}")" 2>/dev/null && pwd || true)"
if [ -d "${SCRIPT_DIR}/skills" ] && [ "${SCRIPT_DIR}" != "$PWD" ]; then
  SRC="$SCRIPT_DIR"
else
  # curl | bash or run from wrong dir — download archive
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  echo "Downloading oh-my-coresearcher..."
  curl -fsSL "$ARCHIVE" | tar -xz -C "$TMP" --strip-components=1
  SRC="$TMP"
fi

# 1. Skills
mkdir -p "$SKILLS_DEST"
cp -r "$SRC/skills"/* "$SKILLS_DEST/"
echo "✓ Skills → $SKILLS_DEST"

# 2. Templates
mkdir -p "$TEMPLATES_DEST"
cp -r "$SRC/templates"/* "$TEMPLATES_DEST/"
echo "✓ Templates → $TEMPLATES_DEST"

# 3. CLAUDE.md
mkdir -p "$CLAUDE_DIR"
CLAUDE_DEST="$CLAUDE_DIR/CLAUDE.md"
if [ -f "$CLAUDE_DEST" ]; then
  printf '\n---\n\n' >> "$CLAUDE_DEST"
  cat "$SRC/CLAUDE.md" >> "$CLAUDE_DEST"
  echo "✓ CLAUDE.md appended → $CLAUDE_DEST"
else
  cp "$SRC/CLAUDE.md" "$CLAUDE_DEST"
  echo "✓ CLAUDE.md → $CLAUDE_DEST"
fi

echo ""
if $GLOBAL; then
  echo "Next steps:"
  echo "  In your research project, run /research — it will auto-initialize RESEARCH.md."
  echo "  Or manually: cp ~/.claude/co-researcher/templates/RESEARCH.md.template ./RESEARCH.md"
else
  echo "Next steps:"
  echo "  cp templates/RESEARCH.md.template RESEARCH.md"
  echo "  Then run /research to start."
fi
