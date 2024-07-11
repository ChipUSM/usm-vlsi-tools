#!/bin/bash

set -ex

export PATH=`realpath $TOOLS/magic/*/bin`:$PATH

volare build --pdk=gf180mcu --clear-build-artifacts -j `nproc` $OPEN_PDKS_REPO_COMMIT
volare enable --pdk=gf180mcu $OPEN_PDKS_REPO_COMMIT

rm -rf $PDK_ROOT/gf180mcuA
rm -rf $PDK_ROOT/gf180mcuB
rm -rf $PDK_ROOT/gf180mcuC
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$OPEN_PDKS_REPO_COMMIT/gf180mcuA
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$OPEN_PDKS_REPO_COMMIT/gf180mcuB
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$OPEN_PDKS_REPO_COMMIT/gf180mcuC

# Filter testing or unused DRC/LVS folders
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$OPEN_PDKS_REPO_COMMIT/gf180mcuD/libs.tech/klayout/drc/testing
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$OPEN_PDKS_REPO_COMMIT/gf180mcuD/libs.tech/klayout/lvs/testing
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$OPEN_PDKS_REPO_COMMIT/gf180mcuD/libs.tech/klayout/tech/drc
rm -rf $PDK_ROOT/volare/gf180mcu/versions/$OPEN_PDKS_REPO_COMMIT/gf180mcuD/libs.tech/klayout/tech/lvs