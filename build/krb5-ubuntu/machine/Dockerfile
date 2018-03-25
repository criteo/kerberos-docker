# Dockerfile - machine
#
# see docker-compose.yml

FROM minimal-ubuntu

# kerberos client
RUN apt install -y ntp krb5-config krb5-user

# ssh client
RUN apt install -y openssh-client

# python web server configuration
COPY ./nodes/machine/index.html .

# kerberos client configuration
ENV KRB5_CONFIG=/etc/krb5.conf
COPY ./services/krb5/client/krb5.conf /etc/krb5.conf

# ssh client configuration
COPY ./services/ssh/client/ssh_config /etc/ssh/ssh_config

# supervisord
COPY ./nodes/machine/supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
