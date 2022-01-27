--
-- ALTER Table: fa_merchant - Schema: fa_merchant - owner: ddsadmin
--

ALTER TABLE fa_merchant.fa_merchant ADD COLUMN status_s VARCHAR NOT NULL;
ALTER TABLE fa_merchant.fa_merchant ADD COLUMN cancellation_t timestamp with time zone;

ALTER TABLE fa_merchant.fa_merchant DROP COLUMN IF EXISTS provider_id;

--
-- ALTER Table: fa_merchant_shop - Schema: fa_merchant - owner: ddsadmin
--

ALTER TABLE fa_merchant.fa_merchant_shop ADD COLUMN company_name_s VARCHAR NOT NULL;
ALTER TABLE fa_merchant.fa_merchant_shop ADD COLUMN company_address_s VARCHAR NOT NULL;
ALTER TABLE fa_merchant.fa_merchant_shop ADD COLUMN contact_person_name_s VARCHAR NOT NULL;
ALTER TABLE fa_merchant.fa_merchant_shop ADD COLUMN contact_person_surname_s VARCHAR NOT NULL;
ALTER TABLE fa_merchant.fa_merchant_shop ADD COLUMN contact_person_email_s VARCHAR;
ALTER TABLE fa_merchant.fa_merchant_shop ADD COLUMN contact_person_tel_1_s VARCHAR;

--
-- CREATE Table: fa_register - Schema: fa_merchant - owner: ddsadmin
--

CREATE TABLE fa_merchant.fa_register (
	register_id int8 NOT NULL,
	register_code_s varchar NOT NULL,
	register_auth_token_s varchar NOT NULL,
    insert_date_t timestamp with time zone,
    insert_user_s varchar(40),
    update_date_t timestamp with time zone,
    update_user_s varchar(40),
    enabled_b boolean
);

ALTER TABLE fa_merchant.fa_register OWNER TO ddsadmin;
GRANT ALL ON TABLE fa_merchant.fa_register TO ddsadmin;
GRANT INSERT, UPDATE, DELETE, SELECT ON TABLE fa_merchant.fa_register TO "FA_USER";

--
-- ALTER Table: fa_register - Schema: fa_merchant - owner: ddsadmin
--

ALTER TABLE fa_merchant.fa_register ADD CONSTRAINT pk_register PRIMARY KEY (register_id);

--
-- CREATE Table: fa_merchant_contract - Schema: fa_merchant - owner: ddsadmin
--

CREATE TABLE fa_merchant.fa_merchant_contract (
	contract_id int8 NOT NULL,
	activation_t timestamp with time zone NOT NULL,
	deactivation_t timestamp with time zone,
	provider_id int8 NOT NULL,
	shop_id varchar NOT NULL,
	insert_date_t timestamp with time zone,
	insert_user_s varchar(40),
	update_date_t timestamp with time zone,
	update_user_s varchar(40),
	enabled_b boolean,
	register_id bigserial NOT NULL
);

ALTER TABLE fa_merchant.fa_merchant_contract OWNER TO ddsadmin;
GRANT ALL ON TABLE fa_merchant.fa_merchant_contract TO ddsadmin;
GRANT INSERT, UPDATE, DELETE, SELECT ON TABLE fa_merchant.fa_merchant_contract TO "FA_USER";

--
-- ALTER Table: fa_merchant_contract - Schema: fa_merchant - owner: ddsadmin
--

ALTER TABLE fa_merchant.fa_merchant_contract ADD CONSTRAINT pk_merchant_contract PRIMARY KEY (contract_id);
ALTER TABLE fa_merchant.fa_merchant_contract ADD CONSTRAINT fk_merchant_shop FOREIGN KEY (shop_id) REFERENCES fa_merchant.fa_merchant_shop(merchant_id);
ALTER TABLE fa_merchant.fa_merchant_contract ADD CONSTRAINT fk_register FOREIGN KEY (register_id) REFERENCES fa_merchant.fa_register(register_id);

--
-- SEQUENCE Table: fa_merchant_contract - Schema: fa_merchant - owner: ddsadmin
--

CREATE SEQUENCE fa_merchant.fa_merchant_contract_id_seq
	INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1
    NO CYCLE;

ALTER SEQUENCE fa_merchant.fa_merchant_contract_id_seq OWNER TO ddsadmin;
GRANT ALL ON SEQUENCE fa_merchant.fa_merchant_contract_id_seq TO ddsadmin;
GRANT ALL ON SEQUENCE fa_merchant.fa_merchant_contract_id_seq TO "FA_USER";

ALTER SEQUENCE fa_merchant.fa_merchant_contract_id_seq OWNED BY fa_merchant.fa_merchant_contract.contract_id;

ALTER TABLE ONLY fa_merchant.fa_merchant_contract ALTER COLUMN contract_id SET DEFAULT nextval('fa_merchant.fa_merchant_contract_id_seq'::regclass);

--
-- SEQUENCE Table: fa_register - Schema: fa_merchant - owner: ddsadmin
--

CREATE SEQUENCE fa_merchant.fa_register_id_seq
	INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1
    NO CYCLE;

ALTER SEQUENCE fa_merchant.fa_register_id_seq OWNER TO ddsadmin;
GRANT ALL ON SEQUENCE fa_merchant.fa_register_id_seq TO ddsadmin;
GRANT ALL ON SEQUENCE fa_merchant.fa_register_id_seq TO "FA_USER";

ALTER SEQUENCE fa_merchant.fa_register_id_seq OWNED BY fa_merchant.fa_register.register_id;

ALTER TABLE ONLY fa_merchant.fa_register ALTER COLUMN register_id SET DEFAULT nextval('fa_merchant.fa_register_id_seq'::regclass);

--
-- ALTER Table: fa_transaction_request - Schema: fa_transaction - owner: ddsadmin
--

ALTER TABLE fa_transaction.fa_transaction_request ADD COLUMN contract_id int8 NOT NULL;