--
-- Roles
--

CREATE ROLE "BPD_AWARD_PERIOD_REMOTE_USER";
ALTER ROLE "BPD_AWARD_PERIOD_REMOTE_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
ALTER ROLE "BPD_PAYMENT_INSTRUMENT_REMOTE_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "BPD_USER";
ALTER ROLE "BPD_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
COMMENT ON ROLE "BPD_USER" IS 'Technical user for Bonus Pagamenti Digitali';
CREATE ROLE "BPD_WINNING_TRANSACTION_REMOTE_USER";
ALTER ROLE "BPD_WINNING_TRANSACTION_REMOTE_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "DASHBOARD_PAGOPA_USER";
ALTER ROLE "DASHBOARD_PAGOPA_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
ALTER ROLE "FA_PAYMENT_INSTRUMENT_REMOTE_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "FA_USER";
ALTER ROLE "FA_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "MONITORING_USER";
ALTER ROLE "MONITORING_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "RTD_USER";
ALTER ROLE "RTD_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "tkm_acquirer_manager";
ALTER ROLE "tkm_acquirer_manager" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;

ALTER USER "BPD_USER" WITH PASSWORD '${bpdUserPassword}';
ALTER USER "RTD_USER" WITH PASSWORD '${rtdUserPassword}';
ALTER USER "FA_USER" WITH PASSWORD '${faUserPassword}';
ALTER USER "FA_PAYMENT_INSTRUMENT_REMOTE_USER" WITH PASSWORD '${faPaymentInstrumentRemoteUserPassword}';
ALTER USER "BPD_PAYMENT_INSTRUMENT_REMOTE_USER" WITH PASSWORD '${bpdPaymentInstrumentRemoteUserPassword}';
ALTER USER "BPD_AWARD_PERIOD_REMOTE_USER" WITH PASSWORD '${bpdAwardPeriodRemoteUserPassword}';
ALTER USER "BPD_WINNING_TRANSACTION_REMOTE_USER" WITH PASSWORD '${bpdWinningTransactionRemoteUserPassword}';
ALTER USER "DASHBOARD_PAGOPA_USER" WITH PASSWORD '${dashboardPagopaUserPassword}';
ALTER USER "MONITORING_USER" WITH PASSWORD '${monitoringUserPassword}';
ALTER USER "tkm_acquirer_manager" WITH PASSWORD '${tkmAcquirerManagerUserPassword}';

--
-- Role memberships
--

GRANT "BPD_USER" TO ddsadmin GRANTED BY ddsadmin;
GRANT "RTD_USER" TO ddsadmin GRANTED BY ddsadmin;

-- Database creation
--

GRANT CONNECT ON DATABASE bpd TO "BPD_WINNING_TRANSACTION_REMOTE_USER";
GRANT CONNECT ON DATABASE bpd TO "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT CONNECT ON DATABASE bpd TO "BPD_AWARD_PERIOD_REMOTE_USER";
GRANT ALL ON DATABASE bpd TO "BPD_USER";
GRANT CONNECT ON DATABASE bpd TO "MONITORING_USER";
GRANT ALL ON DATABASE bpd TO "DASHBOARD_PAGOPA_USER";
GRANT ALL ON DATABASE fa TO "FA_USER";
GRANT CONNECT ON DATABASE fa TO "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT CREATE ON DATABASE fa TO "MONITORING_USER";
GRANT CONNECT ON DATABASE postgres TO "MONITORING_USER";
GRANT CONNECT ON DATABASE rtd TO "RTD_USER";
GRANT CONNECT ON DATABASE rtd TO "MONITORING_USER";