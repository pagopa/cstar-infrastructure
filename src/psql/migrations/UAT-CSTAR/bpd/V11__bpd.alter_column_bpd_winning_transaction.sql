ALTER TABLE bpd_winning_transaction.bpd_winning_transaction 	
	alter column fiscal_code_s  type CHARACTER VARYING(16) using  fiscal_code_s::character varying;