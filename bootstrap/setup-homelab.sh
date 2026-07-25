#!/usr/bin/env bash
set -euo pipefail

# Run this script only on the Ubuntu homelab laptop, after bootstrap.sh.
# It clones the k3s-homelab repo and guides through first-time setup.

HOMELAB_REPO="git@github.com:HiteshRepo/k3s-homelab.git"
HOMELAB_DIR="$HOME/workspace/k3s-homelab"

# ─── Clone repo ───────────────────────────────────────────────────────────────
if [ -d "$HOMELAB_DIR" ]; then
  echo "k3s-homelab already cloned at $HOMELAB_DIR"
else
  echo "Cloning k3s-homelab..."
  mkdir -p "$(dirname "$HOMELAB_DIR")"
  git clone "$HOMELAB_REPO" "$HOMELAB_DIR"
  echo "Cloned to $HOMELAB_DIR"
fi

# ─── First-time setup ─────────────────────────────────────────────────────────
read -p "Run first-time-setup.sh now? (GPU setup must be done first if applicable) [y/N] " yn
if [[ "$yn" == "y" ]]; then
  cd "$HOMELAB_DIR"
  bash first-time-setup.sh
else
  echo ""
  echo "When ready, run:"
  echo "  cd $HOMELAB_DIR"
  echo "  bash gpu-node-setup.sh   # if NVIDIA GPU present (requires reboot)"
  echo "  bash first-time-setup.sh"
fi
