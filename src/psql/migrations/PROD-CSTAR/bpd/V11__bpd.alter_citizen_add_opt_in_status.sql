ALTER TABLE bpd_citizen.bpd_citizen ADD COLUMN opt_in_status_s VARCHAR(10);
ALTER TABLE bpd_citizen.bpd_citizen ALTER COLUMN opt_in_status_s SET DEFAULT 'NOREQ';