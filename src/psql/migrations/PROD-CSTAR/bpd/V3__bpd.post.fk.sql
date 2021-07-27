-- Name: bpd_citizen_ranking bpd_citizen_ranking_new_fiscal_code_c_fkey; Type: FK CONSTRAINT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_citizen_ranking
    ADD CONSTRAINT bpd_citizen_ranking_new_fiscal_code_c_fkey FOREIGN KEY (fiscal_code_c) REFERENCES bpd_citizen.bpd_citizen(fiscal_code_s);


--
-- Name: bpd_payment_instrument_history bpd_payment_instrument_history_fk; Type: FK CONSTRAINT; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_payment_instrument.bpd_payment_instrument_history
    ADD CONSTRAINT bpd_payment_instrument_history_fk FOREIGN KEY (hpan_s) REFERENCES bpd_payment_instrument.bpd_payment_instrument(hpan_s);


