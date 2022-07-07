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
DBMS=$3
DATABASE=$4
shift 4
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
# source "${WORKDIR}/subscriptions/${SUBSCRIPTION}/backend.ini"


# shellcheck disable=SC2154
# printf "Subscription: %s\n" "${SUBSCRIPTION}"
# printf "Resource Group Name: %s\n" "${resource_group_name}"
# retrieve right key vault name to use to get db credentials
source "${WORKDIR}/subscriptions/${SUBSCRIPTION}/keyvault-name"

available_vaults=$(az keyvault list -o tsv --query "[?contains(name,'kv')].{Name:name}")
psql_server_name=${DBMS}

if [[ ! $available_vaults =~ $keyvault_name ]]; then
  echo "${keyvault_name} not exists on azure."
  echo "Please edit keyvault-name file for ${SUBSCRIPTION}"
  echo "These key vaults are available: ${available_vaults}" | tr '\n' ' '
  exit -1
fi

if [[ "$DBMS" =~ "flex" ]]; then
    #psql_server_name=$(az postgres flexible-server list -o tsv --query "[?contains(name,${DBMS})].{Name:name}" | head -1)
    psql_server_private_fqdn=$(az postgres flexible-server list -o tsv --query "[?contains(name,'${DBMS}')].{Name:fullyQualifiedDomainName}" | head -1)
    administrator_login=$(az keyvault secret show --name pgres-flex-admin-login --vault-name "${keyvault_name}" -o tsv --query value)
    administrator_login_password=$(az keyvault secret show --name pgres-flex-admin-pwd --vault-name "${keyvault_name}" -o tsv --query value)
    user="${administrator_login}"
else
    #psql_server_name=$(az postgres server list -o tsv --query "[?contains(name,${DBMS})].{Name:name}" | head -1)
    psql_server_private_fqdn=$(az postgres server list -o tsv --query "[?contains(name,'${DBMS}')].{Name:fullyQualifiedDomainName}" | head -1)
    administrator_login=$(az keyvault secret show --name db-administrator-login --vault-name "${keyvault_name}" -o tsv --query value)
    administrator_login_password=$(az keyvault secret show --name db-administrator-login-password --vault-name "${keyvault_name}" -o tsv --query value)
    user="${administrator_login}@${psql_server_name}"
fi

export FLYWAY_URL="jdbc:postgresql://${psql_server_private_fqdn}:5432/${DATABASE}?sslmode=require"
export FLYWAY_USER="${user}"
export FLYWAY_PASSWORD="${administrator_login_password}"
export SERVER_NAME="${psql_server_name}"
FLYWAY_VERSION="8.4.4"
export FLYWAY_DOCKER_TAG="${FLYWAY_VERSION}-alpine"

bpd_user_password=$(az keyvault secret show --name db-bpd-user-password --vault-name "${keyvault_name}" -o tsv --query value)
rtd_user_password=$(az keyvault secret show --name db-rtd-user-password --vault-name "${keyvault_name}" -o tsv --query value)
fa_user_password=$(az keyvault secret show --name db-fa-user-password --vault-name "${keyvault_name}" -o tsv --query value)
fa_payment_instrument_remote_user_password=$(az keyvault secret show --name db-fa-payment-instrument-remote-user-password --vault-name "${keyvault_name}" -o tsv --query value)
bpd_payment_instrument_remote_user_password=$(az keyvault secret show --name db-bpd-payment-instrument-remote-user-password --vault-name "${keyvault_name}" -o tsv --query value)
bpd_award_period_remote_user_password=$(az keyvault secret show --name db-bpd-award-period-remote-user-password --vault-name "${keyvault_name}" -o tsv --query value)
bpd_winning_transaction_remote_user_password=$(az keyvault secret show --name db-bpd-winning-transaction-remote-user-password --vault-name "${keyvault_name}" -o tsv --query value)
dashboard_pagopa_user_password=$(az keyvault secret show --name db-dashboard-pagopa-user-password --vault-name "${keyvault_name}" -o tsv --query value)
monitoring_user_password=$(az keyvault secret show --name db-monitoring-user-password --vault-name "${keyvault_name}" -o tsv --query value)
monitoring_pdnd_user_password=$(az keyvault secret show --name db-monitoring-pdnd-user-password --vault-name "${keyvault_name}" -o tsv --query value)
monitoring_sia_user_password=$(az keyvault secret show --name db-monitoring-sia-user-password --vault-name "${keyvault_name}" -o tsv --query value)
monitoring_operation_user_password=$(az keyvault secret show --name db-monitoring-operation-user-password --vault-name "${keyvault_name}" -o tsv --query value)
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
export MONITORING_PDND_USER_PASSWORD="${monitoring_pdnd_user_password}"
export MONITORING_SIA_USER_PASSWORD="${monitoring_sia_user_password}"
export MONITORING_OPERATION_USER_PASSWORD="${monitoring_operation_user_password}"
export TKM_ACQUIRER_MANAGER_USER_PASSWORD="${tkm_acquirer_manager_user_password}"

location="${WORKDIR}/migrations/${SUBSCRIPTION}/${DATABASE}"
options="-url=${FLYWAY_URL} -user=${FLYWAY_USER} -password=${FLYWAY_PASSWORD} \
  -validateMigrationNaming=true \
  -placeholders.adminUser=${administrator_login} \
  -placeholders.adminPassword=${administrator_login_password} \
  -placeholders.bpdUserPassword=${BPD_USER_PASSWORD} \
  -placeholders.rtdUserPassword=${RTD_USER_PASSWORD} \
  -placeholders.faUserPassword=${FA_USER_PASSWORD} \
  -placeholders.faPaymentInstrumentRemoteUserPassword=${FA_PAYMENT_INSTRUMENT_REMOTE_USER_PASSWORD} \
  -placeholders.bpdPaymentInstrumentRemoteUserPassword=${BPD_PAYMENT_INSTRUMENT_REMOTE_USER_PASSWORD} \
  -placeholders.bpdAwardPeriodRemoteUserPassword=${BPD_AWARD_PERIOD_REMOTE_USER_PASSWORD} \
  -placeholders.bpdWinningTransactionRemoteUserPassword=${BPD_WINNING_TRANSACTION_REMOTE_USER_PASSWORD} \
  -placeholders.dashboardPagopaUserPassword=${DASHBOARD_PAGOPA_USER_PASSWORD} \
  -placeholders.monitoringUserPassword=${MONITORING_USER_PASSWORD} \
  -placeholders.monitoringPdndUserPassword=${MONITORING_PDND_USER_PASSWORD} \
  -placeholders.monitoringSiaUserPassword=${MONITORING_SIA_USER_PASSWORD} \
  -placeholders.monitoringOperationUserPassword=${MONITORING_OPERATION_USER_PASSWORD} \
  -placeholders.tkmAcquirerManagerUserPassword=${TKM_ACQUIRER_MANAGER_USER_PASSWORD} \
  -placeholders.serverName=${SERVER_NAME}"


if [[ $(flyway -v) =~ ${FLYWAY_VERSION} ]]
then
  flyway -locations="filesystem:${location}" ${options} ${other} ${COMMAND}
else
  docker run --rm -it --network=host -v ${location}:/flyway/sql \
    flyway/flyway:${FLYWAY_DOCKER_TAG} \
    ${options} ${COMMAND} ${other}
fi


