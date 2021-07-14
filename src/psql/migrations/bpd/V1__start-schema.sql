--
-- PostgreSQL database dump
--

-- Dumped from database version 10.11
-- Dumped by pg_dump version 10.14

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
-- Name: bpd_award_period; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_award_period;


--
-- Name: bpd_citizen; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_citizen;


--
-- Name: bpd_dashboard_pagopa; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_dashboard_pagopa;


--
-- Name: bpd_error_record; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_error_record;


--
-- Name: bpd_mcc_category; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_mcc_category;


--
-- Name: bpd_payment_instrument; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_payment_instrument;


--
-- Name: bpd_payment_instrument_tmp; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_payment_instrument_tmp;


--
-- Name: bpd_winning_transaction; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_winning_transaction;


--
-- Name: bpd_winning_transaction_tmp; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bpd_winning_transaction_tmp;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: hypopg; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hypopg WITH SCHEMA public;


--
-- Name: EXTENSION hypopg; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hypopg IS 'Hypothetical indexes for PostgreSQL';


--
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: data_preparation_milestone(); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.data_preparation_milestone() RETURNS void
    LANGUAGE plpgsql
AS $$
DECLARE
    v_citizen_count integer := 0;
    v_tx_count integer := 0;
    v_fiscal_code character varying := null;
BEGIN

    LOOP EXIT WHEN v_citizen_count = 500000;

    v_fiscal_code := 'TESTMLST_2'||v_citizen_count;
    v_tx_count := 0;

    INSERT INTO bpd_citizen.bpd_citizen
    (fiscal_code_s, payoff_instr_s, payoff_instr_type_c, timestamp_tc_t, insert_date_t, insert_user_s, update_date_t, update_user_s, enabled_b, account_holder_cf_s, account_holder_name_s, account_holder_surname_s, check_instr_status_s, cancellation_t, technical_account_holder_s)
    VALUES(v_fiscal_code, 'IT07Y0300203280219129870047', 'IBAN', current_timestamp, current_timestamp, 'TEST_MILESTONE2', current_timestamp, 'TEST_MILESTONE2', true, NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO bpd_citizen.bpd_citizen_ranking
    (fiscal_code_c, award_period_id_n, cashback_n, insert_date_t, insert_user_s, update_date_t, update_user_s, enabled_b, transaction_n, ranking_n, ranking_min_n, ranking_date_t, max_cashback_n, id_trx_pivot, cashback_norm_pivot, id_trx_min_transaction_number)
    VALUES(v_fiscal_code, 2, 1500.00, current_timestamp, 'TEST_MILESTONE2', current_timestamp, 'TEST_MILESTONE2', true, 150, 1, 100000, NULL, 150.00, NULL, NULL, NULL);

    if (v_citizen_count%2=0) then
        LOOP EXIT WHEN v_tx_count = 150;
        INSERT INTO bpd_winning_transaction.bpd_winning_transaction
        (acquirer_c, trx_timestamp_t, hpan_s, operation_type_c, circuit_type_c, amount_i, amount_currency_c, mcc_c, mcc_descr_s, score_n, award_period_id_n, insert_date_t, insert_user_s, update_date_t, update_user_s, enabled_b, merchant_id_s, correlation_id_s, acquirer_id_s, id_trx_issuer_s, id_trx_acquirer_s, bin_s, terminal_id_s, fiscal_code_s, elab_ranking_b, elab_ranking_new_b)
        VALUES('STPAY', current_timestamp, NULL, '00', '09', 100, '978', '0000', '', 10, 2, current_timestamp, 'TEST_MILESTONE2', current_timestamp, 'TEST_MILESTONE2', true, '', '', '', '', 'xxxxxxxx-'||v_fiscal_code||'-'||v_tx_count, '', '', v_fiscal_code, true, false);

        v_tx_count = v_tx_count + 1;
        END LOOP;
    else
        LOOP EXIT WHEN v_tx_count = 49;
        INSERT INTO bpd_winning_transaction.bpd_winning_transaction
        (acquirer_c, trx_timestamp_t, hpan_s, operation_type_c, circuit_type_c, amount_i, amount_currency_c, mcc_c, mcc_descr_s, score_n, award_period_id_n, insert_date_t, insert_user_s, update_date_t, update_user_s, enabled_b, merchant_id_s, correlation_id_s, acquirer_id_s, id_trx_issuer_s, id_trx_acquirer_s, bin_s, terminal_id_s, fiscal_code_s, elab_ranking_b, elab_ranking_new_b)
        VALUES('STPAY', current_timestamp, NULL, '00', '09', 10, '978', '0000', '', 1, 2, current_timestamp, 'TEST_MILESTONE2', current_timestamp, 'TEST_MILESTONE2', true, '', '', '', '', 'xxxxxxxx-'||v_fiscal_code||'-'||v_tx_count, '', '', v_fiscal_code, true, false);

        v_tx_count = v_tx_count + 1;
        END LOOP;
    end if;


    v_citizen_count = v_citizen_count + 1;
    END LOOP;

END;
$$;


--
-- Name: integration_bpd_award_winner(); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.integration_bpd_award_winner() RETURNS void
    LANGUAGE plpgsql
AS $$


begin

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
            and (baw.update_date_t < current_timestamp - interval '24 hour' or baw.update_date_t is null)
         ) tmp
    WHERE baw.id_n = tmp.id_n;


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
      and esito_bonifico_s <> 'ORDINE ESEGUITO'
      and bc.payoff_instr_s is not null
      and bc.enabled_b is true
      and bc.payoff_instr_s <> ''
      and baw.update_date_t < current_timestamp - interval '24 hour'
      and not exists (select 1
                      from bpd_citizen.bpd_award_winner bawin
                      where bawin.fiscal_code_s=bc.fiscal_code_s
                        and bawin.payoff_instr_s=bc.payoff_instr_s
                        and bawin.award_period_id_n = baw.award_period_id_n
                        and status_s='NEW'
                        and ticket_id_n is null
                        and related_id_n is null);
    --capire se necessario specificare un periodo
    --and baw.award_period_id_n =


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

END;
$$;


--
-- Name: test_bonifica(bigint); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.test_bonifica(off bigint) RETURNS void
    LANGUAGE plpgsql
AS $_$
DECLARE
    fiscal_codes RECORD;
begin
    for fiscal_codes in
        select fiscal_code_c from bpd_citizen.bpd_citizen_ranking_new where award_period_id_n = 1 order by fiscal_code_c limit $1
        loop

            raise notice '%',fiscal_codes.fiscal_code_c;
            select pippo from pluto;
            raise notice 'pluto';

            update
                bpd_winning_transaction.bpd_winning_transaction bwt
            set
                elab_ranking_new_b = false
            where
                    bwt.award_period_id_n = 1
              and bwt.elab_ranking_new_b is true
              and bwt.fiscal_code_s = fiscal_codes.fiscal_code_c ;

            delete
            from
                bpd_citizen.bpd_citizen_ranking_new
            where
                    fiscal_code_c = fiscal_codes.fiscal_code_c ;

        end loop;
END;
$_$;


--
-- Name: test_bonifica(bigint, bigint); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.test_bonifica(awp bigint, off bigint) RETURNS void
    LANGUAGE plpgsql
AS $_$
DECLARE
    fiscal_codes RECORD;
    cf_count integer := 0;
begin
    for fiscal_codes in
        select fiscal_code_c from bpd_citizen.bpd_citizen_ranking_new where award_period_id_n = $1 order by fiscal_code_c limit $2
        loop

            select count(*) into cf_count
            from bpd_winning_transaction.bpd_winning_transaction bwt
            where
                    bwt.award_period_id_n = $1
              and bwt.elab_ranking_new_b is true
              and bwt.fiscal_code_s = fiscal_codes.fiscal_code_c ;

            raise notice '%, % TRANS ELABORATE PREUPDATE',fiscal_codes.fiscal_code_c, cf_count;

            select count(*) into cf_count
            from bpd_winning_transaction.bpd_winning_transaction bwt
            where
                    bwt.award_period_id_n = $1
              and bwt.elab_ranking_new_b is FALSE
              and bwt.fiscal_code_s = fiscal_codes.fiscal_code_c ;

            raise notice '%, % TRANS DA ELABORARE PREUPDATE',fiscal_codes.fiscal_code_c, cf_count;

            update
                bpd_winning_transaction.bpd_winning_transaction bwt
            set
                elab_ranking_new_b = false
            where
                    bwt.award_period_id_n = $1
              and bwt.elab_ranking_new_b is true
              and bwt.fiscal_code_s = fiscal_codes.fiscal_code_c ;

            select count(*) into cf_count
            from bpd_winning_transaction.bpd_winning_transaction bwt
            where
                    bwt.award_period_id_n = $1
              and bwt.elab_ranking_new_b is true
              and bwt.fiscal_code_s = fiscal_codes.fiscal_code_c ;

            raise notice '%, % TRANS ELABORATE POSTUPDATE',fiscal_codes.fiscal_code_c, cf_count;

            select count(*) into cf_count
            from bpd_winning_transaction.bpd_winning_transaction bwt
            where
                    bwt.award_period_id_n = $1
              and bwt.elab_ranking_new_b is FALSE
              and bwt.fiscal_code_s = fiscal_codes.fiscal_code_c ;

            raise notice '%, % TRANS DA ELABORARE POSTUPDATE',fiscal_codes.fiscal_code_c, cf_count;

            delete
            from
                bpd_citizen.bpd_citizen_ranking_new
            where
                    fiscal_code_c = fiscal_codes.fiscal_code_c ;

            raise notice '----------------------------------';
        end loop;
END;
$_$;


--
-- Name: test_ranking_old_new(integer); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.test_ranking_old_new(i integer) RETURNS void
    LANGUAGE plpgsql
AS $$
declare
begin
    INSERT INTO bpd_winning_transaction.bpd_winning_transaction
    (acquirer_c, trx_timestamp_t, hpan_s, operation_type_c, circuit_type_c, amount_i, amount_currency_c, mcc_c, mcc_descr_s, score_n, award_period_id_n, insert_date_t, insert_user_s, update_date_t, update_user_s, enabled_b, merchant_id_s, correlation_id_s, acquirer_id_s, id_trx_issuer_s, id_trx_acquirer_s, bin_s, terminal_id_s, fiscal_code_s, elab_ranking_b, elab_ranking_new_b)
    select
        acquirer_c, trx_timestamp_t+ interval '3 second', hpan_s, operation_type_c, circuit_type_c, amount_i, amount_currency_c, mcc_c, mcc_descr_s, score_n, award_period_id_n, insert_date_t, insert_user_s, update_date_t, update_user_s, enabled_b, merchant_id_s, correlation_id_s, acquirer_id_s, id_trx_issuer_s, id_trx_acquirer_s, bin_s, terminal_id_s, fiscal_code_s, false, elab_ranking_new_b
    from bpd_winning_transaction.bpd_winning_transaction bwt
    offset i*300000 limit 300000;
