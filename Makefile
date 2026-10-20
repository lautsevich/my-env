.PHONY: provision check dry-run galaxy-install

TAGS ?= all

provision: galaxy-install
	@echo "Ansible provision…"
	ansible-playbook playbooks/install.yml --ask-become-pass --tags $(TAGS)

check: galaxy-install
	@echo "Ansible dry run…"
	ansible-playbook playbooks/install.yml --ask-become-pass --tags $(TAGS) --check --diff

dry-run:
	bash ./install.sh --dry-run

galaxy-install:
	@echo "Install Ansible roles…"
	ansible-galaxy install -r requirements.yml
