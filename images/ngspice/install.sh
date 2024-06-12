#!/bin/bash

# Based on https://github.com/iic-jku/IIC-OSIC-TOOLS/blob/main/_build/images/ngspice/scripts/install.sh

# Compile options
TOOL_COMPILE_OPTS=(
    "--disable-debug"
    "--enable-openmp"
    "--with-x"
    "--with-readline=yes"
    "--enable-pss"
    "--enable-xspice"
    "--with-fftw3=yes"
    "--enable-osdi"
    "--enable-klu"
)

set -ex
#set -u

# Get data

git clone --filter=blob:none "${NGSPICE_REPO_URL}" "${NGSPICE_NAME}" || true
cd "${NGSPICE_NAME}"
git checkout "${NGSPICE_REPO_COMMIT}"

# Configure compilation

./autogen.sh
#FIXME 2nd run of autogen needed
./autogen.sh

# Compile Executable

./configure \
    ${TOOL_COMPILE_OPTS[@]}  \
    CFLAGS="-m64 -O2" \
    LDFLAGS="-m64 -s" \
    --prefix="${TOOLS}/${NGSPICE_NAME}/${NGSPICE_REPO_COMMIT}"

make -j"$(nproc)"
make install
ln -s "${TOOLS}/${NGSPICE_NAME}/${NGSPICE_REPO_COMMIT}/bin/ngspice" /usr/bin/ngspice

# Regression tests
make -C tests/regression check

# Paranoia Tests requires more automation in parsing responses and ignore
# "expected" leak errors on ngspice.
# apt update && apt install -y p7zip valgrind parallel
# wget https://ngspice.sourceforge.io/tests/paranoia_parallel.7z
# 7za x paranoia_parallel.7z
# cd paranoia_parallel

# ./paranoia_table_generators.sh
# ./runtests.sh paranoia_test_extra.sh ./working

make distclean

# Shared lib

./configure \
    ${TOOL_COMPILE_OPTS[@]} \
    --with-ngshared \
    CFLAGS="-m64 -O2" \
    LDFLAGS="-m64 -s" \
    --prefix="${TOOLS}/${NGSPICE_NAME}/${NGSPICE_REPO_COMMIT}"

make -j"$(nproc)"
make install
