# Dockerfile - kdc-server
#
# see docker-compose.yml

FROM minimal-centos

# kerberos server
RUN yum -y install ntp krb5-server krb5-libs

# python web server configuration
COPY ./nodes/kdc-server/index.html .

# kerberos server configuration
ENV KRB5_CONFIG=/etc/krb5.conf
ENV KRB5_KDC_PROFILE=/var/kerberos/krb5kdc/kdc.conf
RUN mkdir -pv /var/kerberos/krb5kdc/
COPY ./services/krb5/server/kdc.conf /var/kerberos/krb5kdc/kdc.conf
COPY ./services/krb5/server/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl
COPY ./services/krb5/client/krb5.conf /etc/krb5.conf
RUN mkdir -pv /var/log/kerberos/
RUN touch /var/log/kerberos/kadmin.log
RUN touch /var/log/kerberos/krb5lib.log
RUN touch /var/log/kerberos/krb5.log
RUN kdb5_util -r {{REALM_KRB5}} -P {{PREFIX_KRB5}} create -s

# supervisord configuration
COPY ./nodes/kdc-server/supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
