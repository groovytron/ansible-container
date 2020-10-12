BUILD_NAME=deployer
COMPOSE_BUILD_NAME=deployer-container
VERSIONS=0.0.1
LATEST=$(firstword $(VERSIONS))
ALL=$(addprefix deployer,$(VERSIONS))
VCS_REF="$(shell git rev-parse HEAD)"
BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%m:%SZ")"
DOCKERHUB_USER=groovytron

.PHONY: all
all: $(ALL)

.PHONY: $(ALL)
$(ALL):
	BUILD_DATE=$(BUILD_DATE) \
	BUILD_NAME=$(BUILD_NAME) \
	COMPOSE_BUILD_NAME=$(COMPOSE_BUILD_NAME) \
	VCS_REF=$(VCS_REF) \
	docker-compose -f build.yaml build \
		$@

.PHONY:clean
clean:
	for VERSION in $(VERSIONS); do \
		docker image rm -f $(COMPOSE_BUILD_NAME):$$VERSION; \
	done

.PHONY:publish-docker-images
publish-docker-images:
	for VERSION in $(VERSIONS); do \
		docker tag $(COMPOSE_BUILD_NAME):$$VERSION $(DOCKERHUB_USER)/$(BUILD_NAME):$$VERSION && \
		docker push $(DOCKERHUB_USER)/$(BUILD_NAME):$$VERSION; \
	done && \
	docker tag $(COMPOSE_BUILD_NAME):$(LATEST) $(DOCKERHUB_USER)/$(BUILD_NAME):latest && \
	docker push $(DOCKERHUB_USER)/$(BUILD_NAME):latest
