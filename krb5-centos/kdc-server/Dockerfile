# Dockerfile - kdc-server
#
# see docker-compose.yml

FROM minimal-centos

# python web server
COPY index.html .

# kerberos server
RUN yum -y install ntp krb5-server krb5-libs
COPY ./krb-conf/server/kdc.conf /etc/krb5kdc/kdc.conf
COPY ./krb-conf/server/kadm5.acl /etc/krb5kdc/kadm5.acl
COPY ./krb-conf/client/krb5.conf /etc/krb5.conf
RUN mkdir -pv /var/log/kerberos/
RUN touch /var/log/kerberos/kadmin.log
RUN touch /var/log/kerberos/krb5lib.log
RUN kdb5_util create -r EXAMPLE.COM -s -P krb5

# supervisord
COPY ./supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
