
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
