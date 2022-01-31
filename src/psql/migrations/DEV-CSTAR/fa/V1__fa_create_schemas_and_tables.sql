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

-- CUSTOMER

CREATE SCHEMA fa_customer;
ALTER SCHEMA fa_customer OWNER TO "FA_USER";

CREATE TABLE fa_customer.fa_customer (
    fiscal_code_s character varying(16) NOT NULL,
    timestamp_tc_t timestamp with time zone NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    status_c character varying(10) DEFAULT 'ACTIVE'::character varying NOT NULL,
    cancellation_t timestamp with time zone,
    destination_code_s character varying(255) NULL,
    pec_s character varying(255) NULL
);

ALTER TABLE fa_customer.fa_customer OWNER TO "FA_USER";

CREATE TABLE fa_customer.fa_customer_vat (
    fiscal_code_s character varying(16) NOT NULL,
    vat_number_s character varying(11) NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    destination_code_s character varying(255) NULL,
    pec_s character varying(255) NULL
);

ALTER TABLE fa_customer.fa_customer_vat OWNER TO "FA_USER";

-- MERCHANT

CREATE SCHEMA fa_merchant;
ALTER SCHEMA fa_merchant OWNER TO "FA_USER";

CREATE TABLE fa_merchant.fa_merchant (
    vat_number_s character varying(11) NOT NULL,
    timestamp_tc_t timestamp with time zone NOT NULL,
    mcc_invoice_desc_s character varying(40),
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    fiscal_code_s character varying(16),
    company_name_s character varying NULL,
    company_address_s character varying NULL,
    status_s VARCHAR NOT NULL,
    cancellation_t timestamp with time zone
);

ALTER TABLE fa_merchant.fa_merchant OWNER TO "FA_USER";

CREATE TABLE fa_merchant.fa_merchant_shop (
    merchant_id character varying NOT NULL,
    vat_number_s character varying(11) NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    company_name_s VARCHAR NOT NULL,
    company_address_s VARCHAR NOT NULL,
    contact_person_name_s VARCHAR NOT NULL,
    contact_person_surname_s VARCHAR NOT NULL,
    contact_person_email_s VARCHAR,
    contact_person_tel_1_s VARCHAR
);

ALTER TABLE fa_merchant.fa_merchant_shop OWNER TO "FA_USER";

CREATE TABLE fa_merchant.fa_register (
	register_id serial NOT NULL,
	register_code_s varchar NOT NULL,
	register_auth_token_s varchar NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s varchar(40),
    update_date_t timestamp with time zone,
    update_user_s varchar(40),
    enabled_b boolean
);

ALTER TABLE fa_merchant.fa_register OWNER TO "FA_USER";

CREATE TABLE fa_merchant.fa_merchant_contract (
	contract_id serial NOT NULL,
	activation_t timestamp with time zone NOT NULL,
	deactivation_t timestamp with time zone,
	provider_id int8 NOT NULL,
	shop_id varchar NOT NULL,
	insert_date_t timestamp with time zone,
	insert_user_s varchar(40),
	update_date_t timestamp with time zone,
	update_user_s varchar(40),
	enabled_b boolean,
	register_id bigserial NOT NULL
);

ALTER TABLE fa_merchant.fa_merchant_contract OWNER TO "FA_USER";

-- PAYMENT INSTRUMENT

CREATE SCHEMA fa_payment_instrument;
ALTER SCHEMA fa_payment_instrument OWNER TO "FA_USER";

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
    fiscal_code_s character varying(16) NOT NULL,
    channel_s character varying(20) NULL,
    hpan_master_s character varying(64) NULL,
    par_s character varying(32) NULL,
    par_enrollment_t timestamptz(0) NULL,
    par_cancellation_t timestamptz(0) NULL,
    last_tkm_update_t timestamp with time zone NULL
);

ALTER TABLE fa_payment_instrument.fa_payment_instrument OWNER TO "FA_USER";

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

ALTER TABLE fa_payment_instrument.fa_payment_instrument_history OWNER TO "FA_USER";

-- PROVIDER

CREATE SCHEMA fa_provider;
ALTER SCHEMA fa_provider OWNER TO "FA_USER";

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

ALTER TABLE fa_provider.fa_provider OWNER TO "FA_USER";

-- TRANSACTIONS (INVOICES)

CREATE SCHEMA fa_transaction;
ALTER SCHEMA fa_transaction OWNER TO "FA_USER";

CREATE TABLE fa_transaction.fa_transaction (
    id_trx_acquirer_s character varying NOT NULL,
    acquirer_c character varying(20) NOT NULL,
    trx_timestamp_t timestamp with time zone NOT NULL,
    hpan_s character varying(64),
    operation_type_c character varying(5),
    circuit_type_c character varying(5),
    id_trx_issuer_s character varying,
    correlation_id_s character varying,
    amount_i numeric,
    amount_currency_c character varying(3),
    mcc_c character varying(5),
    mcc_descr_s character varying(40),
    acquirer_id_s character varying,
    merchant_id character varying,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    status_s character varying(2) NOT NULL,
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

ALTER TABLE fa_transaction.fa_transaction OWNER TO "FA_USER";

CREATE TABLE fa_transaction.fa_transaction_request (
    vat_number_s character varying NOT NULL,
    transaction_date_t timestamp with time zone NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    invoice_status_s character varying,
    pos_type_s character varying NOT NULL,
    amount_i numeric NOT NULL,
    terminal_id_s character varying(255) NOT NULL,
    bin_card_s character varying NOT NULL,
    auth_code_s character varying NOT NULL,
    merchant_id character varying,
    contract_id int8 NOT NULL
);

ALTER TABLE fa_transaction.fa_transaction_request OWNER TO "FA_USER";

-- FILE STORAGE

CREATE SCHEMA fa_file_storage;
ALTER SCHEMA fa_file_storage OWNER TO "FA_USER";

-- ERROR RECORD

CREATE SCHEMA fa_error_record;
ALTER SCHEMA fa_error_record OWNER TO "FA_USER";

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

ALTER TABLE fa_error_record.fa_transaction_record OWNER TO "FA_USER";