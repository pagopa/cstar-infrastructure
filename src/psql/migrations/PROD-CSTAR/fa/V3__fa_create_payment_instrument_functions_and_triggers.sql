
CREATE OR REPLACE FUNCTION fa_payment_instrument.insert_fa_payment_instrument_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $$
    BEGIN
        INSERT INTO fa_payment_instrument.fa_payment_instrument_history(hpan_s, activation_t, deactivation_t, fiscal_code_s, insert_date_t, insert_user_s, update_date_t, update_user_s, channel_s, par_s, par_activation_t, par_deactivation_t, vat_number_s)
		VALUES(NEW.hpan_s, NEW.enrollment_t, NULL, NEW.fiscal_code_s, NEW.insert_date_t, NEW.insert_user_s, NEW.update_date_t, NEW.update_user_s, NEW.channel_s, NEW.par_s, NEW.par_enrollment_t, NEW.par_cancellation_t, new.vat_number_s) ON CONFLICT DO NOTHING;
        RETURN NEW;
    END;
$$;

ALTER FUNCTION fa_payment_instrument.insert_fa_payment_instrument_history() OWNER TO "FA_USER";


CREATE OR REPLACE FUNCTION fa_payment_instrument.update_fa_payment_instrument_history()
 RETURNS trigger
 LANGUAGE plpgsql
AS $$
			BEGIN
				UPDATE fa_payment_instrument.fa_payment_instrument_history
				SET deactivation_t=NEW.cancellation_t, update_date_t=NEW.update_date_t, update_user_s=NEW.update_user_s,
				par_activation_t=NEW.par_enrollment_t,par_deactivation_t=NEW.par_cancellation_t,vat_number_s=NEW.vat_number_s
				WHERE hpan_s=NEW.hpan_s AND activation_t=OLD.enrollment_t;
				RETURN NEW;
				EXCEPTION WHEN unique_violation THEN
				RETURN OLD;
			END;
$$;

ALTER FUNCTION fa_payment_instrument.update_fa_payment_instrument_history() OWNER TO "FA_USER";


create trigger update_fa_payment_instrument_history_trg after
update
    of cancellation_t on
    fa_payment_instrument.fa_payment_instrument for each row execute procedure fa_payment_instrument.update_fa_payment_instrument_history();

create trigger insert_update_fa_payment_instrument_history_trg after
update
    of enrollment_t on
    fa_payment_instrument.fa_payment_instrument for each row
    when (((new.enabled_b = true)
        and (new.enabled_b <> old.enabled_b)
            and (old.enrollment_t <> new.enrollment_t))) execute procedure fa_payment_instrument.insert_fa_payment_instrument_history();


create trigger insert_fa_payment_instrument_history_trg after
insert
    on
    fa_payment_instrument.fa_payment_instrument for each row
    when ((new.enabled_b = true)) execute procedure fa_payment_instrument.insert_fa_payment_instrument_history();
