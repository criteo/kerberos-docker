#!/usr/bin/env bash
# Useful if your kerberos installation uses service from /etc/init.d/.

# status|start|restart|reload|stop
action=${1:-start}

for script in /etc/init.d/krb5*; do 
  echo === $script $action ====
  $script $action;
done
