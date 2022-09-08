-- Update users password.
--

ALTER USER "FA_USER" WITH PASSWORD '${faUserPassword}';
ALTER USER "MONITORING_USER" WITH PASSWORD '${monitoringUserPassword}';
ALTER USER "FA_PAYMENT_INSTRUMENT_REMOTE_USER" WITH PASSWORD '${faPaymentInstrumentRemoteUserPassword}';
ALTER USER "DASHBOARD_PAGOPA_USER" WITH PASSWORD '${dashboardPagopaUserPassword}';
-- ALTER USER "tkm_acquirer_manager" WITH PASSWORD '${tkmAcquirerManagerUserPassword}';