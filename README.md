# dotfiles

Personal machine bootstrap and configuration management system. Automates the setup of a new macOS or Linux development environment.

## Quick Start

```bash
git clone git@github.com:HiteshRepo/dotfiles.git
cd dotfiles/bootstrap
bash bootstrap.sh
```

## What Gets Set Up

| Step | Script | What it does |
|------|--------|--------------|
| 1 | `setup-github-known-hosts.sh` | Adds GitHub's SSH host key to `~/.ssh/known_hosts` |
| 2 | `setup-ssh-key.sh` | Generates an Ed25519 SSH key and adds it to the agent |
| 3 | `setup-dev-tools.sh` | Installs `uv` and `llm`, symlinks LLM model config |

All scripts are idempotent — safe to re-run on an existing machine.

## Optional: Homelab Setup

For the Ubuntu homelab laptop only, run after `bootstrap.sh`:

```bash
bash bootstrap/setup-homelab.sh
```

This clones `git@github.com:HiteshRepo/k3s-homelab.git` into `~/workspace/k3s-homelab` and optionally runs its first-time setup.

## LLM Configuration

The `llm` CLI is configured to route all model requests through a LiteLLM proxy at `https://litellm.lab.hiteshp.in`. The config is sourced from `config/llm/extra-openai-models.yaml` and symlinked to `~/.config/io.datasette.llm/extra-openai-models.yaml`.

After bootstrap, set the LiteLLM master key:

```bash
llm keys set openai <master-key>
```

Available models:

| Provider | Model |
|----------|-------|
| OpenAI | `gpt-4o`, `gpt-4o-mini` |
| Anthropic | `claude-opus-4-5`, `claude-sonnet-4-5` |
| Ollama (local) | `ollama/llama3.2:3b`, `ollama/qwen2.5:3b`, `ollama/phi3.5` |

```bash
llm models list              # verify available models
llm -m gpt-4o "Hello"        # test a model
```
