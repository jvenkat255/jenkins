# Dockerized Jenkins

[![Circle CI](https://circleci.com/gh/blacklabelops/jenkins/tree/master.svg?style=shield)](https://circleci.com/gh/blacklabelops/jenkins/tree/master) [![Docker Repository on Quay](https://quay.io/repository/blacklabelops/jenkins/status "Docker Repository on Quay")](https://quay.io/repository/blacklabelops/jenkins) [![Docker Stars](https://img.shields.io/docker/stars/blacklabelops/jenkins.svg)](https://hub.docker.com/r/blacklabelops/jenkins/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacklabelops/jenkins.svg)](https://hub.docker.com/r/blacklabelops/jenkins/)

## Supported tags and respective Dockerfile links

| Distribution | Version      | Tag          | Dockerfile | Size |
|--------------|--------------|--------------|------------|------|
| CentOS | latest | latest | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) | [![blacklabelops/jenkins:latest](https://badge.imagelayers.io/blacklabelops/jenkins:latest.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:latest 'blacklabelops/jenkins:latest') |
| CentOS | 1.647 | 1.647 |  [Dockerfile](https://github.com/blacklabelops/jenkins/blob/1.647/Dockerfile) | [![blacklabelops/jenkins:1.647](https://badge.imagelayers.io/blacklabelops/jenkins:1.647.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:1.647 'blacklabelops/jenkins:1.647') |
| CentOS | stable 1.642.1 | 1.642.1 |  [Dockerfile](https://github.com/blacklabelops/jenkins/blob/1.642.1/Dockerfile) | [![blacklabelops/jenkins:1.642.1](https://badge.imagelayers.io/blacklabelops/jenkins:1.642.1.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:1.642.1 'blacklabelops/jenkins:1.642.1') |
| Alpine | latest | alpine | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:alpine](https://badge.imagelayers.io/blacklabelops/jenkins:alpine.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:alpine 'blacklabelops/jenkins:alpine') |
| Alpine | 1.647 | alpine.1.647 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:alpine.1.647](https://badge.imagelayers.io/blacklabelops/jenkins:alpine.1.647.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:alpine.1.647 'blacklabelops/jenkins:alpine.1.647') |
| Alpine | stable 1.642.1 | alpine.1.642.1 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:alpine.1.642.1](https://badge.imagelayers.io/blacklabelops/jenkins:alpine.1.642.1.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:alpine.1.642.1 'blacklabelops/jenkins:alpine.1.642.1') |
| Alpine | release candidate | rc | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:rc](https://badge.imagelayers.io/blacklabelops/jenkins:rc.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:rc 'blacklabelops/jenkins:rc') |
| Alpine | stable release candidate | stable-rc | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:alpine.stable-rc](https://badge.imagelayers.io/blacklabelops/jenkins:stable-rc.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:stable-rc 'blacklabelops/jenkins:stable-rc') |

> Older tags remain but are not supported/rebuild.

## Instant Usage

[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://stackfiles.io/registry/563e68648ba74c01008d72de)

## Make It Short

~~~~
$ docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
~~~~

> This will pull the container and start the latest jenkins on port 8090

Recommended: Docker-Compose! Just curl the files and modify the environment-variables inside
the .env-files.

~~~~
$ curl -O https://raw.githubusercontent.com/blacklabelops/jenkins/master/docker-compose.yml
$ curl -O https://raw.githubusercontent.com/blacklabelops/jenkins/master/jenkins-master.env
$ curl -O https://raw.githubusercontent.com/blacklabelops/jenkins/master/jenkins-slave.env
$ docker-compose up -d
~~~~

> [jenkins-master.env](https://github.com/blacklabelops/jenkins/blob/master/jenkins-master.env) contains a full list of environment variables.

Scaling jenkins slaves:

~~~~
$ docker-compose scale slave=3
~~~~

> Starts three java JDK-8 slaves.

## Features

* Install latest Jenkins.
* Enable security, install plugins, set swarm port with environment-variables.
* On-Demand https.
* Set the Jenkins version number.
* Container writes data to Docker volume.
* Supports the Docker-Compose tool.
* Includes several convenient cli wrapper scripts around docker.

## What's Included

* Jenkins
* Java 8

## Support & Feature Requests

Leave a message and ask questions on Hipchat: [blacklabelops/hipchat](https://www.hipchat.com/geogBFvEM)

## Build Slaves

Build Slaves can be found here: [blacklabelops/swarm](https://github.com/blacklabelops/jenkins-swarm)

## Manual

The detailed manual moved here:

* [Gitbook blacklabelops/jenkins](https://www.gitbook.com/book/blacklabelops/jenkins)
