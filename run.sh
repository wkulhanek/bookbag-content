#!/bin/bash
export guid=wkosp
export ocp_username=wkulhane-redhat.com
export jenkins_url=https://homework-jenkins-gpte-jenkins.apps.shared-na4.na4.openshift.opentlc.com
export gitea_url=https://homework-gitea.apps.shared-na4.na4.openshift.opentlc.com
export login_command='oc login -u wkulhane-redhat.com -p <Your OpenTLC password> https://api.shared-na4.na4.openshift.opentlc.com:8443'
export USERNAME=user15
export PASSWORD=openshift
export CLUSTER_SUBDOMAIN=apps.shared-na4.na4.openshift.opentlc.com
docker run --name bookbag \
           --rm --publish 8080:8080 \
           --env guid="$guid" --env ocp_username="$ocp_username" \
           --env jenkins_url="$jenkins_url" --env gitea_url="$gitea_url" \
           --env login_command="${login_command}" \
           --env USERNAME="$USERNAME" --env PASSWORD="$PASSWORD" \
           --env CLUSTER_SUBDOMAIN="$CLUSTER_SUBDOMAIN" \
       wkulhanek/bookbag-content:latest
