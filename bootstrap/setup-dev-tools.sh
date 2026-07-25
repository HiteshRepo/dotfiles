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

LLM_CONFIG_DIR="$HOME/.config/io.datasette.llm"
LLM_MODELS_FILE="$LLM_CONFIG_DIR/extra-openai-models.yaml"
LLM_MODELS_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/config/llm/extra-openai-models.yaml"

mkdir -p "$LLM_CONFIG_DIR"
if [ -L "$LLM_MODELS_FILE" ]; then
  echo "llm extra-openai-models.yaml already symlinked"
elif [ -f "$LLM_MODELS_FILE" ]; then
  echo "llm extra-openai-models.yaml already exists (not a symlink — skipping)"
else
  ln -s "$LLM_MODELS_SOURCE" "$LLM_MODELS_FILE"
  echo "llm extra-openai-models.yaml symlinked"
fi
