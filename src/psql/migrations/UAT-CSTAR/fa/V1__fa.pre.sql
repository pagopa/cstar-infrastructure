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


ALTER SCHEMA fa_customer OWNER TO ddsadmin;

--
-- Name: fa_file_storage; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_file_storage;


ALTER SCHEMA fa_file_storage OWNER TO ddsadmin;

--
-- Name: fa_merchant; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_merchant;


ALTER SCHEMA fa_merchant OWNER TO ddsadmin;

--
-- Name: fa_payment_instrument; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_payment_instrument;


ALTER SCHEMA fa_payment_instrument OWNER TO ddsadmin;

--
-- Name: fa_provider; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_provider;


ALTER SCHEMA fa_provider OWNER TO ddsadmin;

--
-- Name: fa_transaction; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_transaction;


ALTER SCHEMA fa_transaction OWNER TO ddsadmin;

--
-- Name: fa_error_record; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_error_record;


ALTER SCHEMA fa_error_record OWNER TO ddsadmin;

SET default_tablespace = '';

--
-- Name: fa_customer; Type: TABLE; Schema: fa_customer; Owner: ddsadmin
--

CREATE TABLE fa_customer.fa_customer (
	fiscal_code_s character varying(16) NOT NULL,
	timestamp_tc_t timestamp with time zone NOT NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	enabled_b boolean NULL,
	status_c character varying(10) NOT NULL DEFAULT 'ACTIVE'::character varying,
	cancellation_t timestamp with time zone NULL,
	destination_code_s character varying(255) NULL,
	pec_s character varying(255) NULL
);


ALTER TABLE fa_customer.fa_customer OWNER TO ddsadmin;

--
-- Name: fa_customer_vat; Type: TABLE; Schema: fa_customer; Owner: ddsadmin
--

CREATE TABLE fa_customer.fa_customer_vat (
	fiscal_code_s character varying(16) NOT NULL,
	vat_number_s character varying(11) NOT NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	enabled_b boolean NULL,
	destination_code_s character varying(255) NULL,
	pec_s character varying(255) NULL
);


ALTER TABLE fa_customer.fa_customer_vat OWNER TO ddsadmin;

--
-- Name: fa_merchant; Type: TABLE; Schema: fa_merchant; Owner: ddsadmin
--

CREATE TABLE fa_merchant.fa_merchant (
	vat_number_s character varying(11) NOT NULL,
	timestamp_tc_t timestamp with time zone NOT NULL,
	mcc_invoice_desc_s character varying(40) NULL,
	provider_id bigint NOT NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	enabled_b boolean NULL,
	fiscal_code_s character varying(16) NULL,
	company_name_s character varying NULL,
	company_address_s character varying NULL
);


ALTER TABLE fa_merchant.fa_merchant OWNER TO ddsadmin;

--
-- Name: fa_merchant_shop; Type: TABLE; Schema: fa_merchant; Owner: ddsadmin
--

CREATE TABLE fa_merchant.fa_merchant_shop (
	merchant_id character varying NOT NULL,
	vat_number_s character varying(11) NOT NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	enabled_b boolean NULL
);


ALTER TABLE fa_merchant.fa_merchant_shop OWNER TO ddsadmin;


--
-- Name: fa_provider; Type: TABLE; Schema: fa_provider; Owner: ddsadmin
--

CREATE TABLE fa_provider.fa_provider (
	provider_id bigserial NOT NULL,
	provider_desc_s character varying(255) NOT NULL,
	endpoint_address_s character varying(255) NOT NULL,
	endpoint_chk_merchant_s character varying(255) NOT NULL,
	endpoint_request_fa_s character varying(255) NOT NULL,
	keystore_clob bytea NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	enabled_b boolean NULL,
	endpoint_status_fa_s character varying(255) NULL
);


ALTER TABLE fa_provider.fa_provider OWNER TO ddsadmin;

--
-- Name: SEQUENCE fa_provider_provider_id_seq; Type: ACL; Schema: fa_provider; Owner: ddsadmin
--

CREATE SEQUENCE fa_provider.fa_provider_provider_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;


