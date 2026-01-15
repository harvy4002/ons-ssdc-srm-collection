-- ****************************************************************************
-- RM SQL DATABASE UPDATE EXAMPLE SCRIPT
-- ****************************************************************************
-- Number: 200
-- Purpose: Delete HMS Email Templates
-- Author: Daniel Banks
-- ****************************************************************************

DELETE FROM casev3.email_template
WHERE pack_code IN ('MNE_EN_HMS', 'MRE_EN_HMS');