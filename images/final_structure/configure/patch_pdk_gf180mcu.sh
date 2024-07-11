#!/bin/bash

set -ex

patch_xschem_xschemrc () {
    XSCHEMRC=$LIBS_TECH/xschem/xschemrc

    # Add gf180mcuD symbols to xschem path
    ORIGINAL='append XSCHEM_LIBRARY_PATH :$env(PWD)'
    REPLACE='append XSCHEM_LIBRARY_PATH :$env(PDK_ROOT)/gf180mcuD/libs.tech/xschem'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $XSCHEMRC

    # Update 180MCU_MODELS
    ORIGINAL='set 180MCU_MODELS ${PDK_ROOT}/models/ngspice'
    REPLACE='set 180MCU_MODELS $env(PDK_ROOT)/gf180mcuD/libs.tech/ngspice'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $XSCHEMRC
}


patch_klayout_pymacros () {
    mkdir -p $KLAYOUT_HOME/pymacros/cells
    mv $KLAYOUT_HOME/pymacros/* $KLAYOUT_HOME/pymacros/cells || true
    mv $KLAYOUT_HOME/tech/gf180mcu.lym $KLAYOUT_HOME/pymacros

    # FIX BAD CODE ON EFUSE
    cp ./draw_efuse.py $KLAYOUT_HOME/pymacros/cells
}


patch_klayout_dropdown_menu () {
    # Add dropdown menu
    mv /tmp/globalfoundries-pdk-libs-gf180mcu_fd_pr/rules/klayout/macros $KLAYOUT_HOME

    # Make D the default variant in {drc lvs}_options.yml
    FILEPATH=$KLAYOUT_HOME/macros/*_options.yml

    ORIGINAL='variant: C'
    REPLACE='variant: D'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $FILEPATH

    # Make D default on .lym
    FILEPATH=$KLAYOUT_HOME/macros/gf180mcu_options.lym

    ORIGINAL=';"C"'
    REPLACE=';"D"'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $FILEPATH

    ORIGINAL='], 2)'
    REPLACE='], 3)'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $FILEPATH
}


patch_klayout_colors () {
    # Add Gabriel Maranhao klayout colors
    mv $KLAYOUT_HOME/tech/gf180mcu.lyp $KLAYOUT_HOME/tech/gf180mcu.bkp.lyp
    # Original path: https://raw.githubusercontent.com/ChipUSM/osic-stacks/main/stacks/chipathon-tools/scripts/gf180mcu.lyp
    # Copy the ones on ic-makefile/templates/gf180mcu/
}


patch_klayout_verification () {
    rm -rf $KLAYOUT_HOME/lvs
    rm -rf $KLAYOUT_HOME/drc

    rm -rf $KLAYOUT_HOME/tech/drc
    rm -rf $KLAYOUT_HOME/tech/lvs

    mv globalfoundries-pdk-libs-gf180mcu_fd_pv/klayout/lvs $KLAYOUT_HOME
    mv globalfoundries-pdk-libs-gf180mcu_fd_pv/klayout/drc $KLAYOUT_HOME
    # Add precheck drc
    wget -O $KLAYOUT_HOME/drc/gf180mcuD_mr.drc https://raw.githubusercontent.com/efabless/mpw_precheck/main/checks/tech-files/gf180mcuD_mr.drc
}


export LIBS_TECH=$PDK_ROOT/gf180mcuD/libs.tech
export KLAYOUT_HOME=$PDK_ROOT/gf180mcuD/libs.tech/klayout

python fix-tech-file.py --pdk gf180mcuD $KLAYOUT_HOME/tech/gf180mcu.lyt


patch_xschem_xschemrc
patch_klayout_pymacros

git clone --depth 1 https://github.com/efabless/globalfoundries-pdk-libs-gf180mcu_fd_pr.git /tmp/globalfoundries-pdk-libs-gf180mcu_fd_pr || true
patch_klayout_dropdown_menu

rm -rf /tmp/globalfoundries-pdk-libs-gf180mcu_fd_pr

# git clone --depth 1 https://github.com/efabless/globalfoundries-pdk-libs-gf180mcu_fd_pv.git || true

