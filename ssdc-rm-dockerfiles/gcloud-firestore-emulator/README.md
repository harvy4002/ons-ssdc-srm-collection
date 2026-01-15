# Google Cloud Firestore Emulator Image

[*Google Firestore*](https://cloud.google.com/firestore/) is a flexible, scalable No SQL database service.

This image provides a dockerized version of the *Google Cloud Firestore Emulator*. It is intended to be used as a service on development environments (it **SHOULD NOT** be used in production environments). You can check *Firestore* documentation on [Google Cloud Platform Firestore documentation website](https://firebase.google.com/docs/firestore).

## Build
Build a new image by running:

```sh
docker build . -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/gcloud-firestore-emulator:latest
```

## Usage
The following shell statement show the most simple execution of the provided image. It will execute the *Firestore Emulator* that will listen on port 8540.

```sh
docker run --rm --tty --interactive --publish 8540:8540 europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/gcloud-firestore-emulator
```
