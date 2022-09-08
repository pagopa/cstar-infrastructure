-- Please note this line will produce a full table scan
ALTER TABLE fa_transaction.fa_transaction_request ADD COLUMN invoice_request_id varchar;

ALTER TABLE fa_transaction.fa_transaction ADD COLUMN invoice_request_id varchar;

-- DROP SEQUENCE fa_transaction.fa_transaction_request_request_id_seq;

CREATE SEQUENCE fa_transaction.fa_transaction_request_invoice_request_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;