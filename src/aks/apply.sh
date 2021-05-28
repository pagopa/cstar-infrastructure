#!/usr/bin/env bash

BASHDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORKDIR="$BASHDIR"

kubectl apply -f "${WORKDIR}/00-namespaces/common"




