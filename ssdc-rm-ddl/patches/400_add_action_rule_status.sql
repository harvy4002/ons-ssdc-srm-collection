-- ****************************************************************************
-- RM SQL DATABASE INSERT SCRIPT
-- ****************************************************************************
-- Number: 400
-- Purpose: Add a status for the Action Rules and prepopulate for existing ARs
-- Author: Kacper Prywata, Adam Hawtin
-- ****************************************************************************

ALTER TABLE casev3.action_rule ADD action_rule_status VARCHAR(255)
CHECK (action_rule_status in ('SCHEDULED','SELECTING_CASES','PROCESSING_CASES','COMPLETED','ERRORED'));

UPDATE casev3.action_rule
SET action_rule_status = 'SCHEDULED'
WHERE has_triggered = 'false';

UPDATE casev3.action_rule
SET action_rule_status = 'COMPLETED'
WHERE has_triggered = 'true';
