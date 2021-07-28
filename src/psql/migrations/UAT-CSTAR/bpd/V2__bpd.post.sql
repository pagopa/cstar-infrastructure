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
-- Name: bpd_award_period bpd_award_period_pkey; Type: CONSTRAINT; Schema: bpd_award_period; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_award_period.bpd_award_period
    ADD CONSTRAINT bpd_award_period_pkey PRIMARY KEY (award_period_id_n);


--
-- Name: bpd_award_winner_error_notify bpd_award_winner_error_notify_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_award_winner_error_notify
    ADD CONSTRAINT bpd_award_winner_error_notify_pk PRIMARY KEY (id_error_n);


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
-- Name: bpd_citizen_ranking_deleted bpd_citizen_ranking_deleted_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: BPD_USER
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking_deleted
    ADD CONSTRAINT bpd_citizen_ranking_deleted_pk PRIMARY KEY (fiscal_code_c, award_period_id_n);


--
-- Name: bpd_citizen_ranking bpd_citizen_ranking_new_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking
    ADD CONSTRAINT bpd_citizen_ranking_new_pk PRIMARY KEY (fiscal_code_c, award_period_id_n);


--
-- Name: bpd_citizen_ranking_parimerito bpd_citizen_ranking_parimerito_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking_parimerito
    ADD CONSTRAINT bpd_citizen_ranking_parimerito_pk PRIMARY KEY (fiscal_code_c, award_period_id_n);


--
-- Name: bpd_citizen_ranking_new bpd_citizen_ranking_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking_new
    ADD CONSTRAINT bpd_citizen_ranking_pk PRIMARY KEY (fiscal_code_c, award_period_id_n);


--
-- Name: bpd_ranking_processor_lock_new bpd_ranking_processor_lock_new_pk; Type: CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_ranking_processor_lock_new
    ADD CONSTRAINT bpd_ranking_processor_lock_new_pk PRIMARY KEY (process_id);


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
-- Name: bpd_citizen_deleted pk_bpd_citizen_deleted; Type: CONSTRAINT; Schema: bpd_citizen; Owner: BPD_USER
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_deleted
    ADD CONSTRAINT pk_bpd_citizen_deleted PRIMARY KEY (fiscal_code_s);


--
-- Name: bpd_ranking_ext_new pk_bpd_ranking_ext; Type: CONSTRAINT; Schema: bpd_citizen; Owner: BPD_USER
--

ALTER TABLE ONLY bpd_citizen.bpd_ranking_ext_new
    ADD CONSTRAINT pk_bpd_ranking_ext PRIMARY KEY (award_period_id_n);


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
-- Name: bpd_mcc_category_rel bdp_mcc_category_rel_pk; Type: CONSTRAINT; Schema: bpd_mcc_category; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_mcc_category.bpd_mcc_category_rel
    ADD CONSTRAINT bdp_mcc_category_rel_pk PRIMARY KEY (mcc_s);


--
-- Name: bpd_mcc_category_rel bdp_mcc_category_rel_un; Type: CONSTRAINT; Schema: bpd_mcc_category; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_mcc_category.bpd_mcc_category_rel
    ADD CONSTRAINT bdp_mcc_category_rel_un UNIQUE (mcc_s, mcc_category_id_s);


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
-- Name: bpd_payment_instrument pk_bpd_payment_instrument; Type: CONSTRAINT; Schema: bpd_payment_instrument_tmp; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_payment_instrument_tmp.bpd_payment_instrument
    ADD CONSTRAINT pk_bpd_payment_instrument PRIMARY KEY (hpan_s);


--
-- Name: bpd_citizen_status_data pk_bpd_citizen_status_data; Type: CONSTRAINT; Schema: bpd_winning_transaction; Owner: BPD_USER
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
-- Name: bpd_winning_transaction pk_bpd_winning_transaction; Type: CONSTRAINT; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_winning_transaction_tmp.bpd_winning_transaction
    ADD CONSTRAINT pk_bpd_winning_transaction PRIMARY KEY (id_trx_acquirer_s, trx_timestamp_t, acquirer_c, acquirer_id_s, operation_type_c);


--
-- Name: bpd_winning_transaction_transfer pk_bpd_winning_transaction_transfer; Type: CONSTRAINT; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_winning_transaction_tmp.bpd_winning_transaction_transfer
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
-- Name: bpd_citizen_ranking_new_transaction_n_ap1_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_citizen_ranking_new_transaction_n_ap1_idx ON bpd_citizen.bpd_citizen_ranking USING btree (transaction_n DESC, fiscal_code_c, update_date_t NULLS FIRST) WHERE (award_period_id_n = 1);


--
-- Name: bpd_citizen_ranking_new_transaction_n_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_citizen_ranking_new_transaction_n_idx ON bpd_citizen.bpd_citizen_ranking USING btree (transaction_n DESC, fiscal_code_c);


