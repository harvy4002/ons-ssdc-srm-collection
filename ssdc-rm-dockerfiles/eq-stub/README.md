# EQ Stub Image

This image provides a minimal stub of EQ endpoints required by RM services. Note that the stub uses an in memory call
log so is only suitable to be run as a single stateful instance.

## Build

Build a new image by running:

```sh
make eq-stub
```

## Usage

Start the emulator image with

```shell
make docker-run
```

This will start the stub locally on port `8918`.

Stop it with 

```shell
make down
```

### API Endpoints

#### POST `/flush`

Stubs the EQ `/flush` endpoint for flushing partial questionnaires downstream. The stub endpoint expects a `token` query
parameter but does not attempt to decrypt or validate the token, it is just stored with a timestamp in the in memory
call log.

#### GET `/log/flush`

Returns the current cache of recorded calls for the `/flush` endpoint

#### GET `/log/reset`

Clears the in memory call log
