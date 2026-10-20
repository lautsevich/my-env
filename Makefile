.PHONY: provision check galaxy-install

TAGS ?= all

provision: galaxy-install
	@echo "Ansible provision…"
	ansible-playbook playbooks/install.yml --ask-become-pass --tags $(TAGS)

check: galaxy-install
	@echo "Ansible dry run…"
	ansible-playbook playbooks/install.yml --ask-become-pass --tags $(TAGS) --check --diff

galaxy-install:
	@echo "Install Ansible roles…"
	ansible-galaxy install -r requirements.yml
