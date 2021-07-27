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


