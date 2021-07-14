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

SET default_tablespace = '';

--
-- Name: fa_customer fa_customer_pkey; Type: CONSTRAINT; Schema: fa_customer; Owner: -
--

ALTER TABLE ONLY fa_customer.fa_customer
    ADD CONSTRAINT fa_customer_pkey PRIMARY KEY (fiscal_code_s);


--
-- Name: fa_customer_vat fa_customer_vat_pk; Type: CONSTRAINT; Schema: fa_customer; Owner: -
--

ALTER TABLE ONLY fa_customer.fa_customer_vat
    ADD CONSTRAINT fa_customer_vat_pk PRIMARY KEY (fiscal_code_s, vat_number_s);


--
-- Name: fa_merchant pk_fa_merchant; Type: CONSTRAINT; Schema: fa_merchant; Owner: -
--

ALTER TABLE ONLY fa_merchant.fa_merchant
    ADD CONSTRAINT pk_fa_merchant PRIMARY KEY (vat_number_s);


--
-- Name: fa_merchant_shop pk_fa_merchant_vat; Type: CONSTRAINT; Schema: fa_merchant; Owner: -
--

ALTER TABLE ONLY fa_merchant.fa_merchant_shop
    ADD CONSTRAINT pk_fa_merchant_vat PRIMARY KEY (merchant_id);


--
-- Name: fa_payment_instrument pk_fa_payment_instrument; Type: CONSTRAINT; Schema: fa_payment_instrument; Owner: -
--

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument
    ADD CONSTRAINT pk_fa_payment_instrument PRIMARY KEY (hpan_s);


--
-- Name: fa_transaction_request fa_transaction_request_pk; Type: CONSTRAINT; Schema: fa_transaction; Owner: -
--

ALTER TABLE ONLY fa_transaction.fa_transaction_request
    ADD CONSTRAINT fa_transaction_request_pk PRIMARY KEY (transaction_id_s, vat_number_s, transaction_date_t);


--
-- Name: fa_transaction pk_fa_transaction; Type: CONSTRAINT; Schema: fa_transaction; Owner: -
--

ALTER TABLE ONLY fa_transaction.fa_transaction
    ADD CONSTRAINT pk_fa_transaction PRIMARY KEY (id_trx_acquirer_n, acquirer_c, trx_timestamp_t);


--
-- Name: fa_merchant_shop fk_fa_merchant; Type: FK CONSTRAINT; Schema: fa_merchant; Owner: -
--

ALTER TABLE ONLY fa_merchant.fa_merchant_shop
    ADD CONSTRAINT fk_fa_merchant FOREIGN KEY (vat_number_s) REFERENCES fa_merchant.fa_merchant(vat_number_s) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

