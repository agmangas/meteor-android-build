#!/usr/bin/env bash

set -e

apt-get update && apt-get install -y --no-install-recommends bsdtar

TAR_PATH=$(which tar)
TAR_BAK_PATH=${TAR_PATH}-bak
BSDTAR_PATH=$(which bsdtar)

echo "## Overriding tar with bsdtar"
mv ${TAR_PATH} ${TAR_BAK_PATH} && ln -s ${BSDTAR_PATH} ${TAR_PATH}
