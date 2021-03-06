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

export TF_VAR_k8s_apiserver_port="443"
export TF_VAR_k8s_apiserver_host="${aks_private_fqdn}"
export TF_VAR_k8s_kube_config_path="${kube_config_path}"

# init terraform backend
terraform init -reconfigure \
    -backend-config="storage_account_name=${storage_account_name}" \
    -backend-config="resource_group_name=${resource_group_name}" \
    -backend-config="container_name=${container_name}" \
    -backend-config="key=${key}"

export HELM_DEBUG=1
if echo "init plan apply refresh import output destroy" | grep -w ${COMMAND} > /dev/null; then
  if [ ${COMMAND} = "output" ]; then
    terraform ${COMMAND} $other
  elif [ ${COMMAND} = "init" ]; then
    echo "[INFO] Init already done"
  else
    terraform ${COMMAND} --var-file="${WORKDIR}/subscriptions/${SUBSCRIPTION}/terraform.tfvars" $other
  fi
else
    echo "Action not allowed."
    exit 1
fi
