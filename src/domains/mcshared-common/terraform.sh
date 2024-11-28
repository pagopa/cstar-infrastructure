#!/bin/bash
source "./env/$2/backend.ini"
az account set -s "${subscription}"
echo ${subscription}
export TF_VAR_subscription_id="$(az account list --query "[?isDefault].id" --output tsv)"
echo ${TF_VAR_subscription_id}
# shellcheck source=/dev/null
source ../../../scripts/terraform.sh
