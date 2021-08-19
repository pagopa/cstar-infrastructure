-- Update users password.
--

ALTER USER "BPD_USER" WITH PASSWORD '${bpdUserPassword}';
ALTER USER "RTD_USER" WITH PASSWORD '${rtdUserPassword}';
ALTER USER "FA_USER" WITH PASSWORD '${faUserPassword}';
ALTER USER "MONITORING_USER" WITH PASSWORD '${monitoringUserPassword}';
ALTER USER "FA_PAYMENT_INSTRUMENT_REMOTE_USER" WITH PASSWORD '${faPaymentInstrumentRemoteUserPassword}';
ALTER USER "BPD_PAYMENT_INSTRUMENT_REMOTE_USER" WITH PASSWORD '${bpdPaymentInstrumentRemoteUserPassword}';
ALTER USER "BPD_AWARD_PERIOD_REMOTE_USER" WITH PASSWORD '${bpdAwardPeriodRemoteUserPassword}';
ALTER USER "BPD_WINNING_TRANSACTION_REMOTE_USER" WITH PASSWORD '${bpdWinningTransactionRemoteUserPassword}';
ALTER USER "DASHBOARD_PAGOPA_USER" WITH PASSWORD '${dashboardPagopaUserPassword}';
ALTER USER "tkm_acquirer_manager" WITH PASSWORD '${tkmAcquirerManagerUserPassword}';