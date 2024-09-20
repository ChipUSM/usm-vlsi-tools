#!/bin/bash

rm build_*.log

# Really important
make NO_PULL=Y STAGE=base      build |& tee build_base.log
make NO_PULL=Y STAGE=builder   build |& tee build_builder.log

# Everything else
make NO_PULL=Y STAGE=magic     build |& tee build_magic.log
make NO_PULL=Y STAGE=openvaf   build |& tee build_openvaf.log
make NO_PULL=Y STAGE=ngspice   build |& tee build_ngspice.log
make NO_PULL=Y STAGE=xschem    build |& tee build_xschem.log
make NO_PULL=Y STAGE=yosys     build |& tee build_yosys.log
make NO_PULL=Y STAGE=netgen    build |& tee build_netgen.log
make NO_PULL=Y STAGE=openroad  build |& tee build_openroad.log
make NO_PULL=Y STAGE=iverilog  build |& tee build_iverilog.log
make NO_PULL=Y STAGE=cvc_rv    build |& tee build_cvc_rv.log
make NO_PULL=Y STAGE=verilator build |& tee build_verilator.log
make NO_PULL=Y STAGE=orfs      build |& tee build_orfs.log

make NO_PULL=Y STAGE=open_pdks build |& tee build_open_pdks.log
make NO_PULL=Y STAGE=ihp_pdk   build |& tee build_ihp_pdk.log

make NO_PULL=Y build |& tee build_all.log