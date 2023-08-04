#!/bin/bash

DELETE=false
REGISTRY="cstardcommonacr"
DOMAIN="rtd"
REPOSITORIES=$(az acr repository list --name "$REGISTRY" --query "[?starts_with(@, '$DOMAIN')]" -o tsv)

for repo in $REPOSITORIES; do
    echo "Running for $repo"
    ./acr-clean-image.sh "$REGISTRY" "$repo" $DELETE
    echo
done
