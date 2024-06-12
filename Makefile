
all:
	@echo Nothing selected

TIMESTAMP_DAY=$(shell date +%Y_%m_%d)
TIMESTAMP_TIME=$(shell date +%H_%M_%S)

NPROC=$(shell nproc)

ifneq (,$(DOCKER_ROOT))
DOCKER_ROOT_USER=--user root
endif

ifeq (Windows_NT,$(OS))
DOCKER_SOCKET=//var/run/docker.sock
else
DOCKER_SOCKET=/var/run/docker.sock
endif

DOCKER_RUN_AGENT=docker run -it --rm --mount type=bind,source=$(realpath ./test),target=/home/go/test $(DOCKER_ROOT_USER)
DOCKER_RUN_DIND=$(DOCKER_RUN_AGENT) --privileged -v $(DOCKER_SOCKET):/var/run/docker.sock
DOCKER_IMAGE_AGENT=akilesalreadytaken/gocd-agent-ngspice:latest
DOCKER_IMAGE_DIND=akilesalreadytaken/gocd-agent-dind:latest


########################
# Docker Image Commands
########################


build-agent:
ifeq (,$(DOCKER_TARGET))
	docker build . -t $(DOCKER_IMAGE_AGENT)
else
	docker build --target $(DOCKER_TARGET) . -t $(DOCKER_IMAGE_AGENT)
endif


build-agent-gocd:
	docker build -f Dockerfile . -t $(TIMESTAMP_DAY)_$(TIMESTAMP_TIME) -t latest


start-agent:
	$(DOCKER_RUN_AGENT) $(DOCKER_IMAGE_AGENT) bash -c "cd /home/go/; bash"


start-agent-root:
	$(DOCKER_RUN_AGENT) --user root $(DOCKER_IMAGE_AGENT) bash


start-updated-agent: build-agent start-agent


test-agent:
	$(DOCKER_RUN_AGENT) $(DOCKER_IMAGE_AGENT) bash -c "cd $$HOME/test && make test"


########################
# Docker in Docker Agent
########################


build-dind:
ifeq (,$(DOCKER_TARGET))
	docker build -f Dockerfile.dind . -t $(DOCKER_IMAGE_DIND)
else
	docker build -f Dockerfile.dind --target $(DOCKER_TARGET) . -t $(DOCKER_IMAGE_DIND)
endif


start-dind:
	$(DOCKER_RUN_DIND) $(DOCKER_IMAGE_DIND) bash


start-dind-root:
	$(DOCKER_RUN_DIND) --user root $(DOCKER_IMAGE_DIND) bash
