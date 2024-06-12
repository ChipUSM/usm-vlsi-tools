#!/bin/bash

set -ex


####################
# INSTALL IHP-SG13G2
####################

IHP_PDK="ihp-sg13g2"
MY_PDK="sg13g2"

git clone "$IHP_PDK_REPO_URL" ihp
cd ihp
git checkout $IHP_PDK_REPO_COMMIT


# Some modifications/cleanup needed of stock IHP PDK
# 1) Remove the `pre_osdi` line from the examples
find . -name "*.sch" -exec sed -i '/pre_osdi/d' {} \;


mkdir -p "$PDK_ROOT"
mv ihp-sg13g2 "$PDK_ROOT/sg13g2"

####################
# Compile .va models
####################
cd "$PDK_ROOT/sg13g2/libs.tech/ngspice/openvaf"

# Compile the PSP model
OPENVAF_VERSION=$(ls "$TOOLS/$OPENVAF_NAME")
openvaf psp103_nqs.va