ALTER TABLE fa_provider.fa_provider_provider_id_seq OWNER TO ddsadmin;

--
-- Name: fa_payment_instrument; Type: TABLE; Schema: fa_payment_instrument; Owner: ddsadmin
--

CREATE TABLE fa_payment_instrument.fa_payment_instrument (
	hpan_s character varying(64) NOT NULL,
	enrollment_t timestamp with time zone NOT NULL,
	cancellation_t timestamp with time zone NULL,
	request_canc_t timestamp with time zone NULL,
	status_c character varying(10) NOT NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	enabled_b boolean NULL,
	sdi_s character varying NULL,
	cup_s character varying NULL,
	vat_number_s character varying(11) NULL,
	fiscal_code_s character varying(16) NOT NULL,
	channel_s character varying(20) NULL,
	hpan_master_s character varying(64) NULL,
	par_s character varying(32) NULL,
	par_enrollment_t timestamptz(0) NULL,
	par_cancellation_t timestamptz(0) NULL,
	last_tkm_update_t timestamp with time zone NULL
);


ALTER TABLE fa_payment_instrument.fa_payment_instrument OWNER TO ddsadmin;

--
-- Name: fa_payment_instrument; Type: TABLE; Schema: fa_payment_instrument; Owner: ddsadmin
--

CREATE TABLE fa_payment_instrument.fa_payment_instrument_history (
	hpan_s character varying(64) NOT NULL,
	activation_t timestamp with time zone NOT NULL,
	deactivation_t timestamp with time zone NULL,
	id_n bigserial NOT NULL,
	update_date_t timestamp with time zone NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_user_s character varying(40) NULL,
	fiscal_code_s character varying(16) NULL,
	channel_s character varying(20) NULL,
	par_s character varying(32) NULL,
	par_activation_t timestamptz(0) NULL,
	par_deactivation_t timestamptz(0) NULL,
	vat_number_s character varying(11) NULL
);

ALTER TABLE fa_payment_instrument.fa_payment_instrument_history OWNER TO ddsadmin;

--
-- Name: SEQUENCE fa_payment_instrument_history_id_n_seq; Type: ACL; Schema: fa_payment_instrument; Owner: ddsadmin
--

CREATE SEQUENCE fa_payment_instrument.fa_payment_instrument_history_id_n_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

ALTER TABLE fa_payment_instrument.fa_payment_instrument_history_id_n_seq OWNER TO ddsadmin;

ALTER SEQUENCE fa_payment_instrument.fa_payment_instrument_history_id_n_seq OWNED BY fa_payment_instrument.fa_payment_instrument_history.id_n;

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history ALTER COLUMN id_n SET DEFAULT nextval('fa_payment_instrument.fa_payment_instrument_history_id_n_seq'::regclass);

--
-- Name: SEQUENCE fa_payment_instrument_history_id_n_seq; Type: ACL; Schema: fa_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON SEQUENCE fa_payment_instrument.fa_payment_instrument_history_id_n_seq TO "FA_USER";

--
-- Name: fa_transaction; Type: TABLE; Schema: fa_transaction; Owner: ddsadmin
--

CREATE TABLE fa_transaction.fa_transaction (
	id_trx_acquirer_s character varying NOT NULL,
	acquirer_c character varying(20) NOT NULL,
	trx_timestamp_t timestamp with time zone NOT NULL,
	hpan_s character varying(64) NULL,
	operation_type_c character varying(5) NULL,
	circuit_type_c character varying(5) NULL,
	id_trx_issuer_s character varying NOT NULL,
	correlation_id_s character varying NULL,
	amount_i numeric NOT NULL,
	amount_currency_c character varying(3) NULL,
	mcc_c character varying(5) NULL,
	mcc_descr_s character varying(40) NULL,
	acquirer_id_s character varying NULL,
	merchant_id character varying NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	enabled_b boolean NULL,
	status_s character varying(2) NULL,
	fiscal_code_s character varying(16) NULL,
	par_s character varying(32) NULL,
	hpan_master_s character varying(64) NULL,
	bin_card_s character varying NOT NULL,
	terminal_id_s character varying(255) NOT NULL,
	invoice_status_s character varying NULL,
	invoice_code_s character varying NULL,
	invoice_status_date_t timestamptz(0) NULL,
	invoice_rejected_reason_s character varying NULL,
	invoice_status_insert_request_date_t timestamptz(0) NULL,
	invoice_status_update_request_date_t timestamptz(0) NULL,
	notification_id_s character varying NULL,
	notify_date_t timestamptz(0) NULL,
	notify_status_s character varying NULL,
	invoice_elab_b boolean NULL,
	to_notify_b boolean NULL
);


