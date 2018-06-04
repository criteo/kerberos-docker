# GNU Make 4.1

SHELL = /usr/bin/env bash

# environment
PREFIX_KRB5 = $(shell echo $${PREFIX_KRB5:-krb5})
REALM_KRB5 = $(shell echo $${REALM_KRB5:-EXAMPLE.COM})
# only IPv4
NETWORK_CONTAINER = $(shell echo $${NETWORK_CONTAINER:-10.5.0.0})/24
DOMAIN_CONTAINER = $(shell echo $${DOMAIN_CONTAINER:-example.com})
OS_CONTAINER = $(shell echo $${OS_CONTAINER:-ubuntu})
SHARED_FOLDER = $(shell echo $${SHARED_FOLDER:-${{PWD}}})

TEST = ./test
SCRIPT = ./script

# check minimal installation
ifeq ($(shell which docker),)
  $(error docker is not installed, please install it before using project)
endif

ifeq ($(shell which docker-compose),)
  $(error docker-compose is not installed, please install it before using project)
endif

ifeq ($(shell which virtualenv),)
  $(error virtualenv is not installed, please install it before using project)
endif

# check variables coherence
ifeq ($(filter $(OS_CONTAINER), ubuntu centos),)
  $(error variable OS_CONTAINER is bad defined '$(OS_CONTAINER)', do make <option> <target> ... OS_CONTAINER=<os> possible values: ubuntu centos)
endif

.PHONY: usage
usage:
	@echo "targets include: usage gen-conf pre-build build install test stop start status restart clean switch"

# Choose your OS_CONTAINER (by defaut ubuntu with make install):
# make gen-conf OS_CONTAINER=<os>
# OS_CONTAINER=<os> is valid for all targets depending on this target gen-conf
.PHONY: gen-conf
gen-conf:
	@export PREFIX_KRB5=$(PREFIX_KRB5); \
	export REALM_KRB5=$(REALM_KRB5); \
	export OS_CONTAINER=$(OS_CONTAINER); \
	export NETWORK_CONTAINER=$(NETWORK_CONTAINER); \
	export DOMAIN_CONTAINER=$(DOMAIN_CONTAINER); \
	export SHARED_FOLDER=$(SHARED_FOLDER); \
	source $(SCRIPT)/build-python-env.sh; \
	$(SCRIPT)/get-env.sh; \
	$(SCRIPT)/generate_from_template.py; \
	$(SCRIPT)/create-build-folder.sh

.PHONY: pre-build
pre-build: gen-conf
	@$(SCRIPT)/pre-build.sh

.PHONY: build
build: pre-build
	@$(SCRIPT)/create-network.sh
	@$(SCRIPT)/build.sh

.PHONY: create
create: build
	@$(SCRIPT)/create.sh

.PHONY: init
init: start
	@$(SCRIPT)/init.sh

.PHONY: install
install: create init

# Run all tests (only if you know what you do else make test is sufficient):
# sudo make test TEST_ON_HOST_MACHINE=yes
.PHONY: test
test:
	@$(TEST)/run_all_tests.sh

.PHONY: stop
stop:
	@$(SCRIPT)/stop.sh

.PHONY: start
start:
	@$(SCRIPT)/start.sh

.PHONY: status
status:
	@$(SCRIPT)/status.sh

.PHONY: restart
restart: stop start

.PHONY: clean
clean: status stop
	@$(SCRIPT)/clean.sh

.PHONY: switch
switch:
	@$(SCRIPT)/switch-project.sh $(PROJECT)
