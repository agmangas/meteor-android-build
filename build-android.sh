#!/usr/bin/env bash

set -e

: ${APP_PATH:?}
: ${APP_BUILD_PATH:?}
: ${APP_SERVER:?}
: ${KEYSTORE_FILE_PATH:?}
: ${KEYSTORE_KEYPASS:?}
: ${KEYSTORE_STOREPASS:?}
: ${KEYSTORE_ALIAS:?}
: ${ANDROID_HOME:?}

APK_FILE_NAME=${APK_FILE_NAME-"release-signed.apk"}

cd ${APP_PATH}

echo "Installing NPM packages..."

rm -fr ./node_modules && rm -fr ./.meteor/local
npm install

echo "Building Meteor app..."

meteor build ${APP_BUILD_PATH} --server ${APP_SERVER}

echo "Signing and preparing APK for release..."

cd ${APP_BUILD_PATH}

rm app.tar.gz && mv android/release-unsigned.apk ./ && rm -fr android/

jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ${KEYSTORE_FILE_PATH} \
    -keypass ${KEYSTORE_KEYPASS} -storepass ${KEYSTORE_STOREPASS} release-unsigned.apk ${KEYSTORE_ALIAS}

${ANDROID_HOME}/build-tools/*/zipalign 4 release-unsigned.apk ${APK_FILE_NAME}

rm ./release-unsigned.apk

echo "Done!"
