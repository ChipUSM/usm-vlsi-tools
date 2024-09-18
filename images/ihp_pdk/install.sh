#!/bin/bash

set -ex

git clone --branch dev "$IHP_PDK_REPO_URL" ihp
cd ihp
git checkout $IHP_PDK_REPO_COMMIT
git submodule update --init --recursive

rm -rf \
    ihp-sg13g2/libs.doc/meas \
    ihp-sg13g2/libs.tech/klayout/tech/lvs/testing \
    ihp-sg13g2/libs.tech/openems/testcase

# Some modifications/cleanup needed of stock IHP PDK
# 1) Remove the `pre_osdi` line from the examples
find . -name "*.sch" -exec sed -i '/pre_osdi/d' {} \;

mkdir -p "$PDK_ROOT"
mv ihp-sg13g2 "$PDK_ROOT/$IHP_PDK_NAME"

# Compile the PSP model (DO NOT COMPILE THEM HERE!)
# cd "$PDK_ROOT/$IHP_PDK_NAME/libs.tech/ngspice/openvaf"
# OPENVAF_VERSION=$(ls "$TOOLS/$OPENVAF_NAME")
# openvaf psp103_nqs.va
