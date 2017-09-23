# Dockerfile - service
#
# see docker-compose.yml

FROM minimal-centos

# user
RUN useradd bob
RUN echo "bob:pwd" | chpasswd

# python web server
COPY index.html .

# kerberos client
RUN yum -y install ntp krb5-workstation krb5-libs
COPY ./krb-conf/client/krb5.conf /etc/krb5.conf

# ssh server/client
RUN yum -y install openssh-server openssh-clients
RUN mkdir -pv /var/run/sshd
RUN echo y | sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""
RUN echo y | sudo ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ""
RUN echo y | sudo ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
RUN echo y | sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
COPY ./ssh-conf/server/sshd_config /etc/ssh/sshd_config

# supervisord
COPY ./supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
