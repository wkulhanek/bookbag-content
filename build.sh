#!/bin/bash
#ANTORA_SOURCE=https://github.com/redhat-scholars/openshift-starter-guides.git
#ANTORA_BRANCH=ocp-4.6
ANTORA_SOURCE=https://github.com/wkulhanek/bookbag-rhtr2020
ANTORA_BRANCH=main
docker build --build-arg ANTORA_SOURCE=$ANTORA_SOURCE --build-arg ANTORA_BRANCH=$ANTORA_BRANCH -t wkulhanek/bookbag-content:latest .
