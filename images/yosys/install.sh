#!/bin/bash

set -ex
cd /tmp

# Build yosys
# -----------

REPO_COMMIT_SHORT="$YOSYS_REPO_COMMIT"
YOSYS_PREFIX="${TOOLS}/${YOSYS_NAME}/${REPO_COMMIT_SHORT}"

git clone --depth=1 -b "${YOSYS_REPO_COMMIT}" --recurse "${YOSYS_REPO_URL}" "${YOSYS_NAME}"
cd "${YOSYS_NAME}"
make install -j"$(nproc)" PREFIX="${YOSYS_PREFIX}" CONFIG=gcc ABC_ARCHFLAGS=-Wno-register
cd ..

export PATH=$PATH:${TOOLS}/${YOSYS_NAME}/${REPO_COMMIT_SHORT}/bin

# Build yosys eqy
# ---------------

git clone --depth=1 -b "${YOSYS_REPO_COMMIT}" --recurse ${YOSYS_EQY_REPO_URL} ${YOSYS_EQY_NAME}
cd ${YOSYS_EQY_NAME}
sed -i "s#^PREFIX.*#PREFIX=${YOSYS_PREFIX}#g" Makefile
make install -j"$(nproc)"
cd ..

# Build yosys sby
# ---------------

git clone --depth=1 -b "${YOSYS_REPO_COMMIT}" --recurse ${YOSYS_SBY_REPO_URL} ${YOSYS_SBY_NAME}
cd ${YOSYS_SBY_NAME}
sed -i "s#^PREFIX.*#PREFIX=${YOSYS_PREFIX}#g" Makefile
make install -j"$(nproc)" 
cd ..

# Install yosys mcy
# -----------------

# git clone --depth=1 -b "${YOSYS_REPO_COMMIT}" --recurse ${YOSYS_MCY_REPO_URL} ${YOSYS_MCY_NAME}
# cd ${YOSYS_MCY_NAME}
# sed -i "s#^PREFIX.*#PREFIX=${YOSYS_PREFIX}#g" Makefile
# make install -j"$(nproc)"
# cd ..