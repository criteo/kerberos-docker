# Dockerfile - service
#
# see docker-compose.yml

FROM minimal-ubuntu

# python web server
COPY index.html .

# kerberos client
RUN apt install -y ntp krb5-config krb5-user
COPY ./krb-conf/client/krb5.conf /etc/krb5.conf

# ssh server/client
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
COPY ./ssh-conf/server/sshd_config /etc/ssh/sshd_config

# supervisord
COPY ./supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
