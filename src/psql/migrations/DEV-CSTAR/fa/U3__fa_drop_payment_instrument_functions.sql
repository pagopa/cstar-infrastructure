
DROP FUNCTION IF EXISTS fa_payment_instrument.insert_fa_payment_instrument_history;
DROP FUNCTION IF EXISTS fa_payment_instrument.update_fa_payment_instrument_history;
DROP TRIGGER IF EXISTS update_fa_payment_instrument_history_trg on fa_payment_instrument.fa_payment_instrument;
DROP TRIGGER IF EXISTS insert_update_fa_payment_instrument_history_trg on fa_payment_instrument.fa_payment_instrument;