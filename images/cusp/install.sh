#!/bin/bash

set -ex
cd /tmp

cuspPrefix="${TOOLS}/common"

git clone --depth=1 -b cuda9 https://github.com/cusplibrary/cusplibrary.git
cd cusplibrary
cp -r ./cusp ${cuspPrefix}