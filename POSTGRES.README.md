# README - Connect to Postgres with Kerberos authentication

Kerberos/Docker is a project to run easily a **MIT Kerberos V5** architecture in a cluster of **docker containers**. It is really useful for running integration tests of projects using Kerberos or for learning and testing Kerberos solutions and administration.

## Prerequisites

Use an **operating system compatible with docker**, and install:  
- **docker-ce** (without `sudo` for running the docker command and with `overlay2` driver).  
- **docker-compose**
- **GNU Make** (if not already available).  
- **GNU Bash** (if not already available).

## Usage

After installation, there are 3 containers with a web server on each one to check if it turns:

- `krb5-machine-example-com`
- `krb5-kdc-server-example-com`
- `krb5-service-example-com`

You can connect from `krb5-machine-example-com` to `krb5-service-example-com` with psql command and Kerberos authentication (using GSSAPIAuthentication). For example:

```bash
docker exec -it krb5-machine-example-com /bin/bash
psql -h krb5-service-example-com -U "postgres/krb5-service-example-com.example.com" -d postgres
```

You can also connect to the postgresql server on the machine which configure the Kerberos client and credentials correctly. For example:

Modify your `/etc/hosts` to resolve bidirectionally IP addresses with DNS of
the Kerberos cluster:

~~~
# /etc/hosts
# ...

# Kerberos cluster
# IP FQDN hostname
10.5.0.1	krb5-machine-example-com.example.com krb5-machine-example-com
10.5.0.2	krb5-kdc-server-example-com.example.com krb5-kdc-server-example-com
10.5.0.3	krb5-service-example-com.example.com krb5-service-example-com

# ...
~~~

```bash
sudo apt install -y ntp krb5-config krb5-user
cp build-ubuntu-example.com/services/krb5/client/krb5.conf /etc/krb5.conf
docker cp krb5-kdc-server-example-com:/etc/postgres-server-krb5.keytab postgres-server-krb5.keytab
kinit -kt postgres-server-krb5.keytab postgres/krb5-service-example-com.example.com@EXAMPLE.COM
psql -h krb5-service-example-com -U "postgres/krb5-service-example-com.example.com" -d postgres
```

Here cluster architecture:

<p align="center">
  <img src="./doc/kerberos-docker-architecture.png" width=700/>
</p>


## Installation

Execute:

~~~
make install
~~~

It will use the `./build-ubuntu-example-com` folder, with docker containers under `Ubuntu` and with the kerberos realm `EXAMPLE.COM`.
If you want to use another OS for the docker containers and/or other  Kerberos realm, you need to use `make gen-conf` see `Prerequisites` section.

See `Makefile` with `make usage` for all commands.

## Uninstallation

Execute:

~~~
make clean
~~~

To delete `network-analyser`, do `./network-analyser/clean-network-analyser.sh`.

For Ubuntu operating system on the docker container:

To delete `ubuntu:22.04` and `minimal-ubuntu:latest` docker images do `docker rmi ubuntu:22.04 minimal-ubuntu`.
