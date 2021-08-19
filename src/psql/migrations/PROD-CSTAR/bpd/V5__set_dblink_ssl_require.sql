ALTER SERVER bpd_award_period_remote
	OPTIONS (set sslmode 'require');

ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (set sslmode 'require');

ALTER SERVER bpd_winning_transaction_remote
	OPTIONS (set sslmode 'require');    