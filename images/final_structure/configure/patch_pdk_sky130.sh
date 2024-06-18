#!/bin/bash

KLAYOUT_HOME=$PDK_ROOT/sky130A/libs.tech/klayout

# # Fixing .lyt file

# sed -i 's/>sky130</>sky130A</g' $KLAYOUT_HOME/tech/sky130A.lyt
# sed -i 's/sky130.lyp/sky130A.lyp/g' $KLAYOUT_HOME/tech/sky130A.lyt
# sed -i '/<base-path>/c\ <base-path/>' $KLAYOUT_HOME/tech/sky130A.lyt
# sed -i '/<original-base-path>/c\ <original-base-path>$PDK_ROOT/$PDK/libs.tech/klayout</original-base-path>' $KLAYOUT_HOME/tech/sky130A.lyt

# # Fix lym file

# Klayout PCELL fixing for gdsfactory==7.3.0

sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/via_generator.py
sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/draw_fet.py
sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/layers_def.py
sed -i "s/gdsfactory.*types/gdsfactory.typings/" $KLAYOUT_HOME/pymacros/cells/res_metal_child.py

# Adding precheck drc for klayout

# Files are identical on latest verification
# wget -O $KLAYOUT_HOME/drc/sky130A_mr_2.drc https://raw.githubusercontent.com/efabless/mpw_precheck/main/checks/tech-files/sky130A_mr.drc

# Replace this on sky130A.lyt

#  <connectivity>
#   <!-- "connect" section on libs.tech/magic/sky130A.tech -->
#   <!-- http://opencircuitdesign.com/magic/tech.html -->
#   <connection>poly,66/44,li</connection>
#   <connection>li,67/44,met1</connection>
#   <connection>met1,68/44,met2</connection>
#   <connection>met2,69/44,met3</connection>
#   <connection>met3,via3,met4</connection>
#   <connection>met4,via4,met5</connection>
#   <symbols>poly='66/20+66/5-66/13'</symbols>
#   <symbols>li='67/20+67/5'</symbols>
#   <symbols>met1='68/20+68/5'</symbols>
#   <symbols>met2='69/20+69/5'</symbols>
#   <symbols>met3='70/20+70/5'</symbols>
#   <symbols>via3='70/44-89/44'</symbols>
#   <symbols>met4='71/20+71/5'</symbols>
#   <symbols>via4='71/44-97/44'</symbols>
#   <symbols>met5='72/20+72/5'</symbols>
#  </connectivity>