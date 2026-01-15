-- ****************************************************************************
-- RM SQL DATABASE ROLLBACK SCRIPT
-- ****************************************************************************
-- Number: 800
-- Purpose: Rollback adding an index on the caze_id column on the casev3.uac_qid_link table
-- Author: Hugh
-- ****************************************************************************


DROP INDEX IF EXISTS casev3.uac_qid_caseid_idx;