
--
-- basic app users
--
CREATE ROLE "appdata_admin";
ALTER ROLE "appdata_admin" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT 50 PASSWORD 'md5f4f002e096eb33227c22389326b5b7ff' VALID UNTIL 'infinity';
COMMENT ON ROLE "appdata_admin" IS 'Database administrator account';
CREATE ROLE "appdata";
ALTER ROLE "appdata" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT 200 PASSWORD 'md5f4f002e096eb33227c22389326b5b7ff' VALID UNTIL 'infinity';
COMMENT ON ROLE "appdata" IS 'Account used for all web server to database transactions';

--
-- prepare simple database
--
CREATE DATABASE appdata WITH OWNER = appdata_admin ENCODING = 'UTF8' TABLESPACE = pg_default LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8' CONNECTION LIMIT = -1 TEMPLATE template0;
\c appdata
CREATE EXTENSION pgcrypto;
CREATE EXTENSION pg_stat_statements;
-- rhel7 only for now
-- create extension pgaudit;

--
-- prepare privileges
--
\c appdata
GRANT ALL ON ALL TABLES IN SCHEMA public TO appdata_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO appdata_admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO appdata_admin;

GRANT ALL ON ALL TABLES IN SCHEMA public TO appdata;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO appdata;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO appdata;

