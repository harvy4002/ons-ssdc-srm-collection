-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK SCRIPT
-- ****************************************************************************
-- Number: 600
-- Purpose: Rollback making the qid column in the uac_qid_link table unique
-- Author: Adam Hawtin
-- ****************************************************************************

ALTER TABLE casev3.uac_qid_link DROP CONSTRAINT uac_qid_link_qid_unique;
