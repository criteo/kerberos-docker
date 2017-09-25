# GNU Make 4.1

SHELL = /usr/bin/env bash

TEST = "./test"
SCRIPT = "./script"
OS_CONTAINER = $(shell echo $${OS_CONTAINER:-ubuntu})
USER = $(shell echo $${USER})

# check minimal installation
ifeq ($(shell which docker),)
  $(error docker is not installed, please install it before using project)
endif

ifeq ($(shell which docker-compose),)
  $(error docker-compose is not installed, please install it before using project)
endif

# check variables coherence
ifeq ($(filter $(OS_CONTAINER), ubuntu centos),)
  $(error variable OS_CONTAINER is bad defined '$(OS_CONTAINER)', do make <option> <target> ... OS_CONTAINER=<user> possible values: ubuntu centos)
endif

.PHONY: usage
usage:
	@echo "targets include: usage gen-conf pre-build build install test stop start status restart clean"

# Choose your OS_CONTAINER (by defaut ubuntu with make install):
# make gen-conf OS_CONTAINER=<os>
# OS_CONTAINER=<os> is valid for all targets depending on this target gen-conf
.PHONY: gen-conf
gen-conf:
	@export OS_CONTAINER=$(OS_CONTAINER); \
	source $(SCRIPT)/build-python-env.sh; \
	$(SCRIPT)/get-env.sh; \
	$(SCRIPT)/generate_docker_compose.py

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
clean: stop
	@$(SCRIPT)/clean.sh
