CREATE USER MAPPING FOR "MONITORING_OPERATION_USER" SERVER bpd_payment_instrument_remote;
ALTER USER MAPPING
	FOR "MONITORING_OPERATION_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (user 'MONITORING_OPERATION_USER@${serverName}', password '${monitoringOperationUserPassword}');
ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (ADD sslmode 'require');

CREATE USER MAPPING FOR "MONITORING_OPERATION_USER" SERVER fa_payment_instrument_remote;
ALTER USER MAPPING
	FOR "MONITORING_OPERATION_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (user 'MONITORING_OPERATION_USER@${serverName}', password '${monitoringOperationUserPassword}');
ALTER SERVER fa_payment_instrument_remote
	OPTIONS (ADD sslmode 'require');

GRANT USAGE ON SCHEMA public TO "MONITORING_OPERATION_USER";
GRANT USAGE ON SCHEMA rtd_database TO "MONITORING_OPERATION_USER";
GRANT ALL ON FUNCTION rtd_database.get_payment_instrument_hpans() TO "MONITORING_OPERATION_USER";
GRANT ALL ON FOREIGN SERVER bpd_payment_instrument_remote TO "MONITORING_OPERATION_USER";
GRANT ALL ON FOREIGN SERVER fa_payment_instrument_remote TO "MONITORING_OPERATION_USER";
GRANT SELECT ON TABLE rtd_database.payment_instrument_hpans TO "MONITORING_OPERATION_USER";
GRANT SELECT ON TABLE rtd_database.rtd_batch_exec_data TO "MONITORING_OPERATION_USER";
GRANT SELECT ON TABLE rtd_database.rtd_payment_instrument_data TO "MONITORING_OPERATION_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin IN SCHEMA rtd_database GRANT SELECT ON TABLES  TO "MONITORING_OPERATION_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE ddsadmin GRANT SELECT ON TABLES  TO "MONITORING_OPERATION_USER";
