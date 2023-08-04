#!/bin/bash

function display_help {
    echo "Usage: $0 REGISTRY REPOSITORY DELETE"
    echo "Parameters:"
    echo "  REGISTRY: The name of the ACR registry."
    echo "  REPOSITORY: The name of the repository within the ACR."
    echo "  DELETE: Set to 'true' for a delete images, or 'false' to make a preview"
    exit 1
}

# Check if the number of arguments is correct
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Error: Invalid number of arguments."
    display_help
fi

REGISTRY=$1
REPOSITORY=$2
DELETE=${3:-false}

# Fetch the list of image digests sorted by time (excluding the latest two)
image_digests=$(az acr manifest list-metadata --name $REPOSITORY --registry $REGISTRY \
    --orderby time_desc --query "[2:].digest" -o tsv)

if [ "$DELETE" = false ]; then
    # Dry run version: print the commands without actually executing them
    echo "The image that would be deleted:"
    for digest in $image_digests; do
        echo $REPOSITORY@$digest
    done
else
    # Actual execution version: execute the delete commands
    for digest in $image_digests; do
        az acr repository delete --name $REGISTRY --image $REPOSITORY@$digest --yes
    done
fi