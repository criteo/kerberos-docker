# README - krb5-kdc-server

## Connect to krb5-kdc-server docker container

~~~
docker exec -it krb5-kdc-server bash
~~~

## Init kerberos server

~~~
krb5_newrealm  
--> password: krb5
~~~

~~~
service krb5-admin-server status  
-->  * kadmind is running 
~~~

~~~
service krb5-kdc status  
-->  * krb5kdc is running  
~~~

## Add alice and bob users

~~~
kadmin.local

kadmin.local: addprinc -policy admin alice/admin  
--> password: alice

kadmin.local: addprinc -policy user bob  
--> password: bob

kadmin.local: quit
~~~

## Add service

~~~
kadmin.local

// service/host.fqdn@REALM.NAME
kadmin.local: addprinc -randkey host/krb5-service.example.com[@EXAMPLE.COM]  

kadmin.local: ktadd -k /etc/krb5-service.keytab host/krb5-service.example.com[@EXAMPLE.COM]  

kadmin.local: listprincs

kadmin.local: quit
~~~

## Send keytab to service

~~~
scp /etc/krb5-service.keytab root@krb5-service.example.com:/etc/krb5.keytab
~~~
