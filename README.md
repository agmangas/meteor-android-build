# Meteor Android Docker image

This repository contains a Docker image with an environment prepared to build Cordova-based Android APKs from Meteor projects. It has been tested and should work with both Meteor 1.3 and 1.4. 

Please make sure you've actually added the `android` platform to your Meteor app using the `meteor add-platform` command or the build process will fail.

## Usage

This image requires a couple of inputs from the user:

* The **Meteor app** that needs to be built. It should be mounted on `/app`.
* The **keystore** that will be used to sign the APK file. It should be mounted on `/keys/keystore`. If you do not mount your own keystore the image will use a default one created on image build.

> Using the default keystore could come in handy in a development environment but should **never** be relied on when building the app for production.

The generated APK file will be placed under `/build`. You should mount this volume on your host to be able to actually recover it after the build finishes.

### Configuration variables

Name | Description | Default
--- | --- | ---
`APP_SERVER` | Location where mobile builds connect to the Meteor server | *Required*
`KEYSTORE_ALIAS` | Alias of the keypair that will sign the APK | `defaultkey`
`KEYSTORE_KEYPASS` | Password to access the keypair given by the previous alias | `passwd`
`KEYSTORE_STOREPASS` | Password to access the keystore that contains the keypair | `passwd`

### Example commands

The following command builds the Meteor app found on `/path/to/meteor/app` using the default keystore. The APK file is configured to connect to the remote Meteor server found on *example.com*. It will be placed under the host's current working directory.

```
docker run --rm -it -e APP_SERVER=example.com -v /path/to/meteor/app:/app -v $(pwd):/build agmangas/meteor-android-build
```

This does the same as above but uses an externally defined keystore located on `/path/to/keystore`.

```
docker run --rm -it -e APP_SERVER=example.com -e KEYSTORE_ALIAS=myalias -e KEYSTORE_KEYPASS=mykeypass -e KEYSTORE_STOREPASS=mystorepass -v /path/to/keystore:/keys/keystore:ro -v /path/to/meteor/app:/app -v $(pwd):/build agmangas/meteor-android-build
```
