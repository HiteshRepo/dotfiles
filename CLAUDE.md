# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal machine bootstrap and configuration management system. Automates the setup of development environments on new macOS or Linux machines.

## Key Commands

```bash
# Bootstrap a new machine (runs all setup scripts in sequence)
bash bootstrap/bootstrap.sh

# Optional: setup homelab k3s cluster (Ubuntu only, run after bootstrap)
bash bootstrap/setup-homelab.sh

# Verify setup after bootstrap
ssh-add -l                # Check loaded SSH keys
uv --version              # Verify uv package manager
llm --version             # Verify llm CLI
llm models list           # Check configured LLM models
```

## Architecture

### Bootstrap Flow

```
bootstrap/bootstrap.sh (main entry)
├── setup-github-known-hosts.sh  → Add GitHub to ~/.ssh/known_hosts
├── setup-ssh-key.sh             → Generate Ed25519 key, add to ssh-agent
└── setup-dev-tools.sh           → Install uv + llm CLI, symlink llm config

setup-homelab.sh (optional, homelab Ubuntu only)
└── Clone git@github.com:HiteshRepo/k3s-homelab.git → ~/workspace/k3s-homelab
```

### Config Management

`config/llm/extra-openai-models.yaml` is the source of truth for LLM model definitions. During bootstrap, it gets symlinked to `~/.config/io.datasette.llm/extra-openai-models.yaml`.

All models route through the LiteLLM proxy at `https://litellm.lab.hiteshp.in`. The proxy unifies access to OpenAI, Anthropic, and local Ollama models under a single API key (set via `llm keys set openai <master-key>`).

### Script Design Principles

All scripts are **idempotent** — safe to re-run. Each step checks whether it has already been applied before executing (e.g., checking for existing SSH keys, existing symlinks, already-cloned repos).

SSH permissions follow the required convention: `700` for `~/.ssh/`, `600` for key files.
