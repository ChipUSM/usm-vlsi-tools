all: print

PDK=sky130A
SHARED_DIR=$(abspath ./shared_xserver)

ifeq (,$(DEV))
DOCKER_IMAGE_TAG=akilesalreadytaken/usm-vlsi-tools:latest
STAGE=usm-vlsi-tools
else
DOCKER_IMAGE_TAG=akilesalreadytaken/usm-vlsi-tools:temp
STAGE=usm-vlsi-tools-temp
endif


ifneq (,$(ROOT))
_DOCKER_ROOT_USER=--user root
endif

ifneq (,$(NO_CACHE))
_DOCKER_NO_CACHE=--no-cache
endif

# Windows Specific Configuration
################################
ifeq (Windows_NT,$(OS))

USER_ID=1000
USER_GROUP=1000
DOCKER_RUN=docker run -it --rm $(_DOCKER_ROOT_USER) \
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

UNAME_S := $(shell uname -s)
USER_ID=$(shell id -u)
USER_GROUP=$(shell id -g)

# Linux Specific Configuration
##############################
ifeq ($(UNAME_S),Linux)

# Since it uses local xserver, --net=host is required and DISPLAY should be equal to host

DOCKER_RUN=docker run -it --rm $(_DOCKER_ROOT_USER) \
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
	-e USER_GROUP=$(USER_GROUP)

# _XSERVER_EXISTS and START_XSERVER are not required

endif

# Mac Specific Configuration
############################
ifeq ($(UNAME_S),Darwin)

DOCKER_RUN=docker run -it --rm $(_DOCKER_ROOT_USER) \
	--mount type=bind,source=$(SHARED_DIR),target=/home/designer/shared \
	-e SHELL=/bin/bash \
	-e DISPLAY=host.docker.internal:0 \
	-e LIBGL_ALWAYS_INDIRECT=1 \
	-e XDG_RUNTIME_DIR \
	-e PULSE_SERVER \
	-e USER_ID=$(USER_ID) \
	-e USER_GROUP=$(USER_GROUP) \
	-p 8888:8888

# _XSERVER_EXISTS:=$(shell ?)
# START_XSERVER=xquartz ... ?

endif # Linux/Mac differenciation
endif # Windows differenciation


########################
# Docker Image Commands
########################


print:
	@echo DOCKER_IMAGE_TAG ........ $(DOCKER_IMAGE_TAG)
	@echo DEV ..................... $(DEV)
	@echo SHARED_DIR .............. $(SHARED_DIR)
	@echo OS ...................... $(OS)
	@echo UNAME_S ................. $(UNAME_S)
	@echo STAGE ................... $(STAGE)
	@echo CACHE ................... $(_DOCKER_NO_CACHE)
	@echo _DOCKER_ROOT_USER ....... $(_DOCKER_ROOT_USER)
	@echo _XSERVER_EXISTS ......... $(_XSERVER_EXISTS)
	@echo DOCKER_RUN .............. $(DOCKER_RUN)


build:
ifeq (,$(STAGE))
	BUILDKIT_PROGRESS=plain docker build $(_DOCKER_NO_CACHE) -t $(DOCKER_IMAGE_TAG) .
else
	BUILDKIT_PROGRESS=plain docker build $(_DOCKER_NO_CACHE) -t $(DOCKER_IMAGE_TAG) --target $(STAGE) .
endif
	docker image ls $(DOCKER_IMAGE_TAG)


xserver:
ifeq (,$(_XSERVER_EXISTS))
	$(START_XSERVER)
endif


start: xserver pull
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG)


start-raw:
	docker run -it --rm $(_DOCKER_ROOT_USER) $(DOCKER_IMAGE_TAG)


# Avoid the pull of start
start-latest: build
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG)


# Some flags that might be useful
# --NotebookApp.password=''
# --KernelSpecManager.ensure_native_kernel=False
# --NotebookApp.allow_origin='*'

start-notebook: xserver pull
	$(DOCKER_RUN) $(DOCKER_IMAGE_TAG) "jupyter-lab --no-browser --notebook-dir=./shared --ip 0.0.0.0 --NotebookApp.token=''"


start-devcontainer: xserver pull
	code $(SHARED_DIR)


push:
	docker image push $(DOCKER_IMAGE_TAG)


pull:
ifeq (,$(NO_PULL))
	docker image pull $(DOCKER_IMAGE_TAG)
endif
