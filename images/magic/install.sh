#!/bin/bash

set -ex
set -u

git clone --filter=blob:none $MAGIC_REPO_URL $MAGIC_NAME || true

cd $MAGIC_NAME
git checkout $MAGIC_REPO_COMMIT

./configure --prefix="${TOOLS}/${MAGIC_NAME}"
make database/database.h
make -j"$(nproc)"
make install