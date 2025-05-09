-include .env

BWS_PROJECT_ID ?= 
INVENTORY ?= inventory/all.yaml
PLAYBOOK ?= install.yaml

.PHONY: env-is-set
env-is-set:
	@[ -z $($(ENV)) ] && echo "$(ENV) is not set" && exit 1 || true

.PHONY: _run
_run:
	ANSIBLE_FORCE_COLOR=true \
		ansible-playbook -vvv -i $(INVENTORY) \
		$(if $(value $(TAGS)),, -t $(TAGS)) \
		$(FLAGS)\
		$(PLAYBOOK)

.PHONY: test
test:
	bws run --project-id $(BWS_PROJECT_ID) --no-inherit-env -- \
		$(MAKE) _run PLAYBOOK=test.yaml

# unifi target requires the following environment variables to be set:
# - BWS_ACCESS_TOKEN: Bitwarden access token
# - BWS_SERVER_URL: Bitwarden server URL (e.g. https://vault.bitwarden.com)
.PHONY: unifi
unifi:
	@$(MAKE) env-is-set ENV=BWS_ACCESS_TOKEN
	@$(MAKE) env-is-set ENV=BWS_SERVER_URL
	@$(MAKE) env-is-set ENV=BWS_PROJECT_ID
	bws run --project-id $(BWS_PROJECT_ID) --no-inherit-env -- \
		$(MAKE) _run \
		TAGS="docker,unifi-docker-compose" \
		PLAYBOOK=install.yaml

.PHONY: paperless
paperless:
	$(MAKE) _run \
		TAGS="docker,paperless-docker-compose" \
		PLAYBOOK=paperless.yaml

.PHONY: backrest
backrest:
	@$(MAKE) env-is-set ENV=BWS_ACCESS_TOKEN
	@$(MAKE) env-is-set ENV=BWS_SERVER_URL
	@$(MAKE) env-is-set ENV=BWS_PROJECT_ID
	bws run --project-id $(BWS_PROJECT_ID) --no-inherit-env -- \
		$(MAKE) _run \
		TAGS="docker,backrest-docker-compose" \
		PLAYBOOK=backrest.yaml

.PHONY: run
run:
	$(MAKE) _run

.PHONY: vpn
vpn:
	$(MAKE) _run TAGS_FLAGS="-t vpn"

.PHONY: run.with.reboot
run.with.reboot:
	$(MAKE) _run FLAGS='--extra-vars "reboot=true"'

.PHONY: ping
ping:
	ansible -vv -i $(INVENTORY) all -m ping
