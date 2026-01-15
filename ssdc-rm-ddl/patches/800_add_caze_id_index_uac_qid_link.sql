-- ****************************************************************************
-- RM SQL DATABASE UPDATE EXAMPLE SCRIPT
-- ****************************************************************************
-- Number: 800
-- Purpose: Add an index on the caze_id column on the casev3.uac_qid_link table
-- Author: Hugh
-- ****************************************************************************


CREATE INDEX IF NOT EXISTS uac_qid_caseid_idx ON casev3.uac_qid_link (caze_id);