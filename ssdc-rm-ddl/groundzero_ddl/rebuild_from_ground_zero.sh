#!/bin/bash

# Make sure we're working in the right directory
cd groundzero_ddl || true

PSQL_CONNECT_WRITE_MODE="sslmode=verify-ca sslrootcert=/root/.postgresql/root.crt sslcert=/root/.postgresql/postgresql.crt sslkey=/root/.postgresql/postgresql.key hostaddr=$DB_HOST user=rmuser password=${DB_PASSWORD:=password} dbname=$DB_NAME"

psql "$PSQL_CONNECT_WRITE_MODE" -v "ON_ERROR_STOP=1" -f destroy_schemas.sql || exit 1

# Create schema
for SCHEMA_NAME in casev3 uacqid exceptionmanager ddl_version
do
  {
  echo "begin transaction;"
  echo "create schema if not exists $SCHEMA_NAME;"
  echo "set schema '$SCHEMA_NAME';"
  cat "$SCHEMA_NAME.sql"
  echo "commit transaction;"
  } > "tmp_transaction_$SCHEMA_NAME.sql"

  psql "$PSQL_CONNECT_WRITE_MODE" -f "tmp_transaction_$SCHEMA_NAME.sql"
  rm "tmp_transaction_$SCHEMA_NAME.sql"
done


# Create roles
pushd roles || exit 1
for ROLE_PERMISSIONS_SCRIPT in *.sql;
do
  {
  echo "begin transaction;"
  cat "$ROLE_PERMISSIONS_SCRIPT"
  echo "commit transaction;"
  } > "tmp_transaction_$ROLE_PERMISSIONS_SCRIPT"

  psql "$PSQL_CONNECT_WRITE_MODE" -f "tmp_transaction_$ROLE_PERMISSIONS_SCRIPT"
  rm "tmp_transaction_$ROLE_PERMISSIONS_SCRIPT"
done
popd || exit 1

# Create indexes
psql "$PSQL_CONNECT_WRITE_MODE" -f indexes/GIN_indexes_applied_by_groundzero.sql

# Seed the packcode templates
psql "$PSQL_CONNECT_WRITE_MODE" -f packcode_templates/export_file_templates.sql
psql "$PSQL_CONNECT_WRITE_MODE" -f packcode_templates/email_templates.sql

# Create RM Support UI permissions
pushd ../ui-permissions || exit 1
psql "$PSQL_CONNECT_WRITE_MODE" -f RM-support-permissions.sql

# Create the ATs UI user entry if an email is specified
if [ -n "$ACCEPTANCE_TESTS_EMAIL" ]; then
  sed -e "s/\$ACCEPTANCE_TESTS_EMAIL/$ACCEPTANCE_TESTS_EMAIL/" acceptance-tests-service-account.sql > tmp_acceptance-tests-service-account.sql
  psql "$PSQL_CONNECT_WRITE_MODE" -f tmp_acceptance-tests-service-account.sql
fi

popd || exit 1

