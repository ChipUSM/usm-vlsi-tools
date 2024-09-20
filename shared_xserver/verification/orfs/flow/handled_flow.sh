#!/bin/bash

set -x

# This file should be copied on the flow directory

CMAKE_PACKAGE_ROOT_ARGS="$CMAKE_PACKAGE_ROOT_ARGS -D SWIG_ROOT=/opt/common -D Eigen3_ROOT=/opt/common -D GTest_ROOT=/opt/common -D LEMON_ROOT=/opt/common -D spdlog_ROOT=/opt/common -D ortools_ROOT=/opt/common"
PATH="/opt/common/bin:$PATH"
LD_LIBRARY_PATH="/opt/common/lib64:/opt/common/lib:$LD_LIBRARY_PATH"

export ORFS_DIR=opt/OpenROAD-flow-scripts
export OPENROAD_EXE=$(realpath /opt/openroad/*/bin/openroad)
export YOSYS_EXE=$(realpath /opt/yosys/*/bin/yosys)
export YOSYS_CMD=$(realpath /opt/yosys/*/bin/yosys)
export OPENSTA_EXE=$(realpath /opt/openroad/*/bin/sta)

# Delete results and logs, among other things
clean_flow () {
    sudo make nuke
}

# Remove every line that holds non-deterministic output related to performance
remove_timestamps () {
    file=$1

    sed -i '/^End of script. Logfile hash/d' $file
    sed -i '/^Elapsed time: /d' $file
    sed -i '/^Time spent: /d' $file
    sed -i '/^\[INFO DRT-0267\] cpu time = /d' $file
    sed -i '/^    elapsed time = /d' $file
}

# Fix the incompatibility with klive
# TODO: Test if this is the problem.
sed -i "s/ -zz / -b /g" Makefile


# IMPORTANT!!!!
# I'm using something like a multiline comment on bash to define various tests
# This should allow us to make repeatable evaluations of the outputs

# EXPLANATION!!!!
# <<'###STUFF' creates a heredoc redirected to nothing, ignoring the content.
# https://stackoverflow.com/questions/43158140/way-to-create-multiline-comments-in-bash

# <<'###BLOCK-COMMENT'
clean_flow
make |& tee test1_step_all_1.log
make |& tee test1_step_all_2.log
remove_timestamps test1_step_all_1.log
remove_timestamps test1_step_all_2.log

# La primera ejecución falla en el paso do-6_report con el siguiente mensaje:

#     ==========================================================================
#     finish report_design_area
#     --------------------------------------------------------------------------
#     Design area 813 u^2 71% utilization.
#     [ERROR GUI-0077] QStandardPaths: error creating runtime directory '/run/user/1000' (No such file or directory)
#     Error: final_report.tcl, 70 GUI-0077
#     Command exited with non-zero status 1
#     Elapsed time: 0:01.59[h:]min:sec. CPU time: user 0.52 sys 0.03 (35%). Peak memory: 141896KB.
#     make[1]: *** [Makefile:889: do-6_report] Error 1
#     make: *** [Makefile:888: logs/nangate45/gcd/base/6_report.log] Error 2


# La segunda ejecución retorna la salida esperada. A continuación el texto inicial

#     cp ./results/nangate45/gcd/base/5_route.sdc ./results/nangate45/gcd/base/6_final.sdc
#     cp /home/designer/shared/verification/orfs/flow/platforms/nangate45/lef/NangateOpenCellLibrary.tech.lef ./objects/nangate45/gcd/base/klayout_tech.lef
#     SC_LEF_RELATIVE_PATH="$\(env('FLOW_HOME')\)/platforms/nangate45/lef/NangateOpenCellLibrary.macro.mod.lef"; \
#     OTHER_LEFS_RELATIVE_PATHS=$(echo "<lef-files>$(realpath --relative-to=./results/nangate45/gcd/base ./objects/nangate45/gcd/base/klayout_tech.lef)</lef-files>"); \
#     sed 's,<lef-files>.*</lef-files>,<lef-files>'"$SC_LEF_RELATIVE_PATH"'</lef-files>'"$OTHER_LEFS_RELATIVE_PATHS"',g' /home/designer/shared/verification/orfs/flow/platforms/nangate45/FreePDK45.lyt > ./objects/nangate45/gcd/base/klayout.lyt
#     (/usr/bin/time -f 'Elapsed time: %E[h:]min:sec. CPU time: user %U sys %S (%P). Peak memory: %MKB.' stdbuf -o L /usr/bin/klayout -b -rd design_name=gcd \
#             -rd in_def=./results/nangate45/gcd/base/6_final.def \
#             -rd in_files="/home/designer/shared/verification/orfs/flow/platforms/nangate45/gds/NangateOpenCellLibrary.gds  " \
#             -rd seal_file="" \
#             -rd out_file=./results/nangate45/gcd/base/6_1_merged.gds \
#             -rd tech_file=./objects/nangate45/gcd/base/klayout.lyt \
#             -rd layer_map= \
#             -r /home/designer/shared/verification/orfs/flow/util/def2stream.py) 2>&1 | tee ./logs/nangate45/gcd/base/6_1_merge.log
#     [INFO] Reporting cells prior to loading DEF ...
#     [INFO] Reading DEF ...
#     [INFO] Clearing cells...
#     [INFO] Merging GDS/OAS files...

