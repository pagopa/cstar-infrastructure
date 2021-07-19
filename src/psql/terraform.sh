#!/usr/bin/env bash

#
# Apply the configuration relative to a given subscription
# Subscription are defined in ./subscription
# Usage:
#  ./terraform.sh apply|destroy|plan ENV-CSTAR
#
#  ./terraform.sh apply DEV-CSTAR
#  ./terraform.sh apply UAT-CSTAR
#  ./terraform.sh apply PROD-HUBPA

BASHDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORKDIR="$BASHDIR"

set -e

COMMAND=$1
SUBSCRIPTION=$2
shift 2
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
source "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"

# shellcheck disable=SC2154
printf "Subscription: %s\n" "${SUBSCRIPTION}"
printf "Resource Group Name: %s\n" "${resource_group_name}"
printf "Storage Account Name: %s\n" "${storage_account_name}"

## remove .terraform dir to avoid error changing subscription
rm -rf "${WORKDIR}/.terraform"

# removed using vpn
# export DESTINATION_IP="${vm_public_ip}"
# export USERNAME="${vm_user_name}"
# export TARGET="${psql_private_fqdn}:5432"
# export SOCKET_FILE="/tmp/$SUBSCRIPTION-terraform-sock"
# export RANDOM_PORT=$(echo $((10000 + $RANDOM % 60000)))

# bash scripts/ssh-port-forward.sh
# trap "ssh -S $SOCKET_FILE -O exit $USERNAME@$DESTINATION_IP" EXIT

# export TF_VAR_psql_port="${RANDOM_PORT}"
# export TF_VAR_psql_hostname="localhost"

export TF_VAR_psql_port="5432"
export TF_VAR_psql_hostname="${psql_private_fqdn}"

# removed using vpn
# export TF_DATA_DIR="${WORKDIR}/subscriptions/${SUBSCRIPTION}/.terraform"

# init terraform backend
terraform init \
    -backend-config="storage_account_name=${storage_account_name}" \
    -backend-config="resource_group_name=${resource_group_name}"

if echo "plan apply refresh import output" | grep -w ${COMMAND} > /dev/null; then
  if [ ${COMMAND} = "output" ]; then
    terraform ${COMMAND} $other
  else
    terraform ${COMMAND} --var-file="${WORKDIR}/subscriptions/${SUBSCRIPTION}/terraform.tfvars" $other
  fi
else
    echo "Action not allowed."
    exit 1
fi
