# GNU Make 4.1

SHELL = /usr/bin/env bash

TEST = "./test"
SCRIPT = "./script"

.PHONY: usage
usage:
	@echo "targets include: usage pre-build install test stop start clean"

.PHONY: pre-build
pre-build:
	@$(SCRIPT)/pre-build.sh

.PHONY: install
install: pre-build
	@$(SCRIPT)/create-network.sh
	@$(SCRIPT)/build.sh
	@$(SCRIPT)/create.sh
	@$(SCRIPT)/start.sh
	@$(SCRIPT)/init.sh

.PHONY: test
test:
	@cd $(TEST); ./test.bats

.PHONY: stop
stop:
	@$(SCRIPT)/stop.sh

.PHONY: start
start:
	@$(SCRIPT)/start.sh

.PHONY: clean
clean: stop
	@$(SCRIPT)/clean.sh
