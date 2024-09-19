#!/bin/bash

set -ex
cd /tmp

REPO_COMMIT_SHORT=$(echo "$OPENROAD_APP_REPO_COMMIT" | cut -c 1-7)

git clone --filter=blob:none "${OPENROAD_APP_REPO_URL}" "${OPENROAD_APP_NAME}"
cd "${OPENROAD_APP_NAME}"
git checkout "${OPENROAD_APP_REPO_COMMIT}"
git submodule update --init --recursive

mkdir -p build && cd build
cmake .. "-DCMAKE_INSTALL_PREFIX=${TOOLS}/${OPENROAD_APP_NAME}/${REPO_COMMIT_SHORT}" "-DUSE_SYSTEM_BOOST=ON"
make -j"$(nproc)"
make install