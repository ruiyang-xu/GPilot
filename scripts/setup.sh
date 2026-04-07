#!/bin/bash
# Claude Hub — Setup Script
# Symlinks config/global/ → ~/.claude/
set -euo pipefail

HUB="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Claude Hub Setup"
echo "Hub: $HUB"

mkdir -p "$CLAUDE_DIR/rules"

# Global CLAUDE.md
SRC="$HUB/config/global/CLAUDE.md"
TGT="$CLAUDE_DIR/CLAUDE.md"
if [ -L "$TGT" ] && [ "$(readlink "$TGT")" = "$SRC" ]; then
  echo "[OK] CLAUDE.md"
else
  [ -f "$TGT" ] && [ ! -L "$TGT" ] && mv "$TGT" "$TGT.backup.$(date +%s)"
  ln -sfn "$SRC" "$TGT"
  echo "[LINK] CLAUDE.md"
fi

# Rules
for f in "$HUB/config/global/rules/"*.md; do
  [ -f "$f" ] || continue
  bn=$(basename "$f")
  tgt="$CLAUDE_DIR/rules/$bn"
  if [ -L "$tgt" ] && [ "$(readlink "$tgt")" = "$f" ]; then
    echo "[OK] rules/$bn"
  else
    [ -f "$tgt" ] && [ ! -L "$tgt" ] && mv "$tgt" "$tgt.backup.$(date +%s)"
    ln -sfn "$f" "$tgt"
    echo "[LINK] rules/$bn"
  fi
done

echo "Done."
