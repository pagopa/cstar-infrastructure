-- Update users password.
--

ALTER USER "BPD_USER" WITH PASSWORD '${bpdUserPassword}';
ALTER USER "RTD_USER" WITH PASSWORD '${rtdUserPassword}';
ALTER USER "FA_USER" WITH PASSWORD '${faUserPassword}';
ALTER USER "MONITORING_USER" WITH PASSWORD '${monitoringUserPassword}';