-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK INSERT SCRIPT
-- ****************************************************************************
-- Number: 300
-- Purpose: Rollback adding a description for the Action Rules
-- Author: Kacper Prywata
-- ****************************************************************************

ALTER TABLE casev3.action_rule DROP COLUMN description;
