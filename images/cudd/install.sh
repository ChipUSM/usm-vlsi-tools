#!/bin/bash

set -ex
cd /tmp

cuddPrefix="${TOOLS}/common"
cuddVersion=3.0.0

git clone --depth=1 -b ${cuddVersion} https://github.com/The-OpenROAD-Project/cudd.git
cd cudd
autoreconf
./configure --prefix=${cuddPrefix}
make -j $(nproc) install