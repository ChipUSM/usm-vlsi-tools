#!/bin/bash

set -ex
cd /tmp

orToolsPrefix="${TOOLS}/common"
orToolsVersionBig=9.10
orToolsVersionSmall=${orToolsVersionBig}.4067
    
# if [ "$(uname -m)" == "aarch64" ]; then
echo "OR-TOOLS NOT FOUND"
echo "Installing  OR-Tools for aarch64..."
git clone --depth=1 -b "v${orToolsVersionBig}" https://github.com/google/or-tools.git
cd or-tools
cmake \
    -S. \
    -Bbuild \
    -DBUILD_DEPS:BOOL=ON \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DBUILD_SAMPLES:BOOL=OFF \
    -DBUILD_TESTING:BOOL=OFF \
    -DBUILD_SCIP:BOOL=ON \
    -DBUILD_CoinUtils:BOOL=ON \
    -DBUILD_Osi:BOOL=ON \
    -DBUILD_Clp:BOOL=ON \
    -DBUILD_Cgl:BOOL=ON \
    -DBUILD_Cbc:BOOL=ON \
    -DBUILD_absl:BOOL=ON \
    -DBUILD_Protobuf:BOOL=ON \
    -DCMAKE_INSTALL_PREFIX=${orToolsPrefix} \
    -DCMAKE_CXX_FLAGS="-w" \
    -DCMAKE_C_FLAGS="-w"
cmake --build build --config Release --target install -v -j $(nproc)
# else
#     if [[ $version == rodete ]]; then
#         version=11
#     fi
#     orToolsFile=or-tools_${arch}_${os}-${version}_cpp_v${orToolsVersionSmall}.tar.gz
#     eval wget https://github.com/google/or-tools/releases/download/v${orToolsVersionBig}/${orToolsFile}
#     orToolsPrefix=${PREFIX:-"/opt/or-tools"}
#     if command -v brew &> /dev/null; then
#         orToolsPrefix="$(brew --prefix or-tools)"
#     fi
#     mkdir -p ${orToolsPrefix}
#     tar --strip 1 --dir ${orToolsPrefix} -xf ${orToolsFile}
#     rm -rf ${baseDir}
# fi

CMAKE_PACKAGE_ROOT_ARGS+=" -D ortools_ROOT=$(realpath $orToolsPrefix) "