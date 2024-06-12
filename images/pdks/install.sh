#!/bin/bash

set -ex
set -u

COMMIT=bba8744a60162c27cbf86fb30d926483ff768404

pip install --break-system-packages volare

volare build --pdk=sky130 $COMMIT
volare enable --pdk=sky130 $COMMIT

# I think removing this will reduce sub-stage size.
rm -rf $PDK_ROOT/sky130B
rm -rf $PDK_ROOT/volare/sky130/versions/$COMMIT/sky130B

rm -rf $PDK_ROOT/volare/sky130/build