#!/bin/bash

set -ex
cd /tmp

eigenPrefix="${TOOLS}/common"
eigenVersion=3.4

git clone --depth=1 -b ${eigenVersion} https://gitlab.com/libeigen/eigen.git
cd eigen
cmake -DCMAKE_INSTALL_PREFIX="${eigenPrefix}" -B build .
cmake --build build -j $(nproc) --target install

CMAKE_PACKAGE_ROOT_ARGS+=" -D Eigen3_ROOT=$(realpath $eigenPrefix) "