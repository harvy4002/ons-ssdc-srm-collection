-- THIS FILE IS AUTO-GENERATED
-- DO NOT EDIT IT DIRECTLY
-- REFER TO THE README FOR INSTRUCTIONS ON REGENERATING IT

-- The following statements are required to allow the patch 600 to run against a local dev postgres container
DO $$
BEGIN
    CREATE USER appuser;
    EXCEPTION WHEN duplicate_object THEN RAISE NOTICE '%', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;
ALTER ROLE appuser WITH PASSWORD 'postgres';
CREATE ROLE cloudsqlsuperuser;
CREATE ROLE rm_app_user;
GRANT cloudsqlsuperuser TO appuser;
ALTER ROLE appuser WITH CREATEDB;
ALTER ROLE appuser WITH CREATEROLE;

create schema if not exists casev3;
set schema 'casev3';

    create table action_rule (
        id uuid not null,
        action_rule_status varchar(255) not null check (action_rule_status in ('SCHEDULED','SELECTING_CASES','PROCESSING_CASES','COMPLETED','ERRORED')),
        classifiers bytea,
        created_by varchar(255) not null,
        description varchar(50),
        email_column varchar(255),
        has_triggered BOOLEAN DEFAULT false not null,
        phone_number_column varchar(255),
        selected_case_count integer,
        trigger_date_time timestamp with time zone not null,
        type varchar(255) not null check (type in ('EXPORT_FILE','OUTBOUND_TELEPHONE','FACE_TO_FACE','DEACTIVATE_UAC','SMS','EMAIL','EQ_FLUSH')),
        uac_metadata jsonb,
        collection_exercise_id uuid not null,
        email_template_pack_code varchar(255),
        export_file_template_pack_code varchar(255),
        sms_template_pack_code varchar(255),
        primary key (id)
    );

    create table action_rule_survey_email_template (
        id uuid not null,
        email_template_pack_code varchar(255) not null,
        survey_id uuid not null,
        primary key (id)
    );

    create table action_rule_survey_export_file_template (
        id uuid not null,
        export_file_template_pack_code varchar(255) not null,
        survey_id uuid not null,
        primary key (id)
    );

    create table action_rule_survey_sms_template (
        id uuid not null,
        sms_template_pack_code varchar(255) not null,
        survey_id uuid not null,
        primary key (id)
    );

    create table cases (
        id uuid not null,
        case_ref bigint,
        created_at timestamp with time zone,
        invalid BOOLEAN DEFAULT false not null,
        last_updated_at timestamp with time zone,
        refusal_received varchar(255) check (refusal_received in ('HARD_REFUSAL','EXTRAORDINARY_REFUSAL','SOFT_REFUSAL','WITHDRAWAL_REFUSAL')),
        sample jsonb,
        sample_sensitive jsonb,
        secret_sequence_number serial,
        collection_exercise_id uuid not null,
        primary key (id)
    );

    create table case_to_process (
        id bigserial not null,
        batch_id uuid not null,
        batch_quantity integer not null,
        action_rule_id uuid not null,
        caze_id uuid not null,
        primary key (id)
    );

    create table cluster_leader (
        id uuid not null,
        host_last_seen_alive_at timestamp with time zone not null,
        host_name varchar(255) not null,
        primary key (id)
    );

    create table collection_exercise (
        id uuid not null,
        collection_instrument_selection_rules jsonb not null,
        end_date timestamp with time zone not null,
        metadata jsonb,
        name varchar(255) not null,
        reference varchar(255) not null,
        start_date timestamp with time zone not null,
        survey_id uuid not null,
        primary key (id)
    );

    create table email_template (
        pack_code varchar(255) not null,
        description varchar(255) not null,
        metadata jsonb,
        notify_service_ref varchar(255) not null,
        notify_template_id uuid not null,
        template jsonb not null,
        primary key (pack_code)
    );

    create table event (
        id uuid not null,
        channel varchar(255) not null,
        correlation_id uuid not null,
        created_by varchar(255),
        date_time timestamp with time zone not null,
        description varchar(255) not null,
        message_id uuid not null,
        message_timestamp Timestamp with time zone not null,
        payload jsonb,
        processed_at timestamp with time zone not null,
        source varchar(255) not null,
        type varchar(255) not null check (type in ('NEW_CASE','RECEIPT','REFUSAL','ERASE_DATA','EQ_LAUNCH','INVALID_CASE','UAC_AUTHENTICATION','TELEPHONE_CAPTURE','PRINT_FULFILMENT','EXPORT_FILE','DEACTIVATE_UAC','UPDATE_SAMPLE','UPDATE_SAMPLE_SENSITIVE','SMS_FULFILMENT','ACTION_RULE_SMS_REQUEST','EMAIL_FULFILMENT','ACTION_RULE_EMAIL_REQUEST','ACTION_RULE_SMS_CONFIRMATION','ACTION_RULE_EMAIL_CONFIRMATION')),
        caze_id uuid,
        uac_qid_link_id uuid,
        primary key (id)
    );

    create table export_file_row (
        id bigserial not null,
        batch_id uuid not null,
        batch_quantity integer not null,
        export_file_destination varchar(255) not null,
        pack_code varchar(255) not null,
        row varchar(5000) not null,
        primary key (id)
    );

    create table export_file_template (
        pack_code varchar(255) not null,
        description varchar(255) not null,
        export_file_destination varchar(255) not null,
        metadata jsonb,
        template jsonb not null,
        primary key (pack_code)
    );

    create table fulfilment_next_trigger (
        id uuid not null,
        trigger_date_time timestamp with time zone not null,
        primary key (id)
    );

    create table fulfilment_survey_email_template (
        id uuid not null,
        email_template_pack_code varchar(255) not null,
        survey_id uuid not null,
        primary key (id)
    );

    create table fulfilment_survey_export_file_template (
        id uuid not null,
        export_file_template_pack_code varchar(255) not null,
        survey_id uuid not null,
        primary key (id)
    );

    create table fulfilment_survey_sms_template (
        id uuid not null,
        sms_template_pack_code varchar(255) not null,
        survey_id uuid not null,
        primary key (id)
    );

    create table fulfilment_to_process (
        id bigserial not null,
        batch_id uuid,
        batch_quantity integer,
        correlation_id uuid not null,
        message_id uuid not null unique,
        originating_user varchar(255),
        personalisation jsonb,
        uac_metadata jsonb,
        caze_id uuid not null,
        export_file_template_pack_code varchar(255) not null,
        primary key (id)
    );

    create table job (
        id uuid not null,
        cancelled_at timestamp with time zone,
        cancelled_by varchar(255),
        created_at timestamp with time zone,
        created_by varchar(255) not null,
        error_row_count integer not null,
        fatal_error_description varchar(255),
        file_id uuid not null,
        file_name varchar(255) not null,
        file_row_count integer not null,
        job_status varchar(255) not null check (job_status in ('FILE_UPLOADED','STAGING_IN_PROGRESS','VALIDATION_IN_PROGRESS','VALIDATED_OK','VALIDATED_WITH_ERRORS','VALIDATED_TOTAL_FAILURE','PROCESSING_IN_PROGRESS','PROCESSED','CANCELLED')),
        job_type varchar(255) not null check (job_type in ('SAMPLE','BULK_REFUSAL','BULK_UPDATE_SAMPLE_SENSITIVE','BULK_INVALID','BULK_UPDATE_SAMPLE')),
        last_updated_at timestamp with time zone,
        processed_at timestamp with time zone,
        processed_by varchar(255),
        processing_row_number integer not null,
        staging_row_number integer not null,
        validating_row_number integer not null,
        collection_exercise_id uuid not null,
        primary key (id)
    );

    create table job_row (
        id uuid not null,
        job_row_status varchar(255) not null check (job_row_status in ('STAGED','VALIDATED_OK','VALIDATED_ERROR','PROCESSED')),
        original_row_data bytea not null,
        original_row_line_number integer not null,
        row_data jsonb,
        validation_error_descriptions bytea,
        job_id uuid not null,
        primary key (id)
    );

    create table message_to_send (
        id uuid not null,
        destination_topic varchar(255) not null,
        message_body bytea not null,
        primary key (id)
    );

    create table sms_template (
        pack_code varchar(255) not null,
        description varchar(255) not null,
        metadata jsonb,
        notify_service_ref varchar(255) not null,
        notify_template_id uuid not null,
        template jsonb not null,
        primary key (pack_code)
    );

    create table survey (
        id uuid not null,
        metadata jsonb,
        name varchar(255) not null,
        sample_definition_url varchar(255) not null,
        sample_separator char(1) not null,
        sample_validation_name varchar(25),
        sample_validation_rules jsonb not null,
        sample_with_header_row boolean not null,
        survey_abbreviation varchar(10),
        primary key (id)
    );

    create table uac_qid_link (
        id uuid not null,
        active BOOLEAN DEFAULT true not null,
        collection_instrument_url varchar(255) not null,
        created_at timestamp with time zone,
        eq_launched BOOLEAN DEFAULT false not null,
        last_updated_at timestamp with time zone,
        metadata jsonb,
        qid varchar(255) not null unique,
        receipt_received BOOLEAN DEFAULT false not null,
        uac varchar(255) not null,
        uac_hash varchar(255) not null,
        caze_id uuid not null,
        primary key (id)
    );

    create table user_group (
        id uuid not null,
        description varchar(255),
        name varchar(255) not null unique,
        primary key (id)
    );

    create table user_group_admin (
        id uuid not null,
        group_id uuid not null,
        user_id uuid not null,
        primary key (id)
    );

    create table user_group_member (
        id uuid not null,
        group_id uuid not null,
        user_id uuid not null,
        primary key (id)
    );

    create table user_group_permission (
        id uuid not null,
        authorised_activity varchar(255) check (authorised_activity in ('SUPER_USER','LIST_SURVEYS','VIEW_SURVEY','CREATE_SURVEY','CREATE_EXPORT_FILE_TEMPLATE','CREATE_SMS_TEMPLATE','CREATE_EMAIL_TEMPLATE','LIST_COLLECTION_EXERCISES','VIEW_COLLECTION_EXERCISE','CREATE_COLLECTION_EXERCISE','ALLOW_EXPORT_FILE_TEMPLATE_ON_ACTION_RULE','LIST_ALLOWED_EXPORT_FILE_TEMPLATES_ON_ACTION_RULES','ALLOW_SMS_TEMPLATE_ON_ACTION_RULE','LIST_ALLOWED_SMS_TEMPLATES_ON_ACTION_RULES','ALLOW_EMAIL_TEMPLATE_ON_ACTION_RULE','LIST_ALLOWED_EMAIL_TEMPLATES_ON_ACTION_RULES','ALLOW_EXPORT_FILE_TEMPLATE_ON_FULFILMENT','LIST_ALLOWED_EXPORT_FILE_TEMPLATES_ON_FULFILMENTS','ALLOW_SMS_TEMPLATE_ON_FULFILMENT','LIST_ALLOWED_SMS_TEMPLATES_ON_FULFILMENTS','ALLOW_EMAIL_TEMPLATE_ON_FULFILMENT','LIST_ALLOWED_EMAIL_TEMPLATES_ON_FULFILMENTS','SEARCH_CASES','VIEW_CASE_DETAILS','LIST_ACTION_RULES','CREATE_EXPORT_FILE_ACTION_RULE','CREATE_FACE_TO_FACE_ACTION_RULE','CREATE_OUTBOUND_PHONE_ACTION_RULE','CREATE_DEACTIVATE_UAC_ACTION_RULE','CREATE_SMS_ACTION_RULE','CREATE_EMAIL_ACTION_RULE','CREATE_EQ_FLUSH_ACTION_RULE','LOAD_SAMPLE','VIEW_SAMPLE_LOAD_PROGRESS','LOAD_BULK_REFUSAL','VIEW_BULK_REFUSAL_PROGRESS','LOAD_BULK_UPDATE_SAMPLE_SENSITIVE','LOAD_BULK_INVALID','LOAD_BULK_UPDATE_SAMPLE','VIEW_BULK_UPDATE_SAMPLE_SENSITIVE_PROGRESS','VIEW_BULK_INVALID_PROGRESS','VIEW_BULK_UPDATE_SAMPLE_PROGRESS','DEACTIVATE_UAC','CREATE_CASE_REFUSAL','CREATE_CASE_INVALID_CASE','CREATE_CASE_EXPORT_FILE_FULFILMENT','CREATE_CASE_SMS_FULFILMENT','CREATE_CASE_EMAIL_FULFILMENT','UPDATE_SAMPLE','UPDATE_SAMPLE_SENSITIVE','LIST_EXPORT_FILE_TEMPLATES','LIST_EXPORT_FILE_DESTINATIONS','LIST_SMS_TEMPLATES','LIST_EMAIL_TEMPLATES','CONFIGURE_FULFILMENT_TRIGGER','EXCEPTION_MANAGER_VIEWER','EXCEPTION_MANAGER_PEEK','EXCEPTION_MANAGER_QUARANTINE','LIST_USERS')),
        group_id uuid not null,
        survey_id uuid,
        primary key (id)
    );

    create table users (
        id uuid not null,
        email varchar(255) not null,
        primary key (id),
        constraint users_email_idx unique (email)
    );

    create index cases_case_ref_idx 
       on cases (case_ref);

    create index qid_idx 
       on uac_qid_link (qid);

    create index uac_qid_caseid_idx 
       on uac_qid_link (caze_id);

    alter table if exists action_rule 
       add constraint FK6twtf1ksysh99e4g2ejmoy6c1 
       foreign key (collection_exercise_id) 
       references collection_exercise;

    alter table if exists action_rule 
       add constraint FKssc7f5mlut14gbb20282seiyn 
       foreign key (email_template_pack_code) 
       references email_template;

    alter table if exists action_rule 
       add constraint FK9fefdqv5a7vb04vu7gn6cad19 
       foreign key (export_file_template_pack_code) 
       references export_file_template;

    alter table if exists action_rule 
       add constraint FKtnrm1hhiyehmygso5dsb6dv7a 
       foreign key (sms_template_pack_code) 
       references sms_template;

    alter table if exists action_rule_survey_email_template 
       add constraint FKfjx53yvq2f07lipml9kcm8qlb 
       foreign key (email_template_pack_code) 
       references email_template;

    alter table if exists action_rule_survey_email_template 
       add constraint FKfucekff07exgw9xd5pd6wxc80 
       foreign key (survey_id) 
       references survey;

    alter table if exists action_rule_survey_export_file_template 
       add constraint FKpeyvyyoxpqh7rvae2hxmg2wd2 
       foreign key (export_file_template_pack_code) 
       references export_file_template;

    alter table if exists action_rule_survey_export_file_template 
       add constraint FKmtao7nj3x74iki19rygx5pdcl 
       foreign key (survey_id) 
       references survey;

    alter table if exists action_rule_survey_sms_template 
       add constraint FKrtyhiquv8tgdiv0sc2e5ovqld 
       foreign key (sms_template_pack_code) 
       references sms_template;

    alter table if exists action_rule_survey_sms_template 
       add constraint FKcksec9j9chi54k0fuhsywnfne 
       foreign key (survey_id) 
       references survey;

    alter table if exists cases 
       add constraint FKrl77p02uu7a253tn2ro5mitv5 
       foreign key (collection_exercise_id) 
       references collection_exercise;

    alter table if exists case_to_process 
       add constraint FKmqcrb58vhx7a7qcyyjjvm1y31 
       foreign key (action_rule_id) 
       references action_rule;

    alter table if exists case_to_process 
       add constraint FK104hqblc26y5xjehv2x8dg4k3 
       foreign key (caze_id) 
       references cases;

    alter table if exists collection_exercise 
       add constraint FKrv1ksptm37exmrbj0yutm6fla 
       foreign key (survey_id) 
       references survey;

    alter table if exists event 
       add constraint FKhgvw8xq5panw486l3varef7pk 
       foreign key (caze_id) 
       references cases;

    alter table if exists event 
       add constraint FKamu77co5m9upj2b3c1oun21er 
       foreign key (uac_qid_link_id) 
       references uac_qid_link;

    alter table if exists fulfilment_survey_email_template 
       add constraint FK7yn9o3bjnbaor6e15h1cfolj6 
       foreign key (email_template_pack_code) 
       references email_template;

    alter table if exists fulfilment_survey_email_template 
       add constraint FKtbsv7d3607v1drb4vilugvnk8 
       foreign key (survey_id) 
       references survey;

    alter table if exists fulfilment_survey_export_file_template 
       add constraint FKjit0455kk2vnpbr6cs9wxsggv 
       foreign key (export_file_template_pack_code) 
       references export_file_template;

    alter table if exists fulfilment_survey_export_file_template 
       add constraint FK5u3w6updqcovaf7p4mkl8wtub 
       foreign key (survey_id) 
       references survey;

    alter table if exists fulfilment_survey_sms_template 
       add constraint FKqpoh4166ajt0h9qxwq43asj48 
       foreign key (sms_template_pack_code) 
       references sms_template;

    alter table if exists fulfilment_survey_sms_template 
       add constraint FKi9auhquvx2gipducjycr08ti1 
       foreign key (survey_id) 
       references survey;

    alter table if exists fulfilment_to_process 
       add constraint FK9cu8edtrwirw777f4x1qej03m 
       foreign key (caze_id) 
       references cases;

    alter table if exists fulfilment_to_process 
       add constraint FKic5eccg0ms41mlfe7aqyelje9 
       foreign key (export_file_template_pack_code) 
       references export_file_template;

    alter table if exists job 
       add constraint FK6hra36ow5xge19dg3w1m7fd4r 
       foreign key (collection_exercise_id) 
       references collection_exercise;

    alter table if exists job_row 
       add constraint FK8motlil4mayre4vvdipnjime0 
       foreign key (job_id) 
       references job;

    alter table if exists uac_qid_link 
       add constraint FKngo7bm72f0focdujjma78t4nk 
       foreign key (caze_id) 
       references cases;

    alter table if exists user_group_admin 
       add constraint FKc7secqw35qa62vst6c8fvmnkc 
       foreign key (group_id) 
       references user_group;

    alter table if exists user_group_admin 
       add constraint FK44cbs8vh8ugmfgduvjb9j02kj 
       foreign key (user_id) 
       references users;

    alter table if exists user_group_member 
       add constraint FKnyc05vqmhd9hq1hv6wexhdu4t 
       foreign key (group_id) 
       references user_group;

    alter table if exists user_group_member 
       add constraint FKjbhg45atfwht2ji7xu241m4qp 
       foreign key (user_id) 
       references users;

    alter table if exists user_group_permission 
       add constraint FKao3eqnwgryopngpoq65744h2m 
       foreign key (group_id) 
       references user_group;

    alter table if exists user_group_permission 
       add constraint FKep4hjlw1esp4s8p3row2syxjq 
       foreign key (survey_id) 
       references survey;

