
PROJECT_NAME            := {{cookiecutter.project_name}}

# https://www.gnu.org/software/make/manual/html_node/Special-Variables.html
# https://ftp.gnu.org/old-gnu/Manuals/make-3.80/html_node/make_17.html
PROJECT_MKFILE_PATH     := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
PROJECT_MKFILE_DIR      := $(shell cd $(shell dirname $(PROJECT_MKFILE_PATH)); pwd)

PROJECT_ROOT            := $(PROJECT_MKFILE_DIR)
LOCAL_UNTRACK_DIR       := $(PROJECT_MKFILE_DIR)/.local
DISTRIBUTIONS           := $(LOCAL_UNTRACK_DIR)/dist-newstyle/sdist


update:
	cabal v2-update
	cabal v2-configure
	cabal v2-freeze

build: $(PROJECT_ROOT)/lib $(PROJECT_ROOT)/$(PROJECT_NAME).cabal
	cabal v2-build

.PHONY: run
run:
	cabal v2-run -- --help

.PHONY: run-example
run-example:
	echo "done"

.PHONY: distribute
distribute:
	cabal v2-sdist

.PHONY: publish
publish: | cleanall distribute
	cabal upload $(DISTRIBUTIONS)/$(PROJECT_NAME)-*.tar.gz

.PHONY: release
release:
	cabal upload $(DISTRIBUTIONS)/$(PROJECT_NAME)-*.tar.gz --publish

.PHONY: cleanall
cleanall:
	rm -r $(DISTRIBUTIONS)
