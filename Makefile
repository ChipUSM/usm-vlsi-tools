
all: print

TIMESTAMP_DAY=$(shell date +%Y_%m_%d)
TIMESTAMP_TIME=$(shell date +%H_%M_%S)
USER_ID=$(shell id -u)
USER_GROUP=$(shell id -g)
PDK=sky130A

ifneq (,$(DOCKER_ROOT))
_DOCKER_ROOT_USER=--user root
endif

DOCKER_RUN=docker run -it --rm $(_DOCKER_ROOT_USER) \
	--mount type=bind,source=$(realpath ./shared),target=/home/designer/shared \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v /home/$(USER)/.Xauthority:/root/.Xauthority:rw \
	-v /home/$(USER)/.Xauthority:/home/designer/.Xauthority:rw \
	--net=host \
	-e DISPLAY \
	-e XDG_RUNTIME_DIR \
	-e PULSE_SERVER \
	-e USER_ID=$(USER_ID) \
	-e USER_GROUP=$(USER_GROUP)


DOCKER_IMAGE_TAG=akilesalreadytaken/usm-vlsi-tools:latest


$(shell mkdir -p shared)


########################
# Docker Image Commands
########################


print:
	@echo _DOCKER_ROOT_USER ....... $(_DOCKER_ROOT_USER)
	@echo DOCKER_RUN ........ $(DOCKER_RUN)
	@echo DOCKER_IMAGE_TAG ........ $(DOCKER_IMAGE_TAG)


build:
ifeq (,$(DOCKER_STAGE))
	docker build . -t $(DOCKER_IMAGE_TAG)
else
	docker build --target $(DOCKER_STAGE) . -t $(DOCKER_IMAGE_TAG)
endif


start:
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) bash


start-raw: build
	docker run -it --rm $(_DOCKER_ROOT_USER) $(DOCKER_IMAGE_TAG) bash


start-latest: build start


start-notebook:
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) "jupyter-lab --no-browser --notebook-dir=./shared"