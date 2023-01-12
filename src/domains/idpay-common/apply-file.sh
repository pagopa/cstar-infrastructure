#!/bin/bash
if [[ -z "$@" ]]; then
  echo "Missing file input arguments"
  exit 1
fi

echo "terraform apply \\"
for FILE in "$@"
do
  RESOURCE=$(sed -n 's/resource "\([^"]*\)" "\([^"]*\)".*/-target=\1.\2 \\/gp' $FILE)
  MODULE=$(sed -n 's/module "\([^"]*\)".*/-target=module.\1 \\/gp' $FILE)
  if [[ -z "$RESOURCE" ]] && [[ -z "$MODULE" ]]; then
    echo "Cannot detect terraform resource and module in $FILE"
    exit 1
  fi

  if [[ ! -z "$RESOURCE" ]]; then
    echo -e $"$RESOURCE"
  fi
  if [[ ! -z "$MODULE" ]]; then
    echo -e $"$MODULE"
  fi
done
echo "-refresh=true"
