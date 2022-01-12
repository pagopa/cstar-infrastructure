--
-- Name: fa_error_record; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA fa_error_record;


ALTER SCHEMA fa_error_record OWNER TO ddsadmin;

--
-- Name: fa_customer; Type: TABLE; Schema: -; Owner: ddsadmin
--

ALTER TABLE fa_customer.fa_customer ADD COLUMN destination_code_s character varying(255) NULL;
ALTER TABLE fa_customer.fa_customer ADD COLUMN pec_s character varying(255) NULL;

ALTER TABLE fa_customer.fa_customer_vat ADD COLUMN destination_code_s character varying(255) NULL;
ALTER TABLE fa_customer.fa_customer_vat ADD COLUMN pec_s character varying(255) NULL;

--
-- Name: fa_merchant; Type: TABLE; Schema: -; Owner: ddsadmin
--

ALTER TABLE fa_merchant.fa_merchant ADD COLUMN company_name_s character varying NULL;
ALTER TABLE fa_merchant.fa_merchant ADD COLUMN company_address_s character varying NULL;

--
-- Name: fa_payment_instrument; Type: TABLE; Schema: -; Owner: ddsadmin
--

ALTER TABLE fa_payment_instrument.fa_payment_instrument ADD COLUMN channel_s character varying(20) NULL;
ALTER TABLE fa_payment_instrument.fa_payment_instrument ADD COLUMN hpan_master_s character varying(64) NULL;
ALTER TABLE fa_payment_instrument.fa_payment_instrument ADD COLUMN par_s character varying(32) NULL;
ALTER TABLE fa_payment_instrument.fa_payment_instrument ADD COLUMN par_enrollment_t timestamptz(0) NULL;
ALTER TABLE fa_payment_instrument.fa_payment_instrument ADD COLUMN par_cancellation_t timestamptz(0) NULL;
ALTER TABLE fa_payment_instrument.fa_payment_instrument ADD COLUMN last_tkm_update_t timestamp with time zone NULL;

--
-- Name: fa_payment_instrument_history; Type: TABLE; Schema: fa_payment_instrument; Owner: ddsadmin
--

