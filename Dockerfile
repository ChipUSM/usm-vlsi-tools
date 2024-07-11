# Based on https://github.com/iic-jku/IIC-OSIC-TOOLS/blob/main/_build/Dockerfile

#ARG BASE_IMAGE=gocd/gocd-agent-ubuntu-24.04:v24.1.0
#ARG BASE_IMAGE=ubuntu:24.04
ARG BASE_IMAGE=ubuntu:22.04

ARG NGSPICE_REPO_URL="https://github.com/danchitnis/ngspice-sf-mirror"
ARG NGSPICE_REPO_COMMIT="ngspice-42"
ARG NGSPICE_NAME="ngspice"

ARG OPEN_PDKS_REPO_URL="https://github.com/RTimothyEdwards/open_pdks"
# Jan 10, 2024
ARG OPEN_PDKS_REPO_COMMIT="bdc9412b3e468c102d01b7cf6337be06ec6e9c9a"
# May 26, 2024
ARG OPEN_PDKS_REPO_COMMIT="bba8744a60162c27cbf86fb30d926483ff768404"
# Jun 12, 2024
ARG OPEN_PDKS_REPO_COMMIT="06898d0576a1820a131f58b05b6af5f504f080d9"
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

ARG KLAYOUT_REPO_URL="https://github.com/KLayout/klayout"
ARG KLAYOUT_REPO_COMMIT="v0.29.1"
ARG KLAYOUT_DOWNLOAD="https://www.klayout.org/downloads/Ubuntu-22/klayout_0.29.2-1_amd64.deb"
ARG KLAYOUT_NAME="klayout"

ARG XSCHEM_REPO_URL="https://github.com/StefanSchippers/xschem.git"
ARG XSCHEM_REPO_COMMIT="747652ffe184246edcacfc072834583efcbf84a8"
ARG XSCHEM_NAME="xschem"

ARG OPENROAD_APP_REPO_URL="https://github.com/The-OpenROAD-Project/OpenROAD.git"
ARG OPENROAD_APP_REPO_COMMIT="d423155d69de7f683a23f6916ead418a615ad4ad"
ARG OPENROAD_APP_NAME="openroad"

ARG OPENFASOC_REPO_URL="https://github.com/idea-fasoc/OpenFASOC.git"
ARG OPENFASOC_REPO_COMMIT="7dc5eb42cec94c02b74e72483df6fdc2b2603fb9"
ARG OPENFASOC_NAME="openfasoc"

ARG NETGEN_REPO_URL="https://github.com/rtimothyedwards/netgen"
ARG NETGEN_REPO_COMMIT="1.5.276"
ARG NETGEN_NAME="netgen"

ARG YOSYS_REPO_URL="https://github.com/YosysHQ/yosys"
ARG YOSYS_REPO_COMMIT="yosys-0.41"
ARG YOSYS_NAME="yosys"
ARG YOSYS_EQY_REPO_URL="https://github.com/YosysHQ/eqy.git"
ARG YOSYS_EQY_NAME="yosys_eqy"
ARG YOSYS_SBY_REPO_URL="https://github.com/YosysHQ/sby.git"
ARG YOSYS_SBY_NAME="yosys_sby"
ARG YOSYS_MCY_REPO_URL="https://github.com/YosysHQ/mcy.git"
ARG YOSYS_MCY_NAME="yosys_mcy"


#######################################################################
# Basic configuration for base and builder
#######################################################################

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
RUN --mount=type=bind,source=images/base,target=/images/base \
    bash /images/base/python_packages.sh


#######################################################################
# Builder image (Has all iic dependencies)
#######################################################################
FROM common as builder

RUN --mount=type=bind,source=images/builder,target=/images/builder \
    bash /images/builder/exhaustive-install.sh
RUN --mount=type=bind,source=images/boost,target=/images/boost \
    bash /images/boost/install.sh
RUN --mount=type=bind,source=images/ortools,target=/images/ortools \
    bash /images/ortools/install.sh


#######################################################################
# Compile magic (Requirement for sky130 pdk)
#######################################################################
FROM builder as magic

ARG MAGIC_REPO_URL \
    MAGIC_REPO_COMMIT \
    MAGIC_NAME

RUN --mount=type=bind,source=images/magic,target=/images/magic \
    bash /images/magic/install.sh


#######################################################################
# Build sky130A
#######################################################################
FROM magic as pdks

ARG OPEN_PDKS_REPO_URL \
    OPEN_PDKS_REPO_COMMIT \
    OPEN_PDKS_NAME

RUN --mount=type=bind,source=images/pdks,target=/images/pdks \
    bash /images/pdks/install_sky130.sh
RUN --mount=type=bind,source=images/pdks,target=/images/pdks \
    bash /images/pdks/install_gf180mcu.sh


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
# Compile klayout
#######################################################################
FROM builder as klayout

ARG KLAYOUT_REPO_URL \
    KLAYOUT_REPO_COMMIT \
    KLAYOUT_DOWNLOAD \
    KLAYOUT_NAME

RUN --mount=type=bind,source=images/klayout,target=/images/klayout \
    bash /images/klayout/install.sh


