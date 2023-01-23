INVENTORY ?= inventory/all.yaml

.PHONY: _run
_run:
	ansible-playbook -vv -i $(INVENTORY) $(FLAGS) install.yaml

.PHONY: test
test:
	ansible-playbook -vv -i $(INVENTORY) test.yaml

.PHONY: run
run:
	$(MAKE) _run

.PHONY: run.with.reboot
run.with.reboot:
	$(MAKE) _run FLAGS='--extra-vars "reboot=true"'

.PHONY: ping
ping:
	ansible -vv -i $(INVENTORY) all -m ping
