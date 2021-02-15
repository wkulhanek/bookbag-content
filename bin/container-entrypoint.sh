#!/bin/bash

# $HOME: /opt/app-root/src
# Antora source cloned into $HOME/antora

# Do Variable Substitution here
pushd $HOME/antora/documentation

# Check for existence of environment variable WORKSHOP_VARS
# WORKSHOP_VARS is one variable with all other variables listed in a JSON array
# WORKSHOP_VARS: {"guid": "rdu-0ee7", "user_info_messages": "To Access Control node via SSH:\\nssh generic_cdoerbec@control.rdu-0ee7.example.opentlc.com\\nEnter ssh password when prompted: WLgeUgI54lFy", "ssh_password": "WLgeUgI54lFy", "ssh_command": "ssh generic_cdoerbec@control.rdu-0ee7.example.opentlc.com"}

if [ -z ${WORKSHOP_VARS+x} ]; then
  echo "WORKSHOP_VARS is not set. Attempting regular variable substitution"

  # Retrieve all Environment Variables
  echo "Performing Variable substitution..."
  OLD_IFS=$IFS
  unset IFS
  for VARIABLE_KEY in $(compgen -e)
  do
    VARIABLE_VALUE=${!VARIABLE_KEY}
    echo "Found variable with key ${VARIABLE_KEY} and value ${VARIABLE_VALUE}"

    # Find all *.adoc source files and replace the variables
    find . -name *.adoc -exec awk -i inplace -v key="%${VARIABLE_KEY}%" -v value="${VARIABLE_VALUE}" '{ gsub(key, value)}1' {} +
  done
  IFS=$OLD_IFS
  popd

else
  echo "WORKSHOP_VARS is set. Attempting JSON variable substitution."

  VARIABLE_KEYS=$(echo $WORKSHOP_VARS | jq -r 'to_entries|map("\(.key)")|.[]')

  for VARIABLE_KEY in $VARIABLE_KEYS; do
    VARIABLE_VALUE=$(echo $WORKSHOP_VARS | jq -r ".${VARIABLE_KEY}")
    echo "Found variable with key ${VARIABLE_KEY} and value ${VARIABLE_VALUE}"

    # Find all *.adoc source files and replace the variables
    find . -name *.adoc -exec awk -i inplace -v key="%${VARIABLE_KEY}%" -v value="${VARIABLE_VALUE}" '{ gsub(key, value)}1' {} +
  done
  IFS=$OLD_IFS
fi

# Build Antora Site
pushd $HOME/antora
antora dev-site.yml
popd

# Now start NGINX
echo "Starting nginx..."
exec /usr/sbin/nginx -g "daemon off;" $@