ALTER TABLE bpd_error_record.bpd_transaction_record 
	alter column exception_message_s Type CHARACTER VARYING(40000) USING exception_message_s::character varying ,
	alter column origin_request_id_s Type CHARACTER VARYING(40000) USING origin_request_id_s::character varying
;

ALTER TABLE bpd_citizen.bpd_award_winner 
	alter column consap_id_n  Type bigInt USING  consap_id_n::numeric 
;	

ALTER TABLE bpd_winning_transaction.bpd_winning_transaction 	
	alter column fiscal_code_s  type CHARACTER VARYING(16) using  fiscal_code_s::character varying;