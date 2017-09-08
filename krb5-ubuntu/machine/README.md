# README - krb5-machine

## Connect to machine docker container

~~~
docker exec -it krb5-machine bash
~~~

## Obtaining kerberos ticket

~~~
klist -f

# modify client configuration @ATHENA.MIT.EDU (default realm) by @EXAMPLE.COM  
kinit bob

klist -f

klist -kt

# kdestroy
~~~

## Connect to service

~~~
ssh -vvv bob@krb5-service.example.com
~~~