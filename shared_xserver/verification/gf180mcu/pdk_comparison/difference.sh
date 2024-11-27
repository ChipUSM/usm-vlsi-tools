#!/bin/bash

difference () {
    FIRST=$1
    SECOND=$2
    OUT_FILE=$3

    MAG_TIMESTAMP_PATTERN="^timestamp.*[0-9]\+$"
    XSCHEM_VERSION_PATTERN="xschem.*version=3[.][0-9].*file_version=1.2$"

    DIFF='diff --strip-trailing-cr -r -I $XSCHEM_VERSION_PATTERN -I $MAG_TIMESTAMP_PATTERN'
    SED='sed -e "s|$FIRST/$1|OLD|" -e "s|$SECOND/$1|NEW|"'

    cat > $OUT_FILE.md <<  EOL

# Brief sorted differences:
OLD: $FIRST/$1
NEW: $SECOND/$1

$(eval $DIFF -q $FIRST $SECOND | eval $SED | sort || true)


# Detailed differences:

$(eval $DIFF $FIRST $SECOND | eval $SED | grep -v "^Only in \|^Binary files " || true)
EOL
}

export PDK=gf180mcuD
export LIBS_TECH=$PDK_ROOT/$PDK/libs.tech
export KLAYOUT_HOME=$LIBS_TECH/klayout

## Primitives library


# difference \
#     $LIBS_TECH/xschem \
#     globalfoundries-pdk-libs-gf180mcu_fd_pr/cells/xschem \
#     comparison_xschem
# readlink -f comparison_xschem.md

# difference \
#     $LIBS_TECH/klayout/pymacros \
#     globalfoundries-pdk-libs-gf180mcu_fd_pr/cells/klayout/pymacros \
#     comparison_klayout
# readlink -f comparison_klayout.md

# difference \
#     $LIBS_TECH/ngspice \
#     globalfoundries-pdk-libs-gf180mcu_fd_pr/models/ngspice \
#     comparison_ngspice
# readlink -f comparison_ngspice.md

# difference \
#     $LIBS_TECH/xyce \
#     globalfoundries-pdk-libs-gf180mcu_fd_pr/models/xyce \
#     comparison_xyce
# readlink -f comparison_xyce.md

# Dropdown Menu MACRO relies on $KLAYOUT_HOME/drc and lvs
difference \
    $LIBS_TECH/klayout/macros \
    globalfoundries-pdk-libs-gf180mcu_fd_pr/rules/klayout/macros \
    comparison_klayout_macros
readlink -f comparison_klayout_macros.md

# difference \
#     $LIBS_TECH/klayout/tech \
#     globalfoundries-pdk-libs-gf180mcu_fd_pr/tech/klayout \
#     comparison_klayout_tech
# readlink -f comparison_klayout_tech.md


## Verification library

### First the duplicated ones on the pdk
# difference \
#     $LIBS_TECH/klayout/drc \
#     $LIBS_TECH/klayout/tech/drc \
#     comparison_klayout_drc_duplicated
# readlink -f comparison_klayout_drc_duplicated.md

# Duplicated LVS takes a lot of time
# difference \
#     $LIBS_TECH/klayout/lvs \
#     $LIBS_TECH/klayout/tech/lvs \
#     comparison_klayout_lvs_duplicated
# readlink -f comparison_klayout_lvs_duplicated.md


### Then with specific stuff
# difference \
#     $LIBS_TECH/klayout/drc \
#     globalfoundries-pdk-libs-gf180mcu_fd_pv/klayout/drc \
#     comparison_klayout_drc
# readlink -f comparison_klayout_drc.md