# README - Kerberos/Docker

[![Build status](https://github.com/criteo/kerberos-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/criteo/kerberos-docker/actions/workflows/ci.yml)

Kerberos/Docker is a project to easily run a **MIT Kerberos V5** architecture in a cluster of **Docker containers**. It is beneficial for running integration tests on projects using Kerberos, as well as for learning and testing Kerberos solutions and administration.

<p align="center">
  <img src="./doc/kerberos-docker-logo.png" width=200/>
</p>

See: [MIT Kerberos V5](https://web.mit.edu/kerberos/) and [Docker](https://www.docker.com/).

## Prerequisites

Use an **operating system compatible with docker**, and install:  
- **Docker engine** (without `sudo` for running the Docker command and with `overlay2` driver).  
- **Docker compose**
- [GNU Make](https://www.gnu.org/software/make/make.html) (if not already available).  
- [GNU Bash](https://www.gnu.org/software/bash/bash.html) (if not already available).

Only if you want to generate other Docker configurations, install:
- **Python 3** (if not already available, with `pip` and `venv`).

Only if you want to use Java on your host machine:
- **Java 8 and Maven 3** (if not already available).  

To check the compatible version, see the traces of the `Check version` on GitHub actions (CI) web interface, see [here](https://github.com/criteo/kerberos-docker/actions).  

To run tests, install [Bats](https://github.com/bats-core/bats-core), see `./.ci/install.sh`.

Note:
- For Linux and macOS workstations, it works on all distributions. 
- For Windows workstation, it works on [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) 
with Ubuntu, but connect to the Docker container to interact with the Kerberos server. 

## Usage

After installation, there are three containers with a web server on each one to check if it turns:

- `krb5-machine-example-com`
- `krb5-kdc-server-example-com`
- `krb5-service-example-com`

The goal is to connect from `krb5-machine-example-com` to `krb5-service-example-com` with SSH and Kerberos authentication (using GSSAPIAuthentication).

Here cluster architecture:

<p align="center">
  <img src="./doc/kerberos-docker-architecture.png" width=700/>
</p>


## Installation

Execute:

~~~
make install
~~~

It will use the `./build-ubuntu-example-com` folder, with Docker containers under `Ubuntu` and with the Kerberos realm `EXAMPLE.COM`.
If you want to use another OS for the Docker containers and/or other Kerberos realm, you need to use `make gen-conf`, see the `Prerequisites` section.

See `Makefile` with `make usage` for all commands.

## Uninstallation

Execute:

~~~
make clean
~~~

To delete `network-analyser`, do `./network-analyser/clean-network-analyser.sh`.

For the Ubuntu operating system in the Docker container:

To delete `ubuntu:22.04` and `minimal-ubuntu:latest` Docker images, do `docker rmi ubuntu:22.04 minimal-ubuntu`.

## Test

This project is tested with
[Bash Automated Testing System (BATS)](https://github.com/bats-core/bats-core).


After installing `BATS` (see version in Prerequisites part) and the environment of containers to test, do: 

~~~
make test
~~~

##  Continuous Integration (CI)

This project uses continuous integration with [GitHub Actions](https://github.com/features/actions).  

See all the workflow runs on the CI, [here](https://github.com/criteo/kerberos-docker/actions/workflows/ci.yml).


## Network analyzer

You can create a [Wireshark](https://www.wireshark.org/) instance running in a Docker container built from a Docker image named `network-analyser`.

See more details in `./network-analyser/README.md`.

## Debug and see traces

You can connect with an interactive session to a Docker container:

~~~
docker exec -it <container_name_or_id> bash
~~~

To debug Kerberos client or server:

~~~
export KRB5_TRACE=/dev/stdout
~~~

To debug the SSH client:

~~~~
ssh -vvv username@host
~~~~

To debug the ssh server:

~~~~
/usr/sbin/sshd -f /etc/ssh/sshd_config -d -e
~~~~

## Troubleshooting

**Kerberos services**

On `krb5-kdc-server-example-com` Docker container, there are 2 Kerberos services `krb5-admin-service` and `krb5-kdc`:

~~~
supervisorctl status
~~~

See all opened ports on a machine:

~~~
netstat -tulpn
~~~


Check that each machine has a synchronized time (with `ntp` protocol and `date` to check).

See [Troubleshooting](https://web.mit.edu/kerberos/krb5-latest/doc/admin/troubleshoot.html) and
[Kerberos reserved ports](https://web.mit.edu/kerberos/krb5-1.5/krb5-1.5.4/doc/krb5-admin/Configuring-Your-Firewall-to-Work-With-Kerberos-V5.html).

**Conflict private IP addresses**

To create `example.com` network Docker, the private sub-network `10.5.0.0/24`
should be free and private IP addresses `10.5.0.0/24` should be free also. Check
your routing table with `route -n`, test free IP addresses with
`ping -c 1 -w 2 <host>`, and check request paths with `traceroute <host>`.

If the issue persists, you can do `make clean` or `docker network rm example.com`.

**Working on your computer (host machine) for debugging code**

Modify your `/etc/hosts` to resolve bidirectionally IP addresses with the DNS of the Kerberos cluster:

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

You can `ping krb5-kdc-server-example-com|10.5.0.2` Kerberos KDC server, and check if
Kerberos server port is opened: `nmap -A 10.5.0.2/32 -p 88` (or if SSH
server port: `nmap -A 10.5.0.3/32 -p 22`).

Now you can debug code and do `kinit bob` on the host machine directly.

The order of `entries` and `names` is essential in `/etc/hosts`.
To resolve a name from an IP address, the resolver takes the first one (horizontally) if multiple names
are possible; and to resolve IP address from the name, the resolver takes the first entry (vertically)
if multiple IP addresses are possible: You can use `resolveip <IP|name>`, `getent hosts <IP|name>`
Or take a look at `/etc/hosts`.

## Possible improvements

* Add LDAP as a database for the Kerberos architecture
* Add other connectors and services (PostgreSQL, MongoDB, nfs, Hadoop), only OpenSSH for the moment
* Add Java, Python, or C to connect with Kerberos authentication

## References

* ROBINSON Trevor (eztenia). **Kerberos**. Canonical Ltd. Ubuntu Article, November 2014. Link: https://help.ubuntu.com/community/Kerberos.
* MIGEON Jean. **Protocol, Installation and Single Sign On, The MIT Kerberos Admnistrator's how-to Guide**. MIT Kerberos Consortium, July 2008. p 62.
* BARRETT Daniel, SILVERMAN Richard, BYRNES Robert. **SSH, The Secure Shell: The Definitive Guide, 2nd Edition**. O'Reilly Media, June 2009. p. 672. Notes: Chapter 11. ISBN-10: 0596008953, ISBN-13: 978-0596008956
* GARMAN, Jason. **Kerberos: The Definitive Guide, 2nd Edition**. O'Reilly Media, March 2010. p. 272.  ISBN-10: 0596004036, ISBN-13: 978-0596004033.
* O’MALLEY Owen, ZHANG Kan, RADIA Sanjay, MARTI Ram, and HARRELL Christopher. **Hadoop Security Design**. Yahoo! Research Paper, October 2009. p 19.
*  MATTHIAS Karl, KANE Sean. **Docker: Up & Running**. O'Reilly Media, June 2015. p. 232. ISBN-10: 1491917571, ISBN-13: 978-1491917572.
