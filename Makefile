all: print

PDK=sky130A
DOCKER_IMAGE_TAG=akilesalreadytaken/usm-vlsi-tools:latest
SHARED_DIR=$(abspath ./shared)


ifneq (,$(DOCKER_ROOT))
_DOCKER_ROOT_USER=--user root
endif

ifeq (Windows_NT,$(OS))

# To use GUIs:
# - host.docker.internal:0 allows to connect with vcxscr
# - I think the reuse
# 
# Is --net=host required?
# - GUIs appear with or without it
# - Notebooks don't work, but seems to take longer to fail without this option.
# - ... this might suggest something


DOCKER_RUN=docker run -it --rm --pull=always $(_DOCKER_ROOT_USER) \
	--mount type=bind,source=$(SHARED_DIR),target=/home/designer/shared \
	--net=host \
	-e DISPLAY=host.docker.internal:0 \
	-e XDG_RUNTIME_DIR \
	-e PULSE_SERVER \
	-p 8888:8888

else

USER_ID=$(shell id -u)
USER_GROUP=$(shell id -g)
DOCKER_RUN=docker run -it --rm --pull=always $(_DOCKER_ROOT_USER) \
	--mount type=bind,source=$(SHARED_DIR),target=/home/designer/shared \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v /home/$(USER)/.Xauthority:/root/.Xauthority:rw \
	-v /home/$(USER)/.Xauthority:/home/designer/.Xauthority:rw \
	--net=host \
	-e DISPLAY \
	-e XDG_RUNTIME_DIR \
	-e PULSE_SERVER \
	-e USER_ID=$(USER_ID) \
	-e USER_GROUP=$(USER_GROUP) \
	-p 8888:8888

endif


########################
# Docker Image Commands
########################


print:
	@echo OS ...................... $(OS)
	@echo SHARED_DIR .............. $(SHARED_DIR)
	@echo DOCKER_IMAGE_TAG ........ $(DOCKER_IMAGE_TAG)
	@echo DOCKER_RUN .............. $(DOCKER_RUN)
	@echo _DOCKER_ROOT_USER ....... $(_DOCKER_ROOT_USER)


build:
ifeq (,$(DOCKER_STAGE))
	docker build . -t $(DOCKER_IMAGE_TAG)
else
	docker build --target $(DOCKER_STAGE) . -t $(DOCKER_IMAGE_TAG)
endif


start:
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) bash


start-raw: build
	docker run -it --rm $(_DOCKER_ROOT_USER) $(DOCKER_IMAGE_TAG)


start-latest: build start


start-notebook:
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) "jupyter-lab --no-browser --notebook-dir=./shared --ip 0.0.0.0" 


push:
	docker image push $(DOCKER_IMAGE_TAG)


pull:
	docker image pull $(DOCKER_IMAGE_TAG)
