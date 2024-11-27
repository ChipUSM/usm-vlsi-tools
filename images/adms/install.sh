#!/bin/bash

set -eux

cd /tmp

sudo apt-get install build-essential automake libtool gperf flex bison libxml2 libxml2-dev libxml-libxml-perl libgd-perl

sh bootstrap.sh
./configure
make install
