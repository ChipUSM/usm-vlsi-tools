SHELL :=  /usr/bin/bash

all:
	Xyce dc_res_temp.spice |& tee out.log
	grep "Number Successful Steps Taken" out.log
