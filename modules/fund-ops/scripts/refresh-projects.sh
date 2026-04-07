#!/bin/bash
# Claude Hub — Refresh Project Symlinks
# Re-scans OneDrive and Google Drive project folders, creates/updates symlinks
# Safe to run repeatedly — idempotent

set -euo pipefail

# <!-- customize: set these paths to match your environment -->
HUB="${HUB_PATH:-$HOME/Documents/fund-workspace}"
ONEDRIVE="${ONEDRIVE_PATH:-$HOME/Library/CloudStorage/OneDrive-SharedLibraries-Onedrive/Your Fund/1 - Projects}"
GDRIVE="${GDRIVE_PATH:-$HOME/Library/CloudStorage/GoogleDrive-your.email@gmail.com/Other computers/My PC/Project Documents}"

LOG="$HUB/scripts/refresh.log"
echo "=== Refresh started: $(date) ===" >> "$LOG"

ADDED=0
REMOVED=0

# --- Helper ---
ensure_dir() { mkdir -p "$1" 2>/dev/null; }

# --- 1. Invested (GDrive "1. Invested Projects") ---
TARGET="$HUB/projects/Invested"
ensure_dir "$TARGET"

# Add new legal-name folders
for d in "$GDRIVE/1. Invested Projects"/*\(*\)/; do
  [ -d "$d" ] || continue
  name=$(basename "$d")
  short=$(echo "$name" | sed 's/ (.*//' | sed 's/ *$//')
  clean=$(echo "$short" | tr ' ' '-' | tr ',' '_')
  if [ ! -L "$TARGET/$clean" ]; then
    ln -sfn "$d" "$TARGET/$clean"
    echo "  +Invested: $clean" >> "$LOG"
    ((ADDED++)) || true
  fi
done

# Add standalone folders (no legal-name version)
for d in "$GDRIVE/1. Invested Projects"/*/; do
  name=$(basename "$d")
  [[ "$name" == *"("* ]] && continue
  [[ "$name" == *.jpg ]] && continue
  clean=$(echo "$name" | tr ' ' '-' | tr ',' '_')
  if [ ! -L "$TARGET/$clean" ]; then
    ln -sfn "$d" "$TARGET/$clean"
    echo "  +Invested (standalone): $clean" >> "$LOG"
    ((ADDED++)) || true
  fi
done

# Remove broken symlinks
for link in "$TARGET"/*; do
  [ -L "$link" ] || continue
  if [ ! -e "$link" ]; then
    echo "  -Invested (broken): $(basename "$link")" >> "$LOG"
    rm "$link"
    ((REMOVED++)) || true
  fi
done

# --- 2. Pipeline (GDrive Pipelines + OneDrive active) ---
TARGET="$HUB/projects/Pipeline"
ensure_dir "$TARGET"

# GDrive Pipelines
for d in "$GDRIVE/2. Pipelines"/*/; do
  [ -d "$d" ] || continue
  clean=$(basename "$d" | tr ' ' '-')
  if [ ! -L "$TARGET/$clean" ]; then
    ln -sfn "$d" "$TARGET/$clean"
    echo "  +Pipeline (GDrive): $clean" >> "$LOG"
    ((ADDED++)) || true
  fi
done

# OneDrive active projects
for d in "$ONEDRIVE"/*/; do
  name=$(basename "$d")
  case "$name" in "Archive"*|"0 - Template"*|"00 - Framework"*) continue;; esac
  clean=$(echo "$name" | tr ' ' '-')
  if [ ! -L "$TARGET/$clean" ]; then
    ln -sfn "$d" "$TARGET/$clean"
    echo "  +Pipeline (OneDrive): $clean" >> "$LOG"
    ((ADDED++)) || true
  fi
done

# Remove broken symlinks
for link in "$TARGET"/*; do
  [ -L "$link" ] || continue
  if [ ! -e "$link" ]; then
    echo "  -Pipeline (broken): $(basename "$link")" >> "$LOG"
    rm "$link"
    ((REMOVED++)) || true
  fi
done

# --- 3. Legacy (GDrive Legacy Projects) ---
TARGET="$HUB/projects/Legacy"
ensure_dir "$TARGET"

for d in "$GDRIVE/Legacy Projects"/*/; do
  [ -d "$d" ] || continue
  clean=$(basename "$d" | tr ' ' '-')
  if [ ! -L "$TARGET/$clean" ]; then
    ln -sfn "$d" "$TARGET/$clean"
    echo "  +Legacy: $clean" >> "$LOG"
    ((ADDED++)) || true
  fi
done

for link in "$TARGET"/*; do
  [ -L "$link" ] || continue
  if [ ! -e "$link" ]; then
    echo "  -Legacy (broken): $(basename "$link")" >> "$LOG"
    rm "$link"
    ((REMOVED++)) || true
  fi
done

# --- 4. Archive (OneDrive) ---
TARGET="$HUB/projects/Archive"
ensure_dir "$TARGET"
ln -sfn "$ONEDRIVE/Archive Primary" "$TARGET/Primary" 2>/dev/null || true
ln -sfn "$ONEDRIVE/Archive Secondary" "$TARGET/Secondary" 2>/dev/null || true

# --- 5. Reference ---
TARGET="$HUB/projects/Reference"
ensure_dir "$TARGET"

for f in "$GDRIVE"/*; do
  [ -f "$f" ] || continue
  bn=$(basename "$f")
  [ ! -L "$TARGET/$bn" ] && ln -sfn "$f" "$TARGET/$bn"
done
for f in "$ONEDRIVE"/*; do
  [ -f "$f" ] || continue
  bn=$(basename "$f")
  [ ! -L "$TARGET/$bn" ] && ln -sfn "$f" "$TARGET/$bn"
done
ln -sfn "$ONEDRIVE/0 - Template" "$TARGET/OneDrive-Filing-Template" 2>/dev/null || true
ln -sfn "$ONEDRIVE/00 - Framework" "$TARGET/OneDrive-Research-Framework" 2>/dev/null || true
ln -sfn "$GDRIVE/0. Project Filing Template" "$TARGET/GDrive-Filing-Template" 2>/dev/null || true

# Remove broken reference symlinks
for link in "$TARGET"/*; do
  [ -L "$link" ] || continue
  if [ ! -e "$link" ]; then
    rm "$link"
    ((REMOVED++)) || true
  fi
done

# --- Summary ---
INV=$(ls -1 "$HUB/projects/Invested/" 2>/dev/null | wc -l | tr -d ' ')
PIP=$(ls -1 "$HUB/projects/Pipeline/" 2>/dev/null | wc -l | tr -d ' ')
LEG=$(ls -1 "$HUB/projects/Legacy/" 2>/dev/null | wc -l | tr -d ' ')
REF=$(ls -1 "$HUB/projects/Reference/" 2>/dev/null | wc -l | tr -d ' ')

echo "  Summary: Invested=$INV Pipeline=$PIP Legacy=$LEG Reference=$REF | +$ADDED -$REMOVED" >> "$LOG"
echo "=== Refresh done: $(date) ===" >> "$LOG"
echo ""
echo "Projects refreshed: Invested=$INV Pipeline=$PIP Legacy=$LEG Ref=$REF (+$ADDED new, -$REMOVED removed)"
