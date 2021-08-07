CREATE VIEW bpd_dashboard_pagopa.v_bpd_award_citizen_v2 AS
 SELECT bc.fiscal_code_s,
    baw.id_n,
    baw.award_period_id_n AS aw_winn_award_period_id_n,
    baw.payoff_instr_s,
    baw.amount_n,
    baw.aw_period_start_d AS aw_winn_aw_period_start_d,
    baw.aw_period_end_d AS aw_winn_aw_period_end_d,
    baw.jackpot_n,
    baw.cashback_n AS aw_winn_cashback_n,
    baw.typology_s,
    baw.account_holder_cf_s,
    baw.account_holder_name_s,
    baw.account_holder_surname_s,
    baw.check_instr_status_s,
    baw.insert_date_t AS aw_winn_insert_date_t,
    baw.insert_user_s AS aw_winn_insert_user_s,
    baw.update_date_t AS aw_winn_update_date_t,
    baw.update_user_s AS aw_winn_update_user_s,
    baw.enabled_b AS aw_winn_enabled_b,
    baw.technical_account_holder_s AS aw_winn_tech_acc_hold,
    baw.status_s AS aw_winn_status,
    baw.to_notify_b AS aw_winn_to_notify,
    baw.esito_bonifico_s AS aw_winn_esito_bonifico,
    baw.cro_s AS aw_winn_cro,
    baw.data_esecuzione_t AS aw_winn_data_esecuzione,
    baw.result_reason_s AS aw_winn_result_reason,
    baw.consap_id_n AS aw_winn_consap_id,
    baw.ticket_id_n AS aw_winn_ticket_id,
    baw.related_id_n AS aw_winn_related_id,
    baw.issuer_card_id_s AS aw_winn_issuer_card_id,
    bcr.award_period_id_n AS cit_rank_award_period_id,
    bcr.cashback_n AS cit_rank_cashback_n,
    bcr.transaction_n,
    bcr.ranking_n,
    bcr.insert_date_t AS cit_rank_insert_date_t,
    bcr.insert_user_s AS cit_rank_insert_user_s,
    bcr.update_date_t AS cit_rank_update_date_t,
    bcr.update_user_s AS cit_rank_update_user_s,
    COALESCE(bap.award_period_id_n, bap1.award_period_id_n) AS award_period_id_n,
    COALESCE(bap.aw_period_start_d, bap1.aw_period_start_d) AS aw_per_aw_period_start_d,
    COALESCE(bap.aw_period_end_d, bap1.aw_period_end_d) AS aw_per_aw_period_end_d,
    COALESCE(bap.aw_grace_period_n, bap1.aw_grace_period_n) AS aw_grace_period_n,
    COALESCE(bap.amount_max_n, bap1.amount_max_n) AS amount_max_n,
    COALESCE(bap.trx_volume_min_n, bap1.trx_volume_min_n) AS trx_volume_min_n,
    COALESCE(bap.trx_eval_max_n, bap1.trx_eval_max_n) AS trx_eval_max_n,
    COALESCE(bap.ranking_min_n, bap1.ranking_min_n) AS ranking_min_n,
    COALESCE(bap.trx_cashback_max_n, bap1.trx_cashback_max_n) AS trx_cashback_max_n,
    COALESCE(bap.period_cashback_max_n, bap1.period_cashback_max_n) AS period_cashback_max_n,
    COALESCE(bap.cashback_perc_n, bap1.cashback_perc_n) AS cashback_perc_n,
    COALESCE(bap.insert_date_t, bap1.insert_date_t) AS aw_per_insert_date_t,
    COALESCE(bap.insert_user_s, bap1.insert_user_s) AS aw_per_insert_user_s,
    COALESCE(bap.update_date_t, bap1.update_date_t) AS aw_per_update_date_t,
    COALESCE(bap.update_user_s, bap1.update_user_s) AS aw_per_update_user_s,
    COALESCE(bap.enabled_b, bap1.enabled_b) AS aw_per_enabled_b
   FROM ((((bpd_citizen.bpd_citizen bc
     LEFT JOIN bpd_citizen.bpd_award_winner baw ON (((bc.fiscal_code_s)::text = (baw.fiscal_code_s)::text)))
     LEFT JOIN bpd_citizen.bpd_citizen_ranking bcr ON (((bc.fiscal_code_s)::text = (bcr.fiscal_code_c)::text)))
     LEFT JOIN bpd_award_period.bpd_award_period bap ON ((bcr.award_period_id_n = bap.award_period_id_n)))
     LEFT JOIN bpd_award_period.bpd_award_period bap1 ON ((baw.award_period_id_n = bap1.award_period_id_n)));


ALTER TABLE bpd_dashboard_pagopa.v_bpd_award_citizen_v2 OWNER TO ddsadmin;

GRANT ALL ON TABLE bpd_dashboard_pagopa.v_bpd_award_citizen_v2 TO "BPD_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_award_citizen_v2 TO "MONITORING_USER";