-- ****************************************************************************
-- RM SQL DATABASE INSERT SCRIPT
-- ****************************************************************************
-- Number: 100
-- Purpose: Add Selected Case Count column to action_rule table to store number of cases selected against the action rule
-- Author: Kieran Wardle
-- ****************************************************************************

ALTER TABLE casev3.action_rule ADD selected_case_count INTEGER;