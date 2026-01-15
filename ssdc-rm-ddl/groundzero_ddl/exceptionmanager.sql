
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
