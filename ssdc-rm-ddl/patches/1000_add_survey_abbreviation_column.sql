-- ****************************************************************************
-- RM SQL DATABASE INSERT SCRIPT
-- ****************************************************************************
-- Number: 1000
-- Purpose: Add survey_abbreviation column to survey table
-- Author: Gavin Edwards
-- ****************************************************************************

ALTER TABLE casev3.survey ADD survey_abbreviation VARCHAR(10);