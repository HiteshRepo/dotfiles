DOTFILES_DIR := $(shell pwd)

# ─── Bootstrap ────────────────────────────────────────────────────────────────

.PHONY: bootstrap
bootstrap: ## Run full bootstrap (SSH keys, GitHub known hosts, dev tools)
	bash bootstrap/bootstrap.sh

.PHONY: dev-tools
dev-tools: ## Install dev tools (uv, llm) and symlink configs
	bash bootstrap/setup-dev-tools.sh

.PHONY: homelab
homelab: ## Clone and set up k3s-homelab (Ubuntu homelab laptop only)
	bash bootstrap/setup-homelab.sh

# ─── AI Tools ────────────────────────────────────────────────────────────────

.PHONY: install-aider
install-aider: ## Install aider via uv
	uv tool install --force --python python3.12 --with pip aider-chat@latest

KEY ?= ""

.PHONY: set-ai-key
set-ai-key: ## Set LiteLLM master key for llm and aider (usage: make set-ai-key KEY=<master-key>)
	@if [ -z "$(KEY)" ]; then \
	  echo "Error: pass the key — make set-ai-key KEY=<master-key>"; exit 1; \
	fi
	@python3 -c "\
import json, os; \
f = os.path.expanduser('~/.config/io.datasette.llm/keys.json'); \
keys = json.load(open(f)) if os.path.exists(f) else {}; \
keys['openai'] = '$(KEY)'; \
json.dump(keys, open(f, 'w'), indent=2)"
	@echo "llm key set"
	@SHELL_PROFILE=""; \
	if [ -f "$$HOME/.zshrc" ]; then SHELL_PROFILE="$$HOME/.zshrc"; \
	elif [ -f "$$HOME/.bashrc" ]; then SHELL_PROFILE="$$HOME/.bashrc"; \
	fi; \
	if [ -n "$$SHELL_PROFILE" ]; then \
	  if grep -q "^export OPENAI_API_KEY=" "$$SHELL_PROFILE"; then \
	    sed -i "s|^export OPENAI_API_KEY=.*|export OPENAI_API_KEY=$(KEY)|" "$$SHELL_PROFILE"; \
	    echo "OPENAI_API_KEY updated in $$SHELL_PROFILE"; \
	  else \
	    echo "export OPENAI_API_KEY=$(KEY)" >> "$$SHELL_PROFILE"; \
	    echo "OPENAI_API_KEY added to $$SHELL_PROFILE"; \
	  fi; \
	fi
	@echo "Run: source $$HOME/.zshrc (or .bashrc) to apply in current shell"

# ─── Symlinks ─────────────────────────────────────────────────────────────────

.PHONY: symlink-aider
symlink-aider: ## Symlink .aider.conf.yml to ~/
	@if [ -L ~/.aider.conf.yml ]; then \
	  echo "already symlinked"; \
	elif [ -f ~/.aider.conf.yml ]; then \
	  echo "file already exists (not a symlink — skipping)"; \
	else \
	  ln -s $(DOTFILES_DIR)/config/aider/.aider.conf.yml ~/.aider.conf.yml; \
	  echo "symlinked"; \
	fi

.PHONY: symlink-llm
symlink-llm: ## Symlink llm extra-openai-models.yaml to ~/.config/io.datasette.llm/
	@mkdir -p ~/.config/io.datasette.llm
	@if [ -L ~/.config/io.datasette.llm/extra-openai-models.yaml ]; then \
	  echo "already symlinked"; \
	elif [ -f ~/.config/io.datasette.llm/extra-openai-models.yaml ]; then \
	  echo "file already exists (not a symlink — skipping)"; \
	else \
	  ln -s $(DOTFILES_DIR)/config/llm/extra-openai-models.yaml ~/.config/io.datasette.llm/extra-openai-models.yaml; \
	  echo "symlinked"; \
	fi

# ─── Help ─────────────────────────────────────────────────────────────────────

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*##"}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
