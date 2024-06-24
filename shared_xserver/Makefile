TOP?=ihp-verification.spice

SPICE_FILE=$(realpath $(TOP))
SPICE_DIR=$(dir $(SPICE_FILE))
BASE_NAME=$(basename $(TOP))
SPICE_NAME=$(basename $(notdir $(SPICE_FILE)))
RAW_FILE=$(SPICE_NAME).raw

PDK_ROOT=/opt/pdks

all: print

print:
	@echo TOP: ............... $(TOP)
	@echo SPICE_FILE: ........ $(SPICE_FILE)
	@echo SPICE_DIR: ......... $(SPICE_DIR)
	@echo BASE_NAME: ......... $(BASE_NAME)
	@echo SPICE_NAME: ........ $(SPICE_NAME)
	@echo RAW_FILE: .......... $(RAW_FILE)


test-env-py:
	python3 eval.py $(RAW_FILE)


sim:
	SPICE_USERINIT_DIR=$(SPICE_DIR) ngspice -b -o $(SPICE_NAME).log -r $(RAW_FILE) -a $(SPICE_FILE)


test-sky130:
	PDK=sky130A make TOP=sky130-verification/sky130-verification.spice sim
	grep "freq = 1.381854e+08" sky130-verification.log

test-ihp:
	PDK=sg13g2  make TOP=ihp-verification/ihp-verification.spice sim
	grep "psrr                =  -6.152994e+0" ihp-verification.log