--
-- Name: bpd_citizen_ranking_parimerito_transaction_n_ap1_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_citizen_ranking_parimerito_transaction_n_ap1_idx ON bpd_citizen.bpd_citizen_ranking_parimerito USING btree (transaction_n DESC, fiscal_code_c, update_date_t NULLS FIRST) WHERE (award_period_id_n = 1);


--
-- Name: bpd_citizen_ranking_parimerito_transaction_n_ap999_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_citizen_ranking_parimerito_transaction_n_ap999_idx ON bpd_citizen.bpd_citizen_ranking_parimerito USING btree (transaction_n DESC, fiscal_code_c, update_date_t NULLS FIRST) WHERE (award_period_id_n = 999);


--
-- Name: bpd_citizen_ranking_parimerito_transaction_n_idx; Type: INDEX; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE INDEX bpd_citizen_ranking_parimerito_transaction_n_idx ON bpd_citizen.bpd_citizen_ranking_parimerito USING btree (transaction_n DESC, fiscal_code_c);


--
-- Name: bpd_temp_citizen_fiscal_code_s_idx; Type: INDEX; Schema: bpd_citizen; Owner: BPD_USER
--

CREATE UNIQUE INDEX bpd_temp_citizen_fiscal_code_s_idx ON bpd_citizen.bpd_temp_citizen USING btree (fiscal_code_s);


--
-- Name: temp_citizen_and_pay_fiscal_code_idx; Type: INDEX; Schema: bpd_citizen; Owner: BPD_USER
--

CREATE INDEX temp_citizen_and_pay_fiscal_code_idx ON bpd_citizen.temp_citizen_and_pay USING btree (fiscal_code);


--
-- Name: temp_citizen_and_pay_hpan_s_idx; Type: INDEX; Schema: bpd_citizen; Owner: BPD_USER
--

CREATE INDEX temp_citizen_and_pay_hpan_s_idx ON bpd_citizen.temp_citizen_and_pay USING btree (hpan_s);


--
-- Name: bpd_transaction_record_to_resubmit_b_partial_idx; Type: INDEX; Schema: bpd_error_record; Owner: ddsadmin
--

CREATE INDEX bpd_transaction_record_to_resubmit_b_partial_idx ON bpd_error_record.bpd_transaction_record USING btree (enabled_b) WHERE (to_resubmit_b = true);


--
-- Name: bonifica_pm_hpan_s_idx; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX bonifica_pm_hpan_s_idx ON bpd_payment_instrument.bonifica_pm USING hash (hpan_s);


--
-- Name: bpd_payment_instrument_par_s_idx; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE UNIQUE INDEX bpd_payment_instrument_par_s_idx ON bpd_payment_instrument.bpd_payment_instrument USING btree (hpan_s, par_s) WHERE (par_s IS NOT NULL);


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
-- Name: idx_bpd_payment_instrument_insert_date_hpan; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_insert_date_hpan ON bpd_payment_instrument.bpd_payment_instrument_history USING btree (insert_date_t, hpan_s);


--
-- Name: idx_payment_instrument_hpan_master_s; Type: INDEX; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE INDEX idx_payment_instrument_hpan_master_s ON bpd_payment_instrument.bpd_payment_instrument USING btree (hpan_master_s);


--
-- Name: idx_bpd_payment_instrument_enabled; Type: INDEX; Schema: bpd_payment_instrument_tmp; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_enabled ON bpd_payment_instrument_tmp.bpd_payment_instrument USING btree (enabled_b);


--
-- Name: idx_bpd_payment_instrument_fiscal_code; Type: INDEX; Schema: bpd_payment_instrument_tmp; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_fiscal_code ON bpd_payment_instrument_tmp.bpd_payment_instrument USING btree (fiscal_code_s);


--
-- Name: idx_bpd_payment_instrument_insert_date; Type: INDEX; Schema: bpd_payment_instrument_tmp; Owner: ddsadmin
--

CREATE INDEX idx_bpd_payment_instrument_insert_date ON bpd_payment_instrument_tmp.bpd_payment_instrument USING btree (insert_date_t);


--
-- Name: idx_payment_instrument_hpan_master_s; Type: INDEX; Schema: bpd_payment_instrument_tmp; Owner: ddsadmin
--

CREATE INDEX idx_payment_instrument_hpan_master_s ON bpd_payment_instrument_tmp.bpd_payment_instrument USING btree (hpan_master_s);


--
-- Name: bpd_winning_transaction_enabled_b_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_enabled_b_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (enabled_b);


--
-- Name: bpd_winning_transaction_fiscal_code_s_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_fiscal_code_s_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s, award_period_id_n);


--
-- Name: bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp__idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp__idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (hpan_s, fiscal_code_s, trx_timestamp_t);


