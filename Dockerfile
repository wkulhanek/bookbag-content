FROM registry.access.redhat.com/ubi8/nodejs-14:latest

# Default Variables
# Can be overridden when building the container
ARG ANTORA_SOURCE https://github.com/redhat-scholars/openshift-starter-guides.git
    # Branch to check out
ARG ANTORA_BRANCH ocp-4.6

USER root

RUN dnf -y update && \
    dnf -y install ruby nginx git && \
    dnf -y clean all && \
    npm install -g @antora/cli@2.3 @antora/site-generator-default@2.3 && \
    gem install asciidoctor && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    chgrp -R 0 /run && \
    chmod -R g=u /run

COPY ./bin/container-entrypoint.sh /bin
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN mkdir $HOME/antora && \
    pushd $HOME/antora && \
    git clone $ANTORA_SOURCE $HOME/antora && \
    cd $HOME/antora && \
    git checkout $ANTORA_BRANCH && \
    chgrp -R 0 $HOME/antora && \
    chmod -R g=u $HOME/antora && \
    popd

USER 1001

# NGINX is configured to run on port 8080
EXPOSE 8080
STOPSIGNAL SIGQUIT

ENTRYPOINT ["/bin/container-entrypoint.sh"]
# CMD ["nginx", "-g", "daemon off;"]