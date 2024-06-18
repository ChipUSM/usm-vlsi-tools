#!/bin/bash

set -ex

# Need libboost >= 1.78 for OpenROAD
BOOST_VER_MAJ=1
BOOST_VER_MIN=82	
BOOST_BUILD=0
BOOST_VERSION="$BOOST_VER_MAJ.$BOOST_VER_MIN.$BOOST_BUILD"
echo "[INFO] Installing BOOST version $BOOST_VERSION"
cd /tmp
wget --no-verbose https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}.tar.gz
tar -xf boost-${BOOST_VERSION}.tar.gz
cd boost-${BOOST_VERSION}
./bootstrap.sh
./b2 install

echo "[INFO] Cleaning up caches"
rm -rf /tmp/*