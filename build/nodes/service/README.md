# README - krb5-service

## Connect to service docker container

~~~
docker exec -it krb5-service bash
~~~

## Change root password

~~~
passwd
--> password: root
~~~

## Create bob user

~~~
adduser bob
--> password: bob

mkdir -p /home/bob/

chown -R bob:bob /home/bob/
~~~

## Start ssh server

Start ssh server (options `-d -e` for debug):

~~~
/usr/sbin/sshd -f /etc/ssh/sshd_config
~~~

Note: In docker container sshd is not a service.  

Stop ssh server:

~~~
pkill sshd
~~~

See process:

~~~
ps -e
~~~

## See keytab

~~~
klist -kt
~~~
