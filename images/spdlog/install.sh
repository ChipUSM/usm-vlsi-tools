#!/bin/bash

set -ex
cd /tmp

spdlogPrefix="${TOOLS}/common"
spdlogVersion=1.8.1

git clone --depth=1 -b "v${spdlogVersion}" https://github.com/gabime/spdlog.git
cd spdlog
cmake -DCMAKE_INSTALL_PREFIX="${spdlogPrefix}" -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DSPDLOG_BUILD_EXAMPLE=OFF -B build .
cmake --build build -j $(nproc) --target install

CMAKE_PACKAGE_ROOT_ARGS+=" -D spdlog_ROOT=$(realpath $spdlogPrefix) "