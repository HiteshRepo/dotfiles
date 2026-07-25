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

# ─── Symlinks ─────────────────────────────────────────────────────────────────

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
