#!/bin/bash

# References
# - From IHP: https://ihp-open-pdk-docu.readthedocs.io/en/latest/analog/xyce.html
# - From JKU: https://github.com/iic-jku/IIC-OSIC-TOOLS/blob/main/_build/images/xyce/scripts/install.sh

set -ex
cd /tmp

export REPO_COMMIT_SHORT=$(echo "$XYCE_REPO_COMMIT" | cut -c 1-5)

git clone --depth=1 --branch "${XYCE_REPO_COMMIT}" "${XYCE_REPO_URL}" "${XYCE_NAME}"
cd "${XYCE_NAME}"
./bootstrap

cd /tmp/"${XYCE_NAME}"
git clone --depth=1 --branch "${XYCE_TRILINOS_REPO_COMMIT}" "${XYCE_TRILINOS_REPO_URL}" trilinos

cd "/tmp/${XYCE_NAME}/trilinos"
mkdir -p parallel_build && cd parallel_build
cp /images/xyce/scripts/trilinos.reconfigure.sh ./reconfigure.sh
chmod +x reconfigure.sh
./reconfigure.sh
make -j"$(nproc)"
make install

cd /tmp/"${XYCE_NAME}"
mkdir -p parallel_build && cd parallel_build
cp /images/xyce/scripts/xyce.reconfigure.sh ./reconfigure.sh
chmod +x reconfigure.sh
./reconfigure.sh
make -j"$(nproc)"
make install