ALTER TABLE fa_transaction.fa_transaction OWNER TO ddsadmin;

--
-- Name: fa_transaction_request; Type: TABLE; Schema: fa_transaction; Owner: ddsadmin
--

CREATE TABLE fa_transaction.fa_transaction_request (
	vat_number_s character varying NOT NULL,
	transaction_date_t timestamp with time zone NOT NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	enabled_b boolean NULL,
	invoice_status_s character varying NULL,
	pos_type_s character varying NULL,
	bin_card_s character varying NOT NULL,
	terminal_id_s character varying(255) NOT NULL,
	auth_code_s character varying NOT NULL,
	amount_i numeric NOT NULL,
	merchant_id character varying NULL
);


ALTER TABLE fa_transaction.fa_transaction_request OWNER TO ddsadmin;

--
-- Name: fa_transaction_record; Type: TABLE; Schema: fa_error_record; Owner: ddsadmin
--

CREATE TABLE fa_error_record.fa_transaction_record (
	record_id_s character varying(64) NOT NULL,
	acquirer_c character varying(20) NULL,
	trx_timestamp_t timestamp with time zone NULL,
	hpan_s character varying NULL,
	operation_type_c character varying(5) NULL,
	circuit_type_c character varying(5) NULL,
	amount_i numeric NULL,
	amount_currency_c character varying(3) NULL,
	mcc_c character varying(5) NULL,
	mcc_descr_s character varying(40) NULL,
	score_n numeric NULL,
	award_period_id_n bigint NULL,
	insert_date_t timestamp with time zone NULL,
	insert_user_s character varying(40) NULL,
	update_date_t timestamp with time zone NULL,
	update_user_s character varying(40) NULL,
	merchant_id_s character varying NULL,
	correlation_id_s character varying NULL,
	acquirer_id_s character varying NULL,
	id_trx_issuer_s character varying NULL,
	id_trx_acquirer_s character varying NULL,
	bin_s character varying NULL,
	terminal_id_s character varying NULL,
	fiscal_code_s character varying(16) NULL,
	origin_topic_s character varying(30) NULL,
	origin_listener_s character varying(4000) NULL,
	exception_message_s character varying(4000) NULL,
	origin_request_id_s character varying(4000) NULL,
	last_resubmit_date_t timestamp with time zone NULL,
	to_resubmit_b boolean NULL,
	enabled_b boolean NULL,
	par_s character varying(32) NULL
);

ALTER TABLE fa_error_record.fa_transaction_record OWNER TO ddsadmin;

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
-- Name: SCHEMA fa_payment_instrument_history; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT USAGE ON SCHEMA fa_payment_instrument_history TO "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT ALL ON SCHEMA fa_payment_instrument_history TO "FA_USER";
GRANT USAGE ON SCHEMA fa_payment_instrument_history TO "MONITORING_USER";


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
-- Name: TABLE fa_payment_instrument_history; Type: ACL; Schema: fa_payment_instrument_history; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_payment_instrument.fa_payment_instrument_history TO "FA_USER";
GRANT SELECT ON TABLE fa_payment_instrument.fa_payment_instrument_history TO "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT SELECT ON TABLE fa_payment_instrument.fa_payment_instrument_history TO "MONITORING_USER";


--
-- Name: TABLE fa_transaction; Type: ACL; Schema: fa_transaction; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_transaction.fa_transaction TO "FA_USER";


