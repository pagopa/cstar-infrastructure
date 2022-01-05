--
-- Name: bpd_winning_transaction_transfer_fiscal_code_s_idx; Type: INDEX; Schema: bpd_winning_transaction_transfer; Owner: ddsadmin
--

CREATE INDEX bpd_winning_transaction_transfer_fiscal_code_s_idx ON bpd_winning_transaction.bpd_winning_transaction_transfer USING btree (fiscal_code_s);
