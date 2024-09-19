#!/bin/bash

set -ex
cd /tmp

gtestPrefix="${TOOLS}/common"
gtestVersion=1.13.0
gtestChecksum="a1279c6fb5bf7d4a5e0d0b2a4adb39ac"

eval wget https://github.com/google/googletest/archive/refs/tags/v${gtestVersion}.zip
md5sum -c <(echo "${gtestChecksum} v${gtestVersion}.zip") || exit 1
unzip v${gtestVersion}.zip
cd googletest-${gtestVersion}
cmake -DCMAKE_INSTALL_PREFIX="${gtestPrefix}" -B build .
cmake --build build --target install


CMAKE_PACKAGE_ROOT_ARGS+=" -D GTest_ROOT=$(realpath $gtestPrefix) "