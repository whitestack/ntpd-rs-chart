default: docker_build
include .env

DOCKER_IMAGE ?= ghcr.io/whitestack/ntpd-rs
DOCKER_TAG ?= $(shell git describe --always --abbrev=0)

docker_build:
	docker buildx build \
		--build-arg NTPD_RS_VERSION=$(NTPD_RS_VERSION) \
		-t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
