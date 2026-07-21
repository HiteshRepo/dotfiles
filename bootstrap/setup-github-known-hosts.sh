#!/usr/bin/env bash
# setup-github-ssh.sh
set -euo pipefail

mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/known_hosts
chmod 600 ~/.ssh/known_hosts

if ! ssh-keygen -F github.com >/dev/null; then
  echo "Adding GitHub's host key..."
  ssh-keyscan github.com >> ~/.ssh/known_hosts
else
  echo "GitHub host key already present."
fi

echo "Verify this fingerprint matches https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints:"
ssh-keygen -lf ~/.ssh/known_hosts -F github.com
