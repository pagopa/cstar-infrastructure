ALTER TABLE bpd_citizen.bpd_award_winner 
	alter column consap_id_n  Type bigInt USING  consap_id_n::numeric 
;