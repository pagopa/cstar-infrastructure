

-- CUSTOMER

ALTER TABLE ONLY fa_customer.fa_customer_vat
    DROP CONSTRAINT IF EXISTS fa_customer_vat_fk;

ALTER TABLE ONLY fa_customer.fa_customer
    DROP CONSTRAINT IF EXISTS fa_customer_pkey;

ALTER TABLE ONLY fa_customer.fa_customer_vat
    DROP CONSTRAINT IF EXISTS fa_customer_vat_pk;

-- MERCHANT

ALTER TABLE fa_merchant.fa_merchant_contract 
    DROP CONSTRAINT IF EXISTS fk_merchant_shop;

ALTER TABLE fa_merchant.fa_merchant_contract 
    DROP CONSTRAINT IF EXISTS fk_register;

ALTER TABLE ONLY fa_merchant.fa_merchant_shop
    DROP CONSTRAINT IF EXISTS fk_fa_merchant;

ALTER TABLE ONLY fa_merchant.fa_merchant
    DROP CONSTRAINT IF EXISTS pk_fa_merchant;

ALTER TABLE ONLY fa_merchant.fa_merchant_shop
    DROP CONSTRAINT IF EXISTS pk_fa_merchant_vat;

ALTER TABLE fa_merchant.fa_register 
    DROP CONSTRAINT IF EXISTS pk_register;

ALTER TABLE fa_merchant.fa_merchant_contract 
    DROP CONSTRAINT IF EXISTS pk_merchant_contract;

-- PAYMENT INSTRUMENT

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    DROP CONSTRAINT IF EXISTS fa_payment_instrument_history_fk;

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument
    DROP CONSTRAINT IF EXISTS pk_fa_payment_instrument;

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    DROP CONSTRAINT IF EXISTS fa_payment_instrument_history_pk;

ALTER TABLE ONLY fa_payment_instrument.fa_payment_instrument_history
    DROP CONSTRAINT IF EXISTS fa_payment_instrument_history_un;


-- TRANSACTION

ALTER TABLE ONLY fa_transaction.fa_transaction_request
    DROP CONSTRAINT IF EXISTS fa_transaction_request_pk;

ALTER TABLE ONLY fa_transaction.fa_transaction
    DROP CONSTRAINT IF EXISTS pk_fa_transaction;

-- PROVIDER

ALTER TABLE ONLY fa_provider.fa_provider
    DROP CONSTRAINT IF EXISTS pk_fa_provider;

-- ERROR

ALTER TABLE ONLY fa_error_record.fa_transaction_record
    DROP CONSTRAINT IF EXISTS pk_fa_transaction_record;

-- FA_MOCK
ALTER TABLE ONLY fa_mock.mock_provider
	DROP CONSTRAINT IF EXISTS mock_provider_pk;


ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_customer GRANT ALL ON TABLES TO "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_file_storage GRANT ALL ON TABLES TO "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_merchant GRANT ALL ON TABLES TO "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_payment_instrument GRANT ALL ON TABLES TO "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_provider GRANT ALL ON TABLES TO "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA fa_transaction GRANT ALL ON TABLES TO "${adminUser}";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" IN SCHEMA public GRANT ALL ON TABLES TO "${adminUser}";

ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" REVOKE ALL ON SEQUENCES FROM "FA_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" REVOKE ALL ON TYPES FROM "FA_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" REVOKE ALL ON FUNCTIONS FROM "FA_USER";
ALTER DEFAULT PRIVILEGES FOR ROLE "${adminUser}" REVOKE ALL ON TABLES FROM "FA_USER";
