ALTER SERVER bpd_payment_instrument_remote
	OPTIONS (ADD sslmode 'require');

ALTER SERVER fa_payment_instrument_remote
	OPTIONS (ADD sslmode 'require');
