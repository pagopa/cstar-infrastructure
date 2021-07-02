#!/usr/bin/env bash

#
# Setup configuration relative to a given subscription
# Subscription are defined in ./subscription
# Usage:
#  ./setup.sh ENV-CSTAR
#
#  ./setup.sh DEV-CSTAR
#  ./setup.sh UAT-CSTAR
#  ./setup.sh PROD-HUBPA

BASHDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORKDIR="${BASHDIR//scripts/}"

set -e

SUBSCRIPTION=$1

if [ -z "${SUBSCRIPTION}" ]; then
    printf "\e[1;31mYou must provide a subscription as first argument.\n"
    exit 1
fi

if [ ! -d "${WORKDIR}/subscriptions/${SUBSCRIPTION}" ]; then
    printf "\e[1;31mYou must provide a subscription for which a variable file is defined. You provided: '%s'.\n" "${SUBSCRIPTION}" > /dev/stderr
    exit 1
fi

az account set -s "${SUBSCRIPTION}"

vm_name=$(az vm list -d -o tsv --query "[?contains(name,'jumpbox')].{Name:name}")
vm_resource_group_name=$(az vm list -d -o tsv --query "[?contains(name,'jumpbox')].{Name:resourceGroup}")
vm_user_name=$(az vm list -d -o tsv --query "[?contains(name,'jumpbox')].{Name:osProfile.adminUsername}")
vm_public_ip=$(az vm show -d -g "${vm_resource_group_name}" -n "${vm_name}" --query publicIps -o tsv)

echo "vm_name=${vm_name}" > "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"
echo "vm_resource_group_name=${vm_resource_group_name}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"
echo "vm_user_name=${vm_user_name}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"
echo "vm_public_ip=${vm_public_ip}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"

psql_private_fqdn=$(az postgres server list -o tsv --query "[?contains(name,'postgresql')].{Name:fullyQualifiedDomainName}" | head -1)

echo "psql_private_fqdn=${psql_private_fqdn}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"
