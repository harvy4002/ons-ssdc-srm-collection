-- ****************************************************************************
-- RM SQL DATABASE INSERT SCRIPT
-- ****************************************************************************
-- Number: 700
-- Purpose: Grant update and delete permissions to rm app user
-- Author: Ryan Grundy
-- ****************************************************************************

GRANT UPDATE, DELETE ON casev3.collection_exercise TO rm_app_user;
GRANT UPDATE, DELETE ON casev3.survey TO rm_app_user;
GRANT DELETE ON casev3.action_rule TO rm_app_user;