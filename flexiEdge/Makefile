DIST_DIR ?= $(CURDIR)/dist
CHART_DIR ?= $(CURDIR)/Chart
TMPDIR ?= /tmp
HELM_REPO_TYPE ?= main
HELM_REPO ?= /mnt/charts/flexiwan/$(HELM_REPO_TYPE)
LINT_USE_DOCKER ?= true
LINT_CMD ?= ct lint --config=../Lint/ct.yaml
PROJECT ?= gitlab.com/flexiwangroup/flexiwancharts/
################################## Functionnal targets

# Default Target: run all
all: clean test build deploy

test: lint unit-test

# Execute Static Testing
lint: lint-requirements
	@echo "== Linting Chart..."
	@git remote add flexiedge https://gitlab.com/flexiwangroup/flexiwancharts.git >/dev/null 2>&1 || true
	@git fetch --verbose flexiedge master >/dev/null 2>&1 || true
ifeq ($(LINT_USE_DOCKER),true)
	@docker run --rm -t -v $(CURDIR)/../:/charts -w /charts/flexiEdge/Chart quay.io/helmpack/chart-testing:v3.5.0 $(LINT_CMD)
else
	cd $(CHART_DIR)/tests && $(LINT_CMD)
endif
	@echo "== Linting Finished"

# Execute Unit Testing
unit-test: helm-unittest
	@echo "== Unit Testing Chart..."
	# helm plugin install https://github.com/vbehar/helm3-unittest
	@helm unittest --color --update-snapshot ./Chart
	@echo "== Unit Tests Finished..."


# Generates an artifact containing the Helm Chart in the distribution directory
build: global-requirements $(DIST_DIR)
	@echo "== Building Chart..."
	@helm package $(CHART_DIR) --destination=$(DIST_DIR)
	@echo "== Building Finished"

# Prepare the Helm repository with the latest packaged charts
deploy: global-requirements $(DIST_DIR) $(HELM_REPO)

ifeq ($(HELM_REPO_TYPE),main)
	@echo "== Deploying main Chart..."
endif

ifeq ($(HELM_REPO_TYPE),testing)
	@echo "== Deploying testing Chart..."
	@sed -i 's/appVersion: latest/appVersion: testing/g' Chart/Chart.yaml
endif

ifeq ($(HELM_REPO_TYPE),unstable)
	@echo "== Deploying unstable Chart..."
	@sed -i 's/appVersion: latest/appVersion: unstable/g' Chart/Chart.yaml
endif


	@cp $(DIST_DIR)/*tgz $(CHART_DIR)/artifacthub-repo.yml $(HELM_REPO)/
	@cp $(CHART_DIR)/README.md $(HELM_REPO)/index.md
	@helm repo index --merge $(HELM_REPO)/index.yaml --url https://helm.flexiwan.com/$(HELM_REPO_TYPE) $(HELM_REPO)
	@echo "== Deploying Finished"

# Cleanup leftovers and distribution dir
clean:
	@echo "== Cleaning..."
	@rm -rf $(DIST_DIR)
	#@rm -rf $(HELM_REPO)
	@echo "== Cleaning Finished"

################################## Technical targets

$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

## This directory is git-ignored for now,
## and should become a worktree on the branch gh-pages in the future
$(HELM_REPO):
	@mkdir -p $(HELM_REPO)

global-requirements:
	@echo "== Checking global requirements..."
ifeq ($(LINT_USE_DOCKER),true)
	@command -v docker >/dev/null || ( echo "ERROR: Docker binary not found. Exiting." && exit 1)
	@docker info >/dev/null || ( echo "ERROR: command "docker info" is in error. Exiting." && exit 1)
else
	@command -v helm >/dev/null || ( echo "ERROR: Helm binary not found. Exiting." && exit 1)
	@command -v git >/dev/null || ( echo "ERROR: git binary not found. Exiting." && exit 1)
	@echo "== Global requirements are met."
endif

lint-requirements: global-requirements
	@echo "== Checking requirements for linting..."
ifeq ($(LINT_USE_DOCKER),true)
	@command -v docker >/dev/null || ( echo "ERROR: Docker binary not found. Exiting." && exit 1)
	@docker info >/dev/null || ( echo "ERROR: command "docker info" is in error. Exiting." && exit 1)
else
	@command -v ct >/dev/null || ( echo "ERROR: ct binary not found. Exiting." && exit 1)
	@command -v yamale >/dev/null || ( echo "ERROR: yamale binary not found. Exiting." && exit 1)
	@command -v yamllint >/dev/null || ( echo "ERROR: yamllint binary not found. Exiting." && exit 1)
	@command -v kubectl >/dev/null || ( echo "ERROR: kubectl binary not found. Exiting." && exit 1)
endif
	@echo "== Requirements for linting are met."

helm-unittest: global-requirements
	@echo "== Checking that plugin helm-unittest is available..."
	@helm plugin list 2>/dev/null | grep unittest >/dev/null || helm plugin install https://github.com/vbehar/helm3-unittest --debug
	@echo "== plugin helm-unittest is ready"

.PHONY: all global-requirements lint-requirements helm-unittest lint build deploy clean
