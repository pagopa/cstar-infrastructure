UPDATE bpd_winning_transaction.bpd_winning_transaction_transfer
SET elab_ranking_new_b=false
where elab_ranking_new_b IS NULL;

UPDATE bpd_winning_transaction.bpd_winning_transaction
SET elab_ranking_new_b=false
where elab_ranking_new_b IS NULL;

ALTER TABLE bpd_winning_transaction.bpd_winning_transaction_transfer 
	alter column elab_ranking_new_b  SET NOT NULL,
	alter column elab_ranking_new_b  SET DEFAULT false;
;
ALTER TABLE bpd_winning_transaction.bpd_winning_transaction
	alter column elab_ranking_new_b SET NOT NULL,
	alter column elab_ranking_new_b SET DEFAULT false;