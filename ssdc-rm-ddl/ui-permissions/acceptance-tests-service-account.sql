-- Add the ATs user row (note the placeholder "$ACCEPTANCE_TESTS_EMAIL" needs to be substituted in)
-- Relies on RM-support-permissions.sql
BEGIN;
INSERT INTO casev3.users (id, email)
VALUES ('7f51c6f0-bf65-454c-ae9f-6d59c47a0bb8', -- user ID
        '$ACCEPTANCE_TESTS_EMAIL');             -- AT user email

-- Add the ATs user ID to the super user group
INSERT INTO casev3.user_group_member (id, group_id, user_id)
VALUES ('8245edd0-956c-464b-a2bb-b44306d0b6b5',  -- member ID
        '8269d75c-bfa1-4930-aca2-10dd9c6a2b42',  -- super user group ID
        '7f51c6f0-bf65-454c-ae9f-6d59c47a0bb8'); -- user ID

COMMIT;
