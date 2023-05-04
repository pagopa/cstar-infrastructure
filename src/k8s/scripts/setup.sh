#!/usr/bin/env bash

#
# Setup configuration relative to a given subscription
# Subscription are defined in ../subscription
# Usage from script folder
#  ./setup.sh ENV-CSTAR
#
#  ./setup.sh DEV-CSTAR
#  ./setup.sh UAT-CSTAR



# installs a package if not already installed
# parameters:
# $1: name of the package
# $2: optional, executable command for $1 package. defaults to $1
function installpkg() {
  if [ -z "$1" ]; then
    echo "Impossible to proceed"
    return 1
  fi

  pkg=$1

  if [ -z "$2" ]
    then
      cmd=$pkg
    else
      cmd=$2
  fi

  # Check if the <package> command exists
  if ! command -v "${cmd}" &> /dev/null; then
      echo "The ${pkg} command is not present on the system."

      # Ask the user for confirmation to install the package
      read -p "Do you want to install ${pkg} using brew? (Y/n): " response
      if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
          echo "Installing ${pkg} using brew..."
          brew install ${pkg}

          if [ $? -eq 0 ]; then
              echo "${pkg} successfully installed."
          else
              echo "An error occurred during the installation of ${pkg}. Check the output for more information."
              return 1
          fi
      else
          echo "${pkg} installation canceled by the user."
          exit 1
      fi
      else
        echo "${pkg} already installed"
  fi
}


BASHDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORKDIR="${BASHDIR//scripts/}"
aks_name='' # inside ./subscriptions/${SUBSCRIPTION}/conf

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

echo "Please make sure to be under VPN"

az account set -s "${SUBSCRIPTION}"
source ../subscriptions/${SUBSCRIPTION}/conf

echo "vm_name=${vm_name}" > "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"
echo "vm_resource_group_name=${vm_resource_group_name}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"
echo "vm_user_name=${vm_user_name}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"
echo "vm_public_ip=${vm_public_ip}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"

aks_resource_group_name=$(az aks list -o tsv --query "[?contains(name,'${aks_name}')].{Name:resourceGroup}")
aks_private_fqdn=$(az aks list -o tsv --query "[?contains(name,'${aks_name}')].{Name:privateFqdn}")

rm -rf "${HOME}/.kube/config-${aks_name}"
az aks get-credentials -g "${aks_resource_group_name}" -n "${aks_name}" --subscription "${SUBSCRIPTION}" --file "~/.kube/config-${aks_name}"
az aks get-credentials -g "${aks_resource_group_name}" -n "${aks_name}" --subscription "${SUBSCRIPTION}" --overwrite-existing

# configuration format conversion
installpkg "kubelogin"
kubelogin convert-kubeconfig -l azurecli --kubeconfig "${HOME}/.kube/config-${aks_name}"
kubelogin convert-kubeconfig -l azurecli

echo "aks_private_fqdn=${aks_private_fqdn}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"
echo "kube_config_path=~/.kube/config-${aks_name}" >> "${WORKDIR}/subscriptions/${SUBSCRIPTION}/.bastianhost.ini"

# with AAD auth enabled we need to authenticate the machine on the first setup
echo "Follow Microsoft sign in steps. kubectl get pods command will fail but it's the expected behavior"
kubectl --kubeconfig="${HOME}/.kube/config-${aks_name}" get pods
kubectl config use-context "${aks_name}"
kubectl get pods



