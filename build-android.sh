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
TMP_APP_PATH=/tmp/app
TMP_BUILD_PATH=/tmp/build

echo "Launching mobile build..."

mkdir -p ${TMP_APP_PATH}
mkdir -p ${TMP_BUILD_PATH}

cd ${TMP_APP_PATH}

cp -rp ${APP_PATH}/. ./

echo "Installing NPM packages..."

rm -fr ./node_modules && rm -fr ./.meteor/local
npm install

echo "Building Meteor app..."

meteor build --allow-superuser ${TMP_BUILD_PATH} --server ${APP_SERVER}

cd ${TMP_BUILD_PATH}

echo "Signing and preparing APK for release..."

APK_UNSIGNED_FILE_NAME=$(ls ./android | grep ".apk" | head -n 1)

mv ./android/${APK_UNSIGNED_FILE_NAME} ./

jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
    -keystore ${KEYSTORE_FILE_PATH} -keypass ${KEYSTORE_KEYPASS} \
    -storepass ${KEYSTORE_STOREPASS} ${APK_UNSIGNED_FILE_NAME} ${KEYSTORE_ALIAS}

${ANDROID_HOME}/build-tools/*/zipalign 4 ${APK_UNSIGNED_FILE_NAME} ${APK_FILE_NAME}

mv ./${APK_FILE_NAME} ${APP_BUILD_PATH}

cd ${APP_BUILD_PATH}

rm -fr ${TMP_APP_PATH}
rm -fr ${TMP_BUILD_PATH}

echo "Done!"
