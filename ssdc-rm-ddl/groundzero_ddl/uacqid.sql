
    create table uac_qid (
        uac varchar(255) not null,
        qid varchar(255),
        unique_number serial,
        primary key (uac)
    );
