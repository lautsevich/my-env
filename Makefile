provision:
	@echo "Ansible provision…"
	make galaxy-install

	ansible-playbook playbooks/install.yml --ask-become-pass

galaxy-install:
	@echo "Install Ansible roles…"
	ansible-galaxy install -r requirements.yml