#!/usr/local/bin/bats --tap
#
# test.bats
#
# usage: bats test.bats --trap (execute only in current directory)
#        required: rm -vf "/tmp/bats.log"
#
# Run tests for whole project.

LOG="/tmp/bats.log"

_setup_first() {
  echo -n '' > $LOG
}

_setup() {
  echo "=== $BATS_TEST_NUMBER) $BATS_TEST_DESCRIPTION ===" >> $LOG
}

_teardown() {
  echo -e "*** exit status:\n $status" >> $LOG
  echo -e "*** stdout:\n $output" >> $LOG
  echo -e "*** stderr:\n $error" >> $LOG
}

@test "Test kinit with keytab" {
  _setup_first
  _setup
  run ./kinit_test.sh keytab
  # Success
  [[ "$status" -eq 0 ]]
  _teardown
}

@test "Test kinit with password" {
  _setup
  run ./kinit_test.sh password
  # Success
  [[ "$status" -eq 0 ]]
  _teardown
}

@test "Test SSH connection with Kerberos authentication" {
  _setup
  run ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic'
  # Success
  [[ "$status" -eq 0 ]]
  _teardown
}

@test "Test SSH connection with password authentication" {
  _setup
  run ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=password' '-t'
  # Time out
  #[ "$status" -eq 124 ]]
  _teardown
}

@test "Test SSH connection with public key authentication" {
  _setup
  run ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=publickey'
  # Permission denied (no pair of keys)
  [[ "$status" -eq 255 ]]
  _teardown
}

@test "Test SSH connection with false user" {
  _setup
  run ./ssh_test.sh alice
  # SSH error
  [[ "$status" -eq 255 ]]
  _teardown
}

@test "Test SSH connection with false server" {
  _setup
  run ./ssh_test.sh bob krb5-service.example.org
  # SSH error
  [[ "$status" -eq 255 ]]
  _teardown
}

@test "Test SSH connection with false command" {
  _setup
  run ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic' '' 'unknown'
  # Unknown command
  [[ "$status" -eq 127 ]]
  _teardown
}

@test "Test gssapi-java client/server with incorrect connection" {
  _setup
  run ./gss_api_java_test.sh host krb5-service.example.org 1
  # False server name
  [[ "$status" -eq 1 ]]
  _teardown
}

@test "Test gssapi-java client/server with correct connection" {
  _setup
  # skip "This command will return zero soon, but not now"
  run ./gss_api_java_test.sh host krb5-service.example.com
  # Success
  [[ "$status" -eq 0 ]]
  _teardown
}

@test "Test kdestroy" {
  _setup
  run ./kdestroy_test.sh
  # Success
  [[ "$status" -eq 0 ]]
  _teardown
}

@test "Test gssapi-java unit tests with JUnit" {
  _setup
  run ./gss_api_java_test.sh
  # Success
  [[ "$status" -eq 0 ]]
  _teardown
}
