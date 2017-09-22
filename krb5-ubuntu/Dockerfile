# Dockerfile - minimal-ubuntu
#
# usage: docker build -t minimal-ubuntu .

FROM ubuntu:16.04
MAINTAINER Gilles Legoux <gilles.legoux@gmail.com>

# environment variables
ENV DEBIAN_FRONTEND noninteractive

# build environment
WORKDIR /root/

# update
RUN apt-get update -y

# editor
RUN apt-get install -y vim nano

# general
RUN apt-get install -y sudo sshpass

# network commands
RUN apt-get install -y net-tools
RUN apt-get install -y iputils-ping
RUN apt-get install -y dnsutils
RUN apt-get install -y lsof
RUN apt-get install -y curl wget

# python
RUN apt-get install -y python-dev
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o /tmp/get-pip.py
RUN python /tmp/get-pip.py

# java
RUN apt-get install -y openjdk-8-jdk
# maven
RUN apt-get install -y maven=3.3.9-3

# supervisord
RUN pip install supervisor==3.3.3
RUN mkdir -p /var/log/supervisord/
