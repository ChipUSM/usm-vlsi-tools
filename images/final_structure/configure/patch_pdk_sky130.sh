#!/bin/bash

set -ex

KLAYOUT_HOME=$PDK_ROOT/sky130A/libs.tech/klayout

# Klayout
## Update connectivity and other attributes on tech file
python fix-tech-file.py --pdk sky130A $KLAYOUT_HOME/tech/sky130A.lyt

## Replace gdsfactory.types for gdsfactory.typings on klayout pcells
find $PDK_ROOT/sky130A/libs.tech/klayout/pymacros/cells \
    -name "*.py" \
    -exec sed -i "s/gdsfactory.*types/gdsfactory.typings/" {} \;