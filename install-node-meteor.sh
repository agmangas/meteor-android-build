#!/usr/bin/env bash

set -e

: ${SCRIPTS_PATH:?}

echo "Installing Meteor..."

# Override tar with bsdtar as a temporal fix for:
# https://github.com/docker/hub-feedback/issues/727

bash ${SCRIPTS_PATH}/tar-override.sh
curl https://install.meteor.com/ | sh
bash ${SCRIPTS_PATH}/tar-restore.sh

echo "Installing Node..."

curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs
npm install npm -g