end; $$;


--
-- Name: update_bonifica_recesso_citizen(character varying); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.update_bonifica_recesso_citizen(citizen_range character varying DEFAULT NULL::character varying) RETURNS boolean
    LANGUAGE plpgsql
AS $$
declare
    citizen_range_in timestamp;
    actual_step_time timestamp;
begin
    actual_step_time = current_timestamp;

    raise notice '[%] - FUNCTION update_bonifica_recesso_citizen - start',actual_step_time;

    if(citizen_range is not null) then
        citizen_range_in = cast (citizen_range as timestamp);
    else
        citizen_range_in=current_timestamp - interval '2 day';
    end if;

    insert into bpd_citizen.bpd_citizen_notEnabled
    select fiscal_code_s, cancellation_t
    from bpd_citizen.bpd_citizen bci
    where bci.enabled_b is not true
      and cancellation_t > citizen_range_in;

    actual_step_time = current_timestamp;

    raise notice '[%] - FUNCTION update_bonifica_recesso_citizen - INSERT citizen notenabled - ended for cancellation_t > %',actual_step_time,citizen_range_in;

    update bpd_winning_transaction.bpd_winning_transaction wt
    set enabled_b = false,
        update_date_t = current_timestamp,
        update_user_s = 'bonifica_per_utente_disattivo'
    from (select fiscal_code_s from bpd_citizen.bpd_citizen_notEnabled) bc
    where wt.fiscal_code_s = bc.fiscal_code_s
      and wt.award_period_id_n = 2
      and wt.enabled_b is true;

    actual_step_time = current_timestamp;

    raise notice '[%] - FUNCTION update_bonifica_recesso_citizen - UPDATE winning transaction - ended',actual_step_time;

    update bpd_payment_instrument.bpd_payment_instrument bpi
    set enabled_b = false,
        status_c = 'INACTIVE',
        cancellation_t = bc.cancellation_t,
        update_user_s = 'bonifica_per_utente_disattivo',
        update_date_t = current_timestamp
    from (select fiscal_code_s, cancellation_t from bpd_citizen.bpd_citizen_notEnabled) bc
    where bpi.fiscal_code_s = bc.fiscal_code_s
      and bpi.enabled_b is true;

    actual_step_time = current_timestamp;

    raise notice '[%] - FUNCTION update_bonifica_recesso_citizen - UPDATE payment instrument - ended',actual_step_time;

    truncate table bpd_citizen.bpd_citizen_notEnabled;

    actual_step_time = current_timestamp;

    raise notice '[%] - FUNCTION update_bonifica_recesso_citizen - ended',actual_step_time;

    return true;

end; $$;


--
-- Name: update_bpd_award_winner(); Type: FUNCTION; Schema: bpd_citizen; Owner: -
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


--
-- Name: update_bpd_award_winner(bigint); Type: FUNCTION; Schema: bpd_citizen; Owner: -
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
        technical_account_holder_s
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
        null as technical_account_holder_s
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
    ON conflict(fiscal_code_s, award_period_id_n) DO nothing;

END;$_$;


--
-- Name: update_bpd_citizen_ranking(); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.update_bpd_citizen_ranking() RETURNS TABLE(fiscal_code_out character varying, payoff_instr_out character varying, aw_period_out bigint, ranking_out numeric, amount_out numeric, aw_period_start_out date, aw_period_end_out date)
    LANGUAGE plpgsql
AS $$
declare
    aw_period record;
    start_procedure timestamptz := current_timestamp;
