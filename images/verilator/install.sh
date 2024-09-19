#!/bin/bash

set -ex

REPO_COMMIT_SHORT=$(echo "$VERILATOR_REPO_COMMIT" | cut -c 1-7)

# git clone --filter=blob:none "${VERILATOR_REPO_URL}" "${VERILATOR_NAME}"
git clone --filter=blob:none "${VERILATOR_REPO_URL}" "${VERILATOR_NAME}"
cd "${VERILATOR_NAME}" || exit 1
git checkout "${VERILATOR_REPO_COMMIT}"

autoconf
./configure --prefix="${TOOLS}/${VERILATOR_NAME}/${REPO_COMMIT_SHORT}"
make -j`nproc`
# make test
make install