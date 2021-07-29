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

ALTER USER MAPPING
	FOR "BPD_USER"
	SERVER bpd_award_period_remote
	OPTIONS (user 'BPD_USER@${serverName}', password '${bpdUserPassword}');

ALTER USER MAPPING
	FOR "BPD_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'BPD_USER@${serverName}', password '${bpdUserPassword}');

ALTER USER MAPPING
	FOR "BPD_USER"
	SERVER bpd_winning_transaction_remote
	OPTIONS (user 'BPD_USER@${serverName}', password '${bpdUserPassword}');

--
-- Name: bpd_award_period bpd_award_period_pkey; Type: CONSTRAINT; Schema: bpd_award_period; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_award_period.bpd_award_period
    ADD CONSTRAINT bpd_award_period_pkey PRIMARY KEY (award_period_id_n);


--
-- Name: bpd_award_winner_error_notify bpd_award_error_pkey; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_award_winner_error_notify
    ADD CONSTRAINT bpd_award_error_pkey PRIMARY KEY (id_error_n);


--
-- Name: bpd_award_winner_error bpd_award_winner_error_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_award_winner_error
    ADD CONSTRAINT bpd_award_winner_error_pk PRIMARY KEY (record_id_s);


--
-- Name: bpd_award_winner bpd_award_winner_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_award_winner
    ADD CONSTRAINT bpd_award_winner_pk PRIMARY KEY (id_n);


--
-- Name: bpd_citizen_ranking bpd_citizen_ranking_new_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking
    ADD CONSTRAINT bpd_citizen_ranking_new_pk PRIMARY KEY (fiscal_code_c, award_period_id_n);


--
-- Name: bpd_ranking_processor_lock bpd_ranking_processor_lock_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_ranking_processor_lock
    ADD CONSTRAINT bpd_ranking_processor_lock_pk PRIMARY KEY (process_id);


--
-- Name: bpd_winning_amount bpd_winning_amount_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_winning_amount
    ADD CONSTRAINT bpd_winning_amount_pk PRIMARY KEY (ranking_n);


--
-- Name: bpd_citizen pk_bpd_citizen; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen
    ADD CONSTRAINT pk_bpd_citizen PRIMARY KEY (fiscal_code_s);


--
-- Name: bpd_ranking_ext pk_bpd_ranking_ext_new; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_ranking_ext
    ADD CONSTRAINT pk_bpd_ranking_ext_new PRIMARY KEY (award_period_id_n);


--
-- Name: shedlock shedlock_pkey; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.shedlock
    ADD CONSTRAINT shedlock_pkey PRIMARY KEY (name);


--
-- Name: bpd_transaction_record pk_bpd_transaction_record; Type: CONSTRAINT; Schema: bpd_error_record; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_error_record.bpd_transaction_record
    ADD CONSTRAINT pk_bpd_transaction_record PRIMARY KEY (record_id_s);


--
-- Name: bpd_mcc_category bpd_mcc_category_pkey; Type: CONSTRAINT; Schema: bpd_mcc_category; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_mcc_category.bpd_mcc_category
    ADD CONSTRAINT bpd_mcc_category_pkey PRIMARY KEY (mcc_category_id_s);


--
-- Name: bonifica_pm bonifica_pm_pk; Type: CONSTRAINT; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_payment_instrument.bonifica_pm
    ADD CONSTRAINT bonifica_pm_pk PRIMARY KEY (hpan_s, fiscal_code_s);


--
-- Name: bpd_payment_instrument_history bpd_payment_instrument_history_pk; Type: CONSTRAINT; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_payment_instrument.bpd_payment_instrument_history
    ADD CONSTRAINT bpd_payment_instrument_history_pk PRIMARY KEY (id_n);


--
-- Name: bpd_payment_instrument_history bpd_payment_instrument_history_un; Type: CONSTRAINT; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_payment_instrument.bpd_payment_instrument_history
    ADD CONSTRAINT bpd_payment_instrument_history_un UNIQUE (hpan_s, activation_t, deactivation_t);


--
-- Name: bpd_payment_instrument pk_bpd_payment_instrument; Type: CONSTRAINT; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_payment_instrument.bpd_payment_instrument
    ADD CONSTRAINT pk_bpd_payment_instrument PRIMARY KEY (hpan_s);


