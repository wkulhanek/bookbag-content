#!/bin/bash
export GUID=wkosp
export OCP_USERNAME=wkulhane-redhat.com
export JENKINS_URL=https://homework-jenkins-gpte-jenkins.apps.shared-na4.na4.openshift.opentlc.com
export GITEA_URL=https://homework-gitea.apps.shared-na4.na4.openshift.opentlc.com
export USERNAME=user15
export PASSWORD=openshift
export CLUSTER_SUBDOMAIN=apps.shared-na4.na4.openshift.opentlc.com
docker run --name bookbag \
           --rm --publish 8080:8080 \
           --env GUID=$GUID --env OCP_USERNAME=$OCP_USERNAME \
           --env JENKINS_URL=$JENKINS_URL --env GITEA_URL=$GITEA_URL \
           --env USERNAME=$USERNAME --env PASSWORD=$PASSWORD \
           --env CLUSTER_SUBDOMAIN=$CLUSTER_SUBDOMAIN \
       wkulhanek/bookbag-content:latest
