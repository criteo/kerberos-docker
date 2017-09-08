# Dockerfile - machine
#
# see docker-compose.yml

FROM minimal-ubuntu

# python web server
COPY index.html .

# kerberos client
RUN apt install -y ntp krb5-config krb5-user
COPY ./krb-conf/client/krb5.conf /etc/krb5.conf

# ssh client
RUN apt-get install -y openssh-client
COPY ./ssh-conf/client/ssh_config /etc/ssh/ssh_config

# run command
CMD ["/usr/bin/ssh", "-F", "/etc/ssh/ssh_config"]
CMD ["python", "-m", "SimpleHTTPServer", "5001"]
