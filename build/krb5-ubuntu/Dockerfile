# Dockerfile - minimal-ubuntu
#
# usage: docker build -t minimal-ubuntu .

FROM ubuntu:16.04

# environment variables
ENV DEBIAN_FRONTEND noninteractive

# build environment
WORKDIR /root/

# update
RUN apt update -y

# editor
RUN apt install -y vim nano

# general
RUN apt install -y sudo sshpass

# network commands
RUN apt install -y net-tools
RUN apt install -y iputils-ping
RUN apt install -y dnsutils
RUN apt install -y lsof
RUN apt install -y curl wget

# python
RUN apt install -y python-dev
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o /tmp/get-pip.py
RUN python /tmp/get-pip.py

# java
RUN apt install -y openjdk-8-jdk
# maven
RUN apt install -y maven=3.3.9-3

# supervisord
RUN pip install supervisor==3.3.3
RUN mkdir -p /var/log/supervisord/
