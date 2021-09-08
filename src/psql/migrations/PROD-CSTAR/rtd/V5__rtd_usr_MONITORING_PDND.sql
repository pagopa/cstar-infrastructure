CREATE USER MAPPING FOR "MONITORING_PDND_USER" SERVER bpd_payment_instrument_remote;

ALTER USER MAPPING
	FOR "MONITORING_PDND_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'MONITORING_PDND_USER@${serverName}', password '${monitoringPdndUserPassword}');

CREATE USER MAPPING FOR "MONITORING_PDND_USER" SERVER fa_payment_instrument_remote;

ALTER USER MAPPING
	FOR "MONITORING_PDND_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (user 'MONITORING_PDND_USER@${serverName}', password '${monitoringPdndUserPassword}');

GRANT USAGE ON SCHEMA rtd_database TO "MONITORING_PDND_USER";
GRANT ALL ON FUNCTION rtd_database.get_payment_instrument_hpans() TO "MONITORING_PDND_USER";
GRANT ALL ON FOREIGN DATA WRAPPER dblink_fdw TO "MONITORING_PDND_USER";
GRANT ALL ON FOREIGN SERVER bpd_payment_instrument_remote TO "MONITORING_PDND_USER";
