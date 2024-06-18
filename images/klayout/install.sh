#!/bin/bash

set -e

compile () {
    REPO_COMMIT_SHORT=$(echo "$KLAYOUT_REPO_COMMIT" | cut -c 1-8)

    git clone --filter=blob:none "${KLAYOUT_REPO_URL}" "${KLAYOUT_NAME}"
    cd "${KLAYOUT_NAME}"
    git checkout "${KLAYOUT_REPO_COMMIT}"
    prefix=${TOOLS}/${KLAYOUT_NAME}/${REPO_COMMIT_SHORT}
    mkdir -p "$prefix"
    ./build.sh -j"$(nproc)" -prefix "$prefix" -without-qtbinding
}

download () {
    wget -O klayout_installer.deb "${KLAYOUT_DOWNLOAD}"
    dpkg -i klayout_installer.deb
}

download