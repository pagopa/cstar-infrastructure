ALTER TABLE bpd_error_record.bpd_transaction_record 
	alter column exception_message_s Type CHARACTER VARYING(40000) USING exception_message_s::character varying ,
	alter column origin_request_id_s Type CHARACTER VARYING(40000) USING origin_request_id_s::character varying
;