# README - dev-local

Required:  

- Using ubuntu operating system  
- Having installed and initialized kerberos cluster of docker containers  

To develop your application with Kerberos authentication via host machine
(directly from your desktop without connecting to a container) by using
kerberos cluster of docker containers:  

1. Install kerberos client `sudo apt-get install krb5-user`
2. Copy/Past keytab `bob.keytab` of user principal name `bob@EXAMPLE.COM`
to `/etc/bob.keytab` with `rw-------` permission and owner/group like current
user.
3. Copy/Past client kerberos configuration `krb5.conf` to `/etc/krb5.conf`
(modify `KRB5_CONFIG` if you should choose other location if you multiple 
configuration)
4. Update `/etc/hosts` with private IP addresses of kerberos cluster of
docker containers to have resolution name (with reverse resolution name).
5. Modify your SSH config to authorize GSS API authentication and credentials.

You can use `init_env_dev.sh` script.