--
-- Name: bpd_bancomat_transaction pk_bpd_bancomat_transaction; Type: CONSTRAINT; Schema: bpd_winning_transaction; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_winning_transaction.bpd_bancomat_transaction
    ADD CONSTRAINT pk_bpd_bancomat_transaction PRIMARY KEY (id_trx_acquirer_s, trx_timestamp_t, acquirer_c, acquirer_id_s, operation_type_c);


--
-- Name: bpd_citizen_status_data pk_bpd_citizen_status_data; Type: CONSTRAINT; Schema: bpd_winning_transaction; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_winning_transaction.bpd_citizen_status_data
    ADD CONSTRAINT pk_bpd_citizen_status_data PRIMARY KEY (fiscal_code_s);


--
-- Name: bpd_winning_transaction pk_bpd_winning_transaction; Type: CONSTRAINT; Schema: bpd_winning_transaction; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_winning_transaction.bpd_winning_transaction
    ADD CONSTRAINT pk_bpd_winning_transaction PRIMARY KEY (id_trx_acquirer_s, trx_timestamp_t, acquirer_c, acquirer_id_s, operation_type_c);


--
-- Name: bpd_winning_transaction_transfer pk_bpd_winning_transaction_transfer; Type: CONSTRAINT; Schema: bpd_winning_transaction; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_winning_transaction.bpd_winning_transaction_transfer
    ADD CONSTRAINT pk_bpd_winning_transaction_transfer PRIMARY KEY (id_trx_acquirer_s, trx_timestamp_t, acquirer_c, acquirer_id_s, operation_type_c);


--
-- Name: bpd_award_winner_ap_status_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_award_winner_ap_status_idx ON bpd_citizen.bpd_award_winner USING btree (award_period_id_n, status_s);


--
-- Name: bpd_award_winner_award_period_id_n_fiscal_code_s_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_award_winner_award_period_id_n_fiscal_code_s_idx ON bpd_citizen.bpd_award_winner USING btree (award_period_id_n, fiscal_code_s);


--
-- Name: bpd_award_winner_award_period_id_n_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_award_winner_award_period_id_n_idx ON bpd_citizen.bpd_award_winner USING btree (award_period_id_n, payoff_instr_s);


--
-- Name: bpd_award_winner_error_cf_aw_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_award_winner_error_cf_aw_idx ON bpd_citizen.bpd_award_winner_error_notify USING btree (fiscal_code_s, award_period_id_n);


--
-- Name: bpd_award_winner_error_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_award_winner_error_idx ON bpd_citizen.bpd_award_winner_error_notify USING btree (id_n);


--
-- Name: bpd_award_winner_esito_status_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_award_winner_esito_status_idx ON bpd_citizen.bpd_award_winner USING btree (esito_bonifico_s, status_s);


--
-- Name: bpd_award_winner_integration_unique_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE UNIQUE INDEX bpd_award_winner_integration_unique_idx ON bpd_citizen.bpd_award_winner USING btree (fiscal_code_s, award_period_id_n, ticket_id_n, related_id_n);


--
-- Name: bpd_citizen_notification_step_enabled_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_citizen_notification_step_enabled_idx ON bpd_citizen.bpd_citizen USING btree (notification_step_s, timestamp_tc_t) WHERE (enabled_b IS TRUE);


--
-- Name: bpd_citizen_ranking_new_transaction_n_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_citizen_ranking_new_transaction_n_idx ON bpd_citizen.bpd_citizen_ranking USING btree (transaction_n DESC, fiscal_code_c);


--
-- Name: bpd_citizen_ranking_new_trx_fc_updts_ap2_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_citizen_ranking_new_trx_fc_updts_ap2_idx ON bpd_citizen.bpd_citizen_ranking USING btree (transaction_n DESC, fiscal_code_c, update_date_t NULLS FIRST) WHERE (award_period_id_n = 2);


--
-- Name: idx_bpd_award_period_fiscal_code_award_period_id; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX idx_bpd_award_period_fiscal_code_award_period_id ON bpd_citizen.bpd_award_winner USING btree (fiscal_code_s, award_period_id_n);


--
-- Name: bpd_transaction_record_to_resubmit_b_partial_idx; Type: INDEX; Schema: bpd_error_record; Owner: ddsadmin
--