begin

    insert into bpd_citizen.bpd_elab_transaction_temp(
        id_trx_acquirer_s,
        trx_timestamp_t,
        acquirer_c,
        acquirer_id_s,
        operation_type_c,
        award_period_id_n,
        hpan_s,
        score_n,
        amount_i,
        insert_date_t,
        update_date_t,
        fiscal_code_s,
        correlation_id_s
    )
    select wt.id_trx_acquirer_s,
           wt.trx_timestamp_t,
           wt.acquirer_c,
           wt.acquirer_id_s,
           wt.operation_type_c,
           wt.award_period_id_n,
           wt.hpan_s,
           wt.score_n,
           wt.amount_i,
           wt.insert_date_t,
           wt.update_date_t,
           wt.fiscal_code_s,
           wt.correlation_id_s
    from bpd_citizen.bpd_citizen bc
             inner join public.dblink('bpd_winning_transaction_remote',
                                      'select id_trx_acquirer_s,trx_timestamp_t,acquirer_c,acquirer_id_s,operation_type_c,award_period_id_n, hpan_s, score_n, amount_i, insert_date_t, update_date_t, fiscal_code_s, correlation_id_s from bpd_winning_transaction.bpd_winning_transaction master where master.enabled_b = true and master.elab_ranking_b is not true
                                                                                                                                                                                                                                                                                                    and (master.operation_type_c!=''01'' or (master.operation_type_c=''01'' and (
                                                  ((nullif(master.correlation_id_s,'''') is not null)
                                                      and exists (select * from bpd_winning_transaction.bpd_winning_transaction bin where bin.operation_type_c!=''01'' and master.hpan_s=bin.hpan_s and master.correlation_id_s=bin.correlation_id_s and master.acquirer_c=bin.acquirer_c and master.acquirer_id_s=bin.acquirer_id_s and bin.enabled_b=true and master.award_period_id_n=bin.award_period_id_n))
                                                  or
                                                  ((nullif(master.correlation_id_s,'''') is null)
                                                      and exists (select * from bpd_winning_transaction.bpd_winning_transaction bin  where bin.operation_type_c!=''01'' and master.hpan_s = bin.hpan_s and master.amount_i =bin.amount_i and master.merchant_id_s =bin.merchant_id_s and master.terminal_id_s =bin.terminal_id_s and master.acquirer_c=bin.acquirer_c and master.acquirer_id_s=bin.acquirer_id_s and bin.enabled_b=true and master.award_period_id_n=bin.award_period_id_n))
                                              )
                                              )
                                              )') AS wt(id_trx_acquirer_s varchar,trx_timestamp_t timestamptz,acquirer_c varchar, acquirer_id_s varchar, operation_type_c varchar,award_period_id_n bigint, hpan_s varchar, score_n numeric, amount_i numeric, insert_date_t timestamptz, update_date_t timestamptz, fiscal_code_s varchar, correlation_id_s varchar) on wt.fiscal_code_s=bc.fiscal_code_s
    where bc.enabled_b =true;

    /**
     * trx_daily calculate the cashback accumulated by citizens
     * grouped by fiscal_code and award period
     */
    WITH trx_daily as (
        SELECT
            bc.fiscal_code_s as fiscal_code
             ,sum(wt.score_n) AS cashback
             ,wt.award_period_id_n as award_period
             ,max(wt.insert_date_t) as max_trx_insert
             ,count(1) filter(where wt.score_n >= 0 and wt.operation_type_c!='01') as trx_acquisto
             ,count(1) filter(where wt.score_n <= 0 and wt.operation_type_c='01' and (nullif(correlation_id_s,'''') is null or (select count(1) as conteggio from bpd_winning_transaction.bpd_winning_transaction tmp where tmp.operation_type_c!='01' and tmp.correlation_id_s=wt.correlation_id_s and tmp.acquirer_id_s =wt.acquirer_id_s and tmp.amount_i=wt.amount_i and tmp.hpan_s=wt.hpan_s and tmp.award_period_id_n=wt.award_period_id_n)>0)) as storni
        FROM bpd_citizen.bpd_citizen bc
                 INNER JOIN bpd_citizen.bpd_elab_transaction_temp wt ON wt.fiscal_code_s = bc.fiscal_code_s
                 INNER JOIN public.dblink('bpd_award_period_remote','SELECT award_period_id_n, aw_period_start_d, aw_period_end_d, aw_grace_period_n, ranking_min_n FROM bpd_award_period.bpd_award_period') AS ap(award_period_id_n bigint, aw_period_start_d date, aw_period_end_d date, aw_grace_period_n smallint, ranking_min_n numeric) ON ap.award_period_id_n = wt.award_period_id_n
        where bc.enabled_b = true
        GROUP BY bc.fiscal_code_s, wt.award_period_id_n, ap.ranking_min_n
    )


        /**
         * the bpd_citizen_ranking table is updated with the new calculated scores
         */
    INSERT INTO bpd_citizen.bpd_citizen_ranking (
                                                 fiscal_code_c
                                                ,transaction_n
                                                ,cashback_n
                                                ,award_period_id_n
                                                ,insert_date_t
                                                ,insert_user_s
                                                ,ranking_date_t
    )
    SELECT trx_dly.fiscal_code
         ,trx_dly.trx_acquisto - trx_dly.storni as transazioni
         ,trx_dly.cashback AS cashback
         ,trx_dly.award_period
         ,CURRENT_TIMESTAMP AS insert_date_t
         ,'update_bpd_citizen_ranking' AS insert_user_s
         ,trx_dly.max_trx_insert as ranking_date_t
    FROM trx_daily trx_dly ON conflict(fiscal_code_c, award_period_id_n) DO
        UPDATE
        SET cashback_n = bpd_citizen.bpd_citizen_ranking.cashback_n + excluded.cashback_n
          ,transaction_n = bpd_citizen.bpd_citizen_ranking.transaction_n + excluded.transaction_n
          ,update_date_t = CURRENT_TIMESTAMP
          ,update_user_s = 'update_bpd_citizen_ranking'
          ,ranking_date_t= excluded.ranking_date_t
          ,enabled_b= true;

    for aw_period in
        SELECT *
        FROM public.dblink('bpd_award_period_remote','SELECT award_period_id_n, aw_period_start_d, aw_period_end_d, aw_grace_period_n, ranking_min_n FROM bpd_award_period.bpd_award_period WHERE CURRENT_DATE between aw_period_start_d and aw_period_end_d + aw_grace_period_n') AS ap(award_period_id_n bigint, aw_period_start_d date, aw_period_end_d date, aw_grace_period_n smallint, ranking_min_n numeric)
        loop
            UPDATE  bpd_citizen.bpd_citizen_ranking cr
            SET    ranking_n = sub.rn,
                   ranking_min_n = sub.ranking_min_n,
                   max_cashback_n = sub.period_cashback_max_n
            FROM  (SELECT tmp.fiscal_code_c, tmp.award_period_id_n, tmp.transaction_n, tmp.ranking_min_n, tmp.period_cashback_max_n, row_number() over(order by 1) AS rn
                   from (
                            SELECT bcr.fiscal_code_c, bcr.award_period_id_n, bcr.transaction_n, ap.ranking_min_n, ap.period_cashback_max_n
                            FROM bpd_citizen.bpd_citizen_ranking bcr
                                     inner join bpd_citizen.bpd_citizen bc on bcr.fiscal_code_c = bc.fiscal_code_s
                                     inner join public.dblink('bpd_award_period_remote',format('SELECT award_period_id_n, ranking_min_n, period_cashback_max_n FROM bpd_award_period.bpd_award_period WHERE award_period_id_n= %L',aw_period.award_period_id_n)) AS ap(award_period_id_n bigint, ranking_min_n numeric, period_cashback_max_n numeric) on bcr.award_period_id_n = ap.award_period_id_n
                            WHERE bcr.award_period_id_n = aw_period.award_period_id_n
                              and bc.enabled_b = true
                            ORDER BY transaction_n desc, fiscal_code_c asc) as tmp) sub
            WHERE sub.fiscal_code_c = cr.fiscal_code_c
              and sub.award_period_id_n = cr.award_period_id_n;

            /*
             * update bpd_ranking_ext
             */
            PERFORM bpd_citizen.update_bpd_ranking_ext(aw_period.award_period_id_n, aw_period.ranking_min_n);
        end loop;

    /*
     * update winning transaction
     */
    update bpd_winning_transaction.bpd_winning_transaction wt
    set elab_ranking_b = true
    from (select id_trx_acquirer_s, trx_timestamp_t, acquirer_c,acquirer_id_s,operation_type_c
          from bpd_citizen.bpd_elab_transaction_temp) elab
    where wt.id_trx_acquirer_s=elab.id_trx_acquirer_s
      and wt.trx_timestamp_t=elab.trx_timestamp_t
      and wt.acquirer_c=elab.acquirer_c
      and wt.acquirer_id_s=elab.acquirer_id_s
      and wt.operation_type_c=elab.operation_type_c;

    truncate table bpd_citizen.bpd_elab_transaction_temp;

    UPDATE bpd_citizen.redis_cache_config
    SET update_ranking=true, update_ranking_from=start_procedure;

END;
$$;


--
-- Name: update_bpd_citizen_ranking_old(); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.update_bpd_citizen_ranking_old() RETURNS TABLE(fiscal_code_out character varying, payoff_instr_out character varying, aw_period_out bigint, ranking_out numeric, amount_out numeric, aw_period_start_out date, aw_period_end_out date)
    LANGUAGE plpgsql
AS $$
declare
    aw_period record;
    start_procedure timestamptz := CURRENT_TIMESTAMP;
begin

    insert into bpd_citizen.bpd_elab_transaction_temp(
        id_trx_acquirer_s,
        trx_timestamp_t,
        acquirer_c,
        acquirer_id_s,
        operation_type_c,
        award_period_id_n,
        hpan_s,
        score_n,
        amount_i,
        insert_date_t,
        update_date_t,
        fiscal_code_s,
        correlation_id_s
    )
    select wt.id_trx_acquirer_s,
           wt.trx_timestamp_t,
           wt.acquirer_c,
           wt.acquirer_id_s,
           wt.operation_type_c,
           wt.award_period_id_n,
           wt.hpan_s,
           wt.score_n,
           wt.amount_i,
           wt.insert_date_t,
           wt.update_date_t,
           wt.fiscal_code_s,
           wt.correlation_id_s
    from bpd_citizen.bpd_citizen bc
             inner join public.dblink('bpd_winning_transaction_remote',
                                      'select id_trx_acquirer_s,trx_timestamp_t,acquirer_c,acquirer_id_s,operation_type_c,award_period_id_n, hpan_s, score_n, amount_i, insert_date_t, update_date_t, fiscal_code_s, correlation_id_s from bpd_winning_transaction.bpd_winning_transaction master where master.enabled_b = true and master.elab_ranking_b = false
                                                                                                                                                                                                                                                                                                    and (master.operation_type_c!=''01'' or (master.operation_type_c=''01'' and (
                                                  ((nullif(master.correlation_id_s,'''') is not null)
                                                      and exists (select * from bpd_winning_transaction.bpd_winning_transaction bin where bin.operation_type_c!=''01'' and master.hpan_s=bin.hpan_s and master.correlation_id_s=bin.correlation_id_s and master.acquirer_c=bin.acquirer_c and master.acquirer_id_s=bin.acquirer_id_s and bin.enabled_b=true and master.award_period_id_n=bin.award_period_id_n))
                                                  or
                                                  ((nullif(master.correlation_id_s,'''') is null)
                                                      and exists (select * from bpd_winning_transaction.bpd_winning_transaction bin  where bin.operation_type_c!=''01'' and master.hpan_s = bin.hpan_s and master.amount_i =bin.amount_i and master.merchant_id_s =bin.merchant_id_s and master.terminal_id_s =bin.terminal_id_s and master.acquirer_c=bin.acquirer_c and master.acquirer_id_s=bin.acquirer_id_s and bin.enabled_b=true and master.award_period_id_n=bin.award_period_id_n))
                                              )
                                              )
                                              )') AS wt(id_trx_acquirer_s varchar,trx_timestamp_t timestamptz,acquirer_c varchar, acquirer_id_s varchar, operation_type_c varchar,award_period_id_n bigint, hpan_s varchar, score_n numeric, amount_i numeric, insert_date_t timestamptz, update_date_t timestamptz, fiscal_code_s varchar, correlation_id_s varchar) on wt.fiscal_code_s=bc.fiscal_code_s
    where bc.enabled_b =true;

    /**
     * trx_daily calculate the cashback accumulated by citizens
     * grouped by fiscal_code and award period
     */
    WITH trx_daily as (
        SELECT
            bc.fiscal_code_s as fiscal_code
             ,sum(wt.score_n) AS cashback
             ,wt.award_period_id_n as award_period
             ,max(wt.insert_date_t) as max_trx_insert
             ,count(1) filter(where wt.score_n >= 0 and wt.operation_type_c!='01') as trx_acquisto
             ,count(1) filter(where wt.score_n <= 0 and wt.operation_type_c='01'  and (nullif(correlation_id_s,'''') is null or (select count(1) as conteggio from bpd_winning_transaction.bpd_winning_transaction tmp where tmp.operation_type_c!='01' and tmp.correlation_id_s=wt.correlation_id_s and tmp.acquirer_id_s =wt.acquirer_id_s and tmp.amount_i=wt.amount_i and tmp.hpan_s=wt.hpan_s and tmp.award_period_id_n=wt.award_period_id_n)>0)) as storni
        FROM bpd_citizen.bpd_citizen bc
                 INNER JOIN bpd_citizen.bpd_elab_transaction_temp wt ON wt.fiscal_code_s = bc.fiscal_code_s
                 INNER JOIN public.dblink('bpd_award_period_remote','SELECT award_period_id_n, aw_period_start_d, aw_period_end_d, aw_grace_period_n, ranking_min_n FROM bpd_award_period.bpd_award_period') AS ap(award_period_id_n bigint, aw_period_start_d date, aw_period_end_d date, aw_grace_period_n smallint, ranking_min_n numeric) ON ap.award_period_id_n = wt.award_period_id_n
        where bc.enabled_b = true
        GROUP BY bc.fiscal_code_s, wt.award_period_id_n, ap.ranking_min_n
    )


        /**
         * the bpd_citizen_ranking table is updated with the new calculated scores
         */
    INSERT INTO bpd_citizen.bpd_citizen_ranking (
                                                 fiscal_code_c
                                                ,transaction_n
                                                ,cashback_n
                                                ,award_period_id_n
                                                ,insert_date_t
                                                ,insert_user_s
                                                ,ranking_date_t
    )
    SELECT trx_dly.fiscal_code
         ,trx_dly.trx_acquisto - trx_dly.storni as transazioni
         ,trx_dly.cashback AS cashback
         ,trx_dly.award_period
         ,CURRENT_TIMESTAMP AS insert_date_t
         ,'update_bpd_citizen_ranking' AS insert_user_s
         ,trx_dly.max_trx_insert as ranking_date_t
    FROM trx_daily trx_dly ON conflict(fiscal_code_c, award_period_id_n) DO
        UPDATE
        SET cashback_n = bpd_citizen.bpd_citizen_ranking.cashback_n + excluded.cashback_n
          ,transaction_n = bpd_citizen.bpd_citizen_ranking.transaction_n + excluded.transaction_n
          ,update_date_t = CURRENT_TIMESTAMP
          ,update_user_s = 'update_bpd_citizen_ranking'
          ,ranking_date_t= excluded.ranking_date_t
          ,enabled_b= true;

    for aw_period in
        SELECT *
        FROM public.dblink('bpd_award_period_remote','SELECT award_period_id_n, aw_period_start_d, aw_period_end_d, aw_grace_period_n, ranking_min_n FROM bpd_award_period.bpd_award_period WHERE CURRENT_DATE between aw_period_start_d and aw_period_end_d + aw_grace_period_n') AS ap(award_period_id_n bigint, aw_period_start_d date, aw_period_end_d date, aw_grace_period_n smallint, ranking_min_n numeric)
        loop
            UPDATE  bpd_citizen.bpd_citizen_ranking cr
            SET    ranking_n = sub.rn,
                   ranking_min_n = sub.ranking_min_n,
                   max_cashback_n = sub.period_cashback_max_n
            FROM  (SELECT tmp.fiscal_code_c, tmp.award_period_id_n, tmp.transaction_n, tmp.ranking_min_n, tmp.period_cashback_max_n, row_number() over(order by 1) AS rn
                   from (
                            SELECT bcr.fiscal_code_c, bcr.award_period_id_n, bcr.transaction_n, ap.ranking_min_n, ap.period_cashback_max_n
                            FROM bpd_citizen.bpd_citizen_ranking bcr
                                     inner join bpd_citizen.bpd_citizen bc on bcr.fiscal_code_c = bc.fiscal_code_s
                                     inner join public.dblink('bpd_award_period_remote',format('SELECT award_period_id_n, ranking_min_n, period_cashback_max_n FROM bpd_award_period.bpd_award_period WHERE award_period_id_n= %L',aw_period.award_period_id_n)) AS ap(award_period_id_n bigint, ranking_min_n numeric, period_cashback_max_n numeric) on bcr.award_period_id_n = ap.award_period_id_n
                            WHERE bcr.award_period_id_n = aw_period.award_period_id_n
                              and bc.enabled_b = true
                            ORDER BY transaction_n desc, fiscal_code_c asc) as tmp) sub
            WHERE sub.fiscal_code_c = cr.fiscal_code_c
              and sub.award_period_id_n = cr.award_period_id_n;

            /*
             * update bpd_ranking_ext
             */
            PERFORM bpd_citizen.update_bpd_ranking_ext(aw_period.award_period_id_n, aw_period.ranking_min_n);
        end loop;

    /*
     * update winning transaction
     */
    update bpd_winning_transaction.bpd_winning_transaction wt
    set elab_ranking_b = true
    from (select id_trx_acquirer_s, trx_timestamp_t, acquirer_c,acquirer_id_s,operation_type_c
          from bpd_citizen.bpd_elab_transaction_temp) elab
    where wt.id_trx_acquirer_s=elab.id_trx_acquirer_s
      and wt.trx_timestamp_t=elab.trx_timestamp_t
      and wt.acquirer_c=elab.acquirer_c
      and wt.acquirer_id_s=elab.acquirer_id_s
      and wt.operation_type_c=elab.operation_type_c;

    truncate table bpd_citizen.bpd_elab_transaction_temp;

    UPDATE bpd_citizen.redis_cache_config
    SET update_ranking=true, update_ranking_from=start_procedure;

END;
$$;


--
-- Name: update_bpd_citizen_ranking_tmp_new(); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.update_bpd_citizen_ranking_tmp_new() RETURNS TABLE(fiscal_code_out character varying, payoff_instr_out character varying, aw_period_out bigint, ranking_out numeric, amount_out numeric, aw_period_start_out date, aw_period_end_out date)
    LANGUAGE plpgsql
AS $$
declare
    aw_period record;
begin

    insert into bpd_citizen.bpd_elab_transaction_temp(
        id_trx_acquirer_s,
        trx_timestamp_t,
        acquirer_c,
        acquirer_id_s,
        operation_type_c,
        award_period_id_n,
        hpan_s,
        score_n,
        amount_i,
        insert_date_t,
        update_date_t,
        fiscal_code_s,
        correlation_id_s
    )
    select wt.id_trx_acquirer_s,
           wt.trx_timestamp_t,
           wt.acquirer_c,
           wt.acquirer_id_s,
           wt.operation_type_c,
           wt.award_period_id_n,
           wt.hpan_s,
           wt.score_n,
           wt.amount_i,
           wt.insert_date_t,
           wt.update_date_t,
           wt.fiscal_code_s,
           wt.correlation_id_s
    from bpd_citizen.bpd_citizen bc
             inner join public.dblink('bpd_winning_transaction_remote',
                                      'select id_trx_acquirer_s,trx_timestamp_t,acquirer_c,acquirer_id_s,operation_type_c,award_period_id_n, hpan_s, score_n, amount_i, insert_date_t, update_date_t, fiscal_code_s, correlation_id_s
                                       from bpd_winning_transaction.bpd_winning_transaction_tmp_new master
                                       where master.enabled_b is true
                                         and master.elab_ranking_b is not true
                                         and award_period_id_n = 2
                                         and master.operation_type_c!=''01''
                                       union
                                       select id_trx_acquirer_s,trx_timestamp_t,acquirer_c,acquirer_id_s,operation_type_c,award_period_id_n, hpan_s, score_n, amount_i, insert_date_t, update_date_t, fiscal_code_s, correlation_id_s
                                       from bpd_winning_transaction.bpd_winning_transaction_tmp_new master
                                       where master.enabled_b is true
                                         and master.elab_ranking_b is not true
                                         and award_period_id_n = 2
                                         and master.operation_type_c=''01''
                                         and nullif(master.correlation_id_s,'''') is not null
                                         and exists (select 1 from bpd_winning_transaction.bpd_winning_transaction bin
                                                     where bin.operation_type_c!=''01''
                                                       and master.correlation_id_s = bin.correlation_id_s
                                                       and master.hpan_s=bin.hpan_s
                                                       and master.acquirer_c=bin.acquirer_c
                                                       and master.acquirer_id_s=bin.acquirer_id_s
                                                       and bin.enabled_b is true
                                                       and master.award_period_id_n=bin.award_period_id_n
                                                       and master.fiscal_code_s=bin.fiscal_code_s)
                                       union
                                       select id_trx_acquirer_s,trx_timestamp_t,acquirer_c,acquirer_id_s,operation_type_c,award_period_id_n, hpan_s, score_n, amount_i, insert_date_t, update_date_t, fiscal_code_s, correlation_id_s
                                       from bpd_winning_transaction.bpd_winning_transaction_tmp_new master
                                       where master.enabled_b is true
                                         and master.elab_ranking_b is not true
                                         and award_period_id_n = 2
                                         and master.operation_type_c=''01''
                                         and nullif(master.correlation_id_s,'''') is null
                                         and exists (select 1 from bpd_winning_transaction.bpd_winning_transaction bin
                                                     where bin.operation_type_c!=''01''
                                                       and master.hpan_s = bin.hpan_s
                                                       and master.amount_i =bin.amount_i
                                                       and master.merchant_id_s =bin.merchant_id_s
                                                       and master.terminal_id_s =bin.terminal_id_s
                                                       and master.acquirer_c=bin.acquirer_c
                                                       and master.acquirer_id_s=bin.acquirer_id_s
                                                       and bin.enabled_b is true
                                                       and master.award_period_id_n=bin.award_period_id_n
                                                       and master.fiscal_code_s=bin.fiscal_code_s)')
        AS wt(id_trx_acquirer_s varchar,trx_timestamp_t timestamptz,acquirer_c varchar, acquirer_id_s varchar, operation_type_c varchar,award_period_id_n bigint, hpan_s varchar, score_n numeric, amount_i numeric, insert_date_t timestamptz, update_date_t timestamptz, fiscal_code_s varchar, correlation_id_s varchar) on wt.fiscal_code_s=bc.fiscal_code_s
    where bc.enabled_b =true;

    /**
     * trx_daily calculate the cashback accumulated by citizens
     * grouped by fiscal_code and award period
     */
    WITH trx_daily as (
        SELECT
            bc.fiscal_code_s as fiscal_code
             ,sum(wt.score_n) AS cashback
             ,wt.award_period_id_n as award_period
             ,max(wt.insert_date_t) as max_trx_insert
             ,count(1) filter(where wt.score_n >= 0 and wt.operation_type_c!='01') as trx_acquisto
             ,count(1) filter(where wt.score_n <= 0 and wt.operation_type_c='01' and (nullif(correlation_id_s,'''') is null or (select count(1) as conteggio from bpd_winning_transaction.bpd_winning_transaction tmp where tmp.operation_type_c!='01' and tmp.correlation_id_s=wt.correlation_id_s and tmp.acquirer_id_s =wt.acquirer_id_s and tmp.amount_i=wt.amount_i and tmp.hpan_s=wt.hpan_s and tmp.award_period_id_n=wt.award_period_id_n and tmp.fiscal_code_s=wt.fiscal_code_s)>0)) as storni
        FROM bpd_citizen.bpd_citizen bc
                 INNER JOIN bpd_citizen.bpd_elab_transaction_temp wt ON wt.fiscal_code_s = bc.fiscal_code_s
                 INNER JOIN public.dblink('bpd_award_period_remote','SELECT award_period_id_n, aw_period_start_d, aw_period_end_d, aw_grace_period_n, ranking_min_n FROM bpd_award_period.bpd_award_period') AS ap(award_period_id_n bigint, aw_period_start_d date, aw_period_end_d date, aw_grace_period_n smallint, ranking_min_n numeric) ON ap.award_period_id_n = wt.award_period_id_n
        where bc.enabled_b = true
        GROUP BY bc.fiscal_code_s, wt.award_period_id_n, ap.ranking_min_n
    )


        /**
         * the bpd_citizen_ranking table is updated with the new calculated scores
         */
    INSERT INTO bpd_citizen.bpd_citizen_ranking (
                                                 fiscal_code_c
                                                ,transaction_n
                                                ,cashback_n
                                                ,award_period_id_n
                                                ,insert_date_t
                                                ,insert_user_s
                                                ,ranking_date_t
    )
    SELECT trx_dly.fiscal_code
         ,trx_dly.trx_acquisto - trx_dly.storni as transazioni
         ,trx_dly.cashback AS cashback
         ,trx_dly.award_period
         ,CURRENT_TIMESTAMP AS insert_date_t
         ,'update_bpd_citizen_ranking' AS insert_user_s
         ,trx_dly.max_trx_insert as ranking_date_t
    FROM trx_daily trx_dly ON conflict(fiscal_code_c, award_period_id_n) DO
        UPDATE
        SET cashback_n = bpd_citizen.bpd_citizen_ranking.cashback_n + excluded.cashback_n
          ,transaction_n = bpd_citizen.bpd_citizen_ranking.transaction_n + excluded.transaction_n
          ,update_date_t = CURRENT_TIMESTAMP
          ,update_user_s = 'update_bpd_citizen_ranking'
          ,ranking_date_t= excluded.ranking_date_t
          ,enabled_b= true;

    for aw_period in
        SELECT *
        FROM public.dblink('bpd_award_period_remote','SELECT award_period_id_n, aw_period_start_d, aw_period_end_d, aw_grace_period_n, ranking_min_n FROM bpd_award_period.bpd_award_period WHERE CURRENT_DATE between aw_period_start_d and aw_period_end_d + aw_grace_period_n') AS ap(award_period_id_n bigint, aw_period_start_d date, aw_period_end_d date, aw_grace_period_n smallint, ranking_min_n numeric)
        loop
            UPDATE  bpd_citizen.bpd_citizen_ranking cr
            SET    ranking_n = sub.rn,
                   ranking_min_n = sub.ranking_min_n,
                   max_cashback_n = sub.period_cashback_max_n
            FROM  (SELECT tmp.fiscal_code_c, tmp.award_period_id_n, tmp.transaction_n, tmp.ranking_min_n, tmp.period_cashback_max_n, row_number() over(order by 1) AS rn
                   from (
                            SELECT bcr.fiscal_code_c, bcr.award_period_id_n, bcr.transaction_n, ap.ranking_min_n, ap.period_cashback_max_n
                            FROM bpd_citizen.bpd_citizen_ranking bcr
                                     inner join bpd_citizen.bpd_citizen bc on bcr.fiscal_code_c = bc.fiscal_code_s
                                     inner join public.dblink('bpd_award_period_remote',format('SELECT award_period_id_n, ranking_min_n, period_cashback_max_n FROM bpd_award_period.bpd_award_period WHERE award_period_id_n= %L',aw_period.award_period_id_n)) AS ap(award_period_id_n bigint, ranking_min_n numeric, period_cashback_max_n numeric) on bcr.award_period_id_n = ap.award_period_id_n
                            WHERE bcr.award_period_id_n = aw_period.award_period_id_n
                              and bc.enabled_b = true
                            ORDER BY transaction_n desc, fiscal_code_c asc) as tmp) sub
            WHERE sub.fiscal_code_c = cr.fiscal_code_c
              and sub.award_period_id_n = cr.award_period_id_n;

            /*
             * update bpd_ranking_ext
             */
            PERFORM bpd_citizen.update_bpd_ranking_ext(aw_period.award_period_id_n, aw_period.ranking_min_n);
        end loop;

    /*
     * update winning transaction
     */
    update bpd_winning_transaction.bpd_winning_transaction wt
    set elab_ranking_b = true
    from (select id_trx_acquirer_s, trx_timestamp_t, acquirer_c,acquirer_id_s,operation_type_c
          from bpd_citizen.bpd_elab_transaction_temp) elab
    where wt.id_trx_acquirer_s=elab.id_trx_acquirer_s
      and wt.trx_timestamp_t=elab.trx_timestamp_t
      and wt.acquirer_c=elab.acquirer_c
      and wt.acquirer_id_s=elab.acquirer_id_s
      and wt.operation_type_c=elab.operation_type_c;

    delete from bpd_winning_transaction.bpd_winning_transaction_tmp_new wt
    where CONCAT(wt.id_trx_acquirer_s,wt.trx_timestamp_t,wt.acquirer_c,wt.acquirer_id_s,wt.operation_type_c)
              in (select CONCAT(id_trx_acquirer_s, trx_timestamp_t, acquirer_c,acquirer_id_s,operation_type_c)
                  from bpd_citizen.bpd_elab_transaction_temp);

    truncate table bpd_citizen.bpd_elab_transaction_temp;


END;
$$;


--
-- Name: update_bpd_ranking_ext(bigint, numeric); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.update_bpd_ranking_ext(bigint, numeric) RETURNS void
    LANGUAGE plpgsql
AS $_$
BEGIN

    UPDATE bpd_citizen.bpd_ranking_ext
    SET
        max_transaction_n=subquery.maxTrxNumber,
        min_transaction_n=subquery.minTrxNumber
    FROM (
             select
                 coalesce(max(transaction_n), 0) as maxTrxNumber,
                 coalesce(min(transaction_n) filter (where ranking_n = $2), 0) as minTrxNumber
             from bpd_citizen.bpd_citizen_ranking bcr
             where bcr.enabled_b = true
               and bcr.award_period_id_n = $1
         ) AS subquery
    WHERE award_period_id_n=$1;


    UPDATE bpd_citizen.bpd_ranking_ext
    SET
        total_participants=subquery.total_participants
    FROM (
             select count(1) as total_participants
             from bpd_citizen.bpd_citizen bc
             where enabled_b = true
         ) AS subquery
    WHERE award_period_id_n=$1;

END;
$_$;


--
-- Name: update_ranking_with_milestone(integer, integer); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.update_ranking_with_milestone(in_offset integer, in_limit integer) RETURNS integer
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
                select 	bc.fiscal_code_s,
                          bcr.cashback_n,
                          bcr.transaction_n
                from bpd_citizen.bpd_citizen bc
                         inner join bpd_citizen.bpd_citizen_ranking bcr on
                        bc.fiscal_code_s = bcr.fiscal_code_c
                where bc.enabled_b is true
                  and bcr.award_period_id_n = aw_period.in_award_period
                  and (bcr.id_trx_pivot is null or bcr.cashback_norm_pivot is null or bcr.id_trx_min_transaction_number is null)
                order by bc.fiscal_code_s
                offset in_offset
                    limit in_limit

                LOOP
                    _id_trx_pivot = null;
                    _cashback_norm_pivot = null;
                    _id_trx_min_transaction_number = null;

                    --increment number of elaborated citizen
                    IF (_fiscal_code is not null) THEN
                        _citizen_counter = _citizen_counter + 1;
                        --RAISE NOTICE 'CF(%) - % - %', _fiscal_code, current_timestamp, _citizen_counter;
                    END IF;

                    select wt.id_trx_pivot, wt.cashback_norm_pivot, wt.id_trx_min_transaction_number
                    into _id_trx_pivot, _cashback_norm_pivot, _id_trx_min_transaction_number
                    from public.dblink('bpd_winning_transaction_remote',
                                       format('SELECT id_trx_pivot, cashback_norm_pivot, id_trx_min_transaction_number
					from bpd_winning_transaction.find_citizen_milestones(%L,%L,%L,%L)', _fiscal_code::varchar,aw_period.in_award_period::integer,aw_period._period_cashback_max_n::numeric,aw_period._trx_volume_min_n::integer))
                             AS wt(id_trx_pivot varchar, cashback_norm_pivot numeric, id_trx_min_transaction_number varchar);

                    --performe update based on fiscalCode on citizen_ranking
                    update bpd_citizen.bpd_citizen_ranking
                    set id_trx_pivot = _id_trx_pivot,
                        cashback_norm_pivot = _cashback_norm_pivot,
                        id_trx_min_transaction_number = _id_trx_min_transaction_number,
                        update_date_t = CURRENT_TIMESTAMP,
                        update_user_s = 'update_ranking_with_milestone'
                    where fiscal_code_c = _fiscal_code
                      and award_period_id_n = aw_period.in_award_period;

                END LOOP;
        END LOOP;

    RETURN _citizen_counter;

END;
$$;


--
-- Name: update_ranking_with_milestone(integer, integer, timestamp with time zone); Type: FUNCTION; Schema: bpd_citizen; Owner: -
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

begin

    FOR aw_period
        IN
        select
            ap.award_period_id_n as in_award_period,
            ap.trx_volume_min_n AS _trx_volume_min_n,
            ap.period_cashback_max_n AS _period_cashback_max_n
        from public.dblink('bpd_award_period_remote',
                           'SELECT award_period_id_n, trx_volume_min_n, period_cashback_max_n
                            FROM bpd_award_period.bpd_award_period
                            where award_period_id_n = 2')
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
                  and (bcr.id_trx_pivot is null
                    or bcr.cashback_norm_pivot is null
                    or bcr.id_trx_min_transaction_number is null)
                  and (bcr.cashback_n >= aw_period._period_cashback_max_n
                    or bcr.transaction_n >= aw_period._trx_volume_min_n)
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


--
-- Name: update_ranking_with_milestone_new(integer, integer, timestamp with time zone); Type: FUNCTION; Schema: bpd_citizen; Owner: -
--

CREATE FUNCTION bpd_citizen.update_ranking_with_milestone_new(in_offset integer, in_limit integer, in_now_timestamp timestamp with time zone) RETURNS integer
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

begin

    FOR aw_period
        IN
        select
            ap.award_period_id_n as in_award_period,
            ap.trx_volume_min_n AS _trx_volume_min_n,
            ap.period_cashback_max_n AS _period_cashback_max_n
        from public.dblink('bpd_award_period_remote',
                           'SELECT award_period_id_n, trx_volume_min_n, period_cashback_max_n
                            FROM bpd_award_period.bpd_award_period
                            where award_period_id_n = 2')
                 AS ap(award_period_id_n bigint, trx_volume_min_n int2, period_cashback_max_n numeric)
        LOOP

            FOR _fiscal_code, _total_cashback, _total_transactions IN
                select 	bc.fiscal_code_s,
                          bcr.cashback_n,
                          bcr.transaction_n
                from bpd_citizen.bpd_citizen bc
                         inner join bpd_citizen.bpd_citizen_ranking_new bcr on
                        bc.fiscal_code_s = bcr.fiscal_code_c
                where bc.enabled_b is true
                  and bcr.award_period_id_n = aw_period.in_award_period
                  and (bcr.id_trx_pivot is null or bcr.cashback_norm_pivot is null or bcr.id_trx_min_transaction_number is null)
                  and (bcr.cashback_n >= aw_period._period_cashback_max_n or bcr.transaction_n >= aw_period._trx_volume_min_n)
                  and bcr.update_date_t < in_now_timestamp
                order by bc.fiscal_code_s
                offset in_offset
                    limit in_limit
                    for update skip locked

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
                    from bpd_winning_transaction.find_citizen_milestones_new(_fiscal_code::varchar, aw_period.in_award_period::integer, aw_period._period_cashback_max_n::numeric, aw_period._trx_volume_min_n::integer) AS wt;

                    --performe update based on fiscalCode on citizen_ranking
                    update bpd_citizen.bpd_citizen_ranking_new
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


--
-- Name: insert_bpd_payment_instrument_history(); Type: FUNCTION; Schema: bpd_payment_instrument; Owner: -
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


--
-- Name: update_bpd_payment_instrument_history(); Type: FUNCTION; Schema: bpd_payment_instrument; Owner: -
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


--
-- Name: find_citizen_milestones(character varying, integer, numeric, integer); Type: FUNCTION; Schema: bpd_winning_transaction; Owner: -
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
        order by trx_timestamp_t asc

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


--
-- Name: find_citizen_milestones_new(character varying, integer, numeric, integer); Type: FUNCTION; Schema: bpd_winning_transaction; Owner: -
--

CREATE FUNCTION bpd_winning_transaction.find_citizen_milestones_new(in_fiscal_code character varying, in_award_period integer, in_max_cashback_period numeric, in_trx_volume_min_n integer) RETURNS TABLE(id_trx_pivot character varying, cashback_norm_pivot numeric, id_trx_min_transaction_number character varying)
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
          and bwt.elab_ranking_new_b is true
        order by trx_timestamp_t asc

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


--
-- Name: get_citizen_transactions(text, bigint, text); Type: FUNCTION; Schema: bpd_winning_transaction; Owner: -
--

CREATE FUNCTION bpd_winning_transaction.get_citizen_transactions(in_fiscal_code text, in_award_period bigint, in_hpan text DEFAULT NULL::text) RETURNS TABLE(id_trx_acquirer_s character varying, acquirer_c character varying, trx_timestamp_t timestamp with time zone, hpan_s character varying, operation_type_c character varying, circuit_type_c character varying, id_trx_issuer_s character varying, correlation_id_s character varying, amount_i numeric, amount_currency_c character varying, mcc_c character varying, mcc_descr_s character varying, score_n numeric, award_period_id_n bigint, acquirer_id_s character varying, merchant_id_s character varying, bin_s character varying, terminal_id_s character varying, enabled_b boolean, insert_date_t timestamp with time zone, insert_user_s character varying, update_date_t timestamp with time zone, update_user_s character varying, fiscal_code_s character varying)
    LANGUAGE plpgsql
AS $$
BEGIN
    return query
        select bwt.id_trx_acquirer_s
             ,bwt.acquirer_c
             ,bwt.trx_timestamp_t
             ,bwt.hpan_s
             ,bwt.operation_type_c
             ,bwt.circuit_type_c
             ,bwt.id_trx_issuer_s
             ,bwt.correlation_id_s
             ,bwt.amount_i
             ,bwt.amount_currency_c
             ,bwt.mcc_c
             ,bwt.mcc_descr_s
             ,bwt.score_n
             ,bwt.award_period_id_n
             ,bwt.acquirer_id_s
             ,bwt.merchant_id_s
             ,bwt.bin_s
             ,bwt.terminal_id_s
             ,bwt.enabled_b
             ,bwt.insert_date_t
             ,bwt.insert_user_s
             ,bwt.update_date_t
             ,bwt.update_user_s
             ,bwt.fiscal_code_s
        from bpd_winning_transaction.bpd_winning_transaction bwt
        where bwt.fiscal_code_s = in_fiscal_code and bwt.award_period_id_n = in_award_period
          and bwt.enabled_b
          and (in_hpan is null or in_hpan=bwt.hpan_s )
          and bwt.elab_ranking_b = true;

END;
$$;


--
-- Name: insert_transfer_bpd_winning_transaction_into_new_trg_func(); Type: FUNCTION; Schema: bpd_winning_transaction; Owner: -
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


--
-- Name: datapreparation20210625(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datapreparation20210625() RETURNS text
    LANGUAGE plpgsql
AS $$
declare
    cur_cf_ranking refcursor;
    cur_cf refcursor;
    record_bpd_citizen_rank record;
    fiscalCode_c varchar;
    fiscalCode_cp varchar;
    countervar int := 0;
    countervar2 int := 0;

begin
    open cur_cf for execute
        'select fiscal_code_s from bpd_citizen.bpd_citizen bc  ';
    open cur_cf_ranking for execute
        'select fiscal_code_c from bpd_citizen.bpd_citizen_ranking_parimerito bcrp   ';
    loop
        countervar = countervar+1;
        fetch cur_cf into fiscalCode_c;
        exit when not found;
        fetch cur_cf_ranking into fiscalCode_cp;
        exit when not found;

        update bpd_citizen.bpd_citizen_ranking_parimerito
        set award_period_id_n = 1,
            fiscal_code_c_2 = fiscalCode_c
        where fiscal_code_c = fiscalCode_cp;
        if (countervar = 50000)  then
            countervar2 = countervar2 + 1;
            raise notice '50000 %', countervar2;
            countervar = 0;
        end if;

    end loop;
    return 'OK';
end;
$$;


--
-- Name: datapreparation20210625_upd(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datapreparation20210625_upd() RETURNS text
    LANGUAGE plpgsql
AS $$
declare
    cur_cf_ranking refcursor;
    cur_cf refcursor;
    record_bpd_citizen_rank record;
    fiscalCode_c varchar;
    fiscalCode_cp varchar;
    fiscalCode_exist varchar;
    countervar int := 0;
    counterinner int := 0;
    counterinner2 int := 0;
    countervar2 int := 0;
    cur_cf_exist CURSOR (mykey varchar)  FOR select * from bpd_citizen.bpd_citizen_ranking_parimerito bcrp where fiscal_code_c = mykey limit 1;
    cur_cf_active CURSOR (mykey varchar) FOR select * from bpd_citizen.bpd_citizen bc where fiscal_code_s = mykey and enabled_b = false limit 1;
begin

    open cur_cf for execute
        'select fiscal_code_s from bpd_citizen.bpd_citizen bc ';
    raise notice 'cur_cf';
    open cur_cf_ranking for execute
        'select fiscal_code_c from bpd_citizen.bpd_citizen_ranking_parimerito bcrp where cashback_n is null ;  ';
    raise notice 'cur_cf_ranking';

    <<outer_loop>>
    loop
        countervar = countervar+1;
        <<inner_loop>>
        loop
            counterinner = counterinner + 1;
            if (counterinner = 50000)  then
                counterinner2 = counterinner2 + 1;
                raise notice 'inner loop 50000 %', counterinner2;
                counterinner = 0;
            end if ;
            fetch cur_cf into fiscalCode_c;
            exit outer_loop when not found;

            open cur_cf_exist(mykey := fiscalCode_c);
            fetch cur_cf_exist into fiscalCode_exist;

            if not found then
                close cur_cf_exist;
                open cur_cf_active(mykey := fiscalCode_c);
                fetch cur_cf_active into fiscalCode_exist;
                close cur_cf_active;
                exit inner_loop when not found;
            else
                close cur_cf_exist;
            end if;

        end loop;
        fetch cur_cf_ranking into fiscalCode_cp;
        exit when not found;

        update bpd_citizen.bpd_citizen_ranking_parimerito
        set --award_period_id_n = 1,
            cashback_n=1,
            fiscal_code_c = fiscalCode_c
        where fiscal_code_c = fiscalCode_cp;

        if (countervar = 50000)  then
            countervar2 = countervar2 + 1;
            raise notice '50000 %', countervar2;
            countervar = 0;
        end if;

    end loop;
    return 'OK';
end;
$$;


--
-- Name: datapreparation20210626(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.datapreparation20210626() RETURNS text
    LANGUAGE plpgsql
AS $$
declare
    cur_cf_ranking refcursor;
    cur_cf refcursor;
    record_bpd_citizen_rank record;
    fiscalCode_c varchar;
    fiscalCode_cp varchar;
    fiscalCode_exist int;
    countervar int := 0;
    counterinner int := 0;
    counterinner2 int := 0;
    countervar2 int := 0;
    cur_cf_exist CURSOR (mykey varchar)  FOR select 1 from bpd_citizen.bpd_citizen_ranking_parimerito bcrp where fiscal_code_c = mykey limit 1;
    cur_cf_active CURSOR (mykey varchar) FOR select 1 from bpd_citizen.bpd_citizen bc where fiscal_code_s = mykey and enabled_b = false limit 1;
begin
    open cur_cf for execute
        'select fiscal_code_s from bpd_citizen.bpd_citizen bc ';
    raise notice 'cur_cf';
    open cur_cf_ranking for execute
        'select fiscal_code_c from bpd_citizen.bpd_citizen_ranking_parimerito bcrp where ranking_n is null ;  ';
    raise notice 'cur_cf_ranking';

    <<outer_loop>>
    loop
        countervar = countervar + 1;
        <<inner_loop>>
        loop
            counterinner = counterinner + 1;
            if (counterinner = 50000)  then
                counterinner2 = counterinner2 + 1;
                raise notice 'inner loop 50000 %', counterinner2;
                counterinner = 0;
            end if ;

            fetch cur_cf into fiscalCode_c;
            exit outer_loop when not found;

            open cur_cf_exist(mykey := fiscalCode_c);
            fetch cur_cf_exist into fiscalCode_exist;

            if not FOUND then
                close cur_cf_exist;
                open cur_cf_active(mykey := fiscalCode_c);
                fetch cur_cf_active into fiscalCode_exist;
                if not FOUND then
                    close cur_cf_active;
                    exit inner_loop;
                else
                    --if substring(fiscalCode_c from 0 for 3) <> ''
                    --raise notice 'fiscalCode_c risulta non valido'
                    --end if;
                    close cur_cf_active;
                end if;
            else
                close cur_cf_exist;
            end if;

        end loop;
        fetch cur_cf_ranking into fiscalCode_cp;
        exit when not FOUND;

        update bpd_citizen.bpd_citizen_ranking_parimerito
        set
            award_period_id_n = 1,
            cashback_n=2,
            fiscal_code_c = fiscalCode_c
        where fiscal_code_c = fiscalCode_cp;

        if (countervar = 50000)  then
            countervar2 = countervar2 + 1;
            raise notice '50000 %', countervar2;
            countervar = 0;
        end if;

    end loop;
    return 'OK';
end;
$$;


--
-- Name: bpd_award_period_remote; Type: SERVER; Schema: -; Owner: -
--

CREATE SERVER bpd_award_period_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'bpd',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
    );


--
-- Name: USER MAPPING BPD_USER SERVER bpd_award_period_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR "BPD_USER" SERVER bpd_award_period_remote;


--
-- Name: bpd_payment_instrument_remote; Type: SERVER; Schema: -; Owner: -
--

CREATE SERVER bpd_payment_instrument_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'bpd',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
    );


--
-- Name: USER MAPPING BPD_USER SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR "BPD_USER" SERVER bpd_payment_instrument_remote;


--
-- Name: USER MAPPING ddsadmin SERVER bpd_payment_instrument_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR ddsadmin SERVER bpd_payment_instrument_remote;


--
-- Name: bpd_winning_transaction_remote; Type: SERVER; Schema: -; Owner: -
--

CREATE SERVER bpd_winning_transaction_remote FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    dbname 'bpd',
    host '${serverName}.postgres.database.azure.com',
    port '5432'
    );


--
-- Name: USER MAPPING BPD_USER SERVER bpd_winning_transaction_remote; Type: USER MAPPING; Schema: -; Owner: -
--

CREATE USER MAPPING FOR "BPD_USER" SERVER bpd_winning_transaction_remote;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bpd_award_period; Type: TABLE; Schema: bpd_award_period; Owner: -
--

CREATE TABLE bpd_award_period.bpd_award_period (
                                                   award_period_id_n bigint NOT NULL,
                                                   aw_period_start_d date NOT NULL,
                                                   aw_period_end_d date NOT NULL,
                                                   aw_grace_period_n smallint NOT NULL,
                                                   insert_date_t timestamp with time zone,
                                                   insert_user_s character varying(40),
                                                   update_date_t timestamp with time zone,
                                                   update_user_s character varying(40),
                                                   enabled_b boolean,
                                                   trx_volume_min_n smallint NOT NULL,
                                                   trx_eval_max_n numeric(7,2) NOT NULL,
                                                   amount_max_n numeric(7,2) NOT NULL,
                                                   ranking_min_n numeric NOT NULL,
                                                   trx_cashback_max_n numeric(6,2) NOT NULL,
                                                   period_cashback_max_n numeric(7,2) NOT NULL,
                                                   cashback_perc_n numeric(5,2) NOT NULL,
                                                   status_period_c character varying(10),
                                                   min_amount_n numeric
);


--
-- Name: bpd_award_period_award_period_id_seq; Type: SEQUENCE; Schema: bpd_award_period; Owner: -
--

CREATE SEQUENCE bpd_award_period.bpd_award_period_award_period_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bpd_award_period_award_period_id_seq; Type: SEQUENCE OWNED BY; Schema: bpd_award_period; Owner: -
--

ALTER SEQUENCE bpd_award_period.bpd_award_period_award_period_id_seq OWNED BY bpd_award_period.bpd_award_period.award_period_id_n;


--
-- Name: bpd_award_period_bck; Type: TABLE; Schema: bpd_award_period; Owner: -
--

CREATE TABLE bpd_award_period.bpd_award_period_bck (
                                                       award_period_id_n bigint,
                                                       aw_period_start_d date,
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
                                                       ranking_min_n smallint,
                                                       trx_cashback_max_n numeric(6,2),
                                                       period_cashback_max_n numeric(7,2),
                                                       cashback_perc_n numeric(5,2),
                                                       status_period_c character varying(10)
);


--
-- Name: bpd_award_bpd_ward_error_id_seq; Type: SEQUENCE; Schema: bpd_citizen; Owner: -
--

CREATE SEQUENCE bpd_citizen.bpd_award_bpd_ward_error_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bpd_award_bpd_ward_id_seq; Type: SEQUENCE; Schema: bpd_citizen; Owner: -
--

CREATE SEQUENCE bpd_citizen.bpd_award_bpd_ward_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bpd_award_winner; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_award_winner (
                                              id_n bigint DEFAULT nextval('bpd_citizen.bpd_award_bpd_ward_id_seq'::regclass) NOT NULL,
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
                                              consap_id_n numeric,
                                              issuer_card_id_s character varying(20)
);


--
-- Name: bpd_award_winner_error; Type: TABLE; Schema: bpd_citizen; Owner: -
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
                                                    id_consap_s character varying,
                                                    id_complaint_s character varying,
                                                    id_pagopa_s character varying,
                                                    fiscal_code_s character varying,
                                                    iban_s character varying,
                                                    name_s character varying,
                                                    surname_s character varying,
                                                    cashback_amount_n numeric,
                                                    period_start_date_s character varying,
                                                    period_end_date_s character varying,
                                                    award_period_id_s character varying,
                                                    technical_count_property_s character varying,
                                                    origin_integration_header_s character varying,
                                                    amount_n numeric,
                                                    jackpot_amount_n numeric
);


--
-- Name: bpd_award_winner_error_notify; Type: TABLE; Schema: bpd_citizen; Owner: -
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


--
-- Name: bpd_citizen; Type: TABLE; Schema: bpd_citizen; Owner: -
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


--
-- Name: bpd_citizen_deleted; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_citizen_deleted (
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
                                                 issuer_card_id_s character varying(20)
);


--
-- Name: bpd_citizen_notenabled; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_citizen_notenabled (
                                                    fiscal_code_s character varying(16),
                                                    cancellation_t timestamp with time zone
);


--
-- Name: bpd_citizen_ranking; Type: TABLE; Schema: bpd_citizen; Owner: -
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


--
-- Name: bpd_citizen_ranking_bck; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_citizen_ranking_bck (
                                                     fiscal_code_c character varying(16),
                                                     award_period_id_n bigint,
                                                     ranking_n bigint,
                                                     insert_date_t timestamp with time zone,
                                                     insert_user_s character varying,
                                                     update_date_t timestamp with time zone,
                                                     update_user_s character varying,
                                                     enabled_b boolean,
                                                     ranking_min_n smallint,
                                                     cashback_n numeric,
                                                     transaction_n bigint,
                                                     ranking_date_t timestamp with time zone,
                                                     max_cashback_n numeric
);


--
-- Name: bpd_citizen_ranking_deleted; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_citizen_ranking_deleted (
                                                         fiscal_code_c character varying(16) NOT NULL,
                                                         award_period_id_n bigint NOT NULL,
                                                         ranking_n bigint,
                                                         insert_date_t timestamp with time zone,
                                                         insert_user_s character varying,
                                                         update_date_t timestamp with time zone,
                                                         update_user_s character varying,
                                                         enabled_b boolean DEFAULT true,
                                                         ranking_min_n numeric,
                                                         cashback_n numeric,
                                                         transaction_n bigint,
                                                         ranking_date_t timestamp with time zone,
                                                         max_cashback_n numeric,
                                                         id_trx_pivot character varying,
                                                         cashback_norm_pivot numeric,
                                                         id_trx_min_transaction_number character varying
);


--
-- Name: bpd_citizen_ranking_id_seq; Type: SEQUENCE; Schema: bpd_citizen; Owner: -
--

CREATE SEQUENCE bpd_citizen.bpd_citizen_ranking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bpd_citizen_ranking_new; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_citizen_ranking_new (
                                                     fiscal_code_c character varying(16) NOT NULL,
                                                     award_period_id_n bigint NOT NULL,
                                                     ranking_n bigint,
                                                     insert_date_t timestamp with time zone,
                                                     insert_user_s character varying,
                                                     update_date_t timestamp with time zone,
                                                     update_user_s character varying,
                                                     enabled_b boolean DEFAULT true,
                                                     ranking_min_n numeric,
                                                     cashback_n numeric,
                                                     transaction_n bigint,
                                                     ranking_date_t timestamp with time zone,
                                                     max_cashback_n numeric,
                                                     id_trx_pivot character varying,
                                                     cashback_norm_pivot numeric,
                                                     id_trx_min_transaction_number character varying
);


--
-- Name: bpd_citizen_ranking_parimerito; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_citizen_ranking_parimerito (
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


--
-- Name: bpd_citizen_ranking_recovery; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_citizen_ranking_recovery (
                                                          fiscal_code_c character varying(16),
                                                          cashback_n numeric,
                                                          transaction_n bigint,
                                                          enabled_b boolean,
                                                          update_date_t timestamp with time zone,
                                                          update_user_s character varying,
                                                          award_period_id_n bigint
);


--
-- Name: bpd_const_ranking; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_const_ranking (
                                               max_value bigint,
                                               min_value bigint,
                                               total_participants bigint
);


--
-- Name: bpd_elab_transaction_temp; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_elab_transaction_temp (
                                                       id_trx_acquirer_s character varying,
                                                       trx_timestamp_t timestamp with time zone,
                                                       acquirer_c character varying,
                                                       operation_type_c character varying,
                                                       award_period_id_n bigint,
                                                       hpan_s character varying,
                                                       score_n numeric,
                                                       amount_i numeric,
                                                       insert_date_t timestamp with time zone,
                                                       update_date_t timestamp with time zone,
                                                       fiscal_code_s character varying,
                                                       correlation_id_s character varying,
                                                       acquirer_id_s character varying
);


--
-- Name: bpd_ranking_ext; Type: TABLE; Schema: bpd_citizen; Owner: -
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


--
-- Name: bpd_ranking_ext_new; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_ranking_ext_new (
                                                 award_period_id_n bigint NOT NULL,
                                                 max_transaction_n bigint,
                                                 min_transaction_n bigint,
                                                 total_participants bigint,
                                                 period_cashback_max_n numeric(7,2),
                                                 ranking_min_n numeric,
                                                 insert_date_t timestamp with time zone,
                                                 insert_user_s character varying,
                                                 update_date_t timestamp with time zone,
                                                 update_user_s character varying
);


--
-- Name: bpd_ranking_processor_lock; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_ranking_processor_lock (
                                                        process_id character varying NOT NULL,
                                                        status character varying DEFAULT 'IDLE'::character varying NOT NULL,
                                                        worker_count smallint DEFAULT 0 NOT NULL,
                                                        update_user character varying,
                                                        update_date timestamp(0) with time zone
);


--
-- Name: bpd_ranking_processor_lock_new; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_ranking_processor_lock_new (
                                                            process_id character varying NOT NULL,
                                                            status character varying DEFAULT 'IDLE'::character varying NOT NULL,
                                                            worker_count smallint DEFAULT 0 NOT NULL,
                                                            update_user character varying,
                                                            update_date timestamp(0) with time zone
);


--
-- Name: bpd_temp_citizen; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_temp_citizen (
    fiscal_code_s character varying(16)
);


--
-- Name: bpd_winning_amount; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.bpd_winning_amount (
                                                ranking_n bigint NOT NULL,
                                                amount_n bigint
);


--
-- Name: redis_cache_config; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.redis_cache_config (
                                                update_ranking boolean NOT NULL,
                                                update_ranking_from timestamp with time zone DEFAULT '1970-01-01 00:00:00+00'::timestamp with time zone NOT NULL
);


--
-- Name: temp_citizen_and_pay; Type: TABLE; Schema: bpd_citizen; Owner: -
--

CREATE TABLE bpd_citizen.temp_citizen_and_pay (
                                                  fiscal_code character varying(16),
                                                  hpan_s character varying(64),
                                                  pan character varying(16)
);


--
-- Name: v_bpd_award_citizen; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
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


--
-- Name: v_bpd_award_citizen_v2; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
--

CREATE VIEW bpd_dashboard_pagopa.v_bpd_award_citizen_v2 AS
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
       baw.technical_account_holder_s AS aw_winn_tech_acc_hold,
       baw.status_s AS aw_winn_status,
       baw.to_notify_b AS aw_winn_to_notify,
       baw.esito_bonifico_s AS aw_winn_esito_bonifico,
       baw.cro_s AS aw_winn_cro,
       baw.data_esecuzione_t AS aw_winn_data_esecuzione,
       baw.result_reason_s AS aw_winn_result_reason,
       baw.consap_id_n AS aw_winn_consap_id,
       baw.ticket_id_n AS aw_winn_ticket_id,
       baw.related_id_n AS aw_winn_related_id,
       baw.issuer_card_id_s AS aw_winn_issuer_card_id,
       bcr.award_period_id_n AS cit_rank_award_period_id,
       bcr.cashback_n AS cit_rank_cashback_n,
       bcr.transaction_n,
       bcr.ranking_n,
       bcr.insert_date_t AS cit_rank_insert_date_t,
       bcr.insert_user_s AS cit_rank_insert_user_s,
       bcr.update_date_t AS cit_rank_update_date_t,
       bcr.update_user_s AS cit_rank_update_user_s,
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


--
-- Name: bpd_payment_instrument; Type: TABLE; Schema: bpd_payment_instrument; Owner: -
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
                                                               hpan_master_s character varying(64),
                                                               par_s character varying(32),
                                                               par_enrollment_t timestamp(0) with time zone,
                                                               par_cancellation_t timestamp(0) with time zone,
                                                               last_tkm_update_t timestamp with time zone
);


--
-- Name: v_bpd_citizen; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
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


--
-- Name: v_bpd_citizen_v2; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
--

CREATE VIEW bpd_dashboard_pagopa.v_bpd_citizen_v2 AS
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
       cit.cancellation_t AS ctz_cancellation_t,
       cit.technical_account_holder_s,
       cit.issuer_card_id_s,
       bpi.enrollment_t,
       bpi.cancellation_t AS pay_istr_cancellation_t,
       bpi.channel_s,
       bpi.hpan_master_s,
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


--
-- Name: bpd_payment_instrument_history; Type: TABLE; Schema: bpd_payment_instrument; Owner: -
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
                                                                       update_user_s character varying(40),
                                                                       par_s character varying(32),
                                                                       par_activation_t timestamp(0) with time zone,
                                                                       par_deactivation_t timestamp(0) with time zone
);


--
-- Name: v_bpd_payment_instrument; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
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


--
-- Name: bpd_winning_transaction; Type: TABLE; Schema: bpd_winning_transaction; Owner: -
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
                                                                 fiscal_code_s character varying,
                                                                 elab_ranking_new_b boolean,
                                                                 elab_ranking_b boolean DEFAULT false,
                                                                 valid_b boolean,
                                                                 hpan_master_s character varying(64),
                                                                 par_s character varying(32)
);


--
-- Name: v_bpd_winning_transaction; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
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
       bwt.elab_ranking_new_b AS elab_ranking_b,
       bwt.insert_date_t AS winn_trans_insert_date_t,
       bwt.insert_user_s AS winn_trans_insert_user_s,
       bwt.update_date_t AS winn_trans_update_date_t,
       bwt.update_user_s AS winn_trans_update_user_s
FROM bpd_winning_transaction.bpd_winning_transaction bwt;


--
-- Name: v_bpd_winning_transaction_v2; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
--

CREATE VIEW bpd_dashboard_pagopa.v_bpd_winning_transaction_v2 AS
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


--
-- Name: v_check_missing_iban; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
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
                LEFT JOIN bpd_citizen.bpd_citizen_ranking_new ranking ON (((bc.fiscal_code_s)::text = (ranking.fiscal_code_c)::text)))
       WHERE ((1 = 1) AND (bc.payoff_instr_s IS NULL) AND (bc.cancellation_t IS NULL) AND (bc.enabled_b = true))
       ORDER BY bc.fiscal_code_s, COALESCE((ranking.award_period_id_n)::character(1), 'N/A'::bpchar)) tabella
GROUP BY tabella.award_period_id_n, tabella.classificazione;


--
-- Name: v_check_missing_iban_detail; Type: VIEW; Schema: bpd_dashboard_pagopa; Owner: -
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
         LEFT JOIN bpd_citizen.bpd_citizen_ranking_new ranking ON (((bc.fiscal_code_s)::text = (ranking.fiscal_code_c)::text)))
WHERE ((1 = 1) AND (bc.payoff_instr_s IS NULL) AND (bc.cancellation_t IS NULL) AND (bc.enabled_b = true))
ORDER BY bc.fiscal_code_s, COALESCE((ranking.award_period_id_n)::character(1), 'N/A'::bpchar);


--
-- Name: bpd_transaction_record; Type: TABLE; Schema: bpd_error_record; Owner: -
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
                                                         exception_message_s character varying(4000),
                                                         origin_request_id_s character varying(4000),
                                                         last_resubmit_date_t timestamp with time zone,
                                                         to_resubmit_b boolean,
                                                         enabled_b boolean,
                                                         citizen_validation_date_t timestamp with time zone
);


--
-- Name: bpd_mcc_category; Type: TABLE; Schema: bpd_mcc_category; Owner: -
--

CREATE TABLE bpd_mcc_category.bpd_mcc_category (
                                                   mcc_category_id_s character varying NOT NULL,
                                                   mcc_category_description_s character varying,
                                                   multiplier_score_d numeric NOT NULL
);


--
-- Name: bpd_mcc_category_rel; Type: TABLE; Schema: bpd_mcc_category; Owner: -
--

CREATE TABLE bpd_mcc_category.bpd_mcc_category_rel (
                                                       mcc_s character varying NOT NULL,
                                                       mcc_category_id_s character varying NOT NULL
);


--
-- Name: bonifica_pm; Type: TABLE; Schema: bpd_payment_instrument; Owner: -
--

CREATE TABLE bpd_payment_instrument.bonifica_pm (
                                                    hpan_s character varying NOT NULL,
                                                    fiscal_code_s character varying NOT NULL,
                                                    cancellation_t timestamp with time zone,
                                                    column1 character varying(1024),
                                                    column2 character varying(1024),
                                                    column3 character varying(1024)
);


--
-- Name: bpd_payment_instrument_history_id_n_seq; Type: SEQUENCE; Schema: bpd_payment_instrument; Owner: -
--

CREATE SEQUENCE bpd_payment_instrument.bpd_payment_instrument_history_id_n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bpd_payment_instrument_history_id_n_seq; Type: SEQUENCE OWNED BY; Schema: bpd_payment_instrument; Owner: -
--

ALTER SEQUENCE bpd_payment_instrument.bpd_payment_instrument_history_id_n_seq OWNED BY bpd_payment_instrument.bpd_payment_instrument_history.id_n;


--
-- Name: bpd_payment_instrument_history_id_seq; Type: SEQUENCE; Schema: bpd_payment_instrument; Owner: -
--

CREATE SEQUENCE bpd_payment_instrument.bpd_payment_instrument_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tmp_payment_instrument; Type: TABLE; Schema: bpd_payment_instrument; Owner: -
--

CREATE TABLE bpd_payment_instrument.tmp_payment_instrument (
                                                               api character varying(1024),
                                                               pan character varying(1024),
                                                               pan2 character varying(1024),
                                                               fiscalcode character varying(1024),
                                                               sdi character varying(1024),
                                                               vatnumber character varying(1024),
                                                               hpan character varying(1024),
                                                               hpan2 character varying(1024),
                                                               merchantid character varying(1024),
                                                               providerid character varying(1024),
                                                               customerparameter character varying(1024),
                                                               customerid character varying(1024)
);


--
-- Name: bpd_payment_instrument; Type: TABLE; Schema: bpd_payment_instrument_tmp; Owner: -
--

CREATE TABLE bpd_payment_instrument_tmp.bpd_payment_instrument (
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
                                                                   hpan_master_s character varying(64),
                                                                   par_s character varying(32)
);


--
-- Name: bpd_citizen_status_data; Type: TABLE; Schema: bpd_winning_transaction; Owner: -
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


--
-- Name: bpd_fiscal_code_performance_tmp; Type: TABLE; Schema: bpd_winning_transaction; Owner: -
--

CREATE TABLE bpd_winning_transaction.bpd_fiscal_code_performance_tmp (
                                                                         fiscal_code_s character varying(16),
                                                                         trx_max numeric,
                                                                         done boolean
);


--
-- Name: bpd_winning_transaction_recovery; Type: TABLE; Schema: bpd_winning_transaction; Owner: -
--

CREATE TABLE bpd_winning_transaction.bpd_winning_transaction_recovery (
                                                                          hpan_s character varying(64),
                                                                          fiscal_code_s character varying,
                                                                          enabled_b boolean,
                                                                          elab_ranking_b boolean,
                                                                          update_date_t timestamp with time zone,
                                                                          update_user_s character varying(40),
                                                                          elab_ranking_new_b boolean
);


--
-- Name: bpd_winning_transaction_transfer; Type: TABLE; Schema: bpd_winning_transaction; Owner: -
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
                                                                          elab_ranking_new_b boolean,
                                                                          elab_ranking_b boolean DEFAULT false NOT NULL,
                                                                          partial_transfer_b boolean,
                                                                          parked_b boolean
);


--
-- Name: select hpan_s, fiscal_code_s  from bpd_payment_instrument.bpd_p; Type: TABLE; Schema: bpd_winning_transaction; Owner: -
--

CREATE TABLE bpd_winning_transaction."select hpan_s, fiscal_code_s
from bpd_payment_instrument.bpd_p" (
                                                                            hpan_s character varying(64) NOT NULL,
                                                                            fiscal_code_s character varying(16) NOT NULL
);


--
-- Name: temp_hpan_nft; Type: TABLE; Schema: bpd_winning_transaction; Owner: -
--

CREATE TABLE bpd_winning_transaction.temp_hpan_nft (
                                                       hpan character varying,
                                                       hpanlist character varying(64)
);


--
-- Name: bpd_winning_transaction; Type: TABLE; Schema: bpd_winning_transaction_tmp; Owner: -
--

CREATE TABLE bpd_winning_transaction_tmp.bpd_winning_transaction (
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
                                                                     fiscal_code_s character varying,
                                                                     elab_ranking_b_old boolean DEFAULT false NOT NULL,
                                                                     elab_ranking_b boolean,
                                                                     valid_b boolean
);


--
-- Name: bpd_winning_transaction_transfer; Type: TABLE; Schema: bpd_winning_transaction_tmp; Owner: -
--

CREATE TABLE bpd_winning_transaction_tmp.bpd_winning_transaction_transfer (
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
                                                                              elab_ranking_b boolean DEFAULT false NOT NULL,
                                                                              elab_ranking_new_b boolean,
                                                                              partial_transfer_b boolean,
                                                                              parked_b boolean
);


--
-- Name: stress_test_runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stress_test_runs (
                                         snap_timestamp timestamp with time zone,
                                         conn_runtime interval,
                                         duration interval,
                                         datid oid,
                                         datname name,
                                         pid integer,
                                         usesysid oid,
                                         usename name,
                                         application_name text,
                                         client_addr inet,
                                         client_hostname text,
                                         client_port integer,
                                         backend_start timestamp with time zone,
                                         xact_start timestamp with time zone,
                                         query_start timestamp with time zone,
                                         state_change timestamp with time zone,
                                         wait_event_type text,
                                         wait_event text,
                                         state text,
                                         backend_xid xid,
                                         backend_xmin xid,
                                         query text,
                                         backend_type text
);


--
-- Name: stress_test_runs_202106101000; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stress_test_runs_202106101000 (
                                                      snap_timestamp timestamp with time zone,
                                                      conn_runtime interval,
                                                      duration interval,
                                                      datid oid,
                                                      datname name,
                                                      pid integer,
                                                      usesysid oid,
                                                      usename name,
                                                      application_name text,
                                                      client_addr inet,
                                                      client_hostname text,
                                                      client_port integer,
                                                      backend_start timestamp with time zone,
                                                      xact_start timestamp with time zone,
                                                      query_start timestamp with time zone,
                                                      state_change timestamp with time zone,
                                                      wait_event_type text,
                                                      wait_event text,
                                                      state text,
                                                      backend_xid xid,
                                                      backend_xmin xid,
                                                      query text,
                                                      backend_type text
);


--
-- Name: test; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test (
                             city_id integer NOT NULL,
                             logdate date NOT NULL,
                             peaktemp integer,
                             unitsales integer
);


--
-- Name: test_temp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_temp (
                                  city_id integer NOT NULL,
                                  logdate date NOT NULL,
                                  peaktemp integer,
                                  unitsales integer
)
    PARTITION BY RANGE (logdate);


--
-- Name: test_y2006m02; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_y2006m02 (
                                      city_id integer NOT NULL,
                                      logdate date NOT NULL,
                                      peaktemp integer,
                                      unitsales integer
);
ALTER TABLE ONLY public.test_temp ATTACH PARTITION public.test_y2006m02 FOR VALUES FROM ('2006-02-01') TO ('2006-03-01');


--
-- Name: test_y2006m03; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_y2006m03 (
                                      city_id integer NOT NULL,
                                      logdate date NOT NULL,
                                      peaktemp integer,
                                      unitsales integer
);
ALTER TABLE ONLY public.test_temp ATTACH PARTITION public.test_y2006m03 FOR VALUES FROM ('2006-03-01') TO ('2006-04-01');


--
-- Name: bpd_award_period award_period_id_n; Type: DEFAULT; Schema: bpd_award_period; Owner: -
--

ALTER TABLE ONLY bpd_award_period.bpd_award_period ALTER COLUMN award_period_id_n SET DEFAULT nextval('bpd_award_period.bpd_award_period_award_period_id_seq'::regclass);


--
-- Name: bpd_payment_instrument_history id_n; Type: DEFAULT; Schema: bpd_payment_instrument; Owner: -
--

ALTER TABLE ONLY bpd_payment_instrument.bpd_payment_instrument_history ALTER COLUMN id_n SET DEFAULT nextval('bpd_payment_instrument.bpd_payment_instrument_history_id_n_seq'::regclass);


--
-- PostgreSQL database dump complete
--

