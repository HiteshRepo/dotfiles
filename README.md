# dotfiles

Personal machine bootstrap and configuration management system. Automates the setup of a new macOS or Linux development environment.

## Quick Start

```bash
git clone git@github.com:HiteshRepo/dotfiles.git
cd dotfiles
make bootstrap
```

## What Gets Set Up

| Step | Script | What it does |
|------|--------|--------------|
| 1 | `setup-git.sh` | Installs git, sets global `user.name` / `user.email` |
| 2 | `setup-github-known-hosts.sh` | Adds GitHub's SSH host key to `~/.ssh/known_hosts` |
| 3 | `setup-ssh-key.sh` | Generates an Ed25519 SSH key and adds it to the agent |
| 4 | `setup-dev-tools.sh` | Installs `uv`, `llm`, and `aider`; symlinks their configs |

All scripts are idempotent — safe to re-run on an existing machine.

## Optional: Homelab Setup

For the Ubuntu homelab laptop only, run after `bootstrap`:

```bash
make homelab
```

This clones `git@github.com:HiteshRepo/k3s-homelab.git` into `~/workspace/k3s-homelab`.

## LLM & AI Tool Configuration

`llm` and `aider` both route through a LiteLLM proxy at `https://litellm.lab.hiteshp.in`.

After bootstrap, set the LiteLLM master key once:

```bash
make set-ai-key KEY=<master-key>
```

This writes the key to `~/.config/io.datasette.llm/keys.json` and exports `OPENAI_API_KEY` in your shell profile.

### Config symlinks

| Repo source | Symlink destination |
|---|---|
| `config/llm/extra-openai-models.yaml` | `~/.config/io.datasette.llm/extra-openai-models.yaml` |
| `config/aider/.aider.conf.yml` | `~/.aider.conf.yml` |

### Available models

| Provider | Model |
|----------|-------|
| OpenAI | `gpt-4o`, `gpt-4o-mini` |
| Anthropic | `claude-opus-4-5`, `claude-sonnet-4-5` |
| Ollama (local) | `ollama/llama3.2:3b`, `ollama/qwen2.5:3b`, `ollama/phi3.5` |

```bash
llm models list              # verify available models
llm -m gpt-4o "Hello"        # test a model
```

## Make Targets

```
make bootstrap      Run full bootstrap
make dev-tools      Install uv, llm, aider and symlink configs
make homelab        Clone k3s-homelab (Ubuntu homelab only)
make install-aider  Install aider via uv (python3.12)
make set-ai-key     Set LiteLLM key (usage: make set-ai-key KEY=<key>)
make symlink-aider  Symlink .aider.conf.yml to ~/
make symlink-llm    Symlink extra-openai-models.yaml to ~/.config/io.datasette.llm/
make help           Show all targets
```