--
-- Name: TABLE fa_transaction_request; Type: ACL; Schema: fa_transaction; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_transaction.fa_transaction_request TO "FA_USER";


--
-- Name: TABLE fa_transaction_request; Type: ACL; Schema: fa_transaction; Owner: ddsadmin
--


CREATE OR REPLACE FUNCTION fa_payment_instrument.insert_fa_payment_instrument_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $$
    BEGIN
        INSERT INTO fa_payment_instrument.fa_payment_instrument_history(hpan_s, activation_t, deactivation_t, fiscal_code_s, insert_date_t, insert_user_s, update_date_t, update_user_s, channel_s, par_s, par_activation_t, par_deactivation_t, vat_number_s)
		VALUES(NEW.hpan_s, NEW.enrollment_t, NULL, NEW.fiscal_code_s, NEW.insert_date_t, NEW.insert_user_s, NEW.update_date_t, NEW.update_user_s, NEW.channel_s, NEW.par_s, NEW.par_enrollment_t, NEW.par_cancellation_t, new.vat_number_s) ON CONFLICT DO NOTHING;
        RETURN NEW;
    END;
$$;

ALTER FUNCTION fa_payment_instrument.insert_fa_payment_instrument_history() OWNER TO ddsadmin;

--
-- Name: TABLE fa_transaction_request; Type: ACL; Schema: fa_transaction; Owner: ddsadmin
--


CREATE OR REPLACE FUNCTION fa_payment_instrument.update_fa_payment_instrument_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $$
			BEGIN
				UPDATE fa_payment_instrument.fa_payment_instrument_history
				SET deactivation_t=NEW.cancellation_t, update_date_t=NEW.update_date_t, update_user_s=NEW.update_user_s,
				par_activation_t=NEW.par_enrollment_t,par_deactivation_t=NEW.par_cancellation_t,vat_number_s=NEW.vat_number_s
				WHERE hpan_s=NEW.hpan_s AND activation_t=OLD.enrollment_t;
				RETURN NEW;
				EXCEPTION WHEN unique_violation THEN
				RETURN OLD;
			END;
$$;

ALTER FUNCTION fa_payment_instrument.update_fa_payment_instrument_history() OWNER TO ddsadmin;


--
-- Name: FUNCTION insert_fa_payment_instrument_history(); Type: ACL; Schema: fa_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON FUNCTION fa_payment_instrument.insert_fa_payment_instrument_history() TO "FA_USER";


--
-- Name: FUNCTION update_fa_payment_instrument_history(); Type: ACL; Schema: fa_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON FUNCTION fa_payment_instrument.update_fa_payment_instrument_history() TO "FA_USER";

--
-- Name: fa_payment_instrument update_fa_payment_instrument_history_trg; Type: TRIGGER; Schema: fa_payment_instrument; Owner: ddsadmin
--

create trigger update_fa_payment_instrument_history_trg after
update
    of cancellation_t on
    fa_payment_instrument.fa_payment_instrument for each row execute procedure fa_payment_instrument.update_fa_payment_instrument_history();

--
-- Name: fa_payment_instrument insert_update_fa_payment_instrument_history_trg; Type: TRIGGER; Schema: fa_payment_instrument; Owner: ddsadmin
--

create trigger insert_update_fa_payment_instrument_history_trg after
update
    of enrollment_t on
    fa_payment_instrument.fa_payment_instrument for each row
    when (((new.enabled_b = true)
        and (new.enabled_b <> old.enabled_b)
            and (old.enrollment_t <> new.enrollment_t))) execute procedure fa_payment_instrument.insert_fa_payment_instrument_history();

--
-- Name: fa_payment_instrument insert_fa_payment_instrument_history_trg; Type: TRIGGER; Schema: fa_payment_instrument; Owner: ddsadmin
--

create trigger insert_fa_payment_instrument_history_trg after
insert
    on
    fa_payment_instrument.fa_payment_instrument for each row
    when ((new.enabled_b = true)) execute procedure fa_payment_instrument.insert_fa_payment_instrument_history();


--
-- PostgreSQL database dump complete
--

