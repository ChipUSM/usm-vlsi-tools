#!/bin/bash

echo "DONT USE DIRECTLY"
exit

set -ex
set -u


SCRIPT_DIR=$PWD

KLAYOUT_HOME=$PDK_ROOT/sky130A/libs.tech/klayout

# Fixing .lyt file

sed -i 's/>sky130</>sky130A</g' $KLAYOUT_HOME/tech/sky130A.lyt
sed -i 's/sky130.lyp/sky130A.lyp/g' $KLAYOUT_HOME/tech/sky130A.lyt
sed -i '/<base-path>/c\ <base-path/>' $KLAYOUT_HOME/tech/sky130A.lyt
sed -i '/<original-base-path>/c\ <original-base-path>$PDK_ROOT/$PDK/libs.tech/klayout</original-base-path>' $KLAYOUT_HOME/tech/sky130A.lyt

# Fix lym file

# This will break new installations
# sed -i '1,16d' $KLAYOUT_HOME/pymacros/sky130.lym

# Klayout PCELL fixing for gdsfactory==7.3.0

sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/via_generator.py
sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/draw_fet.py
sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/layers_def.py
sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/res_metal_child.py

# Adding precheck drc for klayout

# Not required on new commits
wget -O $KLAYOUT_HOME/drc/sky130A_mr_2.drc https://raw.githubusercontent.com/efabless/mpw_precheck/main/checks/tech-files/sky130A_mr.drc
