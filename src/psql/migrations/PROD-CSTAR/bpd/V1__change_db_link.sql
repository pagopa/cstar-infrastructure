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



ALTER SERVER bpd_award_period_remote
    OPTIONS (SET host '${serverName}.postgres.database.azure.com');

ALTER SERVER bpd_award_period_remote OWNER TO ddsadmin;

ALTER SERVER bpd_payment_instrument_remote
    OPTIONS (SET host '${serverName}.postgres.database.azure.com');

ALTER SERVER bpd_payment_instrument_remote OWNER TO ddsadmin;

ALTER SERVER bpd_winning_transaction_remote
    OPTIONS (SET host '${serverName}.postgres.database.azure.com');

ALTER SERVER bpd_winning_transaction_remote OWNER TO ddsadmin;

ALTER USER MAPPING
	FOR "BPD_USER"
	SERVER bpd_award_period_remote
	OPTIONS (set user 'BPD_USER@${serverName}', set password '${bpdUserPassword}');

ALTER USER MAPPING
	FOR "BPD_USER"
	SERVER bpd_payment_instrument_remote
	OPTIONS (set user 'BPD_USER@${serverName}', set password '${bpdUserPassword}');

ALTER USER MAPPING
	FOR "BPD_USER"
	SERVER bpd_winning_transaction_remote
	OPTIONS (set user 'BPD_USER@${serverName}', set password '${bpdUserPassword}');