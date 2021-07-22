--
-- PostgreSQL database dump
--

-- Dumped from database version 10.11
-- Dumped by pg_dump version 10.14

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
-- Name: rtd_database; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA rtd_database;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: get_payment_instrument_hpans(); Type: FUNCTION; Schema: rtd_database; Owner: -
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


--
-- Name: bpd_payment_instrument_remote; Type: SERVER; Schema: -; Owner: -
--

CREATE SERVER bpd_payment_instrument_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'bpd',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
    );

ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (sslmode 'require');

--
-- Name: USER MAPPING MONITORING_USER SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR "MONITORING_USER" SERVER bpd_payment_instrument_remote;

ALTER USER MAPPING
	FOR "MONITORING_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'MONITORING_USER@${serverName}', password '${monitoringUserPassword}');

--
-- Name: USER MAPPING RTD_USER SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR "RTD_USER" SERVER bpd_payment_instrument_remote;

ALTER USER MAPPING
	FOR "RTD_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'RTD_USER@${serverName}', password '${rtdUserPassword}');

--
-- Name: USER MAPPING ddsadmin SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR ddsadmin SERVER bpd_payment_instrument_remote OPTIONS (
    password '${bpdPaymentInstrumentRemoteUserPassword}',
    "user" 'BPD_PAYMENT_INSTRUMENT_REMOTE_USER@${serverName}'
    );

--
-- Name: fa_payment_instrument_remote; Type: SERVER; Schema: -; Owner: -
--

CREATE SERVER fa_payment_instrument_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'fa',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
    );

ALTER SERVER fa_payment_instrument_remote
	OPTIONS (sslmode 'require');

--
-- Name: USER MAPPING MONITORING_USER SERVER fa_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR "MONITORING_USER" SERVER fa_payment_instrument_remote;

ALTER USER MAPPING
	FOR "MONITORING_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (user 'MONITORING_USER@${serverName}', password '${monitoringUserPassword}');

--
-- Name: USER MAPPING RTD_USER SERVER fa_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR "RTD_USER" SERVER fa_payment_instrument_remote;

ALTER USER MAPPING
	FOR "RTD_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (user 'RTD_USER@${serverName}', password '${rtdUserPassword}');

--
-- Name: USER MAPPING ddsadmin SERVER fa_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR ddsadmin SERVER fa_payment_instrument_remote OPTIONS (
    password '${faPaymentInstrumentRemoteUserPassword}',
    "user" 'FA_PAYMENT_INSTRUMENT_REMOTE_USER@${serverName}'
    );


SET default_tablespace = '';

--
-- Name: payment_instrument_hpans; Type: MATERIALIZED VIEW; Schema: rtd_database; Owner: -
--

CREATE MATERIALIZED VIEW rtd_database.payment_instrument_hpans AS
SELECT bpd_payment_instr.hpan_s
FROM public.dblink('bpd_payment_instrument_remote'::text, 'SELECT hpan_s FROM bpd_payment_instrument.bpd_payment_instrument WHERE enabled_b=true'::text) bpd_payment_instr(hpan_s character varying)
UNION
SELECT fa_payment_instr.hpan_s
FROM public.dblink('fa_payment_instrument_remote'::text, 'SELECT hpan_s FROM fa_payment_instrument.fa_payment_instrument WHERE enabled_b=true'::text) fa_payment_instr(hpan_s character varying)
WITH NO DATA;


SET default_with_oids = false;

--
-- Name: rtd_batch_exec_data; Type: TABLE; Schema: rtd_database; Owner: -
--

CREATE TABLE rtd_database.rtd_batch_exec_data (
                                                  bpd_execution_date_t timestamp with time zone,
                                                  bpd_del_execution_date_t timestamp with time zone,
                                                  fa_execution_date_t timestamp with time zone,
                                                  fa_del_execution_date_t timestamp with time zone,
                                                  bpd_updt_execution_date_t timestamp with time zone
);


--
-- Name: rtd_payment_instrument_data; Type: TABLE; Schema: rtd_database; Owner: -
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


--
-- PostgreSQL database dump complete
--

