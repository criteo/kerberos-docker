# Dockerfile - kdc-server
#
# see docker-compose.yml

FROM minimal-centos

# kerberos server
RUN yum -y install ntp krb5-server krb5-libs

# python web server configuration
COPY ./nodes/kdc-server/index.html .

# kerberos server configuration
RUN mkdir -pv /var/kerberos/krb5kdc/
COPY ./services/krb5/server/kdc.conf /var/kerberos/krb5kdc/kdc.conf
COPY ./services/krb5/server/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl
COPY ./services/krb5/client/krb5.conf /etc/krb5.conf
RUN mkdir -pv /var/log/kerberos/
RUN touch /var/log/kerberos/kadmin.log
RUN touch /var/log/kerberos/krb5lib.log
RUN kdb5_util create -r EXAMPLE.COM -s -P krb5

# supervisord configuration
COPY ./nodes/kdc-server/supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
