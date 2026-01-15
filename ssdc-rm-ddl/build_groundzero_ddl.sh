#!/bin/bash
set -e
rm groundzero_ddl/casev3.sql
rm groundzero_ddl/uacqid.sql
rm groundzero_ddl/exceptionmanager.sql
rm -rf git_cloned_src
rm -rf temp_clone

mkdir temp_clone
pushd temp_clone || exit 1

if [ -z "$SAMPLE_VALIDATION_BRANCH" ]; then
  git clone git@github.com:ONSdigital/ssdc-shared-sample-validation.git
else
  echo "Cloning Sample Validation branch $SAMPLE_VALIDATION_BRANCH"
  git clone --branch "$SAMPLE_VALIDATION_BRANCH" git@github.com:ONSdigital/ssdc-shared-sample-validation.git
fi

if [ -z "$UAC_QID_SERVICE_BRANCH" ]; then
  git clone git@github.com:ONSdigital/ssdc-rm-uac-qid-service.git
else
  echo "Cloning UAC QID Service branch $UAC_QID_SERVICE_BRANCH"
  git clone --branch "$UAC_QID_SERVICE_BRANCH" git@github.com:ONSdigital/ssdc-rm-uac-qid-service.git
fi

if [ -z "$EXCEPTION_MANAGER_BRANCH" ]; then
  git clone git@github.com:ONSdigital/ssdc-rm-exception-manager.git
else
  echo "Cloning Exception Manager branch $EXCEPTION_MANAGER_BRANCH"
  git clone --branch "$EXCEPTION_MANAGER_BRANCH" git@github.com:ONSdigital/ssdc-rm-exception-manager.git
fi

popd || exit 1

mkdir -p git_cloned_src/uk/gov/ons/ssdc/common/model/entity
cp ssdc-rm-common-entity-model/src/main/java/uk/gov/ons/ssdc/common/model/entity/* git_cloned_src/uk/gov/ons/ssdc/common/model/entity

mkdir -p git_cloned_src/uk/gov/ons/ssdc/common/validation
cp temp_clone/ssdc-shared-sample-validation/src/main/java/uk/gov/ons/ssdc/common/validation/* git_cloned_src/uk/gov/ons/ssdc/common/validation

mkdir -p git_cloned_src/uk/gov/ons/ssdc/uacqid/model/entity
cp temp_clone/ssdc-rm-uac-qid-service/src/main/java/uk/gov/ons/ssdc/uacqid/model/entity/*.java git_cloned_src/uk/gov/ons/ssdc/uacqid/model/entity

mkdir -p git_cloned_src/uk/gov/ons/ssdc/exceptionmanager/model/entity
cp temp_clone/ssdc-rm-exception-manager/src/main/java/uk/gov/ons/ssdc/exceptionmanager/model/entity/*.java git_cloned_src/uk/gov/ons/ssdc/exceptionmanager/model/entity

rm -rf temp_clone

mvn clean package

rm -rf git_cloned_src

java -jar target/ssdc-rm-ddl-1.0-SNAPSHOT.jar casev3 uk.gov.ons.ssdc.common.model.entity
java -jar target/ssdc-rm-ddl-1.0-SNAPSHOT.jar uacqid uk.gov.ons.ssdc.uacqid.model.entity
java -jar target/ssdc-rm-ddl-1.0-SNAPSHOT.jar exceptionmanager uk.gov.ons.ssdc.exceptionmanager.model.entity

./build_init_script.sh

pushd dev-common-postgres-image || exit 1
docker build . -t europe-west2-docker.pkg.dev/ssdc-rm-ci/docker/ssdc-rm-dev-common-postgres:latest
popd || exit 1
