.PHONY: build

# Default values for variables
REPO  ?= camerondurham/x11vnc-docker
TAG   ?= latest
CONTAINER_NAME = x11vnc-test

build:
	docker build -t $(REPO):$(TAG) .


run:
	docker run --rm -d \
		-p 5920:5900 \
		-p 8080:8080 \
		-v /dev/shm:/dev/shm \
		--name $(CONTAINER_NAME) \
		$(REPO):$(TAG)

shell:
	docker exec -it \
		$(CONTAINER_NAME) \
		/bin/bash

stop:
	docker stop $(CONTAINER_NAME)
