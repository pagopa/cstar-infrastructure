--
-- PostgreSQL database dump
--

-- Dumped from database version 11.11
-- Dumped by pg_dump version 13.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: rtd_database; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA rtd_database;


ALTER SCHEMA rtd_database OWNER TO ddsadmin;

--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: hypopg; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hypopg WITH SCHEMA public;


--
-- Name: EXTENSION hypopg; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hypopg IS 'Hypothetical indexes for PostgreSQL';


--
-- Name: get_payment_instrument_hpans(); Type: FUNCTION; Schema: rtd_database; Owner: ddsadmin
--

CREATE FUNCTION rtd_database.get_payment_instrument_hpans() RETURNS TABLE(hpan_s character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY 
(SELECT * FROM public.dblink('bpd_payment_instrument_remote','SELECT hpan_s FROM bpd_payment_instrument.bpd_payment_instrument') AS bpd_payment_instr(hpan_s varchar))
UNION
(SELECT * FROM public.dblink('fa_payment_instrument_remote','SELECT hpan_s FROM fa_payment_instrument.fa_payment_instrument WHERE enabled_b=true') AS fa_payment_instr(hpan_s varchar));
END
$$;


ALTER FUNCTION rtd_database.get_payment_instrument_hpans() OWNER TO ddsadmin;

--
-- Name: bpd_payment_instrument_remote; Type: SERVER; Schema: -; Owner: ddsadmin
--

CREATE SERVER bpd_payment_instrument_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'bpd',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
);

ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (sslmode 'require');


ALTER SERVER bpd_payment_instrument_remote OWNER TO ddsadmin;

--
-- Name: USER MAPPING MONITORING_USER SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

CREATE USER MAPPING FOR "MONITORING_USER" SERVER bpd_payment_instrument_remote;

ALTER USER MAPPING
	FOR "MONITORING_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'MONITORING_USER@${serverName}', password '${monitoringUserPassword}');

--
-- Name: USER MAPPING RTD_USER SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

CREATE USER MAPPING FOR "RTD_USER" SERVER bpd_payment_instrument_remote;

ALTER USER MAPPING
	FOR "RTD_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'RTD_USER@${serverName}', password '${rtdUserPassword}');

--
-- Name: fa_payment_instrument_remote; Type: SERVER; Schema: -; Owner: ddsadmin
--

CREATE SERVER fa_payment_instrument_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'fa',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
);

ALTER SERVER fa_payment_instrument_remote
	OPTIONS (sslmode 'require');

ALTER SERVER fa_payment_instrument_remote OWNER TO ddsadmin;

--
-- Name: USER MAPPING MONITORING_USER SERVER fa_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

CREATE USER MAPPING FOR "MONITORING_USER" SERVER fa_payment_instrument_remote;

ALTER USER MAPPING
	FOR "MONITORING_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (user 'MONITORING_USER@${serverName}', password '${monitoringUserPassword}');

--
-- Name: USER MAPPING RTD_USER SERVER fa_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

CREATE USER MAPPING FOR "RTD_USER" SERVER fa_payment_instrument_remote;

ALTER USER MAPPING
	FOR "RTD_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (user 'RTD_USER@${serverName}', password '${rtdUserPassword}');

SET default_tablespace = '';

--
-- Name: rtd_batch_exec_data; Type: TABLE; Schema: rtd_database; Owner: ddsadmin
--

CREATE TABLE rtd_database.rtd_batch_exec_data (
    bpd_execution_date_t timestamp with time zone DEFAULT '2018-12-31 23:00:00+00'::timestamp with time zone NOT NULL,
    bpd_del_execution_date_t timestamp with time zone DEFAULT '2018-12-31 23:00:00+00'::timestamp with time zone NOT NULL,
    fa_execution_date_t timestamp with time zone DEFAULT '2018-12-31 23:00:00+00'::timestamp with time zone NOT NULL,
    fa_del_execution_date_t timestamp with time zone DEFAULT '2018-12-31 23:00:00+00'::timestamp with time zone NOT NULL
);


ALTER TABLE rtd_database.rtd_batch_exec_data OWNER TO ddsadmin;

--
-- Name: rtd_payment_instrument_data; Type: TABLE; Schema: rtd_database; Owner: ddsadmin
--

CREATE TABLE rtd_database.rtd_payment_instrument_data (
    hpan_s character varying NOT NULL,
    bpd_enabled_b boolean DEFAULT false NOT NULL,
    fa_enabled_b boolean DEFAULT false NOT NULL,
    insert_date_t timestamp with time zone,
    update_date_t timestamp with time zone,
    insert_user_s character varying,
    update_user_s character varying
);


ALTER TABLE rtd_database.rtd_payment_instrument_data OWNER TO ddsadmin;

--
-- Name: SCHEMA rtd_database; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT USAGE ON SCHEMA rtd_database TO "RTD_USER";
GRANT USAGE ON SCHEMA rtd_database TO "MONITORING_USER";


--
-- Name: FUNCTION get_payment_instrument_hpans(); Type: ACL; Schema: rtd_database; Owner: ddsadmin
--

GRANT ALL ON FUNCTION rtd_database.get_payment_instrument_hpans() TO "RTD_USER";
GRANT ALL ON FUNCTION rtd_database.get_payment_instrument_hpans() TO "MONITORING_USER";


--
-- Name: FOREIGN DATA WRAPPER dblink_fdw; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN DATA WRAPPER dblink_fdw TO "RTD_USER";
GRANT ALL ON FOREIGN DATA WRAPPER dblink_fdw TO "MONITORING_USER";


--
-- Name: FOREIGN SERVER bpd_payment_instrument_remote; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN SERVER bpd_payment_instrument_remote TO "RTD_USER";
GRANT ALL ON FOREIGN SERVER bpd_payment_instrument_remote TO "MONITORING_USER";


--
-- Name: FOREIGN SERVER fa_payment_instrument_remote; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN SERVER fa_payment_instrument_remote TO "RTD_USER";


--
-- Name: TABLE rtd_batch_exec_data; Type: ACL; Schema: rtd_database; Owner: ddsadmin
--

GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE rtd_database.rtd_batch_exec_data TO "RTD_USER";


--
-- Name: TABLE rtd_payment_instrument_data; Type: ACL; Schema: rtd_database; Owner: ddsadmin
--

GRANT SELECT,INSERT,DELETE,TRIGGER,UPDATE ON TABLE rtd_database.rtd_payment_instrument_data TO "RTD_USER";


--
-- PostgreSQL database dump complete
--

