REVOKE ALL PRIVILEGES ON DATABASE rtd FROM "RTD_USER";
REVOKE ALL PRIVILEGES ON DATABASE rtd FROM "MONITORING_USER";
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "BPD_WINNING_TRANSACTION_REMOTE_USER";
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "BPD_AWARD_PERIOD_REMOTE_USER";
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "BPD_USER";
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "MONITORING_USER";
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "DASHBOARD_PAGOPA_USER";

--
-- REVOKE MONITORING ROLES
--
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "MONITORING_PDND_USER";
REVOKE ALL PRIVILEGES ON DATABASE rtd FROM "MONITORING_PDND_USER";
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "MONITORING_SIA_USER";
REVOKE ALL PRIVILEGES ON DATABASE rtd FROM "MONITORING_SIA_USER";
REVOKE ALL PRIVILEGES ON DATABASE bpd FROM "MONITORING_OPERATION_USER";
REVOKE ALL PRIVILEGES ON DATABASE rtd FROM "MONITORING_OPERATION_USER";


REVOKE ddsadmin FROM "BPD_USER";
REVOKE ddsadmin FROM "RTD_USER";

DROP ROLE "RTD_USER";
DROP ROLE "BPD_WINNING_TRANSACTION_REMOTE_USER";
DROP ROLE "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
DROP ROLE "BPD_AWARD_PERIOD_REMOTE_USER";
DROP ROLE "BPD_USER";
