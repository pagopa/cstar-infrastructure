--
-- PostgreSQL database dump
--

-- Dumped from database version 11.11
-- Dumped by pg_dump version 13.1

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

--
-- Name: bpd_award_period; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA bpd_award_period;


ALTER SCHEMA bpd_award_period OWNER TO ddsadmin;

--
-- Name: bpd_citizen; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA bpd_citizen;


ALTER SCHEMA bpd_citizen OWNER TO ddsadmin;

--
-- Name: bpd_dashboard_pagopa; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA bpd_dashboard_pagopa;


ALTER SCHEMA bpd_dashboard_pagopa OWNER TO ddsadmin;

--
-- Name: bpd_error_record; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA bpd_error_record;


ALTER SCHEMA bpd_error_record OWNER TO ddsadmin;

--
-- Name: bpd_mcc_category; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA bpd_mcc_category;


ALTER SCHEMA bpd_mcc_category OWNER TO ddsadmin;

--
-- Name: bpd_payment_instrument; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA bpd_payment_instrument;


ALTER SCHEMA bpd_payment_instrument OWNER TO ddsadmin;

--
-- Name: bpd_winning_transaction; Type: SCHEMA; Schema: -; Owner: ddsadmin
--

CREATE SCHEMA bpd_winning_transaction;


ALTER SCHEMA bpd_winning_transaction OWNER TO ddsadmin;

--

GRANT ALL ON SCHEMA bpd_award_period TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_award_period TO "BPD_AWARD_PERIOD_REMOTE_USER";
GRANT USAGE ON SCHEMA bpd_award_period TO "MONITORING_USER";
GRANT USAGE ON SCHEMA bpd_award_period TO "DASHBOARD_PAGOPA_USER";
GRANT ALL ON SCHEMA bpd_citizen TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_citizen TO "MONITORING_USER";
GRANT USAGE ON SCHEMA bpd_citizen TO "DASHBOARD_PAGOPA_USER";
GRANT USAGE ON SCHEMA bpd_dashboard_pagopa TO "DASHBOARD_PAGOPA_USER";
GRANT ALL ON SCHEMA bpd_error_record TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_error_record TO "DASHBOARD_PAGOPA_USER";
GRANT USAGE ON SCHEMA bpd_error_record TO "MONITORING_USER";
GRANT ALL ON SCHEMA bpd_mcc_category TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_mcc_category TO "MONITORING_USER";
GRANT ALL ON SCHEMA bpd_payment_instrument TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_payment_instrument TO "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT USAGE ON SCHEMA bpd_payment_instrument TO "MONITORING_USER";
GRANT USAGE ON SCHEMA bpd_payment_instrument TO "DASHBOARD_PAGOPA_USER";
GRANT ALL ON SCHEMA bpd_winning_transaction TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_winning_transaction TO "BPD_WINNING_TRANSACTION_REMOTE_USER";
GRANT USAGE ON SCHEMA bpd_winning_transaction TO "MONITORING_USER";
GRANT USAGE ON SCHEMA bpd_winning_transaction TO "DASHBOARD_PAGOPA_USER";

--

--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: hypopg; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hypopg WITH SCHEMA public;


--
-- Name: EXTENSION hypopg; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hypopg IS 'Hypothetical indexes for PostgreSQL';


