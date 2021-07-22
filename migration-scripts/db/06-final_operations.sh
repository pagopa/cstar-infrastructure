#!/usr/bin/env bash


### UAT
# environment_short="u"
# environment="uat"
# subscription="UAT-CSTAR"

### PROD
# environment_short="p"
# environment="prod"
# subscription="PROD-CSTAR"

### psql dir

cd ".bash .bash src/psql/"

bash flyway.sh info "${subscription}" fa
bash flyway.sh migrate "${subscription}" fa -target=2

bash flyway.sh info "${subscription}" rtd
bash flyway.sh migrate "${subscription}" rtd -target=2

bash flyway.sh info "${subscription}" bpd
bash flyway.sh migrate "${subscription}" bpd -target=2

# this apply will fail
bash terraform.sh apply "${subscription}" -target='postgresql_role.user["BPD_USER"]'

bash terraform.sh import "${subscription}" 'postgresql_role.user["BPD_USER"]' BPD_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["RTD_USER"]' RTD_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["FA_USER"]' FA_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["BPD_AWARD_PERIOD_REMOTE_USER"]' BPD_AWARD_PERIOD_REMOTE_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["BPD_PAYMENT_INSTRUMENT_REMOTE_USER"]' BPD_PAYMENT_INSTRUMENT_REMOTE_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["BPD_WINNING_TRANSACTION_REMOTE_USER"]' BPD_WINNING_TRANSACTION_REMOTE_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["DASHBOARD_PAGOPA_USER"]' DASHBOARD_PAGOPA_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["FA_PAYMENT_INSTRUMENT_REMOTE_USER"]' FA_PAYMENT_INSTRUMENT_REMOTE_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["MONITORING_USER"]' MONITORING_USER
bash terraform.sh import "${subscription}" 'postgresql_role.user["tkm_acquirer_manager"]' tkm_acquirer_manager
# bash terraform.sh plan "${subscription}"
# bash terraform.sh apply "${subscription}"
