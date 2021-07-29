--
-- PostgreSQL database dump
--

-- Dumped from database version 11.11
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
-- Name: rtd_payment_instrument_data rtd_payment_instrument_data_test_pkey; Type: CONSTRAINT; Schema: rtd_database; Owner: ddsadmin
--

ALTER TABLE ONLY rtd_database.rtd_payment_instrument_data
    ADD CONSTRAINT rtd_payment_instrument_data_test_pkey PRIMARY KEY (hpan_s);


--
-- Name: idx_rtd_payment_instrument_data; Type: INDEX; Schema: rtd_database; Owner: ddsadmin
--

CREATE INDEX idx_rtd_payment_instrument_data ON rtd_database.rtd_payment_instrument_data USING btree (hpan_s);


--
-- PostgreSQL database dump complete
--

