# Google Cloud SDK Terraform Image

This image is based on the [Google cloud-sdk:slim](https://hub.docker.com/r/google/cloud-sdk/) base image from google,
with [tfenv](https://github.com/tfutils/tfenv) and and initial [Terraform](https://www.terraform.io/cli) version
installed.

It is intended as a utility image for use in Concourse tasks which require the Terraform CLI.

## Build

Build a new image by running:

```shell
make cloud-sdk-terraform
```

from the project root directory.

## Usage

This image is intended for use in concourse jobs, not locally.

It provides the tfenv tool, and an initial version of terraform. This allows installation of required Terraform version
at runtime, though using the pre-installed version should be preferred whenever possible.
