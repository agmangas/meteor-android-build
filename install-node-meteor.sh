#!/usr/bin/env bash

set -e

echo "Installing Meteor..."

curl https://install.meteor.com/ | sh

echo "Installing Node..."

curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs
npm install npm -g