# El problema es que la primera linea de la segunda ejecución no aparece en los logs 
# de la primera, lo que indica que un paso no está siendo ejecutado.

# Esto es problemático, ya que no estamos seguros de que funcione correctamente.
###BLOCK-COMMENT

# <<'###BLOCK-COMMENT'
clean_flow
make do-6_report |& tee test2_step_do-6_report.log
remove_timestamps test2_step_do-6_report.log

# Además de el banner de openroad, indica lo siguiente

#     [INFO ORD-0030] Using 4 thread(s).
#     mkdir -p ./objects/nangate45/gcd/base
#     Running final_report.tcl, stage 6_report
#     bash: line 1: ./logs/nangate45/gcd/base/6_report.tmp.log: No such file or directory
#     mv: cannot stat './logs/nangate45/gcd/base/6_report.tmp.log': No such file or directory
#     make: *** [Makefile:889: do-6_report] Error 1

# No entrega mucha información relevante
###BLOCK-COMMENT

# <<'###BLOCK-COMMENT'
clean_flow
make finish  |& tee test3-step-finish-1.log
make finish  |& tee test3-step-finish-2.log
remove_timestamps test3-step-finish-1.log
remove_timestamps test3-step-finish-2.log

# Son lo mismo que la primera iteración. Unicamente diferencias temporales
###BLOCK-COMMENT

# <<'###BLOCK-COMMENT'
clean_flow
make synth floorplan place cts route |& tee test4-route.log
make synth finish |& tee test4-step-finish-1.log
make synth finish |& tee test4-step-finish-2.log
remove_timestamps test4-route.log
remove_timestamps test4-step-finish-1.log
remove_timestamps test4-step-finish-2.log

# Cosas interesantes de este experimento:

# 1. La salida de la primera linea tiene concordancia con lo hecho por "make" directamente?
# La diferencia está al final del archivo test4-route.log, porque comienza la acción de la etapa 6.
# Por ejemplo, la copia de archivos .odb y .sdc, antes del inicio de 

#     Running final_report.tcl, stage 6_report

# 2. La primera iteración de finish es similar al final de "make"?

# La forma sencilla de hacer esto es concatenando ambos archivos route y finish-1
# No hay diferencia, es prácticamente lo mismo.

# 3. finish-2 es equivalente a ejecutar make por segunda vez?
# Si, el mismo caso del punto 2.

# Entonces, el problema está acotado a la etapa finish.

# 4. Las etapas finish-1 y finish-2 son similares?
# Son diferentes, definitivamente hay algo que no se está ejecutando.

#     .PHONY: finish
#     finish: $(LOG_DIR)/6_report.log \
#             $(RESULTS_DIR)/6_final.v \
#             $(RESULTS_DIR)/6_final.sdc \
#             $(RESULTS_DIR)/6_final.gds
#         $(UNSET_AND_MAKE) elapsed

# Cuando los archivos existen, hay etapas que son omitidas.
# Hay que verificar que archivo es el que está incompleto.

# En la carpeta de resultados: 
# - 6_final.v     No se de donde sale...
# - 6_final.sdc   finish-2: Se copia en la primera línea
# - 6_final.gds   finish-2: Linea 27, se copia directo de 6_1_merged.gds

# En carpeta de logs:

# - 6_report.json
# - 6_1_merge.log
# - 6_report.log      Este contiene el log del error final_report.tcl. Al parecer el log se crea 
#                     igualmente, por eso este problema ocurre.

# El gran problema entonces es que el archivo 6_report.log se genera en un proceso 
# que no necesariamente termina correctamente.
# La solución sería que no se ocupe un .log para asegurar que un paso funciona, 
# sino que un archivo vacío creado con touch o algo así.

# La gran pregunta: PORQUÉ FALLA ESE PASO
# Posiblemente haya que revisar final_report.tcl

###BLOCK-COMMENT
