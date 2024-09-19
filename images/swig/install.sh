#!/bin/bash

set -ex
cd /tmp

swigPrefix="${TOOLS}/common"
swigVersion=4.1.0
swigChecksum="794433378154eb61270a3ac127d9c5f3"

pcreVersion=10.42
pcreChecksum="37d2f77cfd411a3ddf1c64e1d72e43f7"

tarName="v${swigVersion}.tar.gz"

eval wget https://github.com/swig/swig/archive/${tarName}
md5sum -c <(echo "${swigChecksum} ${tarName}") || exit 1
tar xfz ${tarName}
cd swig-${tarName%%.tar*} || cd swig-${swigVersion}

# Check if pcre2 is installed
if [[ -z $(pcre2-config --version) ]]; then
    tarName="pcre2-${pcreVersion}.tar.gz"
    eval wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${pcreVersion}/${tarName}
    md5sum -c <(echo "${pcreChecksum} ${tarName}") || exit 1
    ./Tools/pcre-build.sh
fi

./autogen.sh
./configure --prefix=${swigPrefix} --with-boost=${swigPrefix}
make -j $(nproc)
make -j $(nproc) install

CMAKE_PACKAGE_ROOT_ARGS+=" -D SWIG_ROOT=$(realpath $swigPrefix) "
