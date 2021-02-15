#!/bin/bash

# $HOME: /opt/app-root/src
# Antora source cloned into $HOME/antora

# Do Variable Substitution here
pushd $HOME/antora/documentation

# Retrieve all Environment Variables
echo "Performing Variable substitution..."
OLD_IFS=$IFS
unset IFS
for VARIABLE_KEY in $(compgen -e)
do
  VARIABLE_VALUE=${!VARIABLE_KEY}
  # echo "Found variable with key ${VARIABLE_KEY} and value ${VARIABLE_VALUE}\n"

  # Find all *.adoc source files and replace the variables
  find . -name *.adoc -exec awk -i inplace -v key="%${VARIABLE_KEY}%" -v value="${VARIABLE_VALUE}" '{ gsub(key, value)}1' {} +
done
IFS=$OLD_IFS
popd

# Build Antora Site
pushd $HOME/antora
antora dev-site.yml
popd

# Now start NGINX
echo "Starting nginx..."
exec /usr/sbin/nginx -g "daemon off;" $@