-- Please note this line will poduce a full table scan
ALTER TABLE fa_payment_instrument.fa_payment_instrument ALTER COLUMN vat_number_s SET NOT NULL;