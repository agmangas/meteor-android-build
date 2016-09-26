# Meteor Android Docker image

This repository contains a Docker image to build Cordova-based Android APKs from Meteor projects. It comes with all the necessary dependencies (Android SDK, Meteor and Node).

## Usage

This image requires a couple of inputs from the user:

* The **Meteor app** that needs to be built. It should be placed under the `/app` folder.
* The **keystore** that will be used to sign the APK file. It should be placed on `/keys/keystore`. If you do not mount your own keystore a default one will be used, this could come in handy in a development environment but should **never** be relied on if you're building the APK for production.

The generated APK file will be placed under `/build`. You should mount this volume on your host to be able to actually recover it after the build finishes.

### Configuration variables

Name | Description | Default
--- | --- | ---
`APP_SERVER` | Location where APK builds connect to the Meteor server | *Required*
`KEYSTORE_ALIAS` | Alias of the keypair that will sign the APK | `defaultkey`
`KEYSTORE_KEYPASS` | Password to access the keypair given by the previous alias | `passwd`
`KEYSTORE_STOREPASS` | Password to access the keystore that contains the keypair | `passwd`

### Example commands

The following command builds the Meteor app found on `/path/to/meteor/app` using the default keystore. The APK file is configured to connect to the remote Meteor server found on *example.com*. It will be placed under the host's current working directory.

```
docker run --rm -it -e APP_SERVER=example.com -v /path/to/meteor/app:/app -v $(pwd):/build agmangas/meteor-android-build
```

This does the same as above but uses an externally defined keystore.

```
docker run --rm -it -e APP_SERVER=example.com -e KEYSTORE_ALIAS=myalias -e KEYSTORE_KEYPASS=mykeypass -e KEYSTORE_STOREPASS=mystorepass -v /path/to/keystore:/keys/keystore:ro -v /path/to/meteor/app:/app -v $(pwd):/build agmangas/meteor-android-build
```
