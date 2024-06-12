#!/bin/bash

NGSPICE_REPO_URL="https://github.com/danchitnis/ngspice-sf-mirror"
NGSPICE_REPO_COMMIT="ngspice-42"
NGSPICE_NAME="ngspice"

TOOL_COMPILE_OPTS=(
    "--with-x"
    "--enable-xspice"
    "--enable-pss"
    "--with-readline=yes"
    "--disable-debug"
    "--enable-openmp"
    "--with-fftw3=yes"
    "--enable-osdi"
    "--enable-klu"
)

set -ex

git clone \
    --depth 1 \
    --recurse-submodules \
    --shallow-submodules \
    --branch "${NGSPICE_REPO_COMMIT}" \
    "${NGSPICE_REPO_URL}" "${NGSPICE_NAME}" \
    || true

cd "${NGSPICE_NAME}"

# Configure compilation

./autogen.sh
#FIXME 2nd run of autogen needed
./autogen.sh

./configure \
    ${TOOL_COMPILE_OPTS[@]}  \
    CFLAGS="-m64 -O2" \
    LDFLAGS="-m64 -s" \
    --prefix="${TOOLS}/${NGSPICE_NAME}/${NGSPICE_REPO_COMMIT}"

make installcheck |& tee logs.md
echo $PWD/logs.md