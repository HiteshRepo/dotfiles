#!/usr/bin/env bash
set -euo pipefail

if [ ! -f ~/.ssh/id_ed25519 ]; then
  read -p "No SSH key found. Generate one now? [y/N] " yn
  if [[ "$yn" == "y" ]]; then
    email="$(git config --global user.email || true)"
    if [ -z "$email" ]; then
      read -p "No git email configured. Enter email for the SSH key comment: " email
    fi
    ssh-keygen -t ed25519 -C "$email"
  fi
fi

if [ -z "${SSH_AUTH_SOCK:-}" ]; then
  eval "$(ssh-agent -s)" >/dev/null
fi

ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
ssh-add -l
