#!/bin/bash

set -ex

export PATH=`realpath $TOOLS/magic/*/bin`:$PATH

volare build --pdk=sky130 --clear-build-artifacts -j `nproc` $OPEN_PDKS_REPO_COMMIT
volare enable --pdk=sky130 $OPEN_PDKS_REPO_COMMIT

rm -rf $PDK_ROOT/sky130B
rm -rf $PDK_ROOT/volare/sky130/versions/$OPEN_PDKS_REPO_COMMIT/sky130B