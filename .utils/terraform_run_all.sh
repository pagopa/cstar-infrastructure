#!/bin/bash



#
# bash .utils/terraform_run_all.sh <Action>
# bash .utils/terraform_run_all.sh init
#

# 'set -e' tells the shell to exit if any of the foreground command fails,
# i.e. exits with a non-zero status.
set -eu

ACTION="$1"

array=(
    'src::dev'
    'src/k8s::dev-cstar'
    'src/aks-platform::dev01'
    'src/psql::dev-cstar'
    'src/domains/idpay-app::dev'
    'src/domains/idpay-common::dev'
    'src/domains/tae-app::dev'
    'src/domains/tae-common::dev'
    'src/domains/rtd-app::dev'
    'src/domains/rtd-common::dev'
)

function rm_terraform {
    find . \( -iname ".terraform*" ! -iname ".terraform-docs*" ! -iname ".terraform-version" \) -print0 | xargs -0 rm -rf
}

echo "[INFO] 🪚 Delete all .terraform folders"
rm_terraform

echo "[INFO] 🏁 Init all terraform repos"
for index in "${array[@]}" ; do
    FOLDER="${index%%::*}"
    COMMAND="${index##*::}"
    pushd "$(pwd)/${FOLDER}"
        echo "$FOLDER - $COMMAND"
        echo "🔬 folder: $(pwd) in under terraform: $ACTION action"
        sh terraform.sh "$ACTION" "$COMMAND" &
    popd
done

