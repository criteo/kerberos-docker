# Dockerfile - kdc-server
#
# see docker-compose.yml

FROM minimal-ubuntu

# kerberos server
RUN apt install -y ntp krb5-admin-server krb5-kdc

# python web server configuration
COPY ./nodes/kdc-server/index.html .

# kerberos server configuration
COPY ./services/krb5/server/kdc.conf /etc/krb5kdc/kdc.conf
COPY ./services/server/kadm5.acl /etc/krb5kdc/kadm5.acl
COPY ./services/client/krb5.conf /etc/krb5.conf
RUN mkdir -pv /var/log/kerberos/
RUN touch /var/log/kerberos/kadmin.log
RUN touch /var/log/kerberos/krb5lib.log
RUN echo "krb5\nkrb5" | krb5_newrealm

# supervisord
COPY ./nodes/kdc-server/supervisord.conf /etc/supervisord.conf

# when container is starting
CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
