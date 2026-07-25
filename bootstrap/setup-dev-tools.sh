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

# ─── llm (CLI for language models) ────────────────────────────────────────────
if command -v llm &>/dev/null; then
  echo "llm already installed"
else
  echo "Installing llm..."
  uv tool install llm
  echo "llm installed"
fi
