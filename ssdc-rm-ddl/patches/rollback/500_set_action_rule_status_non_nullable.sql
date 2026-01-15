-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK SCRIPT
-- ****************************************************************************
-- Number: 500
-- Purpose: Rollback setting action rule status non-nullable
-- Author: Adam Hawtin
-- ****************************************************************************

ALTER TABLE casev3.action_rule ALTER COLUMN action_rule_status DROP NOT NULL;
