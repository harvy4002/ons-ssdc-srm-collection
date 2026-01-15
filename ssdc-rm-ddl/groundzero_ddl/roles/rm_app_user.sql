DO $$
BEGIN
    CREATE ROLE rm_app_user;
    EXCEPTION WHEN duplicate_object THEN RAISE NOTICE '%, re-applying role grants and privileges', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

GRANT CONNECT ON DATABASE rm TO rm_app_user;

GRANT USAGE ON SCHEMA casev3 TO rm_app_user;
GRANT USAGE ON SCHEMA exceptionmanager TO rm_app_user;
GRANT USAGE ON SCHEMA uacqid TO rm_app_user;

-- casev3 table permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON casev3.action_rule TO rm_app_user;
GRANT SELECT, INSERT, UPDATE ON casev3.action_rule_survey_email_template TO rm_app_user;
GRANT SELECT, INSERT, UPDATE ON casev3.action_rule_survey_export_file_template TO rm_app_user;
GRANT SELECT, INSERT, UPDATE ON casev3.action_rule_survey_sms_template TO rm_app_user;
GRANT SELECT, INSERT, UPDATE ON casev3.cases TO rm_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON casev3.case_to_process TO rm_app_user;
GRANT SELECT, INSERT, UPDATE ON casev3.cluster_leader TO rm_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON casev3.collection_exercise TO rm_app_user;
GRANT SELECT, INSERT ON casev3.email_template TO rm_app_user;
GRANT SELECT, INSERT  ON casev3.event TO rm_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON casev3.export_file_row TO rm_app_user;
GRANT SELECT, INSERT ON casev3.export_file_template TO rm_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON casev3.fulfilment_to_process TO rm_app_user;
GRANT SELECT, INSERT, UPDATE ON casev3.fulfilment_next_trigger TO rm_app_user;
GRANT SELECT, INSERT ON casev3.fulfilment_survey_email_template TO rm_app_user;
GRANT SELECT, INSERT ON casev3.fulfilment_survey_export_file_template TO rm_app_user;
GRANT SELECT, INSERT ON casev3.fulfilment_survey_sms_template TO rm_app_user;
GRANT SELECT, INSERT, UPDATE ON casev3.job TO rm_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON casev3.job_row TO rm_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON casev3.message_to_send TO rm_app_user;
GRANT SELECT, INSERT ON casev3.sms_template TO rm_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON casev3.survey TO rm_app_user;
GRANT SELECT, INSERT, UPDATE ON casev3.uac_qid_link TO rm_app_user;
GRANT SELECT, INSERT ON casev3.users TO rm_app_user;
GRANT SELECT, INSERT ON casev3.user_group TO rm_app_user;
GRANT SELECT, INSERT, DELETE ON casev3.user_group_admin TO rm_app_user;
GRANT SELECT, INSERT, DELETE ON casev3.user_group_member TO rm_app_user;
GRANT SELECT, INSERT, DELETE ON casev3.user_group_permission TO rm_app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON exceptionmanager.quarantined_message TO rm_app_user;
GRANT SELECT, UPDATE, INSERT, DELETE ON exceptionmanager.auto_quarantine_rule TO rm_app_user;

GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA uacqid TO rm_app_user;

GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA casev3 TO rm_app_user;
GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA uacqid TO rm_app_user;
GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA exceptionmanager TO rm_app_user;


GRANT rm_app_user TO appuser;
REVOKE cloudsqlsuperuser FROM appuser;
ALTER ROLE appuser WITH NOCREATEDB;
ALTER ROLE appuser WITH NOCREATEROLE;
