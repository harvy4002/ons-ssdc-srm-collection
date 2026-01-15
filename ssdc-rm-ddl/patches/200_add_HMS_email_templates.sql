-- ****************************************************************************
-- RM SQL DATABASE UPDATE EXAMPLE SCRIPT
-- ****************************************************************************
-- Number: 200
-- Purpose: Add HMS Email Templates
-- Author: Daniel Banks
-- ****************************************************************************

INSERT INTO casev3.email_template (pack_code, description, notify_template_id, notify_service_ref, metadata, template) VALUES
('MNE_EN_HMS', 'Main Notification Email', '883cee97-7a41-4fdb-8a09-0972c86b9375', 'Office_for_National_Statistics_surveys_NHS', null, '["__uac__", "PORTAL_ID", "COLLEX_OPEN_DATE", "COLLEX_CLOSE_DATE", "FIRST_NAME", "__sensitive__.LAST_NAME"]'),
('MRE_EN_HMS', 'Main Reminder Email', '1b46b5e1-e247-48b3-b3b3-bf949efd79cb', 'Office_for_National_Statistics_surveys_NHS', null, '["__uac__", "PORTAL_ID", "COLLEX_OPEN_DATE", "COLLEX_CLOSE_DATE", "FIRST_NAME", "__sensitive__.LAST_NAME"]')
ON CONFLICT (pack_code) DO UPDATE SET (description, notify_template_id, metadata, template) = (EXCLUDED.description, EXCLUDED.notify_template_id, EXCLUDED.metadata, EXCLUDED.template);