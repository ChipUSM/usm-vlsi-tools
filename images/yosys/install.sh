#!/bin/bash

set -ex

# Build yosys
# -----------

REPO_COMMIT_SHORT="$YOSYS_REPO_COMMIT"

git clone --filter=blob:none "${YOSYS_REPO_URL}" "${YOSYS_NAME}"
cd "${YOSYS_NAME}"
git checkout "${YOSYS_REPO_COMMIT}"
git submodule update --init --recursive
make install -j"$(nproc)" PREFIX="${TOOLS}/${YOSYS_NAME}/${REPO_COMMIT_SHORT}" CONFIG=gcc
cd ..

export PATH=$PATH:${TOOLS}/${YOSYS_NAME}/${REPO_COMMIT_SHORT}/bin

# Build yosys eqy
# ---------------

git clone --filter=blob:none ${YOSYS_EQY_REPO_URL} ${YOSYS_EQY_NAME}
cd ${YOSYS_EQY_NAME}
git checkout ${YOSYS_REPO_COMMIT}
git submodule update --init --recursive
sed -i "s#^PREFIX.*#PREFIX=${TOOLS}/${YOSYS_NAME}#g" Makefile
make install -j"$(nproc)"
cd ..

# Build yosys sby
# ---------------

git clone --filter=blob:none ${YOSYS_SBY_REPO_URL} ${YOSYS_SBY_NAME}
cd ${YOSYS_SBY_NAME}
git checkout ${YOSYS_REPO_COMMIT}
git submodule update --init --recursive
sed -i "s#^PREFIX.*#PREFIX=${TOOLS}/${YOSYS_NAME}#g" Makefile
make install -j"$(nproc)" 
cd ..

# Install yosys mcy
# -----------------

git clone --filter=blob:none ${YOSYS_MCY_REPO_URL} ${YOSYS_MCY_NAME}
cd ${YOSYS_MCY_NAME}
git checkout ${YOSYS_REPO_COMMIT}
git submodule update --init --recursive
sed -i "s#^PREFIX.*#PREFIX=${TOOLS}/${YOSYS_NAME}#g" Makefile
make install -j"$(nproc)"
cd ..