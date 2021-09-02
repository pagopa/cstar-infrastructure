ALTER SERVER bpd_award_period_remote
    OPTIONS (ADD sslmode 'require');

ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (ADD sslmode 'require');

ALTER SERVER bpd_winning_transaction_remote
	OPTIONS (ADD sslmode 'require');    