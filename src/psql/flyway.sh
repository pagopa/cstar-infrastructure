#!/usr/bin/env bash

#
# Apply the configuration relative to a given subscription
# Subscription are defined in ./subscription
# Usage:
#  ./flyway.sh info|validate|migrate ENV-CSTAR bpd|rtd schema1|schema2
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
source "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"

# shellcheck disable=SC2154
printf "Subscription: %s\n" "${SUBSCRIPTION}"
printf "Resource Group Name: %s\n" "${resource_group_name}"
printf "Storage Account Name: %s\n" "${storage_account_name}"

## remove .flyway dir to avoid error changing subscription
rm -rf "${WORKDIR}/.flyway"

export DESTINATION_IP="${vm_public_ip}"
export USERNAME="${vm_user_name}"
export TARGET="${psql_private_fqdn}:5432"
export SOCKET_FILE="/tmp/$SUBSCRIPTION-flyway-sock"
export RANDOM_PORT=$(echo $((10000 + $RANDOM % 60000)))

bash scripts/ssh-port-forward.sh
trap "ssh -S $SOCKET_FILE -O exit $USERNAME@$DESTINATION_IP" EXIT

export TF_VAR_psql_port="${RANDOM_PORT}"
export TF_VAR_psql_hostname="localhost"

terraform init \
    -backend-config="storage_account_name=${storage_account_name}" \
    -backend-config="resource_group_name=${resource_group_name}"

export FLYWAY_URL="jdbc:postgresql://$(ipconfig getifaddr en0):${RANDOM_PORT}/${DATABASE}?sslmode=require"
export FLYWAY_USER=$(terraform output -raw psql_username)
export FLYWAY_PASSWORD=$(terraform output -raw psql_password)
export FLYWAY_DOCKER_TAG="7.11.1-alpine"

docker run --rm -it --network=host -v "${WORKDIR}/migrations/${DATABASE}/${SCHEMA}":/flyway/sql \
  flyway/flyway:${FLYWAY_DOCKER_TAG} \
  -url="${FLYWAY_URL}" -user=$FLYWAY_USER -password=$FLYWAY_PASSWORD "$COMMAND" $other
