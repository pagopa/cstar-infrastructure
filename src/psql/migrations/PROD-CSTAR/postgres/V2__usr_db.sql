--
-- Roles
--

CREATE ROLE "DASHBOARD_PAGOPA_USER";
ALTER ROLE "DASHBOARD_PAGOPA_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
ALTER ROLE "FA_PAYMENT_INSTRUMENT_REMOTE_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "FA_USER";
ALTER ROLE "FA_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "MONITORING_USER";
ALTER ROLE "MONITORING_USER" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;
CREATE ROLE "tkm_acquirer_manager";
ALTER ROLE "tkm_acquirer_manager" WITH INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION;

ALTER USER "FA_USER" WITH PASSWORD '${faUserPassword}';
ALTER USER "FA_PAYMENT_INSTRUMENT_REMOTE_USER" WITH PASSWORD '${faPaymentInstrumentRemoteUserPassword}';
ALTER USER "DASHBOARD_PAGOPA_USER" WITH PASSWORD '${dashboardPagopaUserPassword}';
ALTER USER "MONITORING_USER" WITH PASSWORD '${monitoringUserPassword}';
ALTER USER "tkm_acquirer_manager" WITH PASSWORD '${tkmAcquirerManagerUserPassword}';

--
-- Role memberships
--

GRANT "FA_USER" TO ddsadmin GRANTED BY ddsadmin;

-- Database creation
--

GRANT ALL ON DATABASE fa TO "FA_USER";
GRANT CONNECT ON DATABASE fa TO "FA_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT CREATE ON DATABASE fa TO "MONITORING_USER";
GRANT CONNECT ON DATABASE postgres TO "MONITORING_USER";
