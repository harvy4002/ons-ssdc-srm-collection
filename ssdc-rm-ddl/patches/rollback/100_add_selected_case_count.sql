-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK INSERT SCRIPT
-- ****************************************************************************
-- Number: 100
-- Purpose: Rollback add Selected Case Count column to action_rule table to store number of cases selected against the action rule
-- Author: Kieran Wardle
-- ****************************************************************************

ALTER TABLE casev3.action_rule DROP COLUMN selected_case_count;