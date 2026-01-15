-- ****************************************************************************
-- RM SQL DATABASE INSERT SCRIPT
-- ****************************************************************************
-- Number: 900
-- Purpose: Add sample_validation_name to survey table
-- Author: Gavin Edwards / Daniel Banks
-- ****************************************************************************

ALTER TABLE casev3.survey ADD sample_validation_name VARCHAR(25);
