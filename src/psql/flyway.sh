#!/usr/bin/env bash

#
# Apply the configuration relative to a given subscription
# Subscription are defined in ./subscription
# Usage:
#  ./flyway.sh info|validate|migrate ENV-CSTAR bpd|rtd
#
#  ./flyway.sh migrate DEV-CSTAR bpd
#  ./flyway.sh migrate UAT-CSTAR bpd
#  ./flyway.sh migrate PROD-CSTAR bpd

BASHDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORKDIR="$BASHDIR"

set -e

COMMAND=$1
SUBSCRIPTION=$2
DATABASE=$3
shift 3
other=$@

if [ -z "${SUBSCRIPTION}" ]; then
    printf "\e[1;31mYou must provide a subscription as first argument.\n"
    exit 1
fi

if [ ! -d "${WORKDIR}/subscriptions/${SUBSCRIPTION}" ]; then
    printf "\e[1;31mYou must provide a subscription for which a variable file is defined. You provided: '%s'.\n" "${SUBSCRIPTION}" > /dev/stderr
    exit 1
fi

az account set -s "${SUBSCRIPTION}"

# shellcheck disable=SC1090
source "${WORKDIR}/subscriptions/${SUBSCRIPTION}/backend.ini"


# shellcheck disable=SC2154
printf "Subscription: %s\n" "${SUBSCRIPTION}"
printf "Resource Group Name: %s\n" "${resource_group_name}"
printf "Storage Account Name: %s\n" "${storage_account_name}"

psql_server_name=$(az postgres server list -o tsv --query "[?contains(name,'postgresql')].{Name:name}" | head -1)
psql_server_private_fqdn=$(az postgres server list -o tsv --query "[?contains(name,'postgresql')].{Name:fullyQualifiedDomainName}" | head -1)
keyvault_name=$(az keyvault list -o tsv --query "[?contains(name,'kv')].{Name:name}")

administrator_login=$(az keyvault secret show --name db-administrator-login --vault-name "${keyvault_name}" -o tsv --query value)
administrator_login_password=$(az keyvault secret show --name db-administrator-login-password --vault-name "${keyvault_name}" -o tsv --query value)

export FLYWAY_URL="jdbc:postgresql://${psql_server_private_fqdn}:5432/${DATABASE}?sslmode=require"
export FLYWAY_USER="${administrator_login}@${psql_server_name}"
export FLYWAY_PASSWORD="${administrator_login_password}"
export SERVER_NAME="${psql_server_name}"
export FLYWAY_DOCKER_TAG="7.11.1-alpine"

bpd_user_password=$(az keyvault secret show --name db-bpd-user-password --vault-name "${keyvault_name}" -o tsv --query value)
rtd_user_password=$(az keyvault secret show --name db-rtd-user-password --vault-name "${keyvault_name}" -o tsv --query value)
fa_user_password=$(az keyvault secret show --name db-fa-user-password --vault-name "${keyvault_name}" -o tsv --query value)
fa_payment_instrument_remote_user_password=$(az keyvault secret show --name db-fa-payment-instrument-remote-user-password --vault-name "${keyvault_name}" -o tsv --query value)
bpd_payment_instrument_remote_user_password=$(az keyvault secret show --name db-bpd-payment-instrument-remote-user-password --vault-name "${keyvault_name}" -o tsv --query value)
bpd_award_period_remote_user_password=$(az keyvault secret show --name db-bpd-award-period-remote-user-password --vault-name "${keyvault_name}" -o tsv --query value)
bpd_winning_transaction_remote_user_password=$(az keyvault secret show --name db-bpd-winning-transaction-remote-user-password --vault-name "${keyvault_name}" -o tsv --query value)
dashboard_pagopa_user_password=$(az keyvault secret show --name db-dashboard-pagopa-user-password --vault-name "${keyvault_name}" -o tsv --query value)
monitoring_user_password=$(az keyvault secret show --name db-monitoring-user-password --vault-name "${keyvault_name}" -o tsv --query value)
tkm_acquirer_manager_user_password=$(az keyvault secret show --name db-tkm-acquirer-manager-password --vault-name "${keyvault_name}" -o tsv --query value)

export BPD_USER_PASSWORD="${bpd_user_password}"
export RTD_USER_PASSWORD="${rtd_user_password}"
export FA_USER_PASSWORD="${fa_user_password}"
export FA_PAYMENT_INSTRUMENT_REMOTE_USER_PASSWORD="${fa_payment_instrument_remote_user_password}"
export BPD_PAYMENT_INSTRUMENT_REMOTE_USER_PASSWORD="${bpd_payment_instrument_remote_user_password}"
export BPD_AWARD_PERIOD_REMOTE_USER_PASSWORD="${bpd_award_period_remote_user_password}"
export BPD_WINNING_TRANSACTION_REMOTE_USER_PASSWORD="${bpd_winning_transaction_remote_user_password}"
export DASHBOARD_PAGOPA_USER_PASSWORD="${dashboard_pagopa_user_password}"
export MONITORING_USER_PASSWORD="${monitoring_user_password}"
export TKM_ACQUIRER_MANAGER_USER_PASSWORD="${tkm_acquirer_manager_user_password}"

docker run --rm -it --network=host -v "${WORKDIR}/migrations/${SUBSCRIPTION}/${DATABASE}":/flyway/sql \
  flyway/flyway:"${FLYWAY_DOCKER_TAG}" \
  -url="${FLYWAY_URL}" -user="${FLYWAY_USER}" -password="${FLYWAY_PASSWORD}" \
  -validateMigrationNaming=true \
  -placeholders.bpdUserPassword="${BPD_USER_PASSWORD}" \
  -placeholders.rtdUserPassword="${RTD_USER_PASSWORD}" \
  -placeholders.faUserPassword="${FA_USER_PASSWORD}" \
  -placeholders.faPaymentInstrumentRemoteUserPassword="${FA_PAYMENT_INSTRUMENT_REMOTE_USER_PASSWORD}" \
  -placeholders.bpdPaymentInstrumentRemoteUserPassword="${BPD_PAYMENT_INSTRUMENT_REMOTE_USER_PASSWORD}" \
  -placeholders.bpdAwardPeriodRemoteUserPassword="${BPD_AWARD_PERIOD_REMOTE_USER_PASSWORD}" \
  -placeholders.bpdWinningTransactionRemoteUserPassword="${BPD_WINNING_TRANSACTION_REMOTE_USER_PASSWORD}" \
  -placeholders.dashboardPagopaUserPassword="${DASHBOARD_PAGOPA_USER_PASSWORD}" \
  -placeholders.monitoringUserPassword="${MONITORING_USER_PASSWORD}" \
  -placeholders.tkmAcquirerManagerUserPassword="${TKM_ACQUIRER_MANAGER_USER_PASSWORD}" \
  -placeholders.serverName="${SERVER_NAME}" "${COMMAND}" ${other}
