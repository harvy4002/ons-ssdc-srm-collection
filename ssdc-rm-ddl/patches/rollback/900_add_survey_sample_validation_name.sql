-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK INSERT SCRIPT
-- ****************************************************************************
-- Number: 900
-- Purpose: Rollback adding sample_validation_name to survey table
-- Author: Gavin Edwards / Daniel Banks
-- ****************************************************************************

ALTER TABLE casev3.survey DROP COLUMN sample_validation_name;