--
-- Name: bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp_idx1; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp_idx1 ON bpd_winning_transaction.bpd_winning_transaction USING btree (hpan_s, fiscal_code_s, trx_timestamp_t);


--
-- Name: bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp_idx2; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp_idx2 ON bpd_winning_transaction.bpd_winning_transaction USING btree (hpan_s, fiscal_code_s, trx_timestamp_t);


--
-- Name: idx_bpd_winning_transaction_hpan_award_period_id; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX idx_bpd_winning_transaction_hpan_award_period_id ON bpd_winning_transaction.bpd_winning_transaction USING btree (hpan_s, award_period_id_n);


--
-- Name: not_elab_ranking_paym_ap14_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_paym_ap14_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b IS NOT TRUE) AND (award_period_id_n = 14) AND ((operation_type_c)::text <> '01'::text));


--
-- Name: not_elab_ranking_paym_ap1_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_paym_ap1_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b IS NOT TRUE) AND (award_period_id_n = 1) AND ((operation_type_c)::text <> '01'::text));


--
-- Name: not_elab_ranking_rev_paym_ap1_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_rev_paym_ap1_idx ON bpd_winning_transaction.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b IS NOT TRUE) AND (award_period_id_n = 1) AND ((operation_type_c)::text = '01'::text));


--
-- Name: temp_hpan_nft_hpan_idx; Type: INDEX; Schema: bpd_winning_transaction; Owner: BPD_USER
--

CREATE INDEX temp_hpan_nft_hpan_idx ON bpd_winning_transaction.temp_hpan_nft USING btree (hpan);


--
-- Name: bpd_winning_transaction_enabled_b_idx; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_enabled_b_idx ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (enabled_b);


--
-- Name: bpd_winning_transaction_fiscal_code_s_idx; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_fiscal_code_s_idx ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (fiscal_code_s, award_period_id_n);


--
-- Name: bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp__idx; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp__idx ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (hpan_s, fiscal_code_s, trx_timestamp_t);


--
-- Name: bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp_idx1; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp_idx1 ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (hpan_s, fiscal_code_s, trx_timestamp_t);


--
-- Name: bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp_idx2; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_hpan_s_fiscal_code_s_trx_timestamp_idx2 ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (hpan_s, fiscal_code_s, trx_timestamp_t);


--
-- Name: idx_bpd_winning_transaction_hpan_award_period_id; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX idx_bpd_winning_transaction_hpan_award_period_id ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (hpan_s, award_period_id_n);


--
-- Name: not_elab_ranking_paym_ap1_idx; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_paym_ap1_idx ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b IS NOT TRUE) AND (award_period_id_n = 1) AND ((operation_type_c)::text <> '01'::text));


--
-- Name: not_elab_ranking_paym_ap1_idx_old; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_paym_ap1_idx_old ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b_old IS NOT TRUE) AND (award_period_id_n = 1) AND ((operation_type_c)::text <> '01'::text));


--
-- Name: not_elab_ranking_rev_paym_ap1_idx; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_rev_paym_ap1_idx ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b IS NOT TRUE) AND (award_period_id_n = 1) AND ((operation_type_c)::text = '01'::text));


--
-- Name: not_elab_ranking_rev_paym_ap1_idx_old; Type: INDEX; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE INDEX not_elab_ranking_rev_paym_ap1_idx_old ON bpd_winning_transaction_tmp.bpd_winning_transaction USING btree (fiscal_code_s) WHERE ((enabled_b IS TRUE) AND (elab_ranking_b_old IS NOT TRUE) AND (award_period_id_n = 1) AND ((operation_type_c)::text = '01'::text));


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_award_period; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_award_period REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_award_period GRANT SELECT ON TABLES  TO "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_award_period GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_citizen REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_citizen GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_error_record; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_error_record REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_error_record GRANT SELECT ON TABLES  TO "MONITORING_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_error_record GRANT SELECT ON TABLES  TO "DASHBOARD_PAGOPA_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_mcc_category; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_mcc_category REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_mcc_category GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_payment_instrument REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_payment_instrument GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_payment_instrument_tmp; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_payment_instrument_tmp REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_payment_instrument_tmp GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_winning_transaction; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_winning_transaction REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_winning_transaction GRANT SELECT ON TABLES  TO "RTD_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_winning_transaction_tmp REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_winning_transaction_tmp GRANT SELECT ON TABLES  TO "RTD_USER";


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: ddsadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA public REVOKE ALL ON TABLES  FROM ddsadmin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA public GRANT SELECT ON TABLES  TO "MONITORING_USER";


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

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT ALL ON TABLES  TO "BPD_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT SELECT ON TABLES  TO "MONITORING_USER";


--
-- PostgreSQL database dump complete
--

