# ssdc-rm-ddl[![Build Status](https://travis-ci.com/ONSdigital/ssdc-rm-ddl.svg?branch=main)](https://travis-ci.com/ONSdigital/ssdc-rm-ddl)

Contains ground zero scripts to create all the RM database tables, as well as a script to update the DDL from the main
branch of the RM components.

## Common Entity Models

This project houses a sub repo, [ssdc-rm-common-entity-models](ssdc-rm-common-entity-model). This contains the Java
Hibernate ORM models of our database entities, shared by our Java services. This sub repo is built into a JAR artifact
which is imported by our services.

Our database schema definitions are then generated from these Hibernate models.

**AFTER EDITING THE JAVA HIBERNATE MODELS, THE DDL _MUST_ BE REGENERATED**

Refer to [Building the DDL](#building-the-ddl), the generated schemas must be regenerated after any changes to the Java
models. If the schemas have changes, a migration script must also be written, refer
to [Patching a database](#patching-a-database).

### Versioning and Release Process

#### Overall version

The overall version of the DDL is managed automatically by our CI.

#### Schema version

The versioning of the DDL schema must managed manually, and updated in
the [ddl_version.sql](groundzero_ddl/ddl_version.sql) DDL and the [patch database script](patch_database.py)

#### Common Entity Version

The common entity version must be managed manually, changes to
the [ssdc-rm-common-entity-model](ssdc-rm-common-entity-model) must also include a version bump to the `project.version`
in the [pom.xml](ssdc-rm-common-entity-model/pom.xml) file.

## Building the DDL

To regenerate the DDL and build everything you need locally, run:

```shell
make dev-build
```

**It's very important that the DDL script to build ground zero is run, instead of manually editing the files in
the [groundzero_ddl](groundzero_ddl) directory, so that the database is always perfectly in sync with the code on the
master branch.**

### UAC QID and Exception Manager Schemas

The UAC QID and Exception Manager services have their own schemas, independent of the common entities schema defined in
this repository. This repo also handles generating these schema definitions by pulling the services code and using it's
hibernate models.

If you have made changes to Exception Manager or the UAC-QID Service and you need to re-generate the ground zero DDL,
you can specify specific branches with the following options:

- `UAC_QID_SERVICE_BRANCH`
- `EXCEPTION_MANAGER_BRANCH`

For example, you might want to run `UAC_QID_SERVICE_BRANCH=example-branch make dev-build` to get the groundzero DDL to
be generated for an as-yet unmerged branch called `example-branch`.

Once you have run `make dev-build` you will be able to see any differences between the old and the new DDL in Git, and
create patch script(s) accordingly.

## Patching a database

The script `patch_database.py` is used by RM to run database patches from a tagged release of this repository. This
script is invoked from our pipelines and will run in a Kubernetes pod to apply any database patches from files in the
tagged release version of this repository.

The database schema version number and patch numbers must then be updated in [patch_database.py](patch_database.py)
and [groundzero_ddl/ddl_version.sql](groundzero_ddl/ddl_version.sql), so that the patch script is aware of the current
schema version.

### Writing patches

**Patch scripts need to be very carefully considered and tested**; bear in mind they will be automatically run against a
production database during a release. They must be carefully manually tested with data, the unit tests are there to
prove they can run, but provide no assurance that they are safe for the data. `DELETE` statements must be avoided, and
row `UPDATE`s must be **very** carefully considered.

Data patches are better suited to running manually, so that they can be tested in a transaction and rolled back if the
result is not as expected. Breaking changes, such as adding a new mandatory column must be done in stages, for example,
add a new column without constraints, run manual data patches to populate it as required, then deploy another patch to
apply the required constraints once the data will already satisfy them.

#### Seeded data

We use the DDL to seed certain bits of data that we wish to always be set up consistently in our environments, such as
export file and email templates and permission groups. Whereever these rows are inserted, care must be taken to ensure
conflicts are handled for example by using the `ON CONFLICT DO UPDATE SET` syntax to update conflicting rows in place.

### Testing patch scripts

The patch scripts can be tested by running our dev-common-postgres docker image from the latest main branch build, then
running the database patches against it.

If you have rebuilt the dev-common-postgres image locally it will already be on the updated schema version, so the tests
will pull the latest dev common image before running.

Test running your patches with:

```shell
make test-patches
```

And you should see the logs from the patch script indicating it has run the patch script to update the database.

**NOTE:** This test simply verifies that the patches are valid SQL which can run against our schemas, the actual change
they make and it's consistency with the schema change must still be carefully reviewed.

### Rollbacks

Every patch SQL file in [patches](patches) must be accompanied by a rollback script of the same name which undoes the
change, located in [patches/rollback](patches/rollback).

#### Running rollbacks

**NOTE:** Rollbacks will likely be destructive, and can only be safely run the window after deploying a database update,
but before any further activity is allowed in the system. Once the system has been run after applying a patch, rollbacks
cannot be safely run and any issues must be fixed by new fix patches instead.

A script is included to run database rollbacks: [rollback_database.py](rollback_database.py).

Usage (within the ddl pod):

```shell
python rollback_database.py -n <NUM_OF_PATCHES_TO_ROLLBACK> -v <ROLLBACK_VERSION>
```

This will attempt to roll back the given number of patches, and update the ddl version record with the given rollback
version, which must be in the format `v*.*.*-rollback.*`.

By default, it will display the scripts it plans to run and ask for user confirmation to proceed, this is an opportunity
to double-check the rollback before it is run and committed so careful attention should be taken to review what it plans
to run before approving. However, for use in testing or development scripts, this confirmation can be automatically
bypassed with the `--auto-confirm` flag.

#### Testing rollback scripts

Running `make test-patches` will also attempt to run the rollbacks for any patches it runs. If a rollback script for a
new patch is missing, it should fail. However, as with the patches, it does not test the results of the rollback, so
care must still be taken to check the rollback scripts perform the correct action.

If you want to manually test rollbacks locally (to see the user confirmation dialogue, for example), then so long as you
have some local patches and rollbacks which are not built on main branch, you can do this by running:

```shell
make dev-postgres-down dev-postgres-up wait-for-docker-postgres run-test-patches
```

To start up the dev postgres and run the patches into it, then run the rollback script with:

```shell
DB_PORT=16432 pipenv run python rollback_database.py -n <NUMBER OF PATCHES> -v <ROLLBACK VERSION>
```

## Dev Common Postgres Image

This repo also houses a dockerfile for building our [dev postgres image](dev-common-postgres-image), based on the
postgres docker image but initialised with our schemas for dev convenience in local testing. This requires it's own,
combined init SQL script which is also re-generated when you run `make dev-build`, which also locally builds the image.

This image comes with seeded data for Support Tool UI groups.
