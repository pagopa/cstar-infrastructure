--
-- Name: bpd_citizen_ranking_parimerito bpd_citizen_ranking__parimerito_fiscal_code_c_fkey; Type: FK CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking_parimerito
    ADD CONSTRAINT bpd_citizen_ranking__parimerito_fiscal_code_c_fkey FOREIGN KEY (fiscal_code_c) REFERENCES bpd_citizen.bpd_citizen(fiscal_code_s);


--
-- Name: bpd_citizen_ranking_new bpd_citizen_ranking_fiscal_code_c_fkey; Type: FK CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking_new
    ADD CONSTRAINT bpd_citizen_ranking_fiscal_code_c_fkey FOREIGN KEY (fiscal_code_c) REFERENCES bpd_citizen.bpd_citizen(fiscal_code_s);


--
-- Name: bpd_citizen_ranking bpd_citizen_ranking_new_fiscal_code_c_fkey; Type: FK CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking
    ADD CONSTRAINT bpd_citizen_ranking_new_fiscal_code_c_fkey FOREIGN KEY (fiscal_code_c) REFERENCES bpd_citizen.bpd_citizen(fiscal_code_s);


--
-- Name: bpd_mcc_category_rel bdp_mcc_category_rel_fk; Type: FK CONSTRAINT; Schema: bpd_mcc_category; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_mcc_category.bpd_mcc_category_rel
    ADD CONSTRAINT bdp_mcc_category_rel_fk FOREIGN KEY (mcc_category_id_s) REFERENCES bpd_mcc_category.bpd_mcc_category(mcc_category_id_s);


--
-- Name: bpd_payment_instrument_history bpd_payment_instrument_history_fk; Type: FK CONSTRAINT; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_payment_instrument.bpd_payment_instrument_history
    ADD CONSTRAINT bpd_payment_instrument_history_fk FOREIGN KEY (hpan_s) REFERENCES bpd_payment_instrument.bpd_payment_instrument(hpan_s);


--
-- Name: bpd_payment_instrument insert_bpd_payment_instrument_history_trg; Type: TRIGGER; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE TRIGGER insert_bpd_payment_instrument_history_trg AFTER INSERT ON bpd_payment_instrument.bpd_payment_instrument FOR EACH ROW WHEN ((new.enabled_b = true)) EXECUTE PROCEDURE bpd_payment_instrument.insert_bpd_payment_instrument_history();


--
-- Name: bpd_payment_instrument insert_update_bpd_payment_instrument_history_trg; Type: TRIGGER; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE TRIGGER insert_update_bpd_payment_instrument_history_trg AFTER UPDATE OF enrollment_t ON bpd_payment_instrument.bpd_payment_instrument FOR EACH ROW WHEN (((new.enabled_b = true) AND (new.enabled_b <> old.enabled_b) AND (old.enrollment_t <> new.enrollment_t))) EXECUTE PROCEDURE bpd_payment_instrument.insert_bpd_payment_instrument_history();


--
-- Name: bpd_payment_instrument update_bpd_payment_instrument_history_trg; Type: TRIGGER; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE TRIGGER update_bpd_payment_instrument_history_trg AFTER UPDATE OF cancellation_t ON bpd_payment_instrument.bpd_payment_instrument FOR EACH ROW EXECUTE PROCEDURE bpd_payment_instrument.update_bpd_payment_instrument_history();


--
-- Name: bpd_winning_transaction insert_transfer_bpd_winning_transaction_into_new_trg; Type: TRIGGER; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE TRIGGER insert_transfer_bpd_winning_transaction_into_new_trg BEFORE INSERT ON bpd_winning_transaction.bpd_winning_transaction FOR EACH ROW EXECUTE PROCEDURE bpd_winning_transaction.insert_transfer_bpd_winning_transaction_into_new_trg_func();


--
-- Name: bpd_winning_transaction insert_transfer_bpd_winning_transaction_into_new_trg; Type: TRIGGER; Schema: bpd_winning_transaction_tmp; Owner: ddsadmin
--

CREATE TRIGGER insert_transfer_bpd_winning_transaction_into_new_trg BEFORE INSERT ON bpd_winning_transaction_tmp.bpd_winning_transaction FOR EACH ROW EXECUTE PROCEDURE bpd_winning_transaction.insert_transfer_bpd_winning_transaction_into_new_trg_func();
