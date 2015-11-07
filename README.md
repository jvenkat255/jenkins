[![Circle CI](https://circleci.com/gh/blacklabelops/jenkins/tree/master.svg?style=shield)](https://circleci.com/gh/blacklabelops/jenkins/tree/master)
[![Image Layers](https://badge.imagelayers.io/blacklabelops/jenkins:latest.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:latest 'Get your own badge on imagelayers.io')

Docker container with Jenkins Continuous Integration and Delivery server on CentOS.

Discuss this Docker Image on Hipchat: [blacklabelops/hipchat](https://www.hipchat.com/geogBFvEM)

Good news! This container has rooted out root! Safely running inside userspace!

Build Slaves can be found here: [blacklabelops/swarm](https://github.com/blacklabelops/jenkins-swarm)

How-To run this container inside the Google Container Engine (GCE): [blacklabelops/gce-jenkins](https://github.com/blacklabelops/gce-jenkins)

### Instant Usage

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

Container has the following features:

* Install latest Jenkins.
* Enable security, install plugins, set swarm port with docker envs.
* On-Demand https.
* Set the Jenkins version number.
* Container writes data to Docker volume.
* Scripts for backup of Jenkins data.
* Scripts for restore of Jenkins data.
* Supports the Docker-Compose tool.
* Includes several convenient cli wrapper scripts around docker.

## What's Included

* Jenkins Latest
* CentOS 7.1.1503
* Java 8

## Works with

* Docker Latest
* Docker-Compose Latest

## Configuration

### Jenkins HTTPS

This container can create ad-hoc self-signed certificates for https without any reverse proxy. This
gives some out of the box network security. Note that reverse proxies and proper certificate work flows are always
to be prefered! I will use this until the Google Cloud Engine https load balancer will work.

At startup the container will create a unique self-signed certificate. This certificat will live as long as the docker volume. You have to pass Distinguished Name (DN) and a keystore password. The certificate is generated by a Distinguished Name and secured by the keystore password. This is a DN-Example:

~~~~
CN=SBleul,OU=Blacklabelops,O=blacklabelops.net,L=Munich,S=Bavaria,C=DE
~~~~

  * CN = Your name
  * OU = Your organizational unit.
  * O = Organisation name.
  * L = Location, e.g. town name.
  * S = State
  * C = Locale of your county.

Now start your container with additional parameters for starting jenkins with https and a keystore password.

~~~~
$ docker run --name jenkins \
	-e "JENKINS_KEYSTORE_PASSWORD=swordfish" \
	-e "JENKINS_CERTIFICATE_DNAME=CN=SBleul,OU=Blacklabelops,O=blacklabelops.net,L=Munich,S=Bavaria,C=DE" \
	-p 443:8080 \
	blacklabelops/jenkins
~~~~

> Congratulations! You can now access your jenkins instance with simply typing https://youinstance.com! Accept the certificate inside your browser and have fun!

### Jenkins Security

This container support matrix enabled user security and admin account at startup. Jenkins
will be locked up and only allows the defined admin user. Afterwards users and rights
can be configured as usual. The admin password can be changed any time. I use this for starting
the container up inside cloud environments.

~~~~
$ docker run -d --name jenkins \
	-e "JENKINS_ADMIN_USER=jenkins" \
	-e "JENKINS_ADMIN_PASSWORD=swordfish"  \
	-p 8090:8080 \
	blacklabelops/jenkins
~~~~

### Jenkins Installing Plugins

Finally got this working:

You can define a set of plugins that will be installed, if necessary, during initialization. Very good
for testing out new plugins. Also adding default plugins like swarm. You have to define a list
of plugin-ids seperated by a whitespace.

~~~~
$ docker run --name jenkins \
  -e "JENKINS_PLUGINS=gitlab-plugin hipchat swarm" \
  -p 8090:8080 \
  blacklabelops/jenkins
~~~~

> This will install the plugins gitlab-plugin hipchat swarm once during post-inistialization.

### Jenkins Master Number of Executors

Jenkins jobs should be executed on slaves therefore it's good to be able to limit
the executors on the master.

~~~~
$ docker run --name jenkins \
  -e "JENKINS_MASTER_EXECUTORS=0" \
  -p 8090:8080 \
  blacklabelops/jenkins
~~~~

### Jenkins Administrator Address

Setting the Administrators EMail Address. Has the form:
"Administrator Name <mail@example.com>"

~~~~
$ docker run --name jenkins \
  -e "JENKINS_ADMIN_EMAIL=Blacklabelops <blacklabelops@itbleul.de>" \
  -p 8090:8080 \
  blacklabelops/jenkins
~~~~

### Jenkins Mail SMTP

The following parameters enable the servers mail settings.

Minimum example:

~~~~
$ docker run --name jenkins \
  -e "SMTP_USER_NAME=jenkins" \
  -e "SMTP_USER_PASS=swordfish" \
  -e "SMTP_HOST=smtp.mailservice.com" \
  -e "SMTP_PORT=2525" \
  -p 8090:8080 \
  -p 50000:50000 \
  blacklabelops/jenkins
~~~~

Full example:

~~~~
$ docker run --name jenkins \
  -e "SMTP_USER_NAME=jenkins" \
  -e "SMTP_USER_PASS=swordfish" \
  -e "SMTP_HOST=smtp.mailservice.com" \
  -e "SMTP_PORT=2525" \
  -e "SMTP_REPLYTO_ADDRESS=dummy@example.com" \
  -e "SMTP_USE_SSL=true" \
  -e "SMTP_CHARSET=UTF-8" \
  -p 8090:8080 \
  -p 50000:50000 \
  blacklabelops/jenkins
~~~~

### Jenkins Slave Port

The slave port enables the automatic connection of jenkins slaves. The port can be configured as follows.

~~~~
$ docker run --name jenkins \
  -e "JENKINS_SLAVEPORT=50000" \
  -p 8090:8080 \
  -p 50000:50000 \
  blacklabelops/jenkins
~~~~

> Slaves can connect on port 50000.

### Jenkins Command Line Parameters

You can define command line parameters. The list of parameters can be found [here](https://wiki.jenkins-ci.org/display/JENKINS/Starting+and+Accessing+Jenkins).

~~~~
docker run -d --name jenkins \
	-e "JENKINS_PARAMETERS=--httpPort=8090" \
	-p 8090:8090 \
	blacklabelops/jenkins
~~~~

> Starts Jenkins with internal port 8090 rather default port 8080.

### Java-VM Parameters

You can define start up parameters for the Java Virtual Machine, e.g. setting the memory size.

~~~~
docker run -d --name jenkins \
	-e "JAVA_VM_PARAMETERS=-Xmx512m -Xms256m" \
	-p 8090:8080 \
	blacklabelops/jenkins
~~~~

> You will have to use Java 8 parameters.

### Jenkins Logging

This container does not write a logfile by default. It's considered bad practise as logs
should be accessed by the command `docker logs`. There are use case where you want to
have additional log files, e.g. my use case is to relay log to Loggly [Loggly Homepage](https://www.loggly.com/).
I have added a routine for logging and it's activated by defining a logfile.

Environment Variable: LOG_FILE

Example for a separate volume with a logfile:

~~~~
$ docker run -d -p 8090:8080 \
  -v $(pwd)/logs:/jenkinslogs \
  -e "LOG_FILE=/jenkinslogs/jenkins.log" \
  --name jenkins \
  blacklabelops/jenkins
~~~~

> You can watch the log by typing `cat ./logs/jenkins.log`.

Now lets hook up the container with my Loggly side-car container and relay the log to Loggly! The Full
documentation of the loggly container can be found here: [blacklabelops/loggly](https://github.com/blacklabelops/fluentd/tree/master/fluentd-loggly)

~~~~
$ docker run -d \
  --volumes-from jenkins \
  -e "LOGS_DIRECTORIES=/jenkinslogs" \
	-e "LOGGLY_TOKEN=3ere-23kkke-23j3oj-mmkme-343" \
  -e "LOGGLY_TAG=jenkinslog" \
  --name jenkinsloggly \
  blacklabelops/loggly
~~~~

> Note: You need a valid Loggly Customer Key in order to log to Loggly.

### Jenkins Backups with rsnapshot

You can create automatic backups using [blacklabelops/rsnapshotd](https://github.com/blacklabelops/rsnapshot/tree/master/rsnapshot-cron).
This side-car container uses rsnapshot to create snapshots of your jenkins volume periodically.

Full documentation can be found here:  [blacklabelops/rsnapshotd](https://github.com/blacklabelops/rsnapshot/tree/master/rsnapshot-cron)

First fire up the Jenkins master:

~~~~
$ docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
~~~~

Then start and attach the side-car backup container:

~~~~
$ docker run -d \
  --volumes-from jenkins \
	-v $(pwd)/snapshots/:/snapshots \
  -e "CRON_HOURLY=* * * * *" \
	-e "BACKUP_DIRECTORIES=/jenkins/ jenkins/" \
	blacklabelops/rsnapshotd
~~~~

> Mounts all volumes from the running container and snapshots the volume /jenkins inside the local
snapshot directory under `jenkins/`. Note: If you use Windows then you will have to replace $(pwd)
with an abolute path.

### Jenkins Backups in Google Storage Buckets

You can periodically create backups and upload them to your [Google Storage Bucket](https://cloud.google.com/storage/).

Full documentation of the backup container can be found hee: [blacklabelops/gcloud](https://github.com/blacklabelops/gcloud)

First fire up the Jenkins master:

~~~~
$ docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
~~~~

Then start and attach the [blacklabelops/gcloud](https://github.com/blacklabelops/gcloud) container!

The required example crontab can be found here: [example-crontab-backup.txt](https://github.com/blacklabelops/gcloud/blob/master/example-crontab-backup.txt)

~~~~
$ docker run \
  --volumes-from jenkins \
  -v $(pwd)/backups/:/backups \
  -v $(pwd)/logs/:/logs \
  -e "GCLOUD_ACCOUNT=$(base64 auth.json)" \
  -e "GCLOUD_CRON=$(base64 example-crontab-backup.txt)" \
  blacklabelops/gcloud
~~~~

> Uses the authentication file auth.json and executed the crontab th°°at uploads archives to the specified cloud bucket. Logs and
backups are available locally.


## Vagrant

Vagrant is fabulous tool for pulling and spinning up virtual machines like docker with containers. I can configure my development and test environment and simply pull it online. And so can you! Install Vagrant and Virtualbox and spin it up. Change into the project folder and build the project on the spot!

~~~~
$ vagrant up
$ vagrant ssh
[vagrant@localhost ~]$ cd /vagrant
[vagrant@localhost ~]$ docker-compose up
~~~~

> Jenkins will be available on localhost:9200 on the host machine.

Vagrant does not leave any docker artifacts on your beloved desktop and the vagrant image can simply be destroyed and repulled if anything goes wrong. Test my project to your heart's content!

First install:

* [Vagrant](https://www.vagrantup.com/)
* [Virtualbox](https://www.virtualbox.org/)

## Usage

This container includes all the required scripts for container management. Simply clone the project and enter the described commands in your project directory.

[TOC]

### Project Usage

This project can be used from the command line, by bash scripts and the Docker-Compose tool. It's recommended to use the scripts for container management.

#### Run Recommended

~~~~
$ ./scripts/run.sh
~~~~

> This will run the container with the configuration scripts/container.cfg

#### Run Docker-Composite

~~~~
$ docker-compose up -d
~~~~

> This will run the container detached with the configuration docker-composite.yml

#### Run Command Line

~~~~
$ docker run -d -p 8090:8080 --name="jenkins" blacklabelops/jenkins
~~~~

> This will run the jenkins on default settings and port 8090

#### Build Recommended

~~~~
$ ./scripts/build.sh
~~~~

> This will build the container from scratch with all required parameters.

#### Build Docker-Composite

~~~~
docker-compose build
~~~~

> This will build the container according to the docker-composite.yml file.

#### Build Docker Command Line

~~~~
docker build -t="blacklabelops/jenkins" .
~~~~

> This will build the container from scratch.

## Docker Wrapper Scripts

Convenient wrapper scripts for container and image management. The scripts manage one container. In oder to manage multiple containers, copy the scripts and adjust the container.cfg.

Name              | Description
----------------- | ------------
build.sh          | Build the container from scratch.
run.sh            | Run the container.
start.sh          | Start the container from a stopped state.
stop.sh           | Stop the container from a running state.
rm.sh             | Kill all running containers and remove it.
rmi.sh            | Delete container image.
mng.sh            | Manage the docker volume from another container.

> Simply invoke the commands in the project's folder.

## Feature Scripts

Feature scripts for the container. The scripts manage one container. In oder to manage multiple containers, copy the scripts and adjust the container.cfg.

Name              | Description
----------------- | ------------
logs.sh  | Downloads a jenkins logs file from container
backup.sh         | Backups docker volume ["/jenkins"] from container
restore.sh        | Restore the backup into jenkins container

> The examples are executed from project folder.

### logs.sh

This script will search for configured docker container. If no container
found, an error message will be shown. Otherwise, an jenkins logs will be
copied by default into 'logs' folder with following file name and timestamp.

~~~~
$ ./scripts/logs.sh
~~~~

> The log file with timestamp as name und suffix ".log" can be found in the project's logs folder.

#### Error example

~~~~
$ ./scripts/logs.sh
:: Searching for jenkins docker container...

[ERROR] jenkins container is not found
~~~~

#### Success example

~~~~
$ scripts/logs.sh
:: Reading scrips config....
:: Reading container config....
:: Searching for jenkins docker container...
 container is found

:: Downloading logs from container...
 logs directory: /home/docker/jenkins/logs
 log filename  : JenkinsLogs-2015-03-08-16-14-01.log
~~~~

### backup.sh

Backup of docker volume in a tar archive.

~~~~
$ ./scripts/backup.sh
~~~~

> The backups will be placed in the project's backups folder.

#### Error example

~~~~
$ scripts/backup.sh
:: Searching for jenkins docker container...

[ERROR] jenkins container is not found
~~~~

#### Success example

~~~~
$ scripts/backup.sh
:: Reading scrips config....
:: Reading container config....
:: Searching for jenkins docker container...
 container found

:: Backuping /jenkins folder from container...
:: Searching for running backup container...
:: Searching for backup container...
:: Starting backup...
tar: removing leading '/' from member names
:: Searching for backup container...
 backup directory: /home/docker/jenkins/backups
 backup file     : JenkinsBackup-2015-03-08-16-28-40.tar
~~~~

### restore.sh

Restore container from a tar archive.

~~~~
$ ./scripts/restore.sh ./backups/JenkinsBackup-2015-03-08-16-28-40.tar
~~~~

> A temp container will be created and backup file will be extracted into docker volume. The container will be stopped and restartet afterwards.

#### Error example

~~~~
$ scripts/restore.sh

:: Reading scrips config....
:: Reading container config....

No backup archive provided.
Usage: restore.sh {path-to-backup-archive.tar}
~~~~

#### Success example

~~~~
$ ./scripts/restore.sh ./backups/JenkinsBackup-2015-03-08-16-28-40.tar
:: Reading scrips config....
:: Reading container config....
:: Searching for backup file...
 backup archive exists

:: Searching for jenkins container
 container found

:: Restoring /jenkins folder into container...
 stop container if running
:: Searching for running restore container...
:: Searching for restore container...
:: Starting restore...
 backup imported into jenkins container

:: Starting jenkins with restored data again...
:: Searching for restore container...

[SUCCESS] Restoring of backups complete successfull.

~~~~

## Managing Multiple Containers

The scripts can be configured for the support of different containers on the same host manchine. Just copy and paste the project and folder and adjust the configuration file scripts/container.cfg

Name              | Description
----------------- | ------------
CONTAINER_NAME    | The name of the docker container.
IMAGE_NAME         | The name of the docker image.
HOST_PORT        | The exposed port on the host machine.
BACKUP_DIRECTORY | Change the backup directory.
LOGFILE_DIRECTORY | Change the logs download directory.
FILE_TIMESTAMP | Timestamp format for logs and backups.

> Note: CONTAINER_VOLUME must not be changed.

## Setting the Jenkins Version

The jenkins version is configured in the Dockerfile. Please consider that backups will only work with the respective jenkins versions.

Dockerfile:

~~~~
ENV JENKINS_VERSION=latest
~~~~

> This will install the latest jenkins version in each build process.

Dockerfile:

~~~~
ENV JENKINS_VERSION=1.556
~~~~

> This will install the jenkins version 1.556.

## Docker-Compose

This project supports docker-compose. The configuration is inside the docker-compose.yml file.

Example:

~~~~
$ docker-compose up -d
~~~~

> Starts a detached docker container.

Consult the [docker-compose](https://docs.docker.com/compose/) manual for specifics.

> This will enable the administrative account for user jenkins with password swordfish. Note:
This only works when the users are adminsitrated by the servlet container (see security setup).

## References

* [Jenkins Homepage](http://jenkins-ci.org/)
* [Docker Homepage](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker Userguide](https://docs.docker.com/userguide/)
* [Official CentOS Container](https://registry.hub.docker.com/_/centos/)
* [Oracle Java8](https://java.com/de/download/)
