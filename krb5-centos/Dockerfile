# Dockerfile - minimal-centos
#
# usage: docker build -t minimal-centos .

FROM centos:7

# build environment
WORKDIR /root/

# update
RUN yum -y update

# editor
RUN yum -y install vim nano

# general
RUN yum -y install sudo sshpass

# network commands
RUN yum -y install net-tools
RUN yum -y install iputils
RUN yum -y install bind-utils
RUN yum -y install lsof
RUN yum -y install curl wget

# python
RUN yum -y install python-devel
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o /tmp/get-pip.py
RUN python /tmp/get-pip.py

# java
RUN yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
# maven (3.0.5-17)
RUN yum -y install maven

# supervisord
RUN pip install supervisor==3.3.3
RUN mkdir -p /var/log/supervisord/
