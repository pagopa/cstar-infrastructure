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

SET default_tablespace = '';

--
-- Name: fa_customer fa_customer_pkey; Type: CONSTRAINT; Schema: fa_customer; Owner: ddsadmin
--

ALTER TABLE ONLY fa_customer.fa_customer
    ADD CONSTRAINT fa_customer_pkey PRIMARY KEY (fiscal_code_s);


--
-- Name: fa_customer_vat fa_customer_vat_pk; Type: CONSTRAINT; Schema: fa_customer; Owner: ddsadmin
--

ALTER TABLE ONLY fa_customer.fa_customer_vat
    ADD CONSTRAINT fa_customer_vat_pk PRIMARY KEY (fiscal_code_s, vat_number_s);


--
-- Name: fa_merchant pk_fa_merchant; Type: CONSTRAINT; Schema: fa_merchant; Owner: ddsadmin
--

ALTER TABLE ONLY fa_merchant.fa_merchant
    ADD CONSTRAINT pk_fa_merchant PRIMARY KEY (vat_number_s);


--
-- Name: fa_merchant_shop pk_fa_merchant_vat; Type: CONSTRAINT; Schema: fa_merchant; Owner: ddsadmin
--

ALTER TABLE ONLY fa_merchant.fa_merchant_shop
    ADD CONSTRAINT pk_fa_merchant_vat PRIMARY KEY (merchant_id);


--
-- Name: fa_provider pk_fa_provider; Type: CONSTRAINT; Schema: fa_provider; Owner: ddsadmin
--

ALTER TABLE ONLY fa_provider.fa_provider
    ADD CONSTRAINT pk_fa_provider PRIMARY KEY (provider_id);


--
-- Name: fa_payment_instrument pk_fa_payment_instrument; Type: CONSTRAINT; Schema: fa_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument
    ADD CONSTRAINT pk_fa_payment_instrument PRIMARY KEY (hpan_s);


--
-- Name: fa_payment_instrument pk_fa_payment_instrument_history; Type: CONSTRAINT; Schema: fa_payment_instrument_history; Owner: ddsadmin
--

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    ADD CONSTRAINT fa_payment_instrument_history_pk PRIMARY KEY (id_n);


--
-- Name: fa_transaction_request fa_transaction_request_pk; Type: CONSTRAINT; Schema: fa_transaction; Owner: ddsadmin
--

ALTER TABLE ONLY fa_transaction.fa_transaction_request
    ADD CONSTRAINT fa_transaction_request_pk PRIMARY KEY (amount_i, auth_code_s, terminal_id_s, bin_card_s, transaction_date_t);


--
-- Name: fa_transaction pk_fa_transaction; Type: CONSTRAINT; Schema: fa_transaction; Owner: ddsadmin
--

ALTER TABLE ONLY fa_transaction.fa_transaction
    ADD CONSTRAINT fa_transaction_pk PRIMARY KEY (trx_timestamp_t, terminal_id_s, bin_card_s, id_trx_issuer_s, amount_i);


--
-- Name: fa_transaction_record pk_fa_transaction_record; Type: CONSTRAINT; Schema: fa_error_record; Owner: ddsadmin
--

ALTER TABLE ONLY fa_error_record.fa_transaction_record
    ADD CONSTRAINT pk_fa_transaction_record PRIMARY KEY (record_id_s);


--
-- Name: fa_merchant_shop fk_fa_merchant; Type: FK CONSTRAINT; Schema: fa_merchant; Owner: ddsadmin
--

ALTER TABLE ONLY fa_merchant.fa_merchant_shop
    ADD CONSTRAINT fk_fa_merchant FOREIGN KEY (vat_number_s) REFERENCES fa_merchant.fa_merchant(vat_number_s) DEFERRABLE INITIALLY DEFERRED;


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


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: fa_customer; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_customer REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_customer GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: fa_file_storage; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_file_storage REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_file_storage GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: fa_merchant; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_merchant REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_merchant GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: fa_payment_instrument; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_payment_instrument REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_payment_instrument GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: fa_provider; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_provider REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_provider GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: fa_transaction; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_transaction REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA fa_transaction GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA public REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA public GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON SEQUENCES  TO "FA_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON TYPES  TO "FA_USER" WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON FUNCTIONS  TO "FA_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON TABLES  TO "FA_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- PostgreSQL database dump complete
--

