#!/bin/bash

wget -nv -O klayout_installer.deb "${KLAYOUT_DOWNLOAD}"
dpkg -i klayout_installer.deb

rm klayout_installer.deb