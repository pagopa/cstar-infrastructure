--
-- These grants are not supported by the Postgres Terraform Provider since object_type foreign server
--
GRANT USAGE ON FOREIGN SERVER bpd_winning_transaction_remote TO "BPD_USER";
GRANT "BPD_USER" TO ddsadmin GRANTED BY ddsadmin;
