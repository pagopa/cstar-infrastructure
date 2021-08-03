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
-- Name: rtd_payment_instrument_data rtd_payment_instrument_data_test_pkey; Type: CONSTRAINT; Schema: rtd_database; Owner: RTD_USER
--

ALTER TABLE ONLY rtd_database.rtd_payment_instrument_data
    ADD CONSTRAINT rtd_payment_instrument_data_test_pkey PRIMARY KEY (hpan_s);


--
-- Name: idx_bpd_payment_instrument_hpans; Type: INDEX; Schema: rtd_database; Owner: RTD_USER
--

CREATE INDEX idx_bpd_payment_instrument_hpans ON rtd_database.payment_instrument_hpans USING btree (hpan_s);


--
-- Name: idx_rtd_payment_instrument_data; Type: INDEX; Schema: rtd_database; Owner: RTD_USER
--

CREATE INDEX idx_rtd_payment_instrument_data ON rtd_database.rtd_payment_instrument_data USING btree (hpan_s);


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: rtd_database; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA rtd_database REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA rtd_database GRANT ALL ON TABLES  TO "RTD_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA rtd_database GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: payment_instrument_hpans; Type: MATERIALIZED VIEW DATA; Schema: rtd_database; Owner: RTD_USER
--

-- REFRESH MATERIALIZED VIEW rtd_database.payment_instrument_hpans;


--
-- PostgreSQL database dump complete
--

