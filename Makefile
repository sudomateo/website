CONTAINER_IMAGE ?= localhost/sudomateo/website:latest

CONTAINER_ENGINE := $(shell \
	if command -v podman >/dev/null 2>&1; then \
		echo "podman"; \
	elif command -v docker >/dev/null 2>&1; then \
		echo "docker"; \
	else \
		echo "NONE"; \
	fi)

ifeq ($(CONTAINER_ENGINE),NONE)
$(error No container engine found! Please install Podman or Docker)
endif

.PHONY: build
build:
	$(CONTAINER_ENGINE) build \
		--target builder \
		--tag $(CONTAINER_IMAGE) \
		.

.PHONY: dev
dev: build
	$(CONTAINER_ENGINE) run \
		--rm \
		--interactive \
		--tty \
		--volume $(shell pwd):/app:Z \
		--publish 1313:1313 \
		$(CONTAINER_IMAGE) \
		hugo server --buildDrafts --bind 0.0.0.0
