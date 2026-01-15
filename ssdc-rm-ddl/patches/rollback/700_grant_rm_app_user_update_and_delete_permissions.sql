-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK SCRIPT
-- ****************************************************************************
-- Number: 700
-- Purpose: Rollback grant update and delete permissions to rm app user
-- Author: Ryan Grundy
-- ****************************************************************************

REVOKE UPDATE, DELETE ON casev3.collection_exercise FROM rm_app_user;
REVOKE UPDATE, DELETE ON casev3.survey FROM rm_app_user;
REVOKE DELETE ON casev3.action_rule FROM rm_app_user;