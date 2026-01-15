#!/bin/sh

rm dev-common-postgres-image/init.sql || true
set -e
{
echo "-- THIS FILE IS AUTO-GENERATED"
echo "-- DO NOT EDIT IT DIRECTLY"
echo "-- REFER TO THE README FOR INSTRUCTIONS ON REGENERATING IT"
cat dev-common-postgres-image/dev-init.sql
echo ""
echo "create schema if not exists casev3;"
echo "set schema 'casev3';"
cat groundzero_ddl/casev3.sql
echo ""
echo "create schema if not exists uacqid;"
echo "set schema 'uacqid';"
cat groundzero_ddl/uacqid.sql
echo ""
echo "create schema if not exists exceptionmanager;"
echo "set schema 'exceptionmanager';"
cat groundzero_ddl/exceptionmanager.sql
echo ""
echo "create schema if not exists ddl_version;"
echo "set schema 'ddl_version';"
cat groundzero_ddl/ddl_version.sql
echo ""
echo "-- Seed Support Tool UI permissions"
cat ui-permissions/RM-support-permissions.sql
echo ""
echo "-- Seed packcode templates"
echo "-- Export File Templates"
cat groundzero_ddl/packcode_templates/export_file_templates.sql
echo ""
echo "-- Email Template"
cat groundzero_ddl/packcode_templates/email_templates.sql
} > dev-common-postgres-image/init.sql
