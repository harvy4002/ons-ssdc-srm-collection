insert into casev3.users
values ('8d44dca6-359e-4e84-b55d-2d1903f9e561', -- user ID
        <YOUR EMAIL>);                          -- user email

insert into casev3.user_group_member
values ('fb5d6366-e009-46f2-b23e-7b6ee6a27f97',  -- member ID
        '8269d75c-bfa1-4930-aca2-10dd9c6a2b42',  -- group ID
        '8d44dca6-359e-4e84-b55d-2d1903f9e561'); -- user ID

commit;