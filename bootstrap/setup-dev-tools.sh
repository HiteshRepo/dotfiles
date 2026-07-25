#!/usr/bin/env bash
set -euo pipefail

# ─── uv (Python package manager) ──────────────────────────────────────────────
if command -v uv &>/dev/null; then
  echo "uv already installed"
else
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  echo "uv installed"
fi