create schema if not exists uacqid;
set schema 'uacqid';

    create table uac_qid (
        uac varchar(255) not null,
        qid varchar(255),
        unique_number serial,
        primary key (uac)
    );

create schema if not exists exceptionmanager;
set schema 'exceptionmanager';

    create table auto_quarantine_rule (
        id uuid not null,
        expression varchar(255),
        quarantine BOOLEAN DEFAULT false not null,
        rule_expiry_date_time timestamp with time zone,
        suppress_logging BOOLEAN DEFAULT false not null,
        throw_away BOOLEAN DEFAULT false not null,
        primary key (id)
    );

    create table quarantined_message (
        id uuid not null,
        content_type varchar(255),
        error_reports jsonb,
        headers jsonb,
        message_hash varchar(255),
        message_payload bytea,
        routing_key varchar(255),
        service varchar(255),
        skipped_timestamp timestamp with time zone,
        skipping_user varchar(255),
        subscription varchar(255),
        primary key (id)
    );

create schema if not exists ddl_version;
set schema 'ddl_version';
CREATE TABLE ddl_version.patches (patch_number integer PRIMARY KEY, applied_timestamp timestamp with time zone NOT NULL);
CREATE TABLE ddl_version.version (version_tag varchar(256) PRIMARY KEY, updated_timestamp timestamp with time zone NOT NULL);

