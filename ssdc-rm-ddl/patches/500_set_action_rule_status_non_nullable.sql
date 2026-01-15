-- ****************************************************************************
-- RM SQL DATABASE INSERT SCRIPT
-- ****************************************************************************
-- Number: 500
-- Purpose: Make the action rule action rule status column non-nullable
-- Author: Adam Hawtin
-- ****************************************************************************

ALTER TABLE casev3.action_rule ALTER COLUMN action_rule_status SET NOT NULL;
