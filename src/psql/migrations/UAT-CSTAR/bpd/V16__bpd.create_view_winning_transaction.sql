--
-- Name: v_bpd_winning_transaction; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

CREATE VIEW bpd_dashboard_pagopa.v_bpd_winning_transaction AS
 SELECT bwt.fiscal_code_s,
    bwt.trx_timestamp_t,
    bwt.acquirer_id_s,
    bwt.acquirer_c,
    bwt.id_trx_acquirer_s,
    bwt.id_trx_issuer_s,
    bwt.hpan_s,
    bwt.operation_type_c,
    bwt.circuit_type_c,
    bwt.amount_i,
    bwt.amount_currency_c,
    bwt.score_n,
    bwt.award_period_id_n,
    bwt.merchant_id_s,
    bwt.correlation_id_s,
    bwt.bin_s,
    bwt.terminal_id_s,
    bwt.enabled_b,
    bwt.elab_ranking_new_b AS elab_ranking_b,
    bwt.insert_date_t AS winn_trans_insert_date_t,
    bwt.insert_user_s AS winn_trans_insert_user_s,
    bwt.update_date_t AS winn_trans_update_date_t,
    bwt.update_user_s AS winn_trans_update_user_s
   FROM bpd_winning_transaction.bpd_winning_transaction bwt;


ALTER TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction OWNER TO ddsadmin;

--
-- Name: TABLE v_bpd_winning_transaction; Type: ACL; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction TO "BPD_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction TO "DASHBOARD_PAGOPA_USER";