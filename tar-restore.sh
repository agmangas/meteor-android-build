#!/usr/bin/env bash

set -e

TAR_PATH=$(which tar)
TAR_BAK_PATH=${TAR_PATH}-bak

if [ -f ${TAR_BAK_PATH} ]; then
    echo "## Restoring tar"
    rm ${TAR_PATH}
    mv ${TAR_BAK_PATH} ${TAR_PATH}
fi
