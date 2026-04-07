#!/bin/bash
# Claude Hub — Cross-machine Sync
# Pull latest from remote, report changes

set -euo pipefail

HUB_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$HUB_DIR"

echo "Claude Hub Sync"
echo "==============="
echo "Hub: $HUB_DIR"
echo "Machine: $(hostname)"
echo "Time: $(date)"
echo ""

# Check if git repo
if [ ! -d .git ]; then
    echo "[ERROR] Not a git repository. Run 'git init' first."
    exit 1
fi

# Check for uncommitted changes
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    echo "[WARN] Uncommitted changes detected. Stashing..."
    git stash push -m "auto-stash $(date +%Y%m%d%H%M%S)"
    STASHED=true
else
    STASHED=false
fi

# Pull
echo "Pulling latest..."
git pull --rebase origin main 2>/dev/null || git pull --rebase origin master 2>/dev/null || echo "[WARN] No remote configured or pull failed"

# Pop stash if needed
if [ "$STASHED" = true ]; then
    echo "Restoring stashed changes..."
    git stash pop || echo "[WARN] Stash pop had conflicts — resolve manually"
fi

# Re-run setup to ensure symlinks are correct
echo ""
echo "Re-running setup..."
bash "$HUB_DIR/scripts/setup.sh"

echo ""
echo "Sync complete!"
