#!/bin/bash

# $HOME: /opt/app-root/src
# Antora source cloned into $HOME/antora

# Do Variable Substitution here
pushd $HOME/antora/documentation

# Retrieve all Environment Variables
echo "Performing Variable substitution..."
export ENV_VARS=$(env)
for VARIABLE in $ENV_VARS;
do
  # Get KEY and VALUE from variable
  # GUID=wkosp -> KEY=GUID, VALUE=wkosp
  IFS="="
  read -ra VARIABLE_KEY_VALUE <<< ${VARIABLE}

  # Save in environment variables
  # ,, converts the key to lower case
  # VARIABLE_KEY=${VARIABLE_KEY_VALUE[0],,}
  VARIABLE_KEY=${VARIABLE_KEY_VALUE[0]}
  VARIABLE_VALUE=${VARIABLE_KEY_VALUE[1]}
  # echo "Found variable with key ${VARIABLE_KEY} and value ${VARIABLE_VALUE}\n"

  # Find all *.adoc source files and replace the variables
  find . -name *.adoc -exec awk -i inplace -v key="%${VARIABLE_KEY}%" -v value="${VARIABLE_VALUE}" '{ gsub(key, value)}1' {} +
done
IFS=" "
popd

# Build Antora Site
pushd $HOME/antora
antora dev-site.yml
popd

# Now start NGINX
echo "Starting nxinx..."
exec /usr/sbin/nginx -g "daemon off;" $@