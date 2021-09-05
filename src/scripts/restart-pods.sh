#!/bin/bash

namespace=$1

deploys=`kubectl -n $namespace get deployments | tail -n +2 | cut -d ' ' -f 1`
for deploy in $deploys; do
  kubectl -n $1 rollout restart deployments/$deploy
done