#!/bin/bash

set -ex
cd /tmp

lemonPrefix="${TOOLS}/common"
lemonVersion=1.3.1

git clone --depth=1 -b ${lemonVersion} https://github.com/The-OpenROAD-Project/lemon-graph.git
cd lemon-graph
cmake -DCMAKE_INSTALL_PREFIX="${lemonPrefix}" -B build .
cmake --build build -j $(nproc) --target install

CMAKE_PACKAGE_ROOT_ARGS+=" -D LEMON_ROOT=$(realpath $lemonPrefix) "