#!/bin/bash

rm build_*.log

# # Really important
# make NO_PULL=Y STAGE=base      build |& tee build_base.log
# make NO_PULL=Y STAGE=builder   build |& tee build_builder.log

# # Everything else
# make NO_PULL=Y STAGE=magic     build |& tee build_magic.log
# make NO_PULL=Y STAGE=openvaf   build |& tee build_openvaf.log
# make NO_PULL=Y STAGE=ngspice   build |& tee build_ngspice.log
# make NO_PULL=Y STAGE=xyce      build |& tee build_xyce.log
# make NO_PULL=Y STAGE=xschem    build |& tee build_xschem.log
# make NO_PULL=Y STAGE=yosys     build |& tee build_yosys.log
# make NO_PULL=Y STAGE=netgen    build |& tee build_netgen.log
# make NO_PULL=Y STAGE=gaw       build |& tee build_gaw.log
# # make NO_PULL=Y STAGE=gtkwave   build |& tee build_gtkwave.log
# make NO_PULL=Y STAGE=openroad  build |& tee build_openroad.log
# make NO_PULL=Y STAGE=iverilog  build |& tee build_iverilog.log
# make NO_PULL=Y STAGE=cvc_rv    build |& tee build_cvc_rv.log
# make NO_PULL=Y STAGE=verilator build |& tee build_verilator.log
# make NO_PULL=Y STAGE=orfs      build |& tee build_orfs.log

# make NO_PULL=Y STAGE=open_pdks build |& tee build_open_pdks.log
# make NO_PULL=Y STAGE=ihp_pdk   build |& tee build_ihp_pdk.log

# make NO_PULL=Y build |& tee build_all.log


clean_useless_information () {
    # Remove stage finishing timpestamp
    sed -i -r 's/(#[0-9]+) (DONE) [.0-9]*[s]/\1 \2/' $1

    # Remove endings with timestamps
    sed -i -r 's/ [.0-9]+s done$//' $1

    # Remove timestamps from substages output
    sed -i -r 's/(#[0-9]+) ([.0-9]+) /\1 /' $1

    sed -i -r '/Updating files: /d' $1

    # Removing make stuff
    sed -i -r '/(#[0-9]+) ([.0-9]+) gcc /d' $1
    sed -i -r '/(#[0-9]+) ([.0-9]+) rm -[rf]+ /d' $1
    sed -i -r '/(#[0-9]+) ([.0-9]+) \/usr\/bin\/ld /d' $1
    sed -i -r '/(#[0-9]+) ([.0-9]+) sed /d' $1

    # Removing Cmake stuff
    sed -i -r '/#[0-9]+ [.0-9]+ \[[ 0-9]+%\] Building C object /d' $1
    sed -i -r '/#[0-9]+ [.0-9]+ \[[ 0-9]+%\] Building CXX object /d' $1
    sed -i -r '/#[0-9]+ [.0-9]+ \[[ 0-9]+%\] Building Fortran object /d' $1
    sed -i -r '/#[0-9]+ [.0-9]+ \[[ 0-9]+%\] Linking C static library /d' $1
    sed -i -r '/#[0-9]+ [.0-9]+ \[[ 0-9]+%\] Linking CXX static library /d' $1

    sed -i -r '/#[0-9]+ Consolidate compiler generated dependencies of target /d' $1
    sed -i -r '/#[0-9]+ -- Installing: /d' $1

    # TODO: Add this filters
    # (Reading database ... 25%
    # #6 Selecting previously unselected package 
    # #6 Preparing to unpack 
    # #6 Unpacking 
}

build_and_filter_logs () {
    make NO_PULL=Y STAGE=$1 build |& tee build_$1.log || true
    clean_useless_information build_$1.log
}

# Really important
build_and_filter_logs base
build_and_filter_logs builder

build_and_filter_logs magic
build_and_filter_logs openvaf
build_and_filter_logs ngspice
build_and_filter_logs xschem
build_and_filter_logs yosys
build_and_filter_logs netgen
build_and_filter_logs gaw
build_and_filter_logs openroad
build_and_filter_logs iverilog
build_and_filter_logs cvc_rv
build_and_filter_logs verilator
build_and_filter_logs orfs
build_and_filter_logs open_pdks

build_and_filter_logs ihp_pdk

make NO_PULL=Y build |& tee build_all.log || true
clean_useless_information build_all.log