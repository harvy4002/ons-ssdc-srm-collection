-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK INSERT SCRIPT
-- ****************************************************************************
-- Number: 400
-- Purpose: Rollback adding a status for the Action Rules
-- Author: Kacper Prywata
-- ****************************************************************************

ALTER TABLE casev3.action_rule DROP COLUMN action_rule_status;
