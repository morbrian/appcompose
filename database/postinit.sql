--
-- prepare privileges
--

GRANT ALL ON ALL TABLES IN SCHEMA public TO "testdb_admin";
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO "testdb_admin";
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO "testdb_admin";

GRANT ALL ON ALL TABLES IN SCHEMA public TO "testdb_user";
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO "testdb_user";
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO "testdb_user";
