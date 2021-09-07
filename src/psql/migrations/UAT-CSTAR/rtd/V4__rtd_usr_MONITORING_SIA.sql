CREATE USER MAPPING FOR "MONITORING_SIA_USER" SERVER bpd_payment_instrument_remote;
ALTER USER MAPPING
	FOR "MONITORING_SIA_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'MONITORING_SIA_USER@${serverName}', password '${monitoringSiaUserPassword}');
ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (ADD sslmode 'require');

CREATE USER MAPPING FOR "MONITORING_SIA_USER" SERVER fa_payment_instrument_remote;
ALTER USER MAPPING
	FOR "MONITORING_SIA_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (user 'MONITORING_SIA_USER@${serverName}', password '${monitoringSiaUserPassword}');
ALTER SERVER fa_payment_instrument_remote
	OPTIONS (ADD sslmode 'require');

GRANT USAGE ON SCHEMA public TO "MONITORING_SIA_USER";
GRANT USAGE ON SCHEMA rtd_database TO "MONITORING_SIA_USER";
GRANT ALL ON FUNCTION rtd_database.get_payment_instrument_hpans() TO "MONITORING_SIA_USER";
GRANT ALL ON FOREIGN SERVER bpd_payment_instrument_remote TO "MONITORING_SIA_USER";
GRANT ALL ON FOREIGN SERVER fa_payment_instrument_remote TO "MONITORING_SIA_USER";
GRANT SELECT ON TABLE rtd_database.payment_instrument_hpans TO "MONITORING_SIA_USER";
GRANT SELECT ON TABLE rtd_database.rtd_batch_exec_data TO "MONITORING_SIA_USER";
GRANT SELECT ON TABLE rtd_database.rtd_payment_instrument_data TO "MONITORING_SIA_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA rtd_database GRANT SELECT ON TABLES  TO "MONITORING_SIA_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT SELECT ON TABLES  TO "MONITORING_SIA_USER";
