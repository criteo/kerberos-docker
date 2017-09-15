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

# python
RUN apt-get install -y python-dev

# java
RUN apt-get install -y openjdk-8-jdk
