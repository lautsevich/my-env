.PHONY: provision check dry-run galaxy-install vault-edit vault-encrypt

TAGS ?= all

# Vault password: read from .vault-pass in the project root if it exists, otherwise prompt for it.
VAULT_PASS_FILE ?= $(CURDIR)/.vault-pass
VAULT_OPT := $(if $(wildcard $(VAULT_PASS_FILE)),--vault-password-file $(VAULT_PASS_FILE),--ask-vault-pass)
SECRETS := playbooks/vars/secrets.yml
# Every file that must be committed only in encrypted form.
VAULT_FILES := $(SECRETS) playbooks/files/monitors.xml

provision: galaxy-install
	@echo "Ansible provision…"
	ansible-playbook playbooks/install.yml --ask-become-pass $(VAULT_OPT) --tags $(TAGS)

check: galaxy-install
	@echo "Ansible dry run…"
	ansible-playbook playbooks/install.yml --ask-become-pass $(VAULT_OPT) --tags $(TAGS) --check --diff

dry-run:
	bash ./install.sh --dry-run

galaxy-install:
	@echo "Install Ansible roles…"
	ansible-galaxy install -r requirements.yml

vault-edit:
	ansible-vault edit $(VAULT_OPT) $(SECRETS)

# Encrypt every vault file that is currently in plain text; already encrypted ones are skipped.
vault-encrypt:
	@for f in $(VAULT_FILES); do \
	  if head -1 "$$f" | grep -q '^\$$ANSIBLE_VAULT'; then \
	    echo "already encrypted: $$f"; \
	  else \
	    ansible-vault encrypt $(VAULT_OPT) "$$f" || exit 1; \
	  fi; \
	done
