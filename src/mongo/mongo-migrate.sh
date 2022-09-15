#!/usr/bin/env bash

#
# Based on https://github.com/seppevs/migrate-mongo, so please refer to this repo.
# Example:
#   ./mongo-migrate.sh DEV-CSTAR rtd create|up|down|status
#   ./mongo-migrate.sh UAT-CSTAR rtd create|up|down|status
#   ./mongo-migrate.sh PROD-CSTAR rtd create|up|down|status
#

BASHDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORKDIR="$BASHDIR"

set -e
SUBSCRIPTION=$1
DATABASE=$2
shift 2
other=$@

if [ -z "${SUBSCRIPTION}" ]; then
    printf "\e[1;31mYou must provide a subscription as first argument.\n"
    exit 1
fi

LOCATION="${WORKDIR}/migrations/${SUBSCRIPTION}"

if [ ! -d ${LOCATION} ]; then
    printf "\e[1;31mYou must provide a subscription for which a variable file is defined. You provided: '%s'.\n" "${SUBSCRIPTION}" > /dev/stderr
    exit 1
fi

if [ -z "${DATABASE}" ]; then
  printf "\e[1;31mYou must provide a database name\n"
      exit 1
fi

# imports resource_group and cosmos_account_name
source "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.env"

az account set -s "${SUBSCRIPTION}"

MONGODB_URI=$(az cosmosdb keys list --resource-group ${resource_group} \
                --name ${cosmos_account_name} \
                --type connection-strings \
                --query 'connectionStrings[0].connectionString' \
                --output tsv)

# Resume before apply
echo "Please be sure to be under VPN"
echo "Resume before apply:"
echo -e "\tSubscription: ${SUBSCRIPTION}"
echo -e "\tCosmos account: ${cosmos_account_name}"
echo -e "\tResource group: ${resource_group}"
echo -e "\tDatabase: ${DATABASE}"

read -p "Are you sure? (y/n) " choice
if [[ $choice =~ ^[Yy]$ ]]
then
    docker run --rm -it --network=host \
      -v ${LOCATION}:/app \
      -e MONGO_URI=${MONGODB_URI} \
      -e MONGO_DATABASE=${DATABASE} \
      petretiandrea/migrate-mongo \
      migrate-mongo ${other}
fi