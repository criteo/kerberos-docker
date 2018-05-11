# Dockerfile - service
#
# see docker-compose.yml

FROM minimal-centos

# user
RUN useradd bob
RUN echo "bob:pwd" | chpasswd

# kerberos client
RUN yum -y install ntp krb5-workstation krb5-libs

# ssh server/client
RUN yum -y install openssh-server openssh-clients

# python web server
COPY ./nodes/service/index.html .

# kerberos client configuration
ENV KRB5_CONFIG=/etc/krb5.conf
COPY ./services/krb5/client/krb5.conf /etc/krb5.conf

# ssh server/client configuration
RUN mkdir -pv /var/run/sshd
RUN echo y | sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""
RUN echo y | sudo ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ""
RUN echo y | sudo ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
RUN echo y | sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
COPY ./services/ssh/server/sshd_config /etc/ssh/sshd_config

# supervisord configuration
COPY ./nodes/service/supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
