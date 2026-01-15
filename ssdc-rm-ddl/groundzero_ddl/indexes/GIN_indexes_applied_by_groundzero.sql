BEGIN;

CREATE INDEX IF NOT EXISTS case_sample_idx ON casev3.cases USING GIN(sample);
CREATE INDEX IF NOT EXISTS uac_metadata_idx ON casev3.uac_qid_link USING GIN(metadata);

COMMIT;
