#!/bin/bash

set -ex
cd /tmp

# This project is going to have the entire git history so each designer can
# Use different commits

ORFS_REPO_URL=https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
ORFS_NAME=OpenROAD-flow-scripts
ORFS_DIR=$TOOLS/$ORFS_NAME

git clone $ORFS_REPO_URL $ORFS_NAME || true
cd $ORFS_NAME
git checkout $ORFS_REPO_COMMIT

# Avoid klayout incompatibility with klive and -zz
sed -i "s/ -zz / -b /g" flow/Makefile

mv /tmp/$ORFS_NAME $ORFS_DIR