#######################################################################
# Compile xschem
#######################################################################
FROM builder as xschem

ARG XSCHEM_REPO_URL \
    XSCHEM_REPO_COMMIT \
    XSCHEM_NAME

RUN --mount=type=bind,source=images/xschem,target=/images/xschem \
    bash /images/xschem/install.sh


#######################################################################
# Compile yosys
#######################################################################
FROM builder as yosys

ARG YOSYS_REPO_URL \
    YOSYS_REPO_COMMIT \
    YOSYS_NAME \
    YOSYS_EQY_REPO_URL \
    YOSYS_EQY_NAME \
    YOSYS_SBY_REPO_URL \
    YOSYS_SBY_NAME \
    YOSYS_MCY_REPO_URL \
    YOSYS_MCY_NAME

RUN --mount=type=bind,source=images/yosys,target=/images/yosys \
    bash /images/yosys/install.sh

#######################################################################
# Compile netgen
#######################################################################
FROM builder as netgen

ARG NETGEN_REPO_URL \
    NETGEN_REPO_COMMIT \
    NETGEN_NAME

RUN --mount=type=bind,source=images/netgen,target=/images/netgen \
    bash /images/netgen/install.sh


#######################################################################
# Compile openroad
#######################################################################
FROM builder as openroad

ARG OPENROAD_APP_REPO_URL \
    OPENROAD_APP_REPO_COMMIT \
    OPENROAD_APP_NAME

RUN --mount=type=bind,source=images/openroad,target=/images/openroad \
    bash /images/openroad/install.sh


#######################################################################
# Compile openfasoc
#######################################################################
FROM builder as openfasoc

ARG OPENFASOC_REPO_URL \
    OPENFASOC_REPO_COMMIT \
    OPENFASOC_NAME

RUN --mount=type=bind,source=images/openfasoc,target=/images/openfasoc \
    bash /images/openfasoc/install.sh


#######################################################################
# Final output container
#######################################################################
FROM base as usm-vlsi-tools
ARG NGSPICE_REPO_COMMIT \
    OPEN_PDKS_REPO_COMMIT \
    MAGIC_REPO_COMMIT \
    IHP_PDK_REPO_COMMIT \
    KLAYOUT_DOWNLOAD \
    XSCHEM_REPO_COMMIT \
    NETGEN_REPO_COMMIT


# COPY --from=pdks       ${PDK_ROOT}/        ${PDK_ROOT}/
COPY --from=ihp_pdk    ${PDK_ROOT}/sg13g2  ${PDK_ROOT}/sg13g2
COPY --from=ngspice    ${TOOLS}/           ${TOOLS}/
# COPY --from=klayout    ${TOOLS}/           ${TOOLS}/
COPY --from=xschem     ${TOOLS}/           ${TOOLS}/
COPY --from=magic      ${TOOLS}/           ${TOOLS}/
COPY --from=netgen     ${TOOLS}/           ${TOOLS}/
# COPY --from=yosys      ${TOOLS}/           ${TOOLS}/
# COPY --from=openroad   ${TOOLS}/           ${TOOLS}/
# COPY --from=openfasoc  ${TOOLS}/           ${TOOLS}/

RUN --mount=type=bind,source=images/pdks,target=/images/pdks \
    cd /images/pdks/ \
    && bash install_sky130.sh \
    && bash install_gf180mcu.sh

RUN --mount=type=bind,source=images/final_structure/install,target=/images/final_structure/install \
    bash /images/final_structure/install/install_klayout.sh

RUN --mount=type=bind,source=images/final_structure/configure,target=/images/final_structure/configure \
    cd /images/final_structure/configure/ \
    && bash tool_configuration.sh

RUN --mount=type=bind,source=images/final_structure/configure,target=/images/final_structure/configure \
    cd /images/final_structure/configure/ \
    && bash patch_pdk_sky130.sh \
    && bash patch_pdk_gf180mcu.sh \
    && bash modify_user.sh

COPY --chown=designer:designer --chmod=755 images/final_structure/configure/.bashrc /home/designer/.bashrc
COPY --chown=designer:designer --chmod=755 images/final_structure/configure/.bashrc /root/.bashrc
COPY images/final_structure/configure/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /home/designer
USER designer

ENV NGSPICE_REPO_COMMIT=${NGSPICE_REPO_COMMIT} \
    OPEN_PDKS_REPO_COMMIT=${OPEN_PDKS_REPO_COMMIT} \
    MAGIC_REPO_COMMIT=${MAGIC_REPO_COMMIT} \
    IHP_PDK_REPO_COMMIT=${IHP_PDK_REPO_COMMIT} \
    KLAYOUT_DOWNLOAD=${KLAYOUT_DOWNLOAD} \
    XSCHEM_REPO_COMMIT=${XSCHEM_REPO_COMMIT} \
    NETGEN_REPO_COMMIT=${NETGEN_REPO_COMMIT}


#######################################################################
# Digital container
#######################################################################
FROM usm-vlsi-tools as usm-vlsi-digital-tools

USER root

COPY --from=yosys      ${TOOLS}/           ${TOOLS}/
COPY --from=openroad   ${TOOLS}/           ${TOOLS}/