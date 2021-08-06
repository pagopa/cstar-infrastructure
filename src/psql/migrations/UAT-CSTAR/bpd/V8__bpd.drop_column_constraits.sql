ALTER TABLE bpd_award_period.bpd_award_period 
	alter column aw_period_end_d drop not null,
	alter column aw_grace_period_n  drop not null,
	alter column trx_volume_min_n drop not null,
	alter column trx_eval_max_n  drop not null,
	alter column amount_max_n drop not null,
	alter column ranking_min_n drop not null,
	alter column trx_cashback_max_n drop not null ,
	alter column period_cashback_max_n drop not null,
	alter column cashback_perc_n drop not null
;

ALTER TABLE bpd_winning_transaction.bpd_winning_transaction_transfer
	alter column elab_ranking_b drop not null,
	alter column elab_ranking_b DROP DEFAULT
;

ALTER TABLE bpd_winning_transaction.bpd_winning_transaction
	alter column elab_ranking_b DROP DEFAULT
;