# Based on https://github.com/iic-jku/IIC-OSIC-TOOLS/blob/main/_build/Dockerfile

ARG NGSPICE_REPO_URL="https://github.com/danchitnis/ngspice-sf-mirror"
ARG NGSPICE_REPO_COMMIT="ngspice-42"
ARG NGSPICE_NAME="ngspice"

ARG OPEN_PDKS_REPO_URL="https://github.com/RTimothyEdwards/open_pdks"
ARG OPEN_PDKS_REPO_COMMIT="bdc9412b3e468c102d01b7cf6337be06ec6e9c9a"
ARG OPEN_PDKS_NAME="open_pdks"

ARG MAGIC_REPO_URL="https://github.com/RTimothyEdwards/magic.git"
ARG MAGIC_REPO_COMMIT="e9db9ecbc9943a304de80b32ecc58a61a46cc91f"
ARG MAGIC_NAME="magic"

ARG IHP_PDK_REPO_URL="https://github.com/IHP-GmbH/IHP-Open-PDK.git"
# ARG IHP_PDK_REPO_COMMIT="dceb7e6bd1a877182c3ba32c2e238be08368fa3f"
ARG IHP_PDK_REPO_COMMIT="5a42d03194e8c98558f4e34538338a60550f89b9"
ARG IHP_PDK_NAME="ihp-sg13g2"

ARG OPENVAF_REPO_URL="https://github.com/iic-jku/OpenVAF.git"
ARG OPENVAF_REPO_COMMIT="a9697ae7780518f021f9f64e819b3a57033bd39f"
ARG OPENVAF_DOWNLOAD="https://openva.fra1.cdn.digitaloceanspaces.com/openvaf_23_5_0_linux_amd64.tar.gz"
ARG OPENVAF_NAME="openvaf"


#######################################################################
# Basic configuration for base and builder
#######################################################################
ARG BASE_IMAGE=gocd/gocd-agent-ubuntu-24.04:v24.1.0

FROM ${BASE_IMAGE} as common
ARG CONTAINER_TAG=unknown
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TOOLS=/opt \
    PDK_ROOT=/opt/pdks

USER root


#######################################################################
# Setup base image
#######################################################################
FROM common as base

RUN --mount=type=bind,source=images/base,target=/images/base \
    bash /images/base/base_install.sh


#######################################################################
# Builder image (Has all iic dependencies)
#######################################################################
FROM common as builder

RUN --mount=type=bind,source=images/builder,target=/images/builder \
    bash /images/builder/exhaustive-install.sh


#######################################################################
# Compile magic (Requirement for sky130 pdk)
#######################################################################
FROM builder as magic

ARG MAGIC_REPO_URL \
    MAGIC_REPO_COMMIT \
    MAGIC_NAME

RUN --mount=type=bind,source=images/magic,target=/images/magic \
    bash /images/magic/install.sh

ENV PATH=${PATH}:${TOOLS}/${MAGIC_NAME}/bin


#######################################################################
# Build sky130A
#######################################################################
FROM magic as pdks

ARG OPEN_PDKS_REPO_URL \
    OPEN_PDKS_REPO_COMMIT \
    OPEN_PDKS_NAME

RUN --mount=type=bind,source=images/pdks,target=/images/pdks \
    bash /images/pdks/install.sh
RUN --mount=type=bind,source=images/pdks,target=/images/pdks \
    bash /images/pdks/patch.sh


#######################################################################
# Compile openvaf (requirement for ihp pdk)
#######################################################################
FROM builder as openvaf

ARG OPENVAF_REPO_URL \
    OPENVAF_REPO_COMMIT \
    OPENVAF_DOWNLOAD \
    OPENVAF_NAME
ENV OPENVAF_NAME=${OPENVAF_NAME}

RUN --mount=type=bind,source=images/openvaf,target=/images/openvaf \
    bash /images/openvaf/install.sh


#######################################################################
# Build ihp pdk open pdk
#######################################################################
FROM openvaf as ihp_pdk

ARG IHP_PDK_REPO_URL \
    IHP_PDK_REPO_COMMIT \
    IHP_PDK_NAME

RUN --mount=type=bind,source=images/ihp_pdk,target=/images/ihp_pdk \
    bash /images/ihp_pdk/install.sh


#######################################################################
# Compile ngspice
#######################################################################
FROM builder as ngspice

ARG NGSPICE_REPO_URL \
    NGSPICE_REPO_COMMIT \
    NGSPICE_NAME

RUN --mount=type=bind,source=images/ngspice,target=/images/ngspice \
    bash /images/ngspice/install.sh


#######################################################################
# Final output container
#######################################################################
FROM base as gocd-agent-ngspice

ARG NGSPICE_REPO_URL \
    NGSPICE_REPO_COMMIT \
    NGSPICE_NAME \
    OPEN_PDKS_REPO_COMMIT

COPY --from=ngspice  ${TOOLS}/           ${TOOLS}/
COPY --from=pdks     ${PDK_ROOT}/        ${PDK_ROOT}/
COPY --from=ihp_pdk  ${PDK_ROOT}/sg13g2  ${PDK_ROOT}/sg13g2

ENV PATH=${PATH}:${TOOLS}/${NGSPICE_NAME}/${NGSPICE_REPO_COMMIT}/bin \
    LD_LIBRARY_PATH=${TOOLS}/${NGSPICE_NAME}/${NGSPICE_REPO_COMMIT}/lib

USER go