CREATE TABLE fa_payment_instrument.fa_payment_instrument_history (
	hpan_s character varying(64) NOT NULL,
	activation_t timestamp with time zone NOT NULL,
	deactivation_t timestamp with time zone NULL,
	id_n bigint NOT NULL,
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
-- Name: TABLE fa_payment_instrument_history; Type: ACL; Schema: fa_payment_instrument_history; Owner: ddsadmin
--

GRANT ALL ON TABLE fa_payment_instrument.fa_payment_instrument_history TO "FA_USER";
GRANT SELECT ON TABLE fa_payment_instrument.fa_payment_instrument_history TO "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT SELECT ON TABLE fa_payment_instrument.fa_payment_instrument_history TO "MONITORING_USER";

--
-- Name: fa_transaction; Type: TABLE; Schema: fa_transaction; Owner: ddsadmin
--

ALTER TABLE fa_transaction.fa_transaction ADD COLUMN fiscal_code_s character varying(16) NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN par_s character varying(32) NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN hpan_master_s character varying(64) NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN bin_card_s character varying NOT NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN terminal_id_s character varying(255) NOT NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN invoice_status_s character varying NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN invoice_code_s character varying NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN invoice_status_date_t timestamptz(0) NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN invoice_rejected_reason_s character varying NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN invoice_status_insert_request_date_t timestamptz(0) NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN invoice_status_update_request_date_t timestamptz(0) NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN notification_id_s character varying NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN notify_date_t timestamptz(0) NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN notify_status_s character varying NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN invoice_elab_b boolean NULL;
ALTER TABLE fa_transaction.fa_transaction ADD COLUMN to_notify_b boolean NULL;

ALTER TABLE fa_transaction.fa_transaction RENAME COLUMN id_trx_acquirer_n TO id_trx_acquirer_s;
ALTER TABLE fa_transaction.fa_transaction RENAME COLUMN id_trx_issuer_n TO id_trx_issuer_s;
ALTER TABLE fa_transaction.fa_transaction RENAME COLUMN correlation_id_n TO correlation_id_s;
ALTER TABLE fa_transaction.fa_transaction RENAME COLUMN acquirer_id_n TO acquirer_id_s;

ALTER TABLE fa_transaction.fa_transaction ALTER COLUMN id_trx_acquirer_s TYPE character varying;
ALTER TABLE fa_transaction.fa_transaction ALTER COLUMN id_trx_issuer_s TYPE character varying;
ALTER TABLE fa_transaction.fa_transaction ALTER COLUMN correlation_id_s TYPE character varying;
ALTER TABLE fa_transaction.fa_transaction ALTER COLUMN acquirer_id_s TYPE character varying;
ALTER TABLE fa_transaction.fa_transaction ALTER COLUMN merchant_id TYPE character varying;

--
-- Name: fa_transaction; Type: TABLE; Schema: fa_transaction; Owner: ddsadmin
--

ALTER TABLE fa_transaction.fa_transaction_request ADD COLUMN amount_i numeric NOT NULL;
ALTER TABLE fa_transaction.fa_transaction_request ADD COLUMN terminal_id_s character varying(255) NOT NULL;
ALTER TABLE fa_transaction.fa_transaction_request ADD COLUMN bin_card_s character varying NOT NULL;
ALTER TABLE fa_transaction.fa_transaction_request ADD COLUMN auth_code_s character varying NOT NULL;
ALTER TABLE fa_transaction.fa_transaction_request ADD COLUMN merchant_id character varying;

ALTER TABLE fa_transaction.fa_transaction_request ALTER COLUMN invoice_status_s TYPE character varying;

ALTER TABLE fa_transaction.fa_transaction_request DROP COLUMN IF EXISTS transaction_id_s;
ALTER TABLE fa_transaction.fa_transaction_request DROP COLUMN IF EXISTS customer_param_s;
ALTER TABLE fa_transaction.fa_transaction_request DROP COLUMN IF EXISTS customer_param_desc_s;
ALTER TABLE fa_transaction.fa_transaction_request DROP COLUMN IF EXISTS acquirer_id_n;
ALTER TABLE fa_transaction.fa_transaction_request DROP COLUMN IF EXISTS merchant_id_n;

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
-- Name: TABLE fa_payment_instrument; Type: ACL; Schema: fa_payment_instrument; Owner: ddsadmin
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
-- Name: TABLE fa_payment_instrument; Type: ACL; Schema: fa_payment_instrument; Owner: ddsadmin
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
-- Name: fa_provider pk_fa_provider; Type: CONSTRAINT; Schema: fa_provider; Owner: ddsadmin
--

ALTER TABLE ONLY fa_provider.fa_provider
    ADD CONSTRAINT pk_fa_provider PRIMARY KEY (provider_id);

--
-- Name: fa_payment_instrument pk_fa_payment_instrument_history; Type: CONSTRAINT; Schema: fa_payment_instrument_history; Owner: ddsadmin
--

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    ADD CONSTRAINT fa_payment_instrument_history_pk PRIMARY KEY (id_n);

--
-- Name: fa_transaction_request fa_transaction_request_pk; Type: CONSTRAINT; Schema: fa_transaction; Owner: ddsadmin
--

ALTER TABLE ONLY fa_transaction.fa_transaction_request
    DROP CONSTRAINT IF EXISTS fa_transaction_request_pk;

ALTER TABLE ONLY fa_transaction.fa_transaction_request
    ADD CONSTRAINT fa_transaction_request_pk PRIMARY KEY (amount_i, auth_code_s, terminal_id_s, bin_card_s, transaction_date_t);

--
-- Name: fa_transaction fa_transaction_request_pk; Type: CONSTRAINT; Schema: fa_transaction; Owner: ddsadmin
--

ALTER TABLE ONLY fa_transaction.fa_transaction
    DROP CONSTRAINT IF EXISTS pk_fa_transaction;

--
-- Name: fa_transaction_record pk_fa_transaction_record; Type: CONSTRAINT; Schema: fa_error_record; Owner: ddsadmin
--

ALTER TABLE ONLY fa_error_record.fa_transaction_record
    ADD CONSTRAINT pk_fa_transaction_record PRIMARY KEY (record_id_s);

--
-- Name: fa_customer_vat fk_fa_customer_vat; Type: FK CONSTRAINT; Schema: fa_customer; Owner: ddsadmin
--

ALTER TABLE ONLY fa_customer.fa_customer_vat
    ADD CONSTRAINT fa_customer_vat_fk FOREIGN KEY (fiscal_code_s) REFERENCES fa_customer.fa_customer(fiscal_code_s);

--
-- Name: fa_payment_instrument_history fa_payment_instrument_history_un; Type: FK CONSTRAINT; Schema: fa_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    ADD CONSTRAINT fa_payment_instrument_history_un UNIQUE (hpan_s, activation_t, deactivation_t);

--
-- Name: fa_payment_instrument_history fa_payment_instrument_history_fk; Type: FK CONSTRAINT; Schema: fa_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    ADD CONSTRAINT fa_payment_instrument_history_fk FOREIGN KEY (hpan_s) REFERENCES fa_payment_instrument.fa_payment_instrument(hpan_s);


