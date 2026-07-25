#!/usr/bin/env bash
set -euo pipefail

# ─── Install git ──────────────────────────────────────────────────────────────
if command -v git &>/dev/null; then
  echo "git already installed"
else
  echo "Installing git..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    xcode-select --install 2>/dev/null || true
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update && sudo apt install -y git
  fi
  echo "git installed"
fi

# ─── Global config ────────────────────────────────────────────────────────────
git config --global user.name "hiteshrepo"
git config --global user.email "pattanayak.hitesh03@gmail.com"
echo "git global config set (user.name=hiteshrepo, user.email=pattanayak.hitesh03@gmail.com)"
