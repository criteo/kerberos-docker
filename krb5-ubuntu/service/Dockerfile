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

# run command
CMD ["/usr/sbin/sshd", "-f", "/etc/ssh/sshd_config"]
CMD ["python", "-m", "SimpleHTTPServer", "5003"]
