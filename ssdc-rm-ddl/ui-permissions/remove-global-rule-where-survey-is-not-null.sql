-- ****************************************************************************
-- RM SQL DATABASE UPDATE SCRIPT
-- ****************************************************************************
-- Purpose: One off script to remove global group permissions that have been created against a specific survey.
--          A future fix will prevent this from happening to begin with.
-- Author: Gavin Edwards
-- ****************************************************************************

DELETE FROM casev3.user_group_permission
WHERE authorised_activity IN
('LIST_SURVEYS',
 'CREATE_SURVEY',
 'CREATE_EXPORT_FILE_TEMPLATE',
 'CREATE_SMS_TEMPLATE',
 'CREATE_EMAIL_TEMPLATE',
 'LIST_EXPORT_FILE_TEMPLATES',
 'LIST_SMS_TEMPLATES',
 'LIST_EMAIL_TEMPLATES',
 'CONFIGURE_FULFILMENT_TRIGGER',
 'EXCEPTION_MANAGER_VIEWER',
 'EXCEPTION_MANAGER_PEEK',
 'EXCEPTION_MANAGER_QUARANTINE')
AND survey_id IS NOT NULL;