-- ****************************************************************************
-- RM SQL DATABASE INSERT SCRIPT
-- ****************************************************************************
-- Number: 600
-- Purpose: Make the qid column in the uac_qid_link table unique
-- Author: Adam Hawtin
-- ****************************************************************************

ALTER TABLE casev3.uac_qid_link ADD CONSTRAINT uac_qid_link_qid_unique UNIQUE (qid);