--
-- Name: integration_bpd_award_winner(boolean, boolean, boolean); Type: FUNCTION; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE FUNCTION bpd_citizen.integration_bpd_award_winner(is_no_iban_enabled boolean, is_correttivi_enabled boolean, is_integrativi_enabled boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$


	begin
		
		if is_no_iban_enabled then
		raise notice 'is_no_iban_enabled';
			--aggiorna i record con l'iban ricavato dalla citizen
			UPDATE bpd_citizen.bpd_award_winner baw
			SET 
			payoff_instr_s = tmp.payoff_instr_s, 
			update_date_t = current_timestamp,
			update_user_s= 'CEN-131-NEW_IBAN',
			account_holder_cf_s = tmp.account_holder_cf_s,
			account_holder_name_s= tmp.account_holder_name_s,
			account_holder_surname_s = tmp.account_holder_surname_s,
			technical_account_holder_s= tmp.technical_account_holder_s,
			issuer_card_id_s = tmp.issuer_card_id_s,
			aw_period_start_d = tmp.aw_period_start_d,
			aw_period_end_d = tmp.aw_period_end_d
			from (select baw.id_n, bc.payoff_instr_s, baw.esito_bonifico_s, bc.account_holder_cf_s, bc.account_holder_name_s, bc.account_holder_surname_s,  bc.technical_account_holder_s, bc.issuer_card_id_s, bap.aw_period_start_d, bap.aw_period_end_d 
				from bpd_citizen.bpd_award_winner baw
				inner join bpd_citizen.bpd_citizen bc on baw.fiscal_code_s = bc.fiscal_code_s 
				inner join bpd_award_period.bpd_award_period bap on baw.award_period_id_n = bap.award_period_id_n 
				where (baw.payoff_instr_s is null or baw.payoff_instr_s = '') 
				and bc.payoff_instr_s is not null  
				and bc.payoff_instr_s <> ''
				and (baw.esito_bonifico_s is null or baw.esito_bonifico_s = '')
				and bc.enabled_b is true
				and baw.status_s = 'NEW'
				and bc.timestamp_tc_t < bap.aw_period_end_d + interval '1 day'
				and (baw.update_date_t < current_timestamp - interval '24 hour' or baw.update_date_t is null)
				) tmp
			WHERE baw.id_n = tmp.id_n;
		end if;
	
	if is_correttivi_enabled then
	raise notice 'is_correttivi_enabled';
		--crea i record nuovi per tutti gli utenti che hanno ricevuto ko da consap e che hanno un iban diverso da quello inserito
		INSERT INTO bpd_citizen.bpd_award_winner(
			award_period_id_n, 
			fiscal_code_s,
			payoff_instr_s, 
			amount_n, 
			insert_date_t, 
			insert_user_s, 
			update_date_t, 
			update_user_s, 
			enabled_b, 
			aw_period_start_d, 
			aw_period_end_d, 
			jackpot_n, 
			cashback_n, 
			typology_s, 
			account_holder_cf_s, 
			account_holder_name_s, 
			account_holder_surname_s, 
			check_instr_status_s, 
			technical_account_holder_s, 
			chunk_filename_s, 
			status_s, 
			to_notify_b, 
			notify_times_n, 
			notify_id_s, 
			esito_bonifico_s, 
			cro_s, 
			data_esecuzione_t, 
			result_reason_s, 
			consap_id_n, 
			ticket_id_n, 
			related_id_n, 
			issuer_card_id_s)
			select 
			 	baw.award_period_id_n, 
				baw.fiscal_code_s,
				bc.payoff_instr_s, 
				baw.amount_n, 
				current_timestamp, 
				'CEN-131-IBAN_DIFFERENTE', 
				null, 
				null, 
				true, 
				baw.aw_period_start_d, 
				baw.aw_period_end_d, 
				baw.jackpot_n, 
				baw.cashback_n, 
				baw.typology_s, 
				baw.account_holder_cf_s, 
				bc.account_holder_name_s, 
				bc.account_holder_surname_s, 
				bc.check_instr_status_s, 
				bc.technical_account_holder_s, 
				null, 
				'NEW', 
				false, 
				0, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				baw.id_n, 
				bc.issuer_card_id_s 
		from bpd_citizen.bpd_award_winner baw 
		inner join bpd_citizen.bpd_citizen bc on baw.fiscal_code_s = bc.fiscal_code_s 
		where baw.payoff_instr_s <> bc.payoff_instr_s 
		and baw.esito_bonifico_s <> 'ORDINE ESEGUITO'
		and nullif(bc.payoff_instr_s,'') is not null  
		and bc.enabled_b is true
		and baw.enabled_b = true
		and bc.timestamp_tc_t < baw.aw_period_end_d + interval '1 day'
		--and baw.update_date_t < current_timestamp - interval '24 hour'
		and not exists (select 1 
				from bpd_citizen.bpd_award_winner bawin 
				where bawin.fiscal_code_s=bc.fiscal_code_s 
				--and bawin.payoff_instr_s=bc.payoff_instr_s 
				and bawin.award_period_id_n = baw.award_period_id_n
				and bawin.amount_n = baw.amount_n 
				and (bawin.status_s = 'NEW' or bawin.status_s = 'SENT')
				and (nullif(bawin.esito_bonifico_s,'') is null or bawin.esito_bonifico_s='ORDINE ESEGUITO')
				and bawin.enabled_b = true
				and bawin.ticket_id_n is null 
				and bawin.related_id_n = baw.id_n)
		and not exists(select 1 from bpd_citizen.bpd_award_winner bawin2 where bawin2.related_id_n=baw.id_n and bawin2.enabled_b = true);
		--capire se necessario specificare un periodo
		--and baw.award_period_id_n = 
		end if;
		
		if is_integrativi_enabled then	
		raise notice 'is_integrativi_enabled';
			--creare dei nuovi record con il delta qualora non allineato sul periodo precedente
			INSERT INTO bpd_citizen.bpd_award_winner(
				award_period_id_n, 
				fiscal_code_s,
				payoff_instr_s, 
				amount_n, 
				insert_date_t, 
				insert_user_s, 
				update_date_t, 
				update_user_s, 
				enabled_b, 
				aw_period_start_d, 
				aw_period_end_d, 
				jackpot_n, 
				cashback_n, 
				typology_s, 
				account_holder_cf_s, 
				account_holder_name_s, 
				account_holder_surname_s, 
				check_instr_status_s, 
				technical_account_holder_s, 
				chunk_filename_s, 
				status_s, 
				to_notify_b, 
				notify_times_n, 
				notify_id_s, 
				esito_bonifico_s, 
				cro_s, 
				data_esecuzione_t, 
				result_reason_s, 
				consap_id_n, 
				ticket_id_n, 
				related_id_n, 
				issuer_card_id_s)
				select 
				 	coalesce(baw.award_period_id_n, bcr.award_period_id_n), 
					coalesce(baw.fiscal_code_s, bc.fiscal_code_s),
					coalesce(baw.payoff_instr_s, bc.payoff_instr_s), 
					CASE when (case when bcr.cashback_n > ap.amount_max_n then ap.amount_max_n else bcr.cashback_n end)+ coalesce(baw.cashback_n, 0) > ap.amount_max_n
					then (ap.amount_max_n - (case when bcr.cashback_n > ap.amount_max_n then ap.amount_max_n else bcr.cashback_n end)) else coalesce(baw.cashback_n, 0) end as amount_n,
					current_timestamp, 
					'CEN-131-DELTA', 
					null, 
					null, 
					true, 
					coalesce(baw.aw_period_start_d, ap.aw_period_start_d), 
					coalesce(baw.aw_period_end_d, ap.aw_period_end_d), 
					coalesce(baw.jackpot_n, 0),
					CASE when (case when bcr.cashback_n > ap.amount_max_n then ap.amount_max_n else bcr.cashback_n end)+ coalesce(baw.cashback_n, 0) > ap.amount_max_n
					then (ap.amount_max_n - (case when bcr.cashback_n > ap.amount_max_n then ap.amount_max_n else bcr.cashback_n end)) else coalesce(baw.cashback_n, 0) end as cashback_n, 
					coalesce(baw.typology_s, '01'), 
					coalesce(baw.account_holder_cf_s, bc.account_holder_cf_s),
					coalesce(baw.account_holder_name_s, bc.account_holder_name_s),
					coalesce(baw.account_holder_surname_s, bc.account_holder_surname_s),
					coalesce(baw.check_instr_status_s, bc.check_instr_status_s),
					coalesce(baw.technical_account_holder_s, bc.technical_account_holder_s),
					null, 
					'NEW', 
					false, 
					0, 
					null, 
					null, 
					null, 
					null, 
					null, 
					null, 
					null, 
					null, 
					coalesce(baw.issuer_card_id_s, bc.issuer_card_id_s)
			from bpd_citizen.bpd_citizen bc
			left outer join bpd_citizen.bpd_award_winner baw on baw.fiscal_code_s = bc.fiscal_code_s
			inner join bpd_citizen.bpd_citizen_ranking bcr on bc.fiscal_code_s = bcr.fiscal_code_c 
			inner join bpd_award_period.bpd_award_period ap on bcr.award_period_id_n = ap.award_period_id_n 
			where bcr.cashback_n > baw.cashback_n 
			--and (baw.esito_bonifico_s not like 'ORDINE ESEGUITO' or baw.esito_bonifico_s is null)
			--and baw.status_s not like 'SENT'
			and bcr.transaction_n >= ap.trx_cashback_max_n 
			and bcr.award_period_id_n = baw.award_period_id_n 
			and bc.enabled_b is true
			and baw.update_date_t < current_timestamp - interval '24 hour';
			--capire se necessario specificare un periodo
			--and baw.award_period_id_n =
		end if;
	   
	END;
$$;


ALTER FUNCTION bpd_citizen.integration_bpd_award_winner(is_no_iban_enabled boolean, is_correttivi_enabled boolean, is_integrativi_enabled boolean) OWNER TO ddsadmin;

--
-- Name: update_bonifica_recesso_citizen(character varying); Type: FUNCTION; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE FUNCTION bpd_citizen.update_bonifica_recesso_citizen(citizen_range character varying DEFAULT NULL::character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
	citizen_range_in timestamp;
begin
	raise notice 'FUNCTION update_bonifica_recesso_citizen - start';

	if(citizen_range is not null) then
		citizen_range_in = cast (citizen_range as timestamp);
	else
		citizen_range_in=current_timestamp - interval '2 day';
	end if;

	insert into bpd_citizen.bpd_citizen_notEnabled select fiscal_code_s, cancellation_t from bpd_citizen.bpd_citizen bci where bci.enabled_b is not true and cancellation_t > citizen_range_in;

	raise notice 'INSERT citizen_notenabled - ended for cancellation_t > %',citizen_range_in;
	
	update bpd_winning_transaction.bpd_winning_transaction wt
	set enabled_b = false,
		update_date_t = current_timestamp,
		update_user_s = 'bonifica_per_utente_disattivo'
	from (select fiscal_code_s from bpd_citizen.bpd_citizen_notEnabled) bc
	where wt.fiscal_code_s = bc.fiscal_code_s
	and wt.award_period_id_n = 2
	and wt.enabled_b is true;
	
	raise notice 'UPDATE winning_transaction - ended';

	update bpd_payment_instrument.bpd_payment_instrument bpi
	set enabled_b = false, 
		status_c = 'INACTIVE',
		cancellation_t = bc.cancellation_t, 
		update_user_s = 'bonifica_per_utente_disattivo', 
		update_date_t = current_timestamp 
	from (select fiscal_code_s, cancellation_t from bpd_citizen.bpd_citizen_notEnabled) bc
	where bpi.fiscal_code_s = bc.fiscal_code_s
	and bpi.enabled_b is true;

	raise notice 'UPDATE payment_instrument - ended';

	truncate table bpd_citizen.bpd_citizen_notEnabled;
	
	raise notice 'FUNCTION update_bonifica_recesso_citizen - ended';

return true;
	
end; $$;


ALTER FUNCTION bpd_citizen.update_bonifica_recesso_citizen(citizen_range character varying) OWNER TO ddsadmin;

--
-- Name: update_bpd_award_winner(); Type: FUNCTION; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE FUNCTION bpd_citizen.update_bpd_award_winner() RETURNS void
    LANGUAGE plpgsql
    AS $$
 
    
begin

    /**
     * this table contains the award period closest to closing
     */
    CREATE TEMPORARY TABLE ending_award_period (
        actual_end DATE
        ,award_period_id bigserial
        ) on commit drop;
 
    INSERT INTO ending_award_period (
        actual_end
        ,award_period_id
        )
    SELECT ap.aw_period_end_d + ap.aw_grace_period_n AS actual_end
        ,ap.award_period_id_n AS award_period_id
    FROM public.dblink('bpd_award_period_remote','SELECT award_period_id_n, aw_period_start_d, aw_period_end_d, aw_grace_period_n FROM bpd_award_period.bpd_award_period where CURRENT_DATE between aw_period_start_d and aw_period_end_d + aw_grace_period_n + 1') AS ap(award_period_id_n bigint, aw_period_start_d date, aw_period_end_d date, aw_grace_period_n smallint)
    ORDER BY actual_end limit 1;
 
    /**
     * if an award period ends today then a new winner is defined
     * and a new record is added to the bpd_award_winner table
     */
    IF (
            CURRENT_DATE = (
                SELECT ap.aw_period_end_d + ap.aw_grace_period_n + 1 AS actual_end
                    FROM public.dblink('bpd_award_period_remote','SELECT award_period_id_n, aw_period_start_d, aw_period_end_d, aw_grace_period_n FROM bpd_award_period.bpd_award_period WHERE CURRENT_DATE between aw_period_start_d and aw_period_end_d + aw_grace_period_n + 1') AS ap(award_period_id_n bigint, aw_period_start_d date, aw_period_end_d date, aw_grace_period_n smallint)
                    ORDER BY actual_end limit 1
                )
            ) THEN PERFORM bpd_citizen.update_bpd_award_winner((
                SELECT award_period_id
                FROM ending_award_period
                ));
    END IF ;
 
END;$$;


ALTER FUNCTION bpd_citizen.update_bpd_award_winner() OWNER TO ddsadmin;

--
-- Name: update_bpd_award_winner(bigint); Type: FUNCTION; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE FUNCTION bpd_citizen.update_bpd_award_winner(award_period_id bigint) RETURNS void
    LANGUAGE plpgsql
    AS $_$


begin

insert into bpd_citizen.bpd_award_winner(
	award_period_id_n,
	fiscal_code_s,
	payoff_instr_s,
	amount_n,
	insert_date_t,
	insert_user_s,
	enabled_b,
	aw_period_start_d,
	aw_period_end_d,
	jackpot_n,
	cashback_n,
	typology_s,
	account_holder_cf_s,
	account_holder_name_s,
	account_holder_surname_s,
	check_instr_status_s,
	technical_account_holder_s,
	issuer_card_id_s
)
select
bcr.award_period_id_n,
bcr.fiscal_code_c as fiscal_code,
bc.payoff_instr_s as payoff_instr,
case
	when coalesce(bcr.ranking_n, bre.total_participants + 1) <= coalesce(bre.ranking_min_n, bap.ranking_min_n) then (
		case
			when coalesce(bcr.cashback_n, 0) <= coalesce(bre.period_cashback_max_n, bap.period_cashback_max_n) then bcr.cashback_n + bap.amount_max_n
			else bre.period_cashback_max_n + bap.amount_max_n
	end )
	else (
		case
			when coalesce(bcr.cashback_n, 0) <= coalesce(bre.period_cashback_max_n, bap.period_cashback_max_n) then bcr.cashback_n
			else bre.period_cashback_max_n
	end )
	end as amount,
	CURRENT_TIMESTAMP,
	'update_bpd_award_winner' as insert_user_s,
	true,
	bap.aw_period_start_d,
	bap.aw_period_end_d,
	case
		when bcr.ranking_n <= bre.ranking_min_n then bap.amount_max_n
		else 0
		end as jackpot,
	case
		when bcr.cashback_n <= bre.period_cashback_max_n then bcr.cashback_n
		else bre.period_cashback_max_n
	end as cashback,
	case
		when bcr.cashback_n <= 0 then '02'
		when bcr.ranking_n <= bre.ranking_min_n
		and bcr.cashback_n > 0 then '03'
		else '01'
	end as typology,
	bc.account_holder_cf_s,
	bc.account_holder_name_s,
	bc.account_holder_surname_s,
	bc.check_instr_status_s,
	bc.technical_account_holder_s,
	bc.issuer_card_id_s
from
	bpd_citizen.bpd_citizen_ranking bcr
	inner join bpd_citizen.bpd_citizen bc on
	bcr.fiscal_code_c = bc.fiscal_code_s
	inner join bpd_award_period.bpd_award_period bap on
	bcr.award_period_id_n = bap.award_period_id_n
	inner join bpd_citizen.bpd_ranking_ext bre on
	bcr.award_period_id_n = bre.award_period_id_n
where
	bcr.award_period_id_n = $1
	and bcr.transaction_n >= bap.trx_volume_min_n
	and bc.enabled_b = true
ON conflict DO nothing;
END;$_$;


ALTER FUNCTION bpd_citizen.update_bpd_award_winner(award_period_id bigint) OWNER TO ddsadmin;

--
-- Name: update_ranking_with_milestone(integer, integer, timestamp with time zone); Type: FUNCTION; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE FUNCTION bpd_citizen.update_ranking_with_milestone(in_offset integer, in_limit integer, in_now_timestamp timestamp with time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE
		in_award_period bigint;
		_trx_volume_min_n int2;
		_period_cashback_max_n numeric(7,2);
		_fiscal_code varchar(16);
		_total_cashback numeric(19);
		_total_transactions int8;
		_id_trx_pivot varchar;
		_cashback_norm_pivot numeric;
		_id_trx_min_transaction_number varchar;
		_citizen_counter integer = 0;
		aw_period record;
		
	BEGIN
		
		FOR aw_period
		IN 
			select 
				ap.award_period_id_n as in_award_period,
				ap.trx_volume_min_n AS _trx_volume_min_n, 
				ap.period_cashback_max_n AS _period_cashback_max_n 
			from public.dblink('bpd_award_period_remote',
				'SELECT award_period_id_n, trx_volume_min_n, period_cashback_max_n
				FROM bpd_award_period.bpd_award_period
				where CURRENT_DATE between aw_period_start_d and aw_period_end_d + aw_grace_period_n') 
			AS ap(award_period_id_n bigint, trx_volume_min_n int2, period_cashback_max_n numeric)
		LOOP
				
			FOR _fiscal_code, _total_cashback, _total_transactions IN
--				select 	bc.fiscal_code_s,
--						bcr.cashback_n,
--						bcr.transaction_n
--				 from bpd_citizen.bpd_citizen bc 
--	 				inner join bpd_citizen.bpd_citizen_ranking bcr on
--	     			bc.fiscal_code_s = bcr.fiscal_code_c
--	 			where bc.enabled_b is true
--			    and bcr.award_period_id_n = aw_period.in_award_period
--			    and (bcr.id_trx_pivot is null or bcr.cashback_norm_pivot is null or bcr.id_trx_min_transaction_number is null)
--			    and (bcr.cashback_n >= aw_period._period_cashback_max_n or bcr.transaction_n >= aw_period._trx_volume_min_n)
--			    and bcr.update_date_t < in_now_timestamp
--			    order by bc.fiscal_code_s 
--			    offset in_offset
--			    limit in_limit
--			    for update skip locked
			    select
					bcr.fiscal_code_c,
					bcr.cashback_n,
					bcr.transaction_n
				from
					bpd_citizen.bpd_citizen_ranking bcr
				where
					bcr.award_period_id_n = aw_period.in_award_period
					and (
						(bcr.transaction_n >= aw_period._trx_volume_min_n
							and bcr.id_trx_min_transaction_number is null)
						or (bcr.cashback_n >= aw_period._period_cashback_max_n
							and bcr.id_trx_pivot is null)
						)
					and bcr.update_date_t < in_now_timestamp
					and exists (
					select
						1
					from
						bpd_citizen.bpd_citizen bc
					where
						bc.fiscal_code_s = bcr.fiscal_code_c
						and bc.enabled_b is true )
				order by
					bcr.fiscal_code_c offset in_offset
				limit in_limit for
				update
					skip locked
			
			LOOP
				_id_trx_pivot = null;
				_cashback_norm_pivot = null;
				_id_trx_min_transaction_number = null;
			
				--increment number of elaborated citizen
				IF (_fiscal_code is not null) THEN
					_citizen_counter = _citizen_counter + 1;
				END IF;
				
--				select wt.id_trx_pivot, wt.cashback_norm_pivot, wt.id_trx_min_transaction_number 
--				into _id_trx_pivot, _cashback_norm_pivot, _id_trx_min_transaction_number
--				from public.dblink('bpd_winning_transaction_remote',
--					format('SELECT id_trx_pivot, cashback_norm_pivot, id_trx_min_transaction_number
--					from bpd_winning_transaction.find_citizen_milestones(%L,%L,%L,%L)', _fiscal_code::varchar,aw_period.in_award_period::integer,aw_period._period_cashback_max_n::numeric,aw_period._trx_volume_min_n::integer)) 
--				AS wt(id_trx_pivot varchar, cashback_norm_pivot numeric, id_trx_min_transaction_number varchar);
			
				select wt.id_trx_pivot, wt.cashback_norm_pivot, wt.id_trx_min_transaction_number 
				into _id_trx_pivot, _cashback_norm_pivot, _id_trx_min_transaction_number
				from bpd_winning_transaction.find_citizen_milestones(_fiscal_code::varchar, aw_period.in_award_period::integer, aw_period._period_cashback_max_n::numeric, aw_period._trx_volume_min_n::integer) AS wt;
			
				--performe update based on fiscalCode on citizen_ranking
				update bpd_citizen.bpd_citizen_ranking 
				set id_trx_pivot = _id_trx_pivot,
					cashback_norm_pivot = _cashback_norm_pivot,
					id_trx_min_transaction_number = _id_trx_min_transaction_number, 
					update_date_t = in_now_timestamp,
					update_user_s = 'update_ranking_with_milestone'
				where fiscal_code_c = _fiscal_code
				and award_period_id_n = aw_period.in_award_period;
		
			END LOOP;
		END LOOP;
		
	RETURN _citizen_counter;
				
	END;
$$;


ALTER FUNCTION bpd_citizen.update_ranking_with_milestone(in_offset integer, in_limit integer, in_now_timestamp timestamp with time zone) OWNER TO ddsadmin;

--
-- Name: insert_bpd_payment_instrument_history(); Type: FUNCTION; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE FUNCTION bpd_payment_instrument.insert_bpd_payment_instrument_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
        INSERT INTO bpd_payment_instrument.bpd_payment_instrument_history(hpan_s, activation_t, deactivation_t, fiscal_code_s, insert_date_t, insert_user_s, update_date_t, update_user_s)
		VALUES(NEW.hpan_s, NEW.enrollment_t, NULL, NEW.fiscal_code_s, NEW.insert_date_t, NEW.insert_user_s, NEW.update_date_t, NEW.update_user_s) ON CONFLICT DO NOTHING;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION bpd_payment_instrument.insert_bpd_payment_instrument_history() OWNER TO ddsadmin;

--
-- Name: update_bpd_payment_instrument_history(); Type: FUNCTION; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE FUNCTION bpd_payment_instrument.update_bpd_payment_instrument_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
        UPDATE bpd_payment_instrument.bpd_payment_instrument_history
		SET deactivation_t=NEW.cancellation_t, update_date_t=NEW.update_date_t, update_user_s=NEW.update_user_s
		WHERE hpan_s=NEW.hpan_s AND activation_t=OLD.enrollment_t;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION bpd_payment_instrument.update_bpd_payment_instrument_history() OWNER TO ddsadmin;

--
-- Name: find_citizen_milestones(character varying, integer, numeric, integer); Type: FUNCTION; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE FUNCTION bpd_winning_transaction.find_citizen_milestones(in_fiscal_code character varying, in_award_period integer, in_max_cashback_period numeric, in_trx_volume_min_n integer) RETURNS TABLE(id_trx_pivot character varying, cashback_norm_pivot numeric, id_trx_min_transaction_number character varying)
    LANGUAGE plpgsql
    AS $$
	DECLARE
	
		_cashback numeric;
		_id_trx character varying = null;
		_operation_type_c character varying = null;
		_id_trx_acquirer_s bpd_winning_transaction.bpd_winning_transaction.id_trx_acquirer_s%TYPE = null;
		_trx_timestamp_t bpd_winning_transaction.bpd_winning_transaction.trx_timestamp_t%TYPE = null; 
		_acquirer_c bpd_winning_transaction.bpd_winning_transaction.acquirer_c%TYPE = null;  
		_acquirer_id_s bpd_winning_transaction.bpd_winning_transaction.acquirer_id_s%TYPE = null;
	
		v_prev_cumulate_cashback NUMERIC = 0;
		v_next_cumulate_cashback NUMERIC = 0;
		v_cashback_norm numeric = null;
		v_rownum integer = 0;
	
		v_id_trx_pivot character varying = null;
		v_id_trx_min_transaction_number character varying = null;
	
		placeholder_varchar character varying = null;
		placeholder_numeric numeric = null;
	
		v_exists_storno numeric = null;
		
	BEGIN
		
		FOR _cashback, _id_trx, _operation_type_c, _id_trx_acquirer_s, _trx_timestamp_t, _acquirer_c, _acquirer_id_s
		IN
	      	select 	bwt.score_n as cashback,
	      			concat(	id_trx_acquirer_s,
	      					to_char (bwt.trx_timestamp_t::timestamptz AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
	      					acquirer_c,
	      					acquirer_id_s,
	      					operation_type_c) as	id_trx,
	      			bwt.operation_type_c,
	      			bwt.id_trx_acquirer_s, bwt.trx_timestamp_t, bwt.acquirer_c, bwt.acquirer_id_s
			from bpd_winning_transaction.bpd_winning_transaction bwt 
			where bwt.fiscal_code_s = in_fiscal_code 
			and bwt.award_period_id_n = in_award_period
			and bwt.enabled_b is true
			and bwt.elab_ranking_b is true
			order by trx_timestamp_t asc, insert_date_t asc

	   LOOP
	   	 
	   	  IF (_cashback >= 0 AND _operation_type_c != '01') THEN 
	   	  	v_rownum = v_rownum + 1;
	   	  END IF;
	   	 
	   	 IF (_cashback <= 0 AND _operation_type_c = '01') THEN
	   	 	-- search for "storno totale"
	   	 	select 1 into v_exists_storno from bpd_winning_transaction.bpd_winning_transaction master
					where master.fiscal_code_s = in_fiscal_code 
					and master.award_period_id_n = in_award_period
					and master.id_trx_acquirer_s = _id_trx_acquirer_s
					and master.trx_timestamp_t = _trx_timestamp_t
					and master.acquirer_c = _acquirer_c
					and master.acquirer_id_s = _acquirer_id_s
					and master.operation_type_c = _operation_type_c
					and ((nullif(master.correlation_id_s,'''') is not null 
							and exists (select 1 from bpd_winning_transaction.bpd_winning_transaction bin 
								where bin.operation_type_c!='01' 
								and master.hpan_s=bin.hpan_s 
								and master.correlation_id_s=bin.correlation_id_s 
								and master.acquirer_c=bin.acquirer_c 
								and master.acquirer_id_s=bin.acquirer_id_s 
								and bin.enabled_b=true 
								and master.award_period_id_n=bin.award_period_id_n
								and master.fiscal_code_s=bin.fiscal_code_s
								and abs(master.score_n) = abs(bin.score_n) ))
						or
						((nullif(master.correlation_id_s,'''') is null)
							and exists (select 1 from bpd_winning_transaction.bpd_winning_transaction bin 
								where bin.operation_type_c!='01' 
								and master.hpan_s = bin.hpan_s 
								and master.amount_i =bin.amount_i 
								and master.merchant_id_s =bin.merchant_id_s 
								and master.terminal_id_s =bin.terminal_id_s 
								and master.acquirer_c=bin.acquirer_c 
								and master.acquirer_id_s=bin.acquirer_id_s 
								and bin.enabled_b=true 
								and master.award_period_id_n=bin.award_period_id_n
								and master.fiscal_code_s=bin.fiscal_code_s
								and abs(master.score_n) = abs(bin.score_n) ))
						);
					
				IF (v_exists_storno = 1) THEN
					v_rownum = v_rownum - 1;
				END IF;
	   	 END IF;
     
     	  IF (v_rownum = in_trx_volume_min_n) THEN
     	  	v_id_trx_min_transaction_number = _id_trx;
     	  ELSIF (v_rownum < in_trx_volume_min_n) THEN
     	  	v_id_trx_min_transaction_number = null;
     	  END IF;
     	 
	   	  v_prev_cumulate_cashback = v_next_cumulate_cashback;
	      v_next_cumulate_cashback = v_next_cumulate_cashback + _cashback;
	      
	     
	      IF (v_next_cumulate_cashback < v_prev_cumulate_cashback AND v_next_cumulate_cashback < in_max_cashback_period) THEN
	      	v_cashback_norm = null;
	      	v_id_trx_pivot = null;
	      ELSIF (v_next_cumulate_cashback > in_max_cashback_period AND v_id_trx_pivot is null AND v_cashback_norm is null) THEN 
	      	v_cashback_norm = in_max_cashback_period - v_prev_cumulate_cashback;
	      	v_id_trx_pivot = _id_trx;
	      ELSIF (v_next_cumulate_cashback >= in_max_cashback_period AND v_id_trx_pivot is null AND v_cashback_norm is null) THEN 
	      	v_cashback_norm = _cashback;
	        v_id_trx_pivot = _id_trx;
	     END IF;
	     
	   END LOOP;
		

	   RETURN query SELECT v_id_trx_pivot, v_cashback_norm, v_id_trx_min_transaction_number;
	END;
$$;


ALTER FUNCTION bpd_winning_transaction.find_citizen_milestones(in_fiscal_code character varying, in_award_period integer, in_max_cashback_period numeric, in_trx_volume_min_n integer) OWNER TO ddsadmin;

--
-- Name: insert_transfer_bpd_winning_transaction_into_new_trg_func(); Type: FUNCTION; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE FUNCTION bpd_winning_transaction.insert_transfer_bpd_winning_transaction_into_new_trg_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF
		((NEW.operation_type_c)::text = '01'::text)
	THEN
		INSERT INTO bpd_winning_transaction.bpd_winning_transaction_transfer(acquirer_c,trx_timestamp_t,hpan_s,operation_type_c,circuit_type_c,amount_i,amount_currency_c,mcc_c,mcc_descr_s,score_n,award_period_id_n,insert_date_t,insert_user_s,update_date_t,update_user_s,enabled_b,merchant_id_s,correlation_id_s,acquirer_id_s,id_trx_issuer_s,id_trx_acquirer_s,bin_s,terminal_id_s,fiscal_code_s,elab_ranking_b,elab_ranking_new_b)
		VALUES(NEW.acquirer_c,NEW.trx_timestamp_t,NEW.hpan_s,NEW.operation_type_c,NEW.circuit_type_c,NEW.amount_i,NEW.amount_currency_c,NEW.mcc_c,NEW.mcc_descr_s,NEW.score_n,NEW.award_period_id_n,NEW.insert_date_t,NEW.insert_user_s,NEW.update_date_t,NEW.update_user_s,NEW.enabled_b,NEW.merchant_id_s,NEW.correlation_id_s,NEW.acquirer_id_s,NEW.id_trx_issuer_s,NEW.id_trx_acquirer_s,NEW.bin_s,NEW.terminal_id_s,NEW.fiscal_code_s,NEW.elab_ranking_b,NEW.elab_ranking_new_b)
	    on conflict (id_trx_acquirer_s, trx_timestamp_t, acquirer_c, acquirer_id_s, operation_type_c) do nothing;
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION bpd_winning_transaction.insert_transfer_bpd_winning_transaction_into_new_trg_func() OWNER TO ddsadmin;

--
-- Name: bpd_award_period_remote; Type: SERVER; Schema: -; Owner: ddsadmin
--

CREATE SERVER bpd_award_period_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'bpd',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
);

ALTER SERVER bpd_award_period_remote
	OPTIONS (sslmode 'require');

ALTER SERVER bpd_award_period_remote OWNER TO ddsadmin;

--
-- Name: USER MAPPING BPD_USER SERVER bpd_award_period_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

CREATE USER MAPPING FOR "BPD_USER" SERVER bpd_award_period_remote;


--
-- Name: bpd_payment_instrument_remote; Type: SERVER; Schema: -; Owner: ddsadmin
--

CREATE SERVER bpd_payment_instrument_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'bpd',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
);

ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (sslmode 'require');

ALTER SERVER bpd_payment_instrument_remote OWNER TO ddsadmin;

--
-- Name: USER MAPPING BPD_USER SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

CREATE USER MAPPING FOR "BPD_USER" SERVER bpd_payment_instrument_remote;


--
-- Name: bpd_winning_transaction_remote; Type: SERVER; Schema: -; Owner: ddsadmin
--

CREATE SERVER bpd_winning_transaction_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'bpd',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
);

ALTER SERVER bpd_winning_transaction_remote
	OPTIONS (sslmode 'require');

ALTER SERVER bpd_winning_transaction_remote OWNER TO ddsadmin;

--
-- Name: USER MAPPING BPD_USER SERVER bpd_winning_transaction_remote; Type: USER MAPPING; Schema: -; Owner: ddsadmin
--

CREATE USER MAPPING FOR "BPD_USER" SERVER bpd_winning_transaction_remote;


SET default_tablespace = '';

--
-- Name: bpd_award_period; Type: TABLE; Schema: bpd_award_period; Owner: ddsadmin
--

CREATE TABLE bpd_award_period.bpd_award_period (
    award_period_id_n bigint NOT NULL,
    aw_period_start_d date NOT NULL,
    aw_period_end_d date,
    aw_grace_period_n smallint,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    trx_volume_min_n smallint,
    trx_eval_max_n numeric(7,2),
    amount_max_n numeric(7,2),
    ranking_min_n numeric,
    trx_cashback_max_n numeric(6,2),
    period_cashback_max_n numeric(7,2),
    cashback_perc_n numeric(5,2),
    status_period_c character varying(10)
);


ALTER TABLE bpd_award_period.bpd_award_period OWNER TO ddsadmin;

--
-- Name: bpd_award_period_award_period_id_seq; Type: SEQUENCE; Schema: bpd_award_period; Owner: ddsadmin
--

CREATE SEQUENCE bpd_award_period.bpd_award_period_award_period_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bpd_award_period.bpd_award_period_award_period_id_seq OWNER TO ddsadmin;

--
-- Name: bpd_award_period_award_period_id_seq; Type: SEQUENCE OWNED BY; Schema: bpd_award_period; Owner: ddsadmin
--

ALTER SEQUENCE bpd_award_period.bpd_award_period_award_period_id_seq OWNED BY bpd_award_period.bpd_award_period.award_period_id_n;


--
-- Name: bpd_award_bpd_ward_error_id_seq; Type: SEQUENCE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE SEQUENCE bpd_citizen.bpd_award_bpd_ward_error_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bpd_citizen.bpd_award_bpd_ward_error_id_seq OWNER TO ddsadmin;

--
-- Name: bpd_award_bpd_ward_id_seq; Type: SEQUENCE; Schema: bpd_citizen; Owner: BPD_USER
--

CREATE SEQUENCE bpd_citizen.bpd_award_bpd_ward_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bpd_citizen.bpd_award_bpd_ward_id_seq OWNER TO "BPD_USER";

--
-- Name: bpd_award_winner_bkp_consap_20210721_ap2; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_award_winner_bkp_consap_20210721_ap2 (
    id_n bigint,
    award_period_id_n bigint,
    fiscal_code_s character varying(16),
    payoff_instr_s character varying,
    amount_n numeric,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    aw_period_start_d date,
    aw_period_end_d date,
    jackpot_n numeric,
    cashback_n numeric,
    typology_s character varying,
    account_holder_cf_s character varying,
    account_holder_name_s character varying,
    account_holder_surname_s character varying,
    check_instr_status_s character varying,
    technical_account_holder_s character varying,
    chunk_filename_s character varying,
    status_s character varying,
    esito_bonifico_s character varying,
    cro_s character varying,
    data_esecuzione_t date,
    result_reason_s character varying,
    to_notify_b boolean,
    notify_times_n numeric,
    notify_id_s character varying,
    ticket_id_n numeric,
    related_id_n numeric,
    consap_id_n bigint,
    issuer_card_id_s character varying(20)
);


ALTER TABLE bpd_citizen.bpd_award_winner_bkp_consap_20210721_ap2 OWNER TO ddsadmin;

--
-- Name: bpd_award_winner; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_award_winner (
    id_n bigint NOT NULL,
    award_period_id_n bigint NOT NULL,
    fiscal_code_s character varying(16) NOT NULL,
    payoff_instr_s character varying,
    amount_n numeric,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    aw_period_start_d date,
    aw_period_end_d date,
    jackpot_n numeric,
    cashback_n numeric,
    typology_s character varying,
    account_holder_cf_s character varying,
    account_holder_name_s character varying,
    account_holder_surname_s character varying,
    check_instr_status_s character varying,
    technical_account_holder_s character varying,
    chunk_filename_s character varying,
    status_s character varying DEFAULT 'NEW'::character varying NOT NULL,
    esito_bonifico_s character varying,
    cro_s character varying,
    data_esecuzione_t date,
    result_reason_s character varying,
    to_notify_b boolean DEFAULT true,
    notify_times_n numeric DEFAULT 0,
    notify_id_s character varying,
    ticket_id_n numeric,
    related_id_n numeric,
    consap_id_n bigint,
    issuer_card_id_s character varying(20)
);


ALTER TABLE bpd_citizen.bpd_award_winner OWNER TO ddsadmin;

--
-- Name: bpd_award_winner_error; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_award_winner_error (
    id_s character varying,
    result_s character varying,
    result_reason_s character varying,
    cro_s character varying,
    execution_date_s character varying,
    exception_message_s character varying,
    last_resubmit_date_t timestamp with time zone,
    to_resubmit_b boolean,
    enabled_b boolean,
    insert_date_t timestamp with time zone,
    insert_user_s character varying,
    update_date_t timestamp with time zone,
    update_user_s character varying,
    record_id_s character varying NOT NULL,
    origin_topic_s character varying,
    origin_listener_s character varying,
    origin_request_id_s character varying,
    jackpot_amount_n numeric,
    amount_n numeric,
    origin_integration_header_s character varying,
    technical_count_property_s character varying,
    award_period_id_s character varying,
    period_end_date_s character varying,
    period_start_date_s character varying,
    cashback_amount_n numeric,
    surname_s character varying,
    name_s character varying,
    iban_s character varying,
    fiscal_code_s character varying,
    id_pagopa_s character varying,
    id_complaint_s character varying,
    id_consap_s character varying
);


ALTER TABLE bpd_citizen.bpd_award_winner_error OWNER TO ddsadmin;

--
-- Name: bpd_award_winner_error_notify; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_award_winner_error_notify (
    id_error_n bigint DEFAULT nextval('bpd_citizen.bpd_award_bpd_ward_error_id_seq'::regclass) NOT NULL,
    id_n bigint NOT NULL,
    fiscal_code_s character varying,
    award_period_id_n bigint NOT NULL,
    error_code_s character varying NOT NULL,
    error_message_s character varying,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean
);


ALTER TABLE bpd_citizen.bpd_award_winner_error_notify OWNER TO ddsadmin;

--
-- Name: bpd_award_winner_id_n_seq; Type: SEQUENCE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE SEQUENCE bpd_citizen.bpd_award_winner_id_n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bpd_citizen.bpd_award_winner_id_n_seq OWNER TO ddsadmin;

--
-- Name: bpd_award_winner_id_n_seq; Type: SEQUENCE OWNED BY; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER SEQUENCE bpd_citizen.bpd_award_winner_id_n_seq OWNED BY bpd_citizen.bpd_award_winner.id_n;


--
-- Name: bpd_citizen; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_citizen (
    fiscal_code_s character varying(16) NOT NULL,
    payoff_instr_s character varying,
    payoff_instr_type_c character varying(4),
    timestamp_tc_t timestamp with time zone NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    account_holder_cf_s character varying,
    account_holder_name_s character varying,
    account_holder_surname_s character varying,
    check_instr_status_s character varying,
    cancellation_t timestamp with time zone,
    technical_account_holder_s character varying,
    issuer_card_id_s character varying(20),
    notification_step_s character varying(4000)
);


ALTER TABLE bpd_citizen.bpd_citizen OWNER TO ddsadmin;

--
-- Name: bpd_citizen_ranking; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_citizen_ranking (
    fiscal_code_c character varying(16) NOT NULL,
    award_period_id_n bigint NOT NULL,
    cashback_n numeric,
    insert_date_t timestamp with time zone,
    insert_user_s character varying,
    update_date_t timestamp with time zone,
    update_user_s character varying,
    transaction_n bigint,
    ranking_n bigint,
    id_trx_pivot character varying,
    cashback_norm_pivot numeric,
    id_trx_min_transaction_number character varying,
    last_trx_timestamp_t timestamp with time zone
);


ALTER TABLE bpd_citizen.bpd_citizen_ranking OWNER TO ddsadmin;

--
-- Name: bpd_citizen_ranking_id_seq; Type: SEQUENCE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE SEQUENCE bpd_citizen.bpd_citizen_ranking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bpd_citizen.bpd_citizen_ranking_id_seq OWNER TO ddsadmin;

--
-- Name: bpd_const_ranking; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_const_ranking (
    max_value bigint,
    min_value bigint,
    total_participants bigint
);


ALTER TABLE bpd_citizen.bpd_const_ranking OWNER TO ddsadmin;

--
-- Name: bpd_ranking_ext; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_ranking_ext (
    award_period_id_n bigint NOT NULL,
    max_transaction_n bigint,
    min_transaction_n bigint,
    total_participants bigint,
    ranking_min_n numeric,
    period_cashback_max_n numeric(7,2),
    insert_date_t timestamp with time zone,
    insert_user_s character varying,
    update_date_t timestamp with time zone,
    update_user_s character varying
);


ALTER TABLE bpd_citizen.bpd_ranking_ext OWNER TO ddsadmin;

--
-- Name: bpd_ranking_processor_lock; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_ranking_processor_lock (
    process_id character varying NOT NULL,
    status character varying DEFAULT 'IDLE'::character varying NOT NULL,
    worker_count smallint DEFAULT 0 NOT NULL,
    update_user character varying,
    update_date timestamp(0) with time zone
);


ALTER TABLE bpd_citizen.bpd_ranking_processor_lock OWNER TO ddsadmin;

--
-- Name: bpd_winning_amount; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.bpd_winning_amount (
    ranking_n bigint NOT NULL,
    amount_n bigint
);


ALTER TABLE bpd_citizen.bpd_winning_amount OWNER TO ddsadmin;

--
-- Name: shedlock; Type: TABLE; Schema: bpd_citizen; Owner: ddsadmin
--

CREATE TABLE bpd_citizen.shedlock (
    name character varying(64) NOT NULL,
    lock_until timestamp(3) without time zone,
    locked_at timestamp(3) without time zone,
    locked_by character varying(255)
);


ALTER TABLE bpd_citizen.shedlock OWNER TO ddsadmin;

--
-- Name: v_bpd_award_citizen; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

CREATE VIEW bpd_dashboard_pagopa.v_bpd_award_citizen AS
 SELECT bc.fiscal_code_s,
    baw.id_n,
    baw.award_period_id_n AS aw_winn_award_period_id_n,
    baw.payoff_instr_s,
    baw.amount_n,
    baw.aw_period_start_d AS aw_winn_aw_period_start_d,
    baw.aw_period_end_d AS aw_winn_aw_period_end_d,
    baw.jackpot_n,
    baw.cashback_n AS aw_winn_cashback_n,
    baw.typology_s,
    baw.account_holder_cf_s,
    baw.account_holder_name_s,
    baw.account_holder_surname_s,
    baw.check_instr_status_s,
    baw.insert_date_t AS aw_winn_insert_date_t,
    baw.insert_user_s AS aw_winn_insert_user_s,
    baw.update_date_t AS aw_winn_update_date_t,
    baw.update_user_s AS aw_winn_update_user_s,
    baw.enabled_b AS aw_winn_enabled_b,
    bcr.award_period_id_n AS cit_rank_award_period_id,
    bcr.cashback_n AS cit_rank_cashback_n,
    bcr.transaction_n,
    bcr.ranking_n,
    bcr.update_date_t AS ranking_date_t,
    bcr.insert_date_t AS cit_rank_insert_date_t,
    bcr.insert_user_s AS cit_rank_insert_user_s,
    bcr.update_date_t AS cit_rank_update_date_t,
    bcr.update_user_s AS cit_rank_update_user_s,
    NULL::text AS cit_rank_enabled_b,
    COALESCE(bap.award_period_id_n, bap1.award_period_id_n) AS award_period_id_n,
    COALESCE(bap.aw_period_start_d, bap1.aw_period_start_d) AS aw_per_aw_period_start_d,
    COALESCE(bap.aw_period_end_d, bap1.aw_period_end_d) AS aw_per_aw_period_end_d,
    COALESCE(bap.aw_grace_period_n, bap1.aw_grace_period_n) AS aw_grace_period_n,
    COALESCE(bap.amount_max_n, bap1.amount_max_n) AS amount_max_n,
    COALESCE(bap.trx_volume_min_n, bap1.trx_volume_min_n) AS trx_volume_min_n,
    COALESCE(bap.trx_eval_max_n, bap1.trx_eval_max_n) AS trx_eval_max_n,
    COALESCE(bap.ranking_min_n, bap1.ranking_min_n) AS ranking_min_n,
    COALESCE(bap.trx_cashback_max_n, bap1.trx_cashback_max_n) AS trx_cashback_max_n,
    COALESCE(bap.period_cashback_max_n, bap1.period_cashback_max_n) AS period_cashback_max_n,
    COALESCE(bap.cashback_perc_n, bap1.cashback_perc_n) AS cashback_perc_n,
    COALESCE(bap.insert_date_t, bap1.insert_date_t) AS aw_per_insert_date_t,
    COALESCE(bap.insert_user_s, bap1.insert_user_s) AS aw_per_insert_user_s,
    COALESCE(bap.update_date_t, bap1.update_date_t) AS aw_per_update_date_t,
    COALESCE(bap.update_user_s, bap1.update_user_s) AS aw_per_update_user_s,
    COALESCE(bap.enabled_b, bap1.enabled_b) AS aw_per_enabled_b
   FROM ((((bpd_citizen.bpd_citizen bc
     LEFT JOIN bpd_citizen.bpd_award_winner baw ON (((bc.fiscal_code_s)::text = (baw.fiscal_code_s)::text)))
     LEFT JOIN bpd_citizen.bpd_citizen_ranking bcr ON (((bc.fiscal_code_s)::text = (bcr.fiscal_code_c)::text)))
     LEFT JOIN bpd_award_period.bpd_award_period bap ON ((bcr.award_period_id_n = bap.award_period_id_n)))
     LEFT JOIN bpd_award_period.bpd_award_period bap1 ON ((baw.award_period_id_n = bap1.award_period_id_n)));


ALTER TABLE bpd_dashboard_pagopa.v_bpd_award_citizen OWNER TO ddsadmin;

--
-- Name: bpd_payment_instrument; Type: TABLE; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE TABLE bpd_payment_instrument.bpd_payment_instrument (
    hpan_s character varying(64) NOT NULL,
    fiscal_code_s character varying(16) NOT NULL,
    enrollment_t timestamp with time zone NOT NULL,
    cancellation_t timestamp with time zone,
    status_c character varying(10) NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    channel_s character varying(20),
    hpan_master_s character varying(64)
);


ALTER TABLE bpd_payment_instrument.bpd_payment_instrument OWNER TO ddsadmin;

--
-- Name: v_bpd_citizen; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

CREATE VIEW bpd_dashboard_pagopa.v_bpd_citizen AS
 SELECT cit.fiscal_code_s,
    cit.enabled_b,
    cit.payoff_instr_s,
    cit.payoff_instr_type_c,
    cit.account_holder_cf_s,
    cit.account_holder_name_s,
    cit.account_holder_surname_s,
    cit.check_instr_status_s,
    cit.timestamp_tc_t,
    bpi.hpan_s,
    bpi.status_c,
    cit.cancellation_t,
    bpi.enabled_b AS pay_istr_update_enable_b,
    cit.insert_date_t AS ctz_insert_date_t,
    cit.insert_user_s AS ctz_insert_user_s,
    cit.update_date_t AS ctz_update_date_t,
    cit.update_user_s AS ctz_update_user_s,
    bpi.insert_date_t AS pay_istr_insert_date_t,
    bpi.insert_user_s AS pay_istr_insert_user_s,
    bpi.update_date_t AS pay_istr_update_date_t,
    bpi.update_user_s AS pay_istr_update_user_s
   FROM (bpd_citizen.bpd_citizen cit
     LEFT JOIN bpd_payment_instrument.bpd_payment_instrument bpi ON (((cit.fiscal_code_s)::text = (bpi.fiscal_code_s)::text)));


ALTER TABLE bpd_dashboard_pagopa.v_bpd_citizen OWNER TO ddsadmin;

--
-- Name: bpd_payment_instrument_history; Type: TABLE; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE TABLE bpd_payment_instrument.bpd_payment_instrument_history (
    hpan_s character varying(64) NOT NULL,
    activation_t timestamp with time zone NOT NULL,
    deactivation_t timestamp with time zone,
    id_n bigint NOT NULL,
    fiscal_code_s character varying(16),
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40)
);


ALTER TABLE bpd_payment_instrument.bpd_payment_instrument_history OWNER TO ddsadmin;

--
-- Name: v_bpd_payment_instrument; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

CREATE VIEW bpd_dashboard_pagopa.v_bpd_payment_instrument AS
 SELECT bpih.fiscal_code_s,
    bpih.hpan_s,
        CASE
            WHEN (bpih.deactivation_t IS NOT NULL) THEN 'INACTIVE'::text
            ELSE 'ACTIVE'::text
        END AS status_c,
    bpi.channel_s,
    bpi.enabled_b,
    bpih.activation_t AS enrollment_t,
    bpih.deactivation_t AS cancellation_t,
    bpih.insert_date_t AS paym_istr_hist_insert_date_t,
    bpih.insert_user_s AS paym_istr_hist_insert_user_s,
    bpih.update_date_t AS paym_istr_hist_update_date_t,
    bpih.update_user_s AS paym_istr_hist_update_user_s,
    bpi.insert_date_t AS paym_istr_insert_date_t,
    bpi.insert_user_s AS paym_istr_insert_user_s,
    bpi.update_date_t AS paym_istr_update_date_t,
    bpi.update_user_s AS paym_istr_update_user_s
   FROM (bpd_payment_instrument.bpd_payment_instrument_history bpih
     JOIN bpd_payment_instrument.bpd_payment_instrument bpi ON (((bpih.hpan_s)::text = (bpi.hpan_s)::text)));


ALTER TABLE bpd_dashboard_pagopa.v_bpd_payment_instrument OWNER TO ddsadmin;

--
-- Name: bpd_winning_transaction; Type: TABLE; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE TABLE bpd_winning_transaction.bpd_winning_transaction (
    acquirer_c character varying(20) NOT NULL,
    trx_timestamp_t timestamp with time zone NOT NULL,
    hpan_s character varying(64),
    operation_type_c character varying(5) NOT NULL,
    circuit_type_c character varying(5),
    amount_i numeric,
    amount_currency_c character varying(3),
    mcc_c character varying(5),
    mcc_descr_s character varying(40),
    score_n numeric,
    award_period_id_n bigint,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    merchant_id_s character varying,
    correlation_id_s character varying,
    acquirer_id_s character varying NOT NULL,
    id_trx_issuer_s character varying,
    id_trx_acquirer_s character varying NOT NULL,
    bin_s character varying,
    terminal_id_s character varying,
    fiscal_code_s character varying(16),
    elab_ranking_new_b boolean DEFAULT false NOT NULL,
    elab_ranking_b boolean
);


ALTER TABLE bpd_winning_transaction.bpd_winning_transaction OWNER TO ddsadmin;

--
-- Name: v_bpd_winning_transaction; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

CREATE VIEW bpd_dashboard_pagopa.v_bpd_winning_transaction AS
 SELECT bwt.fiscal_code_s,
    bwt.trx_timestamp_t,
    bwt.acquirer_id_s,
    bwt.acquirer_c,
    bwt.id_trx_acquirer_s,
    bwt.id_trx_issuer_s,
    bwt.hpan_s,
    bwt.operation_type_c,
    bwt.circuit_type_c,
    bwt.amount_i,
    bwt.amount_currency_c,
    bwt.score_n,
    bwt.award_period_id_n,
    bwt.merchant_id_s,
    bwt.correlation_id_s,
    bwt.bin_s,
    bwt.terminal_id_s,
    bwt.enabled_b,
    bwt.elab_ranking_b,
    bwt.insert_date_t AS winn_trans_insert_date_t,
    bwt.insert_user_s AS winn_trans_insert_user_s,
    bwt.update_date_t AS winn_trans_update_date_t,
    bwt.update_user_s AS winn_trans_update_user_s
   FROM bpd_winning_transaction.bpd_winning_transaction bwt;


ALTER TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction OWNER TO ddsadmin;

--
-- Name: v_check_missing_iban; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

CREATE VIEW bpd_dashboard_pagopa.v_check_missing_iban AS
 SELECT tabella.award_period_id_n,
    tabella.classificazione,
    count(*) AS count
   FROM ( SELECT bc.fiscal_code_s,
            COALESCE((ranking.award_period_id_n)::character(1), 'N/A'::bpchar) AS award_period_id_n,
                CASE
                    WHEN ((ranking.transaction_n IS NULL) OR (ranking.transaction_n = 0)) THEN 'Non ha transazioni'::text
                    WHEN ((ranking.transaction_n >= 1) AND (ranking.transaction_n <= 10)) THEN 'Ha almeno una transazione'::text
                    WHEN (ranking.transaction_n > 10) THEN 'Ha più di 10 transazioni'::text
                    ELSE 'unknown'::text
                END AS classificazione
           FROM (bpd_citizen.bpd_citizen bc
             LEFT JOIN bpd_citizen.bpd_citizen_ranking ranking ON (((bc.fiscal_code_s)::text = (ranking.fiscal_code_c)::text)))
          WHERE ((1 = 1) AND (bc.payoff_instr_s IS NULL) AND (bc.cancellation_t IS NULL) AND (bc.enabled_b = true))
          ORDER BY bc.fiscal_code_s, COALESCE((ranking.award_period_id_n)::character(1), 'N/A'::bpchar)) tabella
  GROUP BY tabella.award_period_id_n, tabella.classificazione;


ALTER TABLE bpd_dashboard_pagopa.v_check_missing_iban OWNER TO ddsadmin;

--
-- Name: v_check_missing_iban_detail; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

CREATE VIEW bpd_dashboard_pagopa.v_check_missing_iban_detail AS
 SELECT bc.fiscal_code_s,
    COALESCE((ranking.award_period_id_n)::character(1), 'N/A'::bpchar) AS award_period_id_n,
        CASE
            WHEN ((ranking.transaction_n IS NULL) OR (ranking.transaction_n = 0)) THEN 'Non ha transazioni'::text
            WHEN ((ranking.transaction_n >= 1) AND (ranking.transaction_n <= 10)) THEN 'Ha almeno una transazione'::text
            WHEN (ranking.transaction_n > 10) THEN 'Ha più di 10 transazioni'::text
            ELSE 'unknown'::text
        END AS classificazione
   FROM (bpd_citizen.bpd_citizen bc
     LEFT JOIN bpd_citizen.bpd_citizen_ranking ranking ON (((bc.fiscal_code_s)::text = (ranking.fiscal_code_c)::text)))
  WHERE ((1 = 1) AND (bc.payoff_instr_s IS NULL) AND (bc.cancellation_t IS NULL) AND (bc.enabled_b = true))
  ORDER BY bc.fiscal_code_s, COALESCE((ranking.award_period_id_n)::character(1), 'N/A'::bpchar);


ALTER TABLE bpd_dashboard_pagopa.v_check_missing_iban_detail OWNER TO ddsadmin;

--
-- Name: bpd_transaction_record; Type: TABLE; Schema: bpd_error_record; Owner: ddsadmin
--

CREATE TABLE bpd_error_record.bpd_transaction_record (
    record_id_s character varying(64) NOT NULL,
    acquirer_c character varying(20),
    trx_timestamp_t timestamp with time zone,
    hpan_s character varying(64),
    operation_type_c character varying(5),
    circuit_type_c character varying(5),
    amount_i numeric,
    amount_currency_c character varying(3),
    mcc_c character varying(5),
    mcc_descr_s character varying(40),
    score_n numeric,
    award_period_id_n bigint,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    merchant_id_s character varying,
    correlation_id_s character varying,
    acquirer_id_s character varying,
    id_trx_issuer_s character varying,
    id_trx_acquirer_s character varying,
    bin_s character varying,
    terminal_id_s character varying,
    fiscal_code_s character varying(16),
    origin_topic_s character varying(30),
    origin_listener_s character varying(4000),
    exception_message_s character varying(40000),
    origin_request_id_s character varying(40000),
    last_resubmit_date_t timestamp with time zone,
    to_resubmit_b boolean,
    enabled_b boolean,
    citizen_validation_date_t timestamp with time zone
);


ALTER TABLE bpd_error_record.bpd_transaction_record OWNER TO ddsadmin;

--
-- Name: bpd_mcc_category; Type: TABLE; Schema: bpd_mcc_category; Owner: ddsadmin
--

CREATE TABLE bpd_mcc_category.bpd_mcc_category (
    mcc_category_id_s character varying NOT NULL,
    mcc_category_description_s character varying,
    multiplier_score_d numeric NOT NULL
);


ALTER TABLE bpd_mcc_category.bpd_mcc_category OWNER TO ddsadmin;

--
-- Name: bonifica_pm; Type: TABLE; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE TABLE bpd_payment_instrument.bonifica_pm (
    hpan_s character varying NOT NULL,
    fiscal_code_s character varying NOT NULL,
    cancellation_t timestamp with time zone
);


ALTER TABLE bpd_payment_instrument.bonifica_pm OWNER TO ddsadmin;

--
-- Name: bpd_payment_instrument_history_id_n_seq; Type: SEQUENCE; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE SEQUENCE bpd_payment_instrument.bpd_payment_instrument_history_id_n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bpd_payment_instrument.bpd_payment_instrument_history_id_n_seq OWNER TO ddsadmin;

--
-- Name: bpd_payment_instrument_history_id_n_seq; Type: SEQUENCE OWNED BY; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER SEQUENCE bpd_payment_instrument.bpd_payment_instrument_history_id_n_seq OWNED BY bpd_payment_instrument.bpd_payment_instrument_history.id_n;


--
-- Name: bpd_payment_instrument_history_id_seq; Type: SEQUENCE; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE SEQUENCE bpd_payment_instrument.bpd_payment_instrument_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bpd_payment_instrument.bpd_payment_instrument_history_id_seq OWNER TO ddsadmin;

--
-- Name: bpd_payment_instrument_hpan_cancellation; Type: TABLE; Schema: bpd_payment_instrument; Owner: ddsadmin
--

CREATE TABLE bpd_payment_instrument.bpd_payment_instrument_hpan_cancellation (
    hpan_s character varying(64),
    fiscal_code_s character varying(16),
    enrollment_t timestamp with time zone,
    cancellation_t timestamp with time zone,
    status_c character varying(10),
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    channel_s character varying(20),
    hpan_master_s character varying(64)
);


ALTER TABLE bpd_payment_instrument.bpd_payment_instrument_hpan_cancellation OWNER TO ddsadmin;

--
-- Name: bpd_bancomat_transaction; Type: TABLE; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE TABLE bpd_winning_transaction.bpd_bancomat_transaction (
    acquirer_c character varying(20) NOT NULL,
    operation_type_c character varying(5) NOT NULL,
    circuit_type_c character varying(5),
    hpan_s character varying(64),
    trx_timestamp_t timestamp with time zone NOT NULL,
    id_trx_acquirer_s character varying NOT NULL,
    id_trx_issuer_s character varying,
    correlation_id_s character varying,
    amount_i numeric,
    amount_currency_c character varying(3),
    acquirer_id_s character varying NOT NULL,
    merchant_id_s character varying,
    terminal_id_s character varying,
    bin_s character varying,
    mcc_c character varying(6)
);


ALTER TABLE bpd_winning_transaction.bpd_bancomat_transaction OWNER TO ddsadmin;

--
-- Name: bpd_citizen_status_data; Type: TABLE; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE TABLE bpd_winning_transaction.bpd_citizen_status_data (
    update_timestamp_t timestamp with time zone NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    fiscal_code_s character varying(16) NOT NULL
);


ALTER TABLE bpd_winning_transaction.bpd_citizen_status_data OWNER TO ddsadmin;

--
-- Name: bpd_winning_transaction_transfer; Type: TABLE; Schema: bpd_winning_transaction; Owner: ddsadmin
--

CREATE TABLE bpd_winning_transaction.bpd_winning_transaction_transfer (
    acquirer_c character varying(20) NOT NULL,
    trx_timestamp_t timestamp with time zone NOT NULL,
    hpan_s character varying(64),
    operation_type_c character varying(5) NOT NULL,
    circuit_type_c character varying(5),
    amount_i numeric,
    amount_currency_c character varying(3),
    mcc_c character varying(5),
    mcc_descr_s character varying(40),
    score_n numeric,
    award_period_id_n bigint,
    insert_date_t timestamp with time zone,
    insert_user_s character varying(40),
    update_date_t timestamp with time zone,
    update_user_s character varying(40),
    enabled_b boolean,
    merchant_id_s character varying,
    correlation_id_s character varying,
    acquirer_id_s character varying NOT NULL,
    id_trx_issuer_s character varying,
    id_trx_acquirer_s character varying NOT NULL,
    bin_s character varying,
    terminal_id_s character varying,
    fiscal_code_s character varying(16),
    elab_ranking_new_b boolean DEFAULT false NOT NULL,
    elab_ranking_b boolean,
    partial_transfer_b boolean,
    parked_b boolean
);


ALTER TABLE bpd_winning_transaction.bpd_winning_transaction_transfer OWNER TO ddsadmin;

--
-- Name: v_count_trx_analytics; Type: VIEW; Schema: bpd_winning_transaction; Owner: BPD_USER
--

CREATE VIEW bpd_winning_transaction.v_count_trx_analytics AS
 SELECT (bpd_winning_transaction.insert_date_t)::date AS date_insert_t,
    (bpd_winning_transaction.trx_timestamp_t)::date AS trx_date_t,
    bpd_winning_transaction.acquirer_c,
    bpd_winning_transaction.operation_type_c,
    bpd_winning_transaction.circuit_type_c,
    count(*) AS count
   FROM bpd_winning_transaction.bpd_winning_transaction
  WHERE (bpd_winning_transaction.enabled_b = true)
  GROUP BY ((bpd_winning_transaction.insert_date_t)::date), ((bpd_winning_transaction.trx_timestamp_t)::date), bpd_winning_transaction.acquirer_c, bpd_winning_transaction.operation_type_c, bpd_winning_transaction.circuit_type_c
  ORDER BY ((bpd_winning_transaction.insert_date_t)::date), ((bpd_winning_transaction.trx_timestamp_t)::date);


ALTER TABLE bpd_winning_transaction.v_count_trx_analytics OWNER TO "BPD_USER";

--
-- Name: v_elab_transaction_schema; Type: TABLE; Schema: public; Owner: ddsadmin
--

CREATE TABLE public.v_elab_transaction_schema (
    concat text
);


ALTER TABLE public.v_elab_transaction_schema OWNER TO ddsadmin;

--
-- Name: bpd_award_period award_period_id_n; Type: DEFAULT; Schema: bpd_award_period; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_award_period.bpd_award_period ALTER COLUMN award_period_id_n SET DEFAULT nextval('bpd_award_period.bpd_award_period_award_period_id_seq'::regclass);


--
-- Name: bpd_award_winner id_n; Type: DEFAULT; Schema: bpd_citizen; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_citizen.bpd_award_winner ALTER COLUMN id_n SET DEFAULT nextval('bpd_citizen.bpd_award_winner_id_n_seq'::regclass);


--
-- Name: bpd_payment_instrument_history id_n; Type: DEFAULT; Schema: bpd_payment_instrument; Owner: ddsadmin
--

ALTER TABLE ONLY bpd_payment_instrument.bpd_payment_instrument_history ALTER COLUMN id_n SET DEFAULT nextval('bpd_payment_instrument.bpd_payment_instrument_history_id_n_seq'::regclass);


--
-- Name: SCHEMA bpd_award_period; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA bpd_award_period TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_award_period TO "BPD_AWARD_PERIOD_REMOTE_USER";
GRANT USAGE ON SCHEMA bpd_award_period TO "MONITORING_USER";
GRANT USAGE ON SCHEMA bpd_award_period TO "DASHBOARD_PAGOPA_USER";


--
-- Name: SCHEMA bpd_citizen; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA bpd_citizen TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_citizen TO "MONITORING_USER";
GRANT USAGE ON SCHEMA bpd_citizen TO "DASHBOARD_PAGOPA_USER";


--
-- Name: SCHEMA bpd_dashboard_pagopa; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT USAGE ON SCHEMA bpd_dashboard_pagopa TO "DASHBOARD_PAGOPA_USER";


--
-- Name: SCHEMA bpd_error_record; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA bpd_error_record TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_error_record TO "DASHBOARD_PAGOPA_USER";
GRANT USAGE ON SCHEMA bpd_error_record TO "MONITORING_USER";


--
-- Name: SCHEMA bpd_mcc_category; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA bpd_mcc_category TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_mcc_category TO "MONITORING_USER";


--
-- Name: SCHEMA bpd_payment_instrument; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA bpd_payment_instrument TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_payment_instrument TO "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT USAGE ON SCHEMA bpd_payment_instrument TO "MONITORING_USER";
GRANT USAGE ON SCHEMA bpd_payment_instrument TO "DASHBOARD_PAGOPA_USER";


--
-- Name: SCHEMA bpd_winning_transaction; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON SCHEMA bpd_winning_transaction TO "BPD_USER";
GRANT USAGE ON SCHEMA bpd_winning_transaction TO "BPD_WINNING_TRANSACTION_REMOTE_USER";
GRANT USAGE ON SCHEMA bpd_winning_transaction TO "MONITORING_USER";
GRANT USAGE ON SCHEMA bpd_winning_transaction TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TYPE dblink_pkey_results; Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON TYPE public.dblink_pkey_results TO "BPD_USER" WITH GRANT OPTION;


--
-- Name: FUNCTION integration_bpd_award_winner(is_no_iban_enabled boolean, is_correttivi_enabled boolean, is_integrativi_enabled boolean); Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_citizen.integration_bpd_award_winner(is_no_iban_enabled boolean, is_correttivi_enabled boolean, is_integrativi_enabled boolean) TO "BPD_USER";


--
-- Name: FUNCTION update_bonifica_recesso_citizen(citizen_range character varying); Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_citizen.update_bonifica_recesso_citizen(citizen_range character varying) TO "BPD_USER";


--
-- Name: FUNCTION update_bpd_award_winner(); Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_citizen.update_bpd_award_winner() TO "BPD_USER";


--
-- Name: FUNCTION update_bpd_award_winner(award_period_id bigint); Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_citizen.update_bpd_award_winner(award_period_id bigint) TO "BPD_USER";


--
-- Name: FUNCTION update_ranking_with_milestone(in_offset integer, in_limit integer, in_now_timestamp timestamp with time zone); Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_citizen.update_ranking_with_milestone(in_offset integer, in_limit integer, in_now_timestamp timestamp with time zone) TO "BPD_USER";


--
-- Name: FUNCTION insert_bpd_payment_instrument_history(); Type: ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_payment_instrument.insert_bpd_payment_instrument_history() TO "BPD_USER";


--
-- Name: FUNCTION update_bpd_payment_instrument_history(); Type: ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_payment_instrument.update_bpd_payment_instrument_history() TO "BPD_USER";


--
-- Name: FUNCTION find_citizen_milestones(in_fiscal_code character varying, in_award_period integer, in_max_cashback_period numeric, in_trx_volume_min_n integer); Type: ACL; Schema: bpd_winning_transaction; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_winning_transaction.find_citizen_milestones(in_fiscal_code character varying, in_award_period integer, in_max_cashback_period numeric, in_trx_volume_min_n integer) TO "BPD_USER";


--
-- Name: FUNCTION insert_transfer_bpd_winning_transaction_into_new_trg_func(); Type: ACL; Schema: bpd_winning_transaction; Owner: ddsadmin
--

GRANT ALL ON FUNCTION bpd_winning_transaction.insert_transfer_bpd_winning_transaction_into_new_trg_func() TO "BPD_USER";


--
-- Name: FUNCTION dblink(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink(text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink(text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink(text, text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink(text, text) TO "BPD_USER";


--
-- Name: FUNCTION dblink(text, text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink(text, text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_build_sql_delete(text, int2vector, integer, text[]); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_build_sql_delete(text, int2vector, integer, text[]) TO "BPD_USER";


--
-- Name: FUNCTION dblink_build_sql_insert(text, int2vector, integer, text[], text[]); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_build_sql_insert(text, int2vector, integer, text[], text[]) TO "BPD_USER";


--
-- Name: FUNCTION dblink_build_sql_update(text, int2vector, integer, text[], text[]); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_build_sql_update(text, int2vector, integer, text[], text[]) TO "BPD_USER";


--
-- Name: FUNCTION dblink_cancel_query(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_cancel_query(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_close(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_close(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_close(text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_close(text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_close(text, text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_close(text, text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_close(text, text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_close(text, text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_connect(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_connect(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_connect(text, text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_connect(text, text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_current_query(); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_current_query() TO "BPD_USER";


--
-- Name: FUNCTION dblink_disconnect(); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_disconnect() TO "BPD_USER";


--
-- Name: FUNCTION dblink_disconnect(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_disconnect(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_error_message(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_error_message(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_exec(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_exec(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_exec(text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_exec(text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_exec(text, text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_exec(text, text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_exec(text, text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_exec(text, text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_fdw_validator(options text[], catalog oid); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_fdw_validator(options text[], catalog oid) TO "BPD_USER";


--
-- Name: FUNCTION dblink_fetch(text, integer); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_fetch(text, integer) TO "BPD_USER";


--
-- Name: FUNCTION dblink_fetch(text, integer, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_fetch(text, integer, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_fetch(text, text, integer); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_fetch(text, text, integer) TO "BPD_USER";


--
-- Name: FUNCTION dblink_fetch(text, text, integer, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_fetch(text, text, integer, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_get_connections(); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_get_connections() TO "BPD_USER";


--
-- Name: FUNCTION dblink_get_notify(OUT notify_name text, OUT be_pid integer, OUT extra text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_get_notify(OUT notify_name text, OUT be_pid integer, OUT extra text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_get_notify(conname text, OUT notify_name text, OUT be_pid integer, OUT extra text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_get_notify(conname text, OUT notify_name text, OUT be_pid integer, OUT extra text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_get_pkey(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_get_pkey(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_get_result(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_get_result(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_get_result(text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_get_result(text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_is_busy(text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_is_busy(text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_open(text, text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_open(text, text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_open(text, text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_open(text, text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_open(text, text, text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_open(text, text, text) TO "BPD_USER";


--
-- Name: FUNCTION dblink_open(text, text, text, boolean); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_open(text, text, text, boolean) TO "BPD_USER";


--
-- Name: FUNCTION dblink_send_query(text, text); Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON FUNCTION public.dblink_send_query(text, text) TO "BPD_USER";


--
-- Name: FOREIGN SERVER bpd_award_period_remote; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN SERVER bpd_award_period_remote TO "BPD_USER";


--
-- Name: FOREIGN SERVER bpd_payment_instrument_remote; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN SERVER bpd_payment_instrument_remote TO "BPD_USER";


--
-- Name: FOREIGN SERVER bpd_winning_transaction_remote; Type: ACL; Schema: -; Owner: ddsadmin
--

GRANT ALL ON FOREIGN SERVER bpd_winning_transaction_remote TO "BPD_USER";


--
-- Name: TABLE bpd_award_period; Type: ACL; Schema: bpd_award_period; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_award_period.bpd_award_period TO "BPD_USER";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE bpd_award_period.bpd_award_period TO "BPD_AWARD_PERIOD_REMOTE_USER";
GRANT SELECT ON TABLE bpd_award_period.bpd_award_period TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_award_period.bpd_award_period TO "DASHBOARD_PAGOPA_USER";


--
-- Name: SEQUENCE bpd_award_period_award_period_id_seq; Type: ACL; Schema: bpd_award_period; Owner: ddsadmin
--

GRANT ALL ON SEQUENCE bpd_award_period.bpd_award_period_award_period_id_seq TO "BPD_USER";


--
-- Name: SEQUENCE bpd_award_bpd_ward_error_id_seq; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON SEQUENCE bpd_citizen.bpd_award_bpd_ward_error_id_seq TO "BPD_USER";


--
-- Name: TABLE bpd_award_winner; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_award_winner TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner TO "MONITORING_USER";


--
-- Name: TABLE bpd_award_winner_bkp_consap_20210721_ap2; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_award_winner_bkp_consap_20210721_ap2 TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner_bkp_consap_20210721_ap2 TO "MONITORING_USER";


--
-- Name: TABLE bpd_award_winner_error; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_award_winner_error TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner_error TO "MONITORING_USER";


--
-- Name: TABLE bpd_award_winner_error_notify; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_award_winner_error_notify TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_award_winner_error_notify TO "MONITORING_USER";


--
-- Name: SEQUENCE bpd_award_winner_id_n_seq; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON SEQUENCE bpd_citizen.bpd_award_winner_id_n_seq TO "BPD_USER";


--
-- Name: TABLE bpd_citizen; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_citizen TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_citizen TO "MONITORING_USER";


--
-- Name: TABLE bpd_citizen_ranking; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_citizen_ranking TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_citizen_ranking TO "MONITORING_USER";


--
-- Name: SEQUENCE bpd_citizen_ranking_id_seq; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON SEQUENCE bpd_citizen.bpd_citizen_ranking_id_seq TO "BPD_USER";


--
-- Name: TABLE bpd_const_ranking; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_const_ranking TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_const_ranking TO "MONITORING_USER";


--
-- Name: TABLE bpd_ranking_ext; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_ranking_ext TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_ranking_ext TO "MONITORING_USER";


--
-- Name: TABLE bpd_ranking_processor_lock; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_ranking_processor_lock TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_ranking_processor_lock TO "MONITORING_USER";


--
-- Name: TABLE bpd_winning_amount; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.bpd_winning_amount TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.bpd_winning_amount TO "MONITORING_USER";


--
-- Name: TABLE shedlock; Type: ACL; Schema: bpd_citizen; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_citizen.shedlock TO "BPD_USER";
GRANT SELECT ON TABLE bpd_citizen.shedlock TO "MONITORING_USER";


--
-- Name: TABLE v_bpd_award_citizen; Type: ACL; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_dashboard_pagopa.v_bpd_award_citizen TO "BPD_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_award_citizen TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_award_citizen TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TABLE bpd_payment_instrument; Type: ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_payment_instrument.bpd_payment_instrument TO "BPD_USER";
GRANT SELECT ON TABLE bpd_payment_instrument.bpd_payment_instrument TO "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT SELECT ON TABLE bpd_payment_instrument.bpd_payment_instrument TO "MONITORING_USER";


--
-- Name: TABLE v_bpd_citizen; Type: ACL; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_dashboard_pagopa.v_bpd_citizen TO "BPD_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_citizen TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_citizen TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TABLE bpd_payment_instrument_history; Type: ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_payment_instrument.bpd_payment_instrument_history TO "BPD_USER";
GRANT SELECT ON TABLE bpd_payment_instrument.bpd_payment_instrument_history TO "BPD_PAYMENT_INSTRUMENT_REMOTE_USER";
GRANT SELECT ON TABLE bpd_payment_instrument.bpd_payment_instrument_history TO "MONITORING_USER";


--
-- Name: TABLE v_bpd_payment_instrument; Type: ACL; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_dashboard_pagopa.v_bpd_payment_instrument TO "BPD_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_payment_instrument TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_payment_instrument TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TABLE bpd_winning_transaction; Type: ACL; Schema: bpd_winning_transaction; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_winning_transaction.bpd_winning_transaction TO "BPD_USER";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE bpd_winning_transaction.bpd_winning_transaction TO "BPD_WINNING_TRANSACTION_REMOTE_USER";
GRANT SELECT ON TABLE bpd_winning_transaction.bpd_winning_transaction TO "MONITORING_USER";


--
-- Name: TABLE v_bpd_winning_transaction; Type: ACL; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction TO "BPD_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_bpd_winning_transaction TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TABLE v_check_missing_iban; Type: ACL; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_dashboard_pagopa.v_check_missing_iban TO "BPD_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_check_missing_iban TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_check_missing_iban TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TABLE v_check_missing_iban_detail; Type: ACL; Schema: bpd_dashboard_pagopa; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_dashboard_pagopa.v_check_missing_iban_detail TO "BPD_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_check_missing_iban_detail TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_dashboard_pagopa.v_check_missing_iban_detail TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TABLE bpd_transaction_record; Type: ACL; Schema: bpd_error_record; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_error_record.bpd_transaction_record TO "BPD_USER";
GRANT SELECT ON TABLE bpd_error_record.bpd_transaction_record TO "MONITORING_USER";
GRANT SELECT ON TABLE bpd_error_record.bpd_transaction_record TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TABLE bpd_mcc_category; Type: ACL; Schema: bpd_mcc_category; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_mcc_category.bpd_mcc_category TO "BPD_USER";
GRANT SELECT ON TABLE bpd_mcc_category.bpd_mcc_category TO "MONITORING_USER";


--
-- Name: TABLE bonifica_pm; Type: ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_payment_instrument.bonifica_pm TO "BPD_USER";
GRANT SELECT ON TABLE bpd_payment_instrument.bonifica_pm TO "MONITORING_USER";


--
-- Name: SEQUENCE bpd_payment_instrument_history_id_n_seq; Type: ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON SEQUENCE bpd_payment_instrument.bpd_payment_instrument_history_id_n_seq TO "BPD_USER";


--
-- Name: SEQUENCE bpd_payment_instrument_history_id_seq; Type: ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON SEQUENCE bpd_payment_instrument.bpd_payment_instrument_history_id_seq TO "BPD_USER";


--
-- Name: TABLE bpd_payment_instrument_hpan_cancellation; Type: ACL; Schema: bpd_payment_instrument; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_payment_instrument.bpd_payment_instrument_hpan_cancellation TO "BPD_USER";
GRANT SELECT ON TABLE bpd_payment_instrument.bpd_payment_instrument_hpan_cancellation TO "MONITORING_USER";


--
-- Name: TABLE bpd_bancomat_transaction; Type: ACL; Schema: bpd_winning_transaction; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_winning_transaction.bpd_bancomat_transaction TO "BPD_USER";
GRANT SELECT ON TABLE bpd_winning_transaction.bpd_bancomat_transaction TO "MONITORING_USER";


--
-- Name: TABLE bpd_citizen_status_data; Type: ACL; Schema: bpd_winning_transaction; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_winning_transaction.bpd_citizen_status_data TO "BPD_USER";
GRANT SELECT ON TABLE bpd_winning_transaction.bpd_citizen_status_data TO "MONITORING_USER";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE bpd_winning_transaction.bpd_citizen_status_data TO "BPD_WINNING_TRANSACTION_REMOTE_USER";
GRANT SELECT ON TABLE bpd_winning_transaction.bpd_citizen_status_data TO "DASHBOARD_PAGOPA_USER";


--
-- Name: TABLE bpd_winning_transaction_transfer; Type: ACL; Schema: bpd_winning_transaction; Owner: ddsadmin
--

GRANT ALL ON TABLE bpd_winning_transaction.bpd_winning_transaction_transfer TO "BPD_USER";
GRANT SELECT ON TABLE bpd_winning_transaction.bpd_winning_transaction_transfer TO "MONITORING_USER";


--
-- Name: TABLE v_count_trx_analytics; Type: ACL; Schema: bpd_winning_transaction; Owner: BPD_USER
--

GRANT SELECT ON TABLE bpd_winning_transaction.v_count_trx_analytics TO "MONITORING_USER" WITH GRANT OPTION;
GRANT ALL ON TABLE bpd_winning_transaction.v_count_trx_analytics TO ddsadmin WITH GRANT OPTION;


--
-- Name: TABLE v_elab_transaction_schema; Type: ACL; Schema: public; Owner: ddsadmin
--

GRANT ALL ON TABLE public.v_elab_transaction_schema TO "BPD_USER";
GRANT SELECT ON TABLE public.v_elab_transaction_schema TO "MONITORING_USER";


--
-- PostgreSQL database dump complete
--

