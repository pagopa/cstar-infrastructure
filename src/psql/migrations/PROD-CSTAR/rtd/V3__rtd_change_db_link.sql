
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (set host '${serverName}.postgres.database.azure.com');

ALTER USER MAPPING
	FOR "MONITORING_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (set user 'MONITORING_USER@${serverName}', set password '${monitoringUserPassword}');

ALTER USER MAPPING
	FOR "RTD_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (set user 'RTD_USER@${serverName}', set password '${rtdUserPassword}');

ALTER SERVER fa_payment_instrument_remote
	OPTIONS (set host '${serverName}.postgres.database.azure.com');

ALTER SERVER fa_payment_instrument_remote OWNER TO ddsadmin;

--
-- Name: USER MAPPING MONITORING_USER SERVER fa_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

ALTER USER MAPPING
	FOR "MONITORING_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (set user 'MONITORING_USER@${serverName}', set password '${monitoringUserPassword}');

--
-- Name: USER MAPPING RTD_USER SERVER fa_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

ALTER USER MAPPING
	FOR "RTD_USER"
	SERVER fa_payment_instrument_remote
	OPTIONS (set user 'RTD_USER@${serverName}', set password '${rtdUserPassword}');