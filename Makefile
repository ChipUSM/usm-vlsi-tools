all: print

PDK=sky130A
DOCKER_IMAGE_TAG=akilesalreadytaken/usm-vlsi-tools:latest
SHARED_DIR=$(abspath ./shared_xserver)


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

USER_ID=1000
USER_GROUP=1000
DOCKER_RUN=docker run -it --rm --pull=always $(_DOCKER_ROOT_USER) \
	--mount type=bind,source=$(SHARED_DIR),target=/home/designer/shared \
	--user $(USER_ID):$(USER_GROUP) \
	-e SHELL=/bin/bash \
	-e DISPLAY=host.docker.internal:0 \
	-e LIBGL_ALWAYS_INDIRECT=1 \
	-e XDG_RUNTIME_DIR \
	-e PULSE_SERVER \
	-p 8888:8888

_XSERVER_EXISTS:=$(shell powershell -noprofile Get-Process vcxsrv -ErrorAction SilentlyContinue)
START_XSERVER=powershell -noprofile vcxsrv.exe :0 -multiwindow -clipboard -primary -wgl

else

USER_ID=$(shell id -u)
USER_GROUP=$(shell id -g)
DOCKER_RUN=docker run -it --rm --pull=always $(_DOCKER_ROOT_USER) \
	--mount type=bind,source=$(SHARED_DIR),target=/home/designer/shared \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v /home/$(USER)/.Xauthority:/root/.Xauthority:rw \
	-v /home/$(USER)/.Xauthority:/home/designer/.Xauthority:rw \
	--net=host \
	-e SHELL=/bin/bash \
	-e DISPLAY \
	-e LIBGL_ALWAYS_INDIRECT=1 \
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
	@echo _XSERVER_EXISTS ......... $(_XSERVER_EXISTS)


build:
ifeq (,$(DOCKER_STAGE))
	docker build . -t $(DOCKER_IMAGE_TAG)
else
	docker build --target $(DOCKER_STAGE) . -t $(DOCKER_IMAGE_TAG)
endif


xserver:
ifeq (,$(_XSERVER_EXISTS))
	$(START_XSERVER)
endif


start:
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) bash


start-raw:
	docker run -it --rm $(_DOCKER_ROOT_USER) $(DOCKER_IMAGE_TAG)


start-latest: build start


# Some flags that might be useful
# --NotebookApp.password=''
# --KernelSpecManager.ensure_native_kernel=False
# --NotebookApp.allow_origin='*'

start-notebook:
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) "jupyter-lab --no-browser --notebook-dir=./shared --ip 0.0.0.0 --NotebookApp.token=''"


push:
	docker image push $(DOCKER_IMAGE_TAG)


pull:
	docker image pull $(DOCKER_IMAGE_TAG)
