# Dockerfile - machine
#
# see docker-compose.yml

FROM minimal-centos

# kerberos client
RUN yum -y install ntp krb5-workstation krb5-libs

# ssh client
RUN yum -y install openssh-clients

# python web server configuration
COPY ./nodes/machine/index.html .

# kerberos client configuration
ENV KRB5_CONFIG=/etc/krb5.conf
COPY ./services/krb5/client/krb5.conf /etc/krb5.conf

# ssh client configuration
COPY ./services/ssh/client/ssh_config /etc/ssh/ssh_config

# supervisord configuration
COPY ./nodes/machine/supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
