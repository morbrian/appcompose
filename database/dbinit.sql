
--
-- basic app users
--
CREATE ROLE "testdb_admin";
ALTER ROLE "testdb_admin" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT 50;
COMMENT ON ROLE "testdb_admin" IS 'Database administrator account';
CREATE ROLE "testdb_user";
ALTER ROLE "testdb_user" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT 200;
COMMENT ON ROLE "testdb_user" IS 'Account used for all web server to database transactions';

--
-- prepare simple database
--
CREATE DATABASE testbaseline WITH OWNER = "testdb_admin" ENCODING = 'UTF8' TABLESPACE = pg_default LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8' CONNECTION LIMIT = -1 TEMPLATE template0;

--
-- prepare simple data in testdb
--

\c testbaseline
CREATE EXTENSION pgcrypto;
CREATE EXTENSION pg_stat_statements;
-- rhel7 only for now
-- create extension pgaudit;

CREATE TABLE sample (
  id bigint,
  name character varying,
  cost double precision,
  active boolean
);

GRANT ALL ON ALL TABLES IN SCHEMA public TO "postgres";

INSERT INTO sample (id, name, cost, active) VALUES
( 1, 'apple', 123.00, true ),
( 2, 'orange', 246.00, true ),
( 3, 'banana', 369.00, true ),
( 4, 'kiwi', 4812.00, false ),
( 5, 'avocado', 51015.00, true );

