FROM blacklabelops/java:centos.jdk8
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# Build time arguments
# Values: latest or version number
ARG JENKINS_VERSION=latest
#Values: war or war-stable
ARG JENKINS_RELEASE=war
#Permissions, set the linux user id and group id
ARG CONTAINER_UID=1000
ARG CONTAINER_GID=1000

# env variables for the console or child containers to override
ENV JAVA_VM_PARAMETERS=-Xmx512m \
    JENKINS_MASTER_EXECUTORS= \
    JENKINS_SLAVEPORT=50000 \
    JENKINS_PLUGINS=swarm \
    JENKINS_PARAMETERS= \
    JENKINS_KEYSTORE_PASSWORD= \
    JENKINS_CERTIFICATE_DNAME= \
    JENKINS_ENV_FILE= \
    JENKINS_HOME=/jenkins \
    JENKINS_DELAYED_START=

RUN export CONTAINER_USER=jenkins && \
    export CONTAINER_GROUP=jenkins && \
    # Add user
    /usr/sbin/groupadd --gid $CONTAINER_GID jenkins && \
    /usr/sbin/useradd --uid $CONTAINER_UID --gid $CONTAINER_GID --create-home --shell /bin/bash jenkins && \
    # Install software
    yum install -y \
      git \
      unzip \
      wget \
      zip && \
    yum clean all && rm -rf /var/cache/yum/* && \
    # Install jenkins
    mkdir -p /usr/bin/jenkins && \
    wget --directory-prefix=/usr/bin/jenkins \
         http://mirrors.jenkins-ci.org/${JENKINS_RELEASE}/${JENKINS_VERSION}/jenkins.war && \
    chown -R $CONTAINER_USER:$CONTAINER_GROUP /usr/bin/jenkins && \
    chmod ug+x /usr/bin/jenkins/jenkins.war && \
    # Jenkins directory
    mkdir -p ${JENKINS_HOME} && \
    chown -R $CONTAINER_USER:$CONTAINER_GROUP ${JENKINS_HOME} && \
    # Install Tini Zombie Reaper And Signal Forwarder
    export TINI_VERSION=0.9.0 && \
    export TINI_SHA=fa23d1e20732501c3bb8eeeca423c89ac80ed452 && \
    curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static -o /bin/tini && \
    chmod +x /bin/tini && \
    echo "$TINI_SHA /bin/tini" | sha1sum -c -

WORKDIR /jenkins
VOLUME ["/jenkins"]
EXPOSE 8080 50000

USER jenkins
COPY imagescripts/docker-entrypoint.sh /home/jenkins/docker-entrypoint.sh
ENTRYPOINT ["/bin/tini","--","/home/jenkins/docker-entrypoint.sh"]
CMD ["jenkins"]
