
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
