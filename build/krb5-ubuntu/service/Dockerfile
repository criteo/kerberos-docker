# Dockerfile - service
#
# see docker-compose.yml

FROM minimal-ubuntu

# user
RUN echo "pwd\npwd" | adduser bob --gecos ""

# kerberos client
RUN apt install -y ntp krb5-config krb5-user

# ssh server/client
RUN apt install -y openssh-server

# python web server configuration
COPY ./nodes/service/index.html .

# kerberos client configuration
ENV KRB5_CONFIG=/etc/krb5.conf
COPY ./services/krb5/client/krb5.conf /etc/krb5.conf

# ssh server/client configuration
RUN mkdir /var/run/sshd
COPY ./services/ssh/server/sshd_config /etc/ssh/sshd_config

# supervisord configuration
COPY ./nodes/service/supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
