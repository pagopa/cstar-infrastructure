GRANT USAGE ON SCHEMA bpd_award_period TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_citizen TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_error_record TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_mcc_category TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_payment_instrument TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_winning_transaction TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_award_period TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_citizen TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_error_record TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_mcc_category TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_payment_instrument TO "MONITORING_OPERATION_USER";

GRANT USAGE ON SCHEMA bpd_winning_transaction TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_award_period.bpd_award_period TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner_bkp_consap_20210721_ap2 TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner_bck_ap1_202101261644 TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner_error TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner_error_notify TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_citizen TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_citizen_ranking TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_const_ranking TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_ranking_ext TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_ranking_processor_lock TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.bpd_winning_amount TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_citizen.shedlock TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_award_citizen TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_payment_instrument.bpd_payment_instrument TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_citizen TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_payment_instrument.bpd_payment_instrument_history TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_payment_instrument TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_winning_transaction.bpd_winning_transaction TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_check_missing_iban TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_check_missing_iban_detail TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_error_record.bpd_transaction_record TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_mcc_category.bpd_mcc_category TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_payment_instrument.bonifica_pm TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_payment_instrument.bpd_payment_instrument_hpan_cancellation TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_winning_transaction.bpd_bancomat_transaction TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_winning_transaction.bpd_citizen_status_data TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_winning_transaction.bpd_winning_transaction_transfer TO "MONITORING_OPERATION_USER";

GRANT SELECT ON TABLE bpd_winning_transaction.v_count_trx_analytics TO "MONITORING_OPERATION_USER" WITH GRANT OPTION;

GRANT SELECT ON TABLE public.v_elab_transaction_schema TO "MONITORING_OPERATION_USER";

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA bpd_error_record GRANT
SELECT
  ON TABLES TO "MONITORING_OPERATION_USER";

ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT
SELECT
  ON TABLES TO "MONITORING_OPERATION_USER";

