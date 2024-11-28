#!/bin/bash

set -x

export KLAYOUT_HOME=$TOOLS/klayout/download
mkdir -p $KLAYOUT_HOME

COUNTER=15

klayout -t -ne -rr -b -y klive
klayout -t -ne -rr -b -y gdsfactory
klayout -t -ne -rr -b -y xsection

until [[ "$?" == "0" || $COUNTER -lt 0 ]]
do
    sleep 1
    ((COUNTER--))
    klayout -t -ne -rr -b -y klive
    klayout -t -ne -rr -b -y gdsfactory
    klayout -t -ne -rr -b -y xsection
done

if [[ "$COUNTER" == "0" ]]; then
    exit 1
fi