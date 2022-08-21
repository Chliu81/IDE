# To tag docker images
GIT_TAG ?= $(shell git log -1 --pretty=%h)
export GIT_TAG

# Theia IDES
THEIA_BASE_IDE := \
	theia-base-38 theia-base-39 theia-base-310 \
	theia-base-38-bare theia-base-39-bare theia-base-310-bare \
	webtop-base-ubuntu

THEIA_IDES := \
	theia-xv6 theia-admin theia-devops theia-jepst theia-golang \
	theia-flask-39 theia-flask-310 \
	theia-mysql-39 theia-mysql-310

help:
	@echo 'For convenience'
	@echo
	@echo 'Available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

.PHONY: build-base-ides # Build base ide images
build-base-ides:
	@echo 'building base images'
	docker-compose build --parallel --pull $(THEIA_BASE_IDE)

.PHONY: build-ides      # Build all ide docker images
build-ides:
	@echo 'building ide image'
	docker-compose build --parallel $(THEIA_IDES)

.PHONY: push-base-ides  # Push base ide images to registry.digitalocean.com
push-base-ides:
	docker-compose push $(THEIA_BASE_IDE)

.PHONY: push-ides       # Push ide images to registry.digitalocean.com
push-ides:
	docker-compose push $(THEIA_IDES)

.PHONY: prop-ides       # Create theia-prop daemonset to propagate latest ide images
prop-ides:
	kubectl rollout restart ds anubis-theia-prop -n anubis
