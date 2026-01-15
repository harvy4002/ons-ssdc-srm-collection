#!/bin/sh

# Note: The building of the 'copy_in_tables.sql' file must be built for tables in the following order to avoid primary key conflicts
#       when re-inserting data:
#           1. users
#           2. user_group
#           3. user_group_member
#           4. user_group_admin
#           5. user_group_permission


# Make sure we're working in the right directory
cd groundzero_ddl || true

PSQL_CONNECT_WRITE_MODE="sslmode=verify-ca sslrootcert=/root/.postgresql/root.crt sslcert=/root/.postgresql/postgresql.crt sslkey=/root/.postgresql/postgresql.key hostaddr=$DB_HOST user=rmuser password=${DB_PASSWORD:=password} dbname=$DB_NAME"

# Seeded data IDs - these are seeded data and will be ignored from the restore
RM_SUPPORT_USER_GROUP_ID="b19a77bd-6a02-4851-8116-9e915738b700"
RM_SUPPORT_ACTIONS_USER_GROUP_ID="a25c7f99-d2ce-4267-aea4-0a133028f793"
RM_SUPER_USER_GROUP_ID="8269d75c-bfa1-4930-aca2-10dd9c6a2b42"

# Create the copy in/out files and run the copy out
echo "begin transaction;" > copy_out_tables.sql
echo "begin transaction;" > copy_in_tables.sql

# Copy out the users table data
echo "\copy casev3.users to backup_users.txt;" >> copy_out_tables.sql
echo "\copy casev3.users from backup_users.txt;" >> copy_in_tables.sql

# Copy out the user_group table data. Do not copy user groups which are already seeded with ground zero
echo "\copy (SELECT * FROM casev3.user_group WHERE id NOT IN ('$RM_SUPPORT_USER_GROUP_ID','$RM_SUPPORT_ACTIONS_USER_GROUP_ID', '$RM_SUPER_USER_GROUP_ID')) to backup_user_group.txt;" >> copy_out_tables.sql
echo "\copy casev3.user_group from backup_user_group.txt;" >> copy_in_tables.sql

# Copy out all the non survey specific user_group_member and user_group_admin tables
for TABLE_NAME in user_group_member user_group_admin
do
  echo "\copy casev3.$TABLE_NAME to backup_$TABLE_NAME.txt;" >> copy_out_tables.sql
  echo "\copy casev3.$TABLE_NAME from backup_$TABLE_NAME.txt;" >> copy_in_tables.sql
done

# Only copy the global roles from the user_group_permission table, as survey specific roles will no longer work.
# Also, do not copy user group permissions which are already seeded with ground zero
echo "\copy (select * from casev3.user_group_permission where survey_id is null AND group_id NOT IN ('$RM_SUPPORT_USER_GROUP_ID','$RM_SUPPORT_ACTIONS_USER_GROUP_ID', '$RM_SUPER_USER_GROUP_ID')) to backup_user_group_permission.txt;" >> copy_out_tables.sql
echo "\copy casev3.user_group_permission from backup_user_group_permission.txt;" >> copy_in_tables.sql

echo "commit transaction;" >> copy_out_tables.sql
echo "commit transaction;" >> copy_in_tables.sql

psql "$PSQL_CONNECT_WRITE_MODE" -f copy_out_tables.sql

# Run the ground zero
./rebuild_from_ground_zero.sh

# Restore the tables
psql "$PSQL_CONNECT_WRITE_MODE" -f copy_in_tables.sql

# Remove all table files
for TABLE_NAME in users user_group user_group_permission user_group_member user_group_admin
do
  rm backup_$TABLE_NAME.txt
done

rm copy_out_tables.sql
rm copy_in_tables.sql
