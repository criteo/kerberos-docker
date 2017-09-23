# Dockerfile - machine
#
# see docker-compose.yml

FROM minimal-centos

# python web server
COPY index.html .

# kerberos client
RUN yum -y install ntp krb5-workstation krb5-libs
COPY ./krb-conf/client/krb5.conf /etc/krb5.conf

# ssh client
RUN yum -y install openssh-clients
COPY ./ssh-conf/client/ssh_config /etc/ssh/ssh_config

# supervisord
COPY ./supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
