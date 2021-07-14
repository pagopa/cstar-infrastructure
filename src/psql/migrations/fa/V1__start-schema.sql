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
-- Name: fa_customer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA fa_customer;


--
-- Name: fa_file_storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA fa_file_storage;


--
-- Name: fa_merchant; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA fa_merchant;


--
-- Name: fa_payment_instrument; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA fa_payment_instrument;


--
-- Name: fa_provider; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA fa_provider;


--
-- Name: fa_transaction; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA fa_transaction;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: fa_customer; Type: TABLE; Schema: fa_customer; Owner: -
--

CREATE TABLE fa_customer.fa_customer (
                                         fiscal_code_s character varying(16) NOT NULL,
                                         timestamp_tc_t timestamp with time zone NOT NULL,
                                         insert_date_t timestamp with time zone,
                                         insert_user_s character varying(40),
                                         update_date_t timestamp with time zone,
                                         update_user_s character varying(40),
                                         enabled_b boolean,
                                         status_c character varying(10) DEFAULT 'ACTIVE'::character varying NOT NULL,
                                         cancellation_t timestamp with time zone
);


--
-- Name: fa_customer_vat; Type: TABLE; Schema: fa_customer; Owner: -
--

CREATE TABLE fa_customer.fa_customer_vat (
                                             fiscal_code_s character varying(16) NOT NULL,
                                             vat_number_s character varying(11) NOT NULL,
                                             insert_date_t timestamp with time zone,
                                             insert_user_s character varying(40),
                                             update_date_t timestamp with time zone,
                                             update_user_s character varying(40),
                                             enabled_b boolean
);


--
-- Name: fa_merchant; Type: TABLE; Schema: fa_merchant; Owner: -
--

CREATE TABLE fa_merchant.fa_merchant (
                                         vat_number_s character varying(11) NOT NULL,
                                         timestamp_tc_t timestamp with time zone NOT NULL,
                                         mcc_invoice_desc_s character varying(40),
                                         provider_id bigint NOT NULL,
                                         insert_date_t timestamp with time zone,
                                         insert_user_s character varying(40),
                                         update_date_t timestamp with time zone,
                                         update_user_s character varying(40),
                                         enabled_b boolean,
                                         fiscal_code_s character varying(16)
);


--
-- Name: fa_merchant_shop; Type: TABLE; Schema: fa_merchant; Owner: -
--

CREATE TABLE fa_merchant.fa_merchant_shop (
                                              merchant_id character varying NOT NULL,
                                              vat_number_s character varying(11) NOT NULL,
                                              insert_date_t timestamp with time zone,
                                              insert_user_s character varying(40),
                                              update_date_t timestamp with time zone,
                                              update_user_s character varying(40),
                                              enabled_b boolean
);


--
-- Name: fa_payment_instrument; Type: TABLE; Schema: fa_payment_instrument; Owner: -
--

CREATE TABLE fa_payment_instrument.fa_payment_instrument (
                                                             hpan_s character varying(64) NOT NULL,
                                                             enrollment_t timestamp with time zone NOT NULL,
                                                             cancellation_t timestamp with time zone,
                                                             request_canc_t timestamp with time zone,
                                                             status_c character varying(10) NOT NULL,
                                                             insert_date_t timestamp with time zone,
                                                             insert_user_s character varying(40),
                                                             update_date_t timestamp with time zone,
                                                             update_user_s character varying(40),
                                                             enabled_b boolean,
                                                             sdi_s character varying,
                                                             cup_s character varying,
                                                             vat_number_s character varying(11) NOT NULL,
                                                             fiscal_code_s character varying(16) NOT NULL
);


--
-- Name: fa_transaction; Type: TABLE; Schema: fa_transaction; Owner: -
--

CREATE TABLE fa_transaction.fa_transaction (
                                               id_trx_acquirer_n integer NOT NULL,
                                               acquirer_c character varying(20) NOT NULL,
                                               trx_timestamp_t timestamp with time zone NOT NULL,
                                               hpan_s character varying(64),
                                               operation_type_c character varying(5),
                                               circuit_type_c character varying(5),
                                               id_trx_issuer_n integer,
                                               correlation_id_n integer,
                                               amount_i numeric,
                                               amount_currency_c character varying(3),
                                               mcc_c character varying(5),
                                               mcc_descr_s character varying(40),
                                               acquirer_id_n integer,
                                               merchant_id bigint,
                                               insert_date_t timestamp with time zone,
                                               insert_user_s character varying(40),
                                               update_date_t timestamp with time zone,
                                               update_user_s character varying(40),
                                               enabled_b boolean,
                                               status_s character varying(2) NOT NULL
);


--
-- Name: fa_transaction_request; Type: TABLE; Schema: fa_transaction; Owner: -
--

CREATE TABLE fa_transaction.fa_transaction_request (
                                                       transaction_id_s character varying NOT NULL,
                                                       vat_number_s character varying NOT NULL,
                                                       customer_param_s character varying NOT NULL,
                                                       customer_param_desc_s character varying,
                                                       transaction_date_t timestamp with time zone NOT NULL,
                                                       insert_date_t timestamp with time zone,
                                                       insert_user_s character varying(40),
                                                       update_date_t timestamp with time zone,
                                                       update_user_s character varying(40),
                                                       enabled_b boolean,
                                                       invoice_status_s character varying NOT NULL,
                                                       acquirer_id_n integer,
                                                       merchant_id_n bigint,
                                                       pos_type_s character varying NOT NULL
);


--
-- PostgreSQL database dump complete
--

