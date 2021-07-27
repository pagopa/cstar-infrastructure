--
-- PostgreSQL database dump
--

-- Dumped from database version 10.16
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
-- Name: rtd_database; Type: SCHEMA; Schema: -; Owner: RTD_USER
--

CREATE SCHEMA rtd_database;


ALTER SCHEMA rtd_database OWNER TO "RTD_USER";

--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: get_payment_instrument_hpans(); Type: FUNCTION; Schema: rtd_database; Owner: RTD_USER
--

CREATE FUNCTION rtd_database.get_payment_instrument_hpans() RETURNS TABLE(hpan_s character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY 
SELECT extr.hpan_s FROM ((
SELECT bpd_payment_instr.hpan_s FROM public.dblink('bpd_payment_instrument_remote','SELECT hpan_s FROM bpd_payment_instrument.bpd_payment_instrument WHERE enabled_b=true')
	AS bpd_payment_instr(hpan_s varchar))
UNION
(SELECT fa_payment_instr.hpan_s FROM public.dblink('fa_payment_instrument_remote','SELECT hpan_s FROM fa_payment_instrument.fa_payment_instrument WHERE enabled_b=true')
 AS fa_payment_instr(hpan_s varchar))
 ) extr
 ORDER BY extr.hpan_s;
END
$$;


ALTER FUNCTION rtd_database.get_payment_instrument_hpans() OWNER TO "RTD_USER";

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
-- Name: USER MAPPING ddsadmin SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

-- TODO: ?????????
-- CREATE USER MAPPING FOR ddsadmin SERVER bpd_payment_instrument_remote OPTIONS (
--     password 'XXXXXXXXXX',
--     "user" 'BPD_PAYMENT_INSTRUMENT_REMOTE_USER@ddspostgret01.postgres.database.azure.com'
-- );

CREATE USER MAPPING FOR ddsadmin SERVER bpd_payment_instrument_remote;

ALTER USER MAPPING
	FOR "ddsadmin"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'BPD_PAYMENT_INSTRUMENT_REMOTE_USER@${serverName}', password '${bpdPaymentInstrumentRemoteUserPassword}');

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

--
-- Name: USER MAPPING ddsadmin SERVER fa_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

-- TODO: ?????????
-- CREATE USER MAPPING FOR ddsadmin SERVER fa_payment_instrument_remote OPTIONS (
--     password 'XXXXXX',
--     "user" 'FA_PAYMENT_INSTRUMENT_REMOTE_USER@ddspostgret01.postgres.database.azure.com'
-- );

CREATE USER MAPPING FOR ddsadmin SERVER fa_payment_instrument_remote;

ALTER USER MAPPING
	FOR "ddsadmin"
	SERVER fa_payment_instrument_remote
	OPTIONS (user 'FA_PAYMENT_INSTRUMENT_REMOTE_USER@${serverName}', password '${faPaymentInstrumentRemoteUserPassword}');

SET default_tablespace = '';

--
-- Name: payment_instrument_hpans; Type: MATERIALIZED VIEW; Schema: rtd_database; Owner: RTD_USER
--

CREATE MATERIALIZED VIEW rtd_database.payment_instrument_hpans AS
 SELECT bpd_payment_instr.hpan_s
   FROM public.dblink('bpd_payment_instrument_remote'::text, 'SELECT hpan_s FROM bpd_payment_instrument.bpd_payment_instrument WHERE enabled_b=true'::text) bpd_payment_instr(hpan_s character varying)
UNION
 SELECT fa_payment_instr.hpan_s
   FROM public.dblink('fa_payment_instrument_remote'::text, 'SELECT hpan_s FROM fa_payment_instrument.fa_payment_instrument WHERE enabled_b=true'::text) fa_payment_instr(hpan_s character varying)
  WITH NO DATA;


ALTER TABLE rtd_database.payment_instrument_hpans OWNER TO "RTD_USER";

--
-- Name: rtd_batch_exec_data; Type: TABLE; Schema: rtd_database; Owner: RTD_USER
--

CREATE TABLE rtd_database.rtd_batch_exec_data (
    bpd_execution_date_t timestamp with time zone,
    bpd_del_execution_date_t timestamp with time zone,
    fa_execution_date_t timestamp with time zone,
    fa_del_execution_date_t timestamp with time zone,
    bpd_updt_execution_date_t timestamp with time zone
);


ALTER TABLE rtd_database.rtd_batch_exec_data OWNER TO "RTD_USER";

--
-- Name: rtd_payment_instrument_data; Type: TABLE; Schema: rtd_database; Owner: RTD_USER
--

CREATE TABLE rtd_database.rtd_payment_instrument_data (
    hpan_s character varying NOT NULL,
    bpd_enabled_b boolean DEFAULT false NOT NULL,
    fa_enabled_b boolean DEFAULT false NOT NULL,
    insert_date_t timestamp with time zone,
    update_date_t timestamp with time zone,
    insert_user_s character varying,
    update_user_s character varying,
    par_s character varying
);


ALTER TABLE rtd_database.rtd_payment_instrument_data OWNER TO "RTD_USER";

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: azure_superuser
--

GRANT USAGE ON SCHEMA public TO "MONITORING_USER";


--
-- Name: SCHEMA rtd_database; Type: ACL; Schema: -; Owner: RTD_USER
--

GRANT USAGE ON SCHEMA rtd_database TO "MONITORING_USER";


--
-- Name: FUNCTION get_payment_instrument_hpans(); Type: ACL; Schema: rtd_database; Owner: RTD_USER
--

GRANT ALL ON FUNCTION rtd_database.get_payment_instrument_hpans() TO "MONITORING_USER";


--
-- Name: FOREIGN DATA WRAPPER dblink_fdw; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN DATA WRAPPER dblink_fdw TO "RTD_USER";


--
-- Name: FOREIGN SERVER bpd_payment_instrument_remote; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN SERVER bpd_payment_instrument_remote TO "RTD_USER";
GRANT ALL ON FOREIGN SERVER bpd_payment_instrument_remote TO "MONITORING_USER";


--
-- Name: FOREIGN SERVER fa_payment_instrument_remote; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN SERVER fa_payment_instrument_remote TO "RTD_USER";
GRANT ALL ON FOREIGN SERVER fa_payment_instrument_remote TO "MONITORING_USER";


--
-- Name: TABLE payment_instrument_hpans; Type: ACL; Schema: rtd_database; Owner: RTD_USER
--

GRANT SELECT ON TABLE rtd_database.payment_instrument_hpans TO "MONITORING_USER";


--
-- Name: TABLE rtd_batch_exec_data; Type: ACL; Schema: rtd_database; Owner: RTD_USER
--

GRANT SELECT ON TABLE rtd_database.rtd_batch_exec_data TO "MONITORING_USER";


--
-- Name: TABLE rtd_payment_instrument_data; Type: ACL; Schema: rtd_database; Owner: RTD_USER
--

GRANT SELECT ON TABLE rtd_database.rtd_payment_instrument_data TO "MONITORING_USER";


--
-- PostgreSQL database dump complete
--

