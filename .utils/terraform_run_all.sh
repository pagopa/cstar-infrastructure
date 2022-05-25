#!/bin/bash



#
# bash .utils/terraform_run_all.sh init local
# bash .utils/terraform_run_all.sh init docker
#

# 'set -e' tells the shell to exit if any of the foreground command fails,
# i.e. exits with a non-zero status.
set -eu

ACTION="$1"
MODE="$2"

pushd "$(pwd)/src"
rm -rf .terraform
echo "🔬 folder: $(pwd) in under terraform: $ACTION action $MODE mode"
sh terraform.sh "$ACTION" dev
popd

pushd "$(pwd)/src/k8s"
rm -rf .terraform
echo "🔬 folder: $(pwd) in under terraform: $ACTION action $MODE mode"
sh terraform.sh "$ACTION" dev-cstar
popd

pushd "$(pwd)/src/aks-platform"
rm -rf .terraform
echo "🔬 folder: $(pwd) in under terraform: $ACTION action $MODE mode"
sh terraform.sh "$ACTION" dev01
popd

pushd "$(pwd)/src/psql"
rm -rf .terraform
echo "🔬 folder: $(pwd) in under terraform: $ACTION action $MODE mode"
sh terraform.sh "$ACTION" dev-cstar
popd
