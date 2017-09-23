# usage: source config.sh

# Kerberos environment variables of MIT implmentation 
export KRB5_CONFIG="/etc/krb5-dev.conf"
export KRB5CCNAME="/tmp/krb5cc_$(id -u)-dev"
export KRB5_TRACE=/dev/stderr

# other environment variables
export KEYTAB="/etc/bob.keytab"
