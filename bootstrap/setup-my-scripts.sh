#!/usr/bin/env bash
set -euo pipefail

MY_SCRIPTS_REPO="git@github.com:HiteshRepo/my-scripts.git"
MY_SCRIPTS_DIR="$HOME/Documents/personal/codebase/my-scripts"

# ─── Clone repo ───────────────────────────────────────────────────────────────
if [ -d "$MY_SCRIPTS_DIR" ]; then
  echo "my-scripts already cloned at $MY_SCRIPTS_DIR"
else
  echo "Cloning my-scripts..."
  mkdir -p "$(dirname "$MY_SCRIPTS_DIR")"
  git clone "$MY_SCRIPTS_REPO" "$MY_SCRIPTS_DIR"
  echo "Cloned to $MY_SCRIPTS_DIR"
fi