-- Version and patch number for the current ground zero,
-- NOTE: These must be updated every time the repo is tagged
-- NOTE: the CURRENT_VERSION in /patch_database.py must also be updated to match this version_tag
INSERT INTO ddl_version.patches (patch_number, applied_timestamp) VALUES (1000, current_timestamp);
INSERT INTO ddl_version.version (version_tag, updated_timestamp) VALUES ('v1.3.6', current_timestamp);

-- Seed Support Tool UI permissions
BEGIN;

-- RM SUPPORT ACTIONS
INSERT INTO casev3.user_group (id, description, name) VALUES ('a25c7f99-d2ce-4267-aea4-0a133028f793', 'Group to temporarily move into to get all Action permissions except create Users or Groups', 'RM SUPPORT ACTIONS') ON CONFLICT DO NOTHING;

INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('938cee41-3ad7-4740-af07-1501a2931d90', 'EXCEPTION_MANAGER_QUARANTINE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('e454c6a4-37b8-48f2-b180-33a6d1dac0db', 'EXCEPTION_MANAGER_PEEK', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('08be718e-0afd-4320-9cf7-1531e84f69da', 'CREATE_SURVEY', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('b853b901-8159-40d0-a373-309ff32f8bca', 'CREATE_EXPORT_FILE_TEMPLATE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('13c8f54e-9ed1-40e2-a89d-d5714a2b9e46', 'CREATE_SMS_TEMPLATE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('bd0a7643-8db3-4b52-ba8c-ff62aa3068fd', 'CREATE_EMAIL_TEMPLATE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('3c2cd0bd-9c7d-4802-b01d-a9d62b24d37c', 'CREATE_COLLECTION_EXERCISE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('ce7c2e7e-8b0f-483a-b80c-1dbc3e6a91ba', 'ALLOW_EXPORT_FILE_TEMPLATE_ON_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('0f24d3c2-d625-41f8-b1a6-9f42f4de60a9', 'ALLOW_SMS_TEMPLATE_ON_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('d57bc0aa-e98b-4f7e-85b5-5c9bcfa284db', 'ALLOW_EMAIL_TEMPLATE_ON_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('558ec090-d44b-401b-abbb-7352e11aafbe', 'ALLOW_EMAIL_TEMPLATE_ON_FULFILMENT', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('c6424f68-87a5-417d-9ea1-2969795ee01a', 'CREATE_EXPORT_FILE_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('b87d94b9-f916-420f-90cc-52705fc415b8', 'CREATE_FACE_TO_FACE_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('1b5219ca-9e56-4b49-9208-95edc6ead0d3', 'CREATE_OUTBOUND_PHONE_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('7d9324aa-deb7-4da7-bd38-4c89345a7ecd', 'CREATE_DEACTIVATE_UAC_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('aa9c83d5-beac-48c3-b32e-9851a057bc83', 'CREATE_EQ_FLUSH_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('188a309b-c4cb-4e84-9846-aefec2929216', 'CREATE_SMS_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('825179c4-076d-49c4-81d5-53848b288b48', 'CREATE_EMAIL_ACTION_RULE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('54c61071-4c61-4477-8b83-071d7314f943', 'LOAD_SAMPLE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('b787fba3-1bf0-4ea4-be66-ed71e235be02', 'LOAD_BULK_REFUSAL', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('5b34b96b-b813-4cab-af07-ea6e9c3c2d0d', 'LOAD_BULK_UPDATE_SAMPLE_SENSITIVE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('6a4dd655-423d-4d56-bc38-604a61e55721', 'LOAD_BULK_INVALID', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('4b244c4d-d3ca-4841-a396-d03dc200396f', 'LOAD_BULK_UPDATE_SAMPLE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('5798a4a2-9ab8-4509-9f88-71fde81e6948', 'DEACTIVATE_UAC', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('5cfe474a-71f3-46bf-b9fe-fa6388c8c9da', 'CREATE_CASE_REFUSAL', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('c484fdc8-3bfd-40ad-b608-75b9d94b434e', 'CREATE_CASE_INVALID_CASE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('336002f6-b98b-40dc-acf6-6490b6348d8e', 'UPDATE_SAMPLE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('20348a51-352f-4f2d-98d3-d6549110b9bf', 'UPDATE_SAMPLE_SENSITIVE', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('dddfd81d-a184-4c71-a639-df64acf47b37', 'CREATE_CASE_EXPORT_FILE_FULFILMENT', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('ccc4e85f-ecb9-467d-be11-715ab605cf02', 'CREATE_CASE_SMS_FULFILMENT', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('4990e4de-42aa-4fd7-a654-554e440def38', 'CREATE_CASE_EMAIL_FULFILMENT', 'a25c7f99-d2ce-4267-aea4-0a133028f793', NULL) ON CONFLICT DO NOTHING;

-- RM SUPPORT
INSERT INTO casev3.user_group VALUES ('b19a77bd-6a02-4851-8116-9e915738b700', 'RM Support - Read only', 'RM SUPPORT') ON CONFLICT DO NOTHING;

INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('6f655e60-be27-4092-84e0-3b64971a4dac', 'EXCEPTION_MANAGER_VIEWER', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('81e78da1-5e2a-4457-a2ee-cc12c884f2fa', 'LIST_ACTION_RULES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('ff682c9f-11db-42be-9e22-b384cf96557e', 'LIST_ALLOWED_EMAIL_TEMPLATES_ON_ACTION_RULES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('db5e3d2b-0bb1-4fcd-a99b-0f90a319ba04', 'LIST_ALLOWED_EMAIL_TEMPLATES_ON_FULFILMENTS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('0fefc7ac-3548-49a8-8f5c-512b1e319ecc', 'LIST_ALLOWED_EXPORT_FILE_TEMPLATES_ON_ACTION_RULES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('900abc3c-ee97-4101-81ca-09f753651109', 'LIST_ALLOWED_EXPORT_FILE_TEMPLATES_ON_FULFILMENTS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('191408ca-7579-4135-a070-c5c9c3907b51', 'LIST_ALLOWED_SMS_TEMPLATES_ON_ACTION_RULES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('7ebd8b21-e90d-4c76-b98c-984146137507', 'LIST_ALLOWED_SMS_TEMPLATES_ON_FULFILMENTS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('f1f526ee-a10e-4772-923b-ec3586826cbf', 'LIST_COLLECTION_EXERCISES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('9fabaeb6-479f-4474-b22f-4ce1e9c06f9c', 'LIST_EMAIL_TEMPLATES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('40d65e5c-5a07-43c8-8243-c263e2d26b78', 'LIST_EXPORT_FILE_DESTINATIONS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('44945e73-f295-42b6-b240-d5d9aa57b217', 'LIST_EXPORT_FILE_TEMPLATES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('81395c04-416c-4e3f-9397-83a08ac8bdf2', 'LIST_SMS_TEMPLATES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('cc542d88-b1e6-4ab0-ba09-9857a4cc5877', 'LIST_SURVEYS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('53d7355d-fce6-40e1-9dd9-17af1d9a0dfc', 'SEARCH_CASES', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('60e8bf0b-079d-4784-89b9-ab8613f23af0', 'VIEW_BULK_INVALID_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('29a3b8ac-81ca-41c7-be4a-ceb57071a8c8', 'VIEW_BULK_REFUSAL_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('80363171-0e29-4f01-b1f9-17272da66552', 'VIEW_BULK_UPDATE_SAMPLE_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('23a7f3a1-194f-4455-adbd-e3da1047a88e', 'VIEW_BULK_UPDATE_SAMPLE_SENSITIVE_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('91f93759-a0ba-41e6-b368-d331efb01366', 'VIEW_CASE_DETAILS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('28e30f2e-2d1b-4fa1-92ca-cd8323179c55', 'VIEW_COLLECTION_EXERCISE', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('26cf0f7a-7f0f-4e5b-8be2-640745be9cdf', 'VIEW_SAMPLE_LOAD_PROGRESS', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;
INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('18c78ba8-17ec-4c09-972d-c1c6c88359d5', 'VIEW_SURVEY', 'b19a77bd-6a02-4851-8116-9e915738b700', NULL) ON CONFLICT DO NOTHING;

-- super
INSERT INTO casev3.user_group (id, description, name) VALUES ('8269d75c-bfa1-4930-aca2-10dd9c6a2b42', 'Super user - full permissions', 'super') ON CONFLICT DO NOTHING;;

INSERT INTO casev3.user_group_permission (id, authorised_activity, group_id, survey_id) VALUES ('c469377e-680e-4cb1-92a0-5217be2b3a52', 'SUPER_USER', '8269d75c-bfa1-4930-aca2-10dd9c6a2b42', NULL) ON CONFLICT DO NOTHING;

COMMIT;
-- Seed packcode templates
-- Export File Templates

-- Email Template
-- HMS EMAIL TEMPLATE

INSERT INTO casev3.email_template (pack_code, description, notify_template_id, notify_service_ref, metadata, template) VALUES
('MNE_EN_HMS', 'Main Notification Email', '883cee97-7a41-4fdb-8a09-0972c86b9375', 'Office_for_National_Statistics_surveys_NHS', null, '["__uac__", "PORTAL_ID", "COLLEX_OPEN_DATE", "COLLEX_CLOSE_DATE", "FIRST_NAME", "__sensitive__.LAST_NAME"]'),
('MRE_EN_HMS', 'Main Reminder Email', '1b46b5e1-e247-48b3-b3b3-bf949efd79cb', 'Office_for_National_Statistics_surveys_NHS', null, '["__uac__", "PORTAL_ID", "COLLEX_OPEN_DATE", "COLLEX_CLOSE_DATE", "FIRST_NAME", "__sensitive__.LAST_NAME"]')
ON CONFLICT (pack_code) DO UPDATE SET (description, notify_template_id, metadata, template) = (EXCLUDED.description, EXCLUDED.notify_template_id, EXCLUDED.metadata, EXCLUDED.template);