CREATE INDEX bpd_transaction_record_to_resubmit_b_partial_idx ON bpd_error_record.bpd_transaction_record USING btree (enabled_b) WHERE (to_resubmit_b = true);


--
-- Name: bonifica_pm_hpan_s_idx; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX bonifica_pm_hpan_s_idx ON bpd_payment_instrument.bonifica_pm USING btree (hpan_s);


--
-- Name: idx_bpd_payment_instrument_enabled; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_enabled ON bpd_payment_instrument.bpd_payment_instrument USING btree (enabled_b);


--
-- Name: idx_bpd_payment_instrument_fiscal_code; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_fiscal_code ON bpd_payment_instrument.bpd_payment_instrument USING btree (fiscal_code_s);


--
-- Name: idx_bpd_payment_instrument_history_activation_deactivation; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_history_activation_deactivation ON bpd_payment_instrument.bpd_payment_instrument_history USING btree (activation_t, deactivation_t);


--
-- Name: idx_bpd_payment_instrument_insert_date; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_insert_date ON bpd_payment_instrument.bpd_payment_instrument USING btree (insert_date_t);


--
-- Name: idx_bpd_payment_instrument_insert_hpan; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_insert_hpan ON bpd_payment_instrument.bpd_payment_instrument_history USING btree (hpan_s);


--
-- Name: bpd_winning_transaction_fiscal_code_s_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_fiscal_code_s_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s, award_period_id_n);


--
-- Name: bpd_winning_transaction_insert_date_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_insert_date_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (insert_date_t);


--
-- Name: idx_bpd_winning_transaction_hpan_award_period_id; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX idx_bpd_winning_transaction_hpan_award_period_id ON bpd_winning_transaction.bpd_winning_transaction USING btree (hpan_s, award_period_id_n);


--
-- Name: idx_cf_partial_ap2; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX idx_cf_partial_ap2 ON bpd_winning_transaction.bpd_winning_transaction_transfer USING btree (fiscal_code_s) WHERE ((award_period_id_n = 2) AND (partial_transfer_b IS NOT TRUE) AND (parked_b IS NOT TRUE));


--
-- Name: idx_cf_partial_ap3; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX idx_cf_partial_ap3 ON bpd_winning_transaction.bpd_winning_transaction_transfer USING btree (fiscal_code_s) WHERE ((award_period_id_n = 3) AND (partial_transfer_b IS NOT TRUE) AND (parked_b IS NOT TRUE));


--
-- Name: not_elab_ranking_paym_ap2_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_paym_ap2_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b IS NOT TRUE) AND (award_period_id_n = 2) AND ((operation_type_c)::text <> '01'::text));


--
-- Name: not_elab_ranking_paym_ap2_idx_old; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_paym_ap2_idx_old ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_new_b IS NOT TRUE) AND (award_period_id_n = 2) AND ((operation_type_c)::text <> '01'::text));


--
-- Name: not_elab_ranking_paym_ap3_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_paym_ap3_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b IS NOT TRUE) AND (award_period_id_n = 3) AND ((operation_type_c)::text <> '01'::text));


--
-- Name: not_elab_ranking_rev_paym_ap2_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_rev_paym_ap2_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b IS NOT TRUE) AND (award_period_id_n = 2) AND ((operation_type_c)::text = '01'::text));


--
-- Name: not_elab_ranking_rev_paym_ap2_idx_old; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_rev_paym_ap2_idx_old ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_new_b IS NOT TRUE) AND (award_period_id_n = 2) AND ((operation_type_c)::text = '01'::text));


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_dashboard_pagopa REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_dashboard_pagopa GRANT SELECT ON TABLES  TO "DASHBOARD_PAGOPA_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_error_record; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_error_record REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_error_record GRANT SELECT ON TABLES  TO "MONITORING_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_error_record GRANT SELECT ON TABLES  TO "DASHBOARD_PAGOPA_USER";


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON SEQUENCES  TO "BPD_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON TYPES  TO "BPD_USER";


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON FUNCTIONS  TO "BPD_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT SELECT ON TABLES  TO "MONITORING_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON TABLES  TO "BPD_USER";


--
-- PostgreSQL database dump complete
--

