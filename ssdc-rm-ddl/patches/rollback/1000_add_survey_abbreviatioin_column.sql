-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK INSERT SCRIPT
-- ****************************************************************************
-- Number: 1000
-- Purpose: Rollback adding survey_abbreviation column to survey table
-- Author: Gavin Edwards
-- ****************************************************************************

ALTER TABLE casev3.survey DROP COLUMN survey_abbreviation;