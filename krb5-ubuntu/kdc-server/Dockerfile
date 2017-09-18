# Dockerfile - kdc-server
#
# see docker-compose.yml

FROM minimal-ubuntu

# python web server
COPY index.html .

# kerberos server
RUN apt install -y ntp krb5-admin-server krb5-kdc
COPY ./krb-conf/server/kdc.conf /etc/krb5kdc/kdc.conf
COPY ./krb-conf/server/kadm5.acl /etc/krb5kdc/kadm5.acl
COPY ./krb-conf/client/krb5.conf /etc/krb5.conf

# ssh client
RUN apt-get install -y openssh-client

# when container is starting
CMD ["service", "krb5-kdc", "start"]
CMD ["service", "krb5-admin-server", "start"]
CMD ["python", "-m", "SimpleHTTPServer", "5002"]
