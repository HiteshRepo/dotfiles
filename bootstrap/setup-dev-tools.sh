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

# ─── aider (AI pair programmer) ───────────────────────────────────────────────
if command -v aider &>/dev/null; then
  echo "aider already installed"
else
  echo "Installing aider..."
  uv tool install --force --python python3.12 --with pip aider-chat@latest
  echo "aider installed"
fi

AIDER_CONFIG_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/config/aider/.aider.conf.yml"
AIDER_CONFIG_FILE="$HOME/.aider.conf.yml"

if [ -L "$AIDER_CONFIG_FILE" ]; then
  echo "aider .aider.conf.yml already symlinked"
elif [ -f "$AIDER_CONFIG_FILE" ]; then
  echo "aider .aider.conf.yml already exists (not a symlink — skipping)"
else
  ln -s "$AIDER_CONFIG_SOURCE" "$AIDER_CONFIG_FILE"
  echo "aider .aider.conf.yml symlinked"
fi

# ─── Shell env vars ───────────────────────────────────────────────────────────
SHELL_PROFILE=""
if [ -f "$HOME/.zshrc" ]; then SHELL_PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then SHELL_PROFILE="$HOME/.bashrc"
fi

if [ -n "$SHELL_PROFILE" ]; then
  if ! grep -q "REQUESTS_CA_BUNDLE" "$SHELL_PROFILE"; then
    echo 'export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt' >> "$SHELL_PROFILE"
    echo 'export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt' >> "$SHELL_PROFILE"
    echo "Python SSL env vars added to $SHELL_PROFILE"
  else
    echo "REQUESTS_CA_BUNDLE already in $SHELL_PROFILE"
  fi
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
