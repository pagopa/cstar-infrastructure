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
-- Name: fa_customer; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_customer;
ALTER SCHEMA fa_customer OWNER TO '${adminUser}';

--
-- Name: fa_file_storage; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_file_storage;
ALTER SCHEMA fa_file_storage OWNER TO '${adminUser}';

--
-- Name: fa_merchant; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_merchant;
ALTER SCHEMA fa_merchant OWNER TO '${adminUser}';

--
-- Name: fa_payment_instrument; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_payment_instrument;
ALTER SCHEMA fa_payment_instrument OWNER TO '${adminUser}';

--
-- Name: fa_provider; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_provider;
ALTER SCHEMA fa_provider OWNER TO '${adminUser}';

--
-- Name: fa_transaction; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_transaction;
ALTER SCHEMA fa_transaction OWNER TO '${adminUser}';

SET default_tablespace = '';

--
-- Name: fa_customer; Type: TABLE; Schema: fa_customer; Owner: ddsadmin
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

ALTER TABLE fa_customer.fa_customer OWNER TO '${adminUser}';

--
-- Name: fa_customer_vat; Type: TABLE; Schema: fa_customer; Owner: ddsadmin
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

ALTER TABLE fa_customer.fa_customer_vat OWNER TO '${adminUser}';

--
-- Name: fa_merchant; Type: TABLE; Schema: fa_merchant; Owner: ddsadmin
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

ALTER TABLE fa_merchant.fa_merchant OWNER TO '${adminUser}';

--
-- Name: fa_merchant_shop; Type: TABLE; Schema: fa_merchant; Owner: ddsadmin
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

ALTER TABLE fa_merchant.fa_merchant_shop OWNER TO '${adminUser}';

--
-- Name: fa_payment_instrument; Type: TABLE; Schema: fa_payment_instrument; Owner: ddsadmin
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

ALTER TABLE fa_payment_instrument.fa_payment_instrument OWNER TO '${adminUser}';

--
-- Name: fa_transaction; Type: TABLE; Schema: fa_transaction; Owner: ddsadmin
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

ALTER TABLE fa_transaction.fa_transaction OWNER TO '${adminUser}';

--
-- Name: fa_transaction_request; Type: TABLE; Schema: fa_transaction; Owner: ddsadmin
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

ALTER TABLE fa_transaction.fa_transaction_request OWNER TO '${adminUser}';

--
-- Name: SCHEMA fa_customer; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA fa_customer TO "FA_USER";
GRANT USAGE ON SCHEMA fa_customer TO "MONITORING_USER";


--
-- Name: SCHEMA fa_file_storage; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA fa_file_storage TO "FA_USER";
GRANT USAGE ON SCHEMA fa_file_storage TO "MONITORING_USER";


--
-- Name: SCHEMA fa_merchant; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA fa_merchant TO "FA_USER";
GRANT USAGE ON SCHEMA fa_merchant TO "MONITORING_USER";


--
-- Name: SCHEMA fa_payment_instrument; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT USAGE ON SCHEMA fa_payment_instrument TO "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT ALL ON SCHEMA fa_payment_instrument TO "FA_USER";
GRANT USAGE ON SCHEMA fa_payment_instrument TO "MONITORING_USER";


--
-- Name: SCHEMA fa_provider; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA fa_provider TO "FA_USER";
GRANT USAGE ON SCHEMA fa_provider TO "MONITORING_USER";


--
-- Name: SCHEMA fa_transaction; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA fa_transaction TO "FA_USER";
GRANT USAGE ON SCHEMA fa_transaction TO "MONITORING_USER";


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: azure_superuser
--

GRANT USAGE ON SCHEMA public TO "MONITORING_USER";


--
-- Name: TABLE fa_customer; Type: ACL; Schema: fa_customer; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_customer.fa_customer TO "FA_USER";


--
-- Name: TABLE fa_customer_vat; Type: ACL; Schema: fa_customer; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_customer.fa_customer_vat TO "FA_USER";


--
-- Name: TABLE fa_merchant; Type: ACL; Schema: fa_merchant; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_merchant.fa_merchant TO "FA_USER";


--
-- Name: TABLE fa_merchant_shop; Type: ACL; Schema: fa_merchant; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_merchant.fa_merchant_shop TO "FA_USER";


--
-- Name: TABLE fa_payment_instrument; Type: ACL; Schema: fa_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_payment_instrument.fa_payment_instrument TO "FA_USER";
GRANT SELECT ON TABLE fa_payment_instrument.fa_payment_instrument TO "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT SELECT ON TABLE fa_payment_instrument.fa_payment_instrument TO "MONITORING_USER";


--
-- Name: TABLE fa_transaction; Type: ACL; Schema: fa_transaction; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_transaction.fa_transaction TO "FA_USER";


--
-- Name: TABLE fa_transaction_request; Type: ACL; Schema: fa_transaction; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_transaction.fa_transaction_request TO "FA_USER";