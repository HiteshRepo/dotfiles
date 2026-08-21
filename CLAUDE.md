# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal machine bootstrap and configuration management system. Automates the setup of development environments on new macOS or Linux machines.

## Key Commands

```bash
# Bootstrap a new machine (runs all setup scripts in sequence)
make bootstrap          # or: bash bootstrap/bootstrap.sh

# Individual steps (all idempotent)
make dev-tools          # Install ffmpeg, uv, llm, aider; symlink configs
make homelab            # Clone k3s-homelab (Ubuntu homelab only)

# AI tool setup
make install-aider      # Install aider via uv (python3.12)
make set-ai-key KEY=<master-key>  # Set LiteLLM key in keys.json + shell profile

# Symlink management (run manually if bootstrap was skipped)
make symlink-aider      # ~/.aider.conf.yml → config/aider/.aider.conf.yml
make symlink-llm        # ~/.config/io.datasette.llm/extra-openai-models.yaml → config/llm/

# Verify setup after bootstrap
ssh-add -l              # Check loaded SSH keys
uv --version            # Verify uv package manager
llm --version           # Verify llm CLI
llm models list         # Check configured LLM models
```

## Architecture

### Bootstrap Flow

```
bootstrap/bootstrap.sh (main entry)
├── setup-git.sh                 → Install git, set global user.name/email
├── setup-github-known-hosts.sh  → Add GitHub to ~/.ssh/known_hosts
├── setup-ssh-key.sh             → Generate Ed25519 key, add to ssh-agent
└── setup-dev-tools.sh           → Install ffmpeg + uv + llm + aider; symlink configs

setup-homelab.sh (optional, homelab Ubuntu only)
└── Clone git@github.com:HiteshRepo/k3s-homelab.git → ~/workspace/k3s-homelab
```

### Config Management

Two configs are managed as symlinks from this repo:

| Source (repo) | Symlink destination | Tool |
|---|---|---|
| `config/llm/extra-openai-models.yaml` | `~/.config/io.datasette.llm/extra-openai-models.yaml` | `llm` CLI |
| `config/aider/.aider.conf.yml` | `~/.aider.conf.yml` | `aider` |

`llm` routes directly to the LiteLLM proxy at `https://litellm.lab.hiteshp.in`. Both tools use the same LiteLLM master key — stored in `~/.config/io.datasette.llm/keys.json` under key `openai`, and as `OPENAI_API_KEY` in the shell profile.

**aider is different**: its config points to `http://localhost:4000/v1`, so it requires a live port-forward to the LiteLLM service before use:

```bash
kubectl port-forward svc/litellm 4000:4000 -n <namespace>
```

### SSL Environment Variables

`setup-dev-tools.sh` appends these to `~/.zshrc` / `~/.bashrc` (needed for Python HTTP clients to trust the homelab's self-signed TLS cert):

```bash
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
```

### Script Design Principles

All scripts are **idempotent** — safe to re-run. Each step checks whether it has already been applied before executing (e.g., checking for existing SSH keys, existing symlinks, already-cloned repos).

SSH permissions follow the required convention: `700` for `~/.ssh/`, `600` for key files.
