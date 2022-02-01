
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

SET default_tablespace = '';

-- CUSTOMER

ALTER TABLE ONLY fa_customer.fa_customer
    ADD CONSTRAINT fa_customer_pkey PRIMARY KEY (fiscal_code_s);

ALTER TABLE ONLY fa_customer.fa_customer_vat
    ADD CONSTRAINT fa_customer_vat_pk PRIMARY KEY (fiscal_code_s, vat_number_s);

ALTER TABLE ONLY fa_customer.fa_customer_vat
    ADD CONSTRAINT fa_customer_vat_fk FOREIGN KEY (fiscal_code_s) REFERENCES fa_customer.fa_customer(fiscal_code_s);

-- MERCHANT

ALTER TABLE ONLY fa_merchant.fa_merchant
    ADD CONSTRAINT pk_fa_merchant PRIMARY KEY (vat_number_s);

ALTER TABLE ONLY fa_merchant.fa_merchant_shop
    ADD CONSTRAINT pk_fa_merchant_vat PRIMARY KEY (merchant_id);

ALTER TABLE fa_merchant.fa_register 
    ADD CONSTRAINT pk_register PRIMARY KEY (register_id);

ALTER TABLE fa_merchant.fa_merchant_contract 
    ADD CONSTRAINT pk_merchant_contract PRIMARY KEY (contract_id);

ALTER TABLE fa_merchant.fa_merchant_contract 
    ADD CONSTRAINT fk_merchant_shop FOREIGN KEY (shop_id) REFERENCES fa_merchant.fa_merchant_shop(merchant_id);

ALTER TABLE fa_merchant.fa_merchant_contract 
    ADD CONSTRAINT fk_register FOREIGN KEY (register_id) REFERENCES fa_merchant.fa_register(register_id);


-- PAYMENT INSTRUMENT

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument
    ADD CONSTRAINT pk_fa_payment_instrument PRIMARY KEY (hpan_s);

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    ADD CONSTRAINT fa_payment_instrument_history_pk PRIMARY KEY (id_n);

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    ADD CONSTRAINT fa_payment_instrument_history_un UNIQUE (hpan_s, activation_t, deactivation_t);

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    ADD CONSTRAINT fa_payment_instrument_history_fk FOREIGN KEY (hpan_s) REFERENCES fa_payment_instrument.fa_payment_instrument(hpan_s);


-- TRANSACTION

ALTER TABLE ONLY fa_transaction.fa_transaction_request
    ADD CONSTRAINT fa_transaction_request_pk PRIMARY KEY (amount_i, auth_code_s, terminal_id_s, bin_card_s, transaction_date_t);

-- ALTER TABLE ONLY fa_transaction.fa_transaction
--     ADD CONSTRAINT pk_fa_transaction PRIMARY KEY (id_trx_acquirer_n, acquirer_c, trx_timestamp_t);


-- MERCHANT

ALTER TABLE ONLY fa_merchant.fa_merchant_shop
    ADD CONSTRAINT fk_fa_merchant FOREIGN KEY (vat_number_s) REFERENCES fa_merchant.fa_merchant(vat_number_s) DEFERRABLE INITIALLY DEFERRED;

-- PROVIDER
ALTER TABLE ONLY fa_provider.fa_provider
    ADD CONSTRAINT pk_fa_provider PRIMARY KEY (provider_id);

-- ERROR

ALTER TABLE ONLY fa_error_record.fa_transaction_record
    ADD CONSTRAINT pk_fa_transaction_record PRIMARY KEY (record_id_s);

-- FA_MOCK
ALTER TABLE ONLY fa_mock.mock_provider
	ADD CONSTRAINT mock_provider_pk PRIMARY KEY (transaction_date_t, amount_i, bin_card_s, auth_code_s, terminal_id_s);


ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_customer REVOKE ALL ON TABLES FROM "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_file_storage REVOKE ALL ON TABLES FROM "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_merchant REVOKE ALL ON TABLES FROM "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_payment_instrument REVOKE ALL ON TABLES FROM "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_provider REVOKE ALL ON TABLES FROM "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_transaction REVOKE ALL ON TABLES  FROM "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA public REVOKE ALL ON TABLES  FROM "${adminUser}";

ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" GRANT ALL ON SEQUENCES  TO "FA_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" GRANT ALL ON TYPES  TO "FA_USER" WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" GRANT ALL ON FUNCTIONS  TO "FA_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" GRANT ALL ON TABLES  TO "FA_USER";