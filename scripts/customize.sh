#!/bin/bash
# GPilot — Customize Script
# Reads your .env file and applies your configuration across the workspace.
# Usage: bash scripts/customize.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$ROOT/.env"

# --- Check .env exists ---
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: .env file not found."
  echo "Run: cp .env.example .env"
  echo "Then edit .env with your values."
  exit 1
fi

# --- Load .env ---
set -a
source "$ENV_FILE"
set +a

# --- Validate required fields ---
if [ -z "${USER_NAME:-}" ] || [ "$USER_NAME" = "Your Name" ]; then
  echo "Error: USER_NAME is not set in .env. Please edit .env first."
  exit 1
fi

ORG_NAME="${ORG_NAME:-Acme Ventures}"
USER_INITIALS="${USER_INITIALS:-${USER_NAME:0:2}}"
FOCUS_SECTORS="${FOCUS_SECTORS:-Software/SaaS, AI/ML, Fintech, Healthtech, Deeptech}"

echo "Customizing GPilot for: $USER_NAME ($USER_INITIALS) — $ORG_NAME"
echo "Focus sectors: $FOCUS_SECTORS"
echo "============================================"

CHANGED=0

# --- Cross-platform sed (macOS vs Linux) ---
do_sed() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

# --- 1. CLAUDE.md ---
if [ -f "$ROOT/CLAUDE.md" ]; then
  do_sed "s/YN/$USER_INITIALS/g" "$ROOT/CLAUDE.md"
  do_sed "s/Acme Ventures/$ORG_NAME/g" "$ROOT/CLAUDE.md"
  echo "  [ok] CLAUDE.md"
  ((CHANGED++)) || true
fi

# --- 2. config/global/CLAUDE.md ---
if [ -f "$ROOT/config/global/CLAUDE.md" ]; then
  do_sed "s/Solo GP/$USER_NAME/g" "$ROOT/config/global/CLAUDE.md"
  echo "  [ok] config/global/CLAUDE.md"
  ((CHANGED++)) || true
fi

# --- 3. Feishu config (if exists in modules) ---
FEISHU_CONFIG="$ROOT/modules/integrations/feishu/feishu-link.md"
if [ -f "$FEISHU_CONFIG" ]; then
  do_sed "s/Your Name (YN)/$USER_NAME ($USER_INITIALS)/g" "$FEISHU_CONFIG"
  do_sed "s/Acme Ventures/$ORG_NAME/g" "$FEISHU_CONFIG"
  if [ -n "${FEISHU_OPEN_ID:-}" ]; then
    do_sed "s/ou_YOUR_OPEN_ID_HERE/$FEISHU_OPEN_ID/g" "$FEISHU_CONFIG"
  fi
  echo "  [ok] modules/integrations/feishu/feishu-link.md"
  ((CHANGED++)) || true
fi

# --- 4. config/mcp.json ---
if [ -f "$ROOT/config/mcp.json" ] && [ -n "${PERPLEXITY_API_KEY:-}" ]; then
  do_sed "s/YOUR_PERPLEXITY_API_KEY_HERE/$PERPLEXITY_API_KEY/g" "$ROOT/config/mcp.json"
  echo "  [ok] config/mcp.json (API key set)"
  ((CHANGED++)) || true
fi

# --- 5. Fund-ops refresh script (if enabled) ---
REFRESH_SCRIPT="$ROOT/modules/fund-ops/scripts/refresh-projects.sh"
if [ -f "$REFRESH_SCRIPT" ]; then
  if [ -n "${GDRIVE_EMAIL:-}" ]; then
    do_sed "s/your.email@gmail.com/$GDRIVE_EMAIL/g" "$REFRESH_SCRIPT"
  fi
  do_sed "s/Your Fund/$ORG_NAME/g" "$REFRESH_SCRIPT"
  echo "  [ok] modules/fund-ops/scripts/refresh-projects.sh"
  ((CHANGED++)) || true
fi

# --- 6. Dashboard ---
if [ -f "$ROOT/dashboard/app/layout.tsx" ]; then
  do_sed "s/Portfolio Alpha/$ORG_NAME Portfolio I/g" "$ROOT/dashboard/app/layout.tsx"
  do_sed "s/Portfolio Beta/$ORG_NAME Portfolio II/g" "$ROOT/dashboard/app/layout.tsx"
  echo "  [ok] dashboard/app/layout.tsx"
  ((CHANGED++)) || true
fi

if [ -f "$ROOT/dashboard/lib/types.ts" ]; then
  do_sed "s/Portfolio Alpha/$ORG_NAME Portfolio I/g" "$ROOT/dashboard/lib/types.ts"
  do_sed "s/Portfolio Beta/$ORG_NAME Portfolio II/g" "$ROOT/dashboard/lib/types.ts"
  echo "  [ok] dashboard/lib/types.ts"
  ((CHANGED++)) || true
fi

# --- 7. Initialize data files from .example templates ---
for example_file in "$ROOT"/data/state/*.json.example "$ROOT"/dashboard/public/*.json.example; do
  [ -f "$example_file" ] || continue
  target="${example_file%.example}"
  if [ ! -f "$target" ]; then
    cp "$example_file" "$target"
    echo "  [ok] $(basename "$target") (initialized from .example)"
    ((CHANGED++)) || true
  else
    echo "  [skip] $(basename "$target") (already exists)"
  fi
done

echo "============================================"
echo "Done! $CHANGED files customized."
echo ""
echo "Next steps:"
echo "  1. Run: bash scripts/setup.sh"
echo "  2. Open this project in Claude Code"
echo "  3. Try: /query \"What is the current state of AI infrastructure?\""
