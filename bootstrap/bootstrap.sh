#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/setup-git.sh"
"$SCRIPT_DIR/setup-github-known-hosts.sh"
"$SCRIPT_DIR/setup-ssh-key.sh"
"$SCRIPT_DIR/setup-my-scripts.sh"
"$SCRIPT_DIR/setup-dev-tools.sh"
