#!/bin/bash

set -ex

export KLAYOUT_HOME=$TOOLS/klayout/download
export KLAYOUT_PATH=$KLAYOUT_HOME:$KLAYOUT_PATH
klayout -t -ne -rr -b -y klive