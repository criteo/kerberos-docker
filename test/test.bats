#!/usr/bin/env bats
#
# test.bats
#
# usage: bats test.bats --trap (execute only in current directory)
#        Required: rm -vf "${LOG}"
#
# Run tests for whole project.
# To skip a test add this line at the beginning of related test:
# skip "This command will return zero soon, but not now"

source config.sh

# helper

message() {
  echo -e "${1}${@:1}${NC}" >> "${LOG}"
}

success() {
  message ${GREEN} "✓"
  true
}

failure() {
  message ${RED} "✗"
  false
}

# setup and teardown

setup() {
  message ${YELLOW} "=== $BATS_TEST_NUMBER) ${BATS_TEST_DESCRIPTION} ==="
}

teardown() {
  # nothing to do
  :
}

# set of tests

@test "Test kinit with keytab" {
  run ./wrapper_test.sh "$LOG" ./kinit_test.sh keytab
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test kinit with password" {
  run ./wrapper_test.sh "$LOG" ./kinit_test.sh password
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test SSH connection with Kerberos authentication" {
  run ./wrapper_test.sh "$LOG" ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic'
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test SSH connection with password authentication" {
  run ./wrapper_test.sh "$LOG" ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=password' '-t'
  # Time out
  [[ "$status" -eq 124 ]] || failure
  success
}

@test "Test SSH connection with public key authentication" {
  run ./wrapper_test.sh "$LOG" ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=publickey'
  # Permission denied (no pair of keys)
  [[ "$status" -eq 255 ]] || failure
  success
}

@test "Test SSH connection with false user" {
  run ./wrapper_test.sh "$LOG" ./ssh_test.sh alice
  # SSH error
  [[ "$status" -eq 255 ]] || failure
  success
}

@test "Test SSH connection with false server" {
  run ./wrapper_test.sh "$LOG" ./ssh_test.sh bob krb5-service.example.org
  # SSH error
  [[ "$status" -eq 255 ]] || failure
  success
}

@test "Test SSH connection with false command" {
  run ./wrapper_test.sh "$LOG" ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic' '' 'unknown'
  # Unknown command
  [[ "$status" -eq 127 ]] || failure
  success
}

@test "Test gssapi-java client/server with incorrect connection" {
  run ./wrapper_test.sh "$LOG" ./gss_api_java_test.sh host krb5-service.example.org 1
  # False server name
  [[ "$status" -eq 1 ]] || failure
  success
}

@test "Test gssapi-java client/server with correct connection" {
  run ./wrapper_test.sh "$LOG" ./gss_api_java_test.sh host krb5-service.example.com
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test kdestroy" {
  run ./wrapper_test.sh "$LOG" ./kdestroy_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test gssapi-java unit tests with JUnit" {
  run ./wrapper_test.sh "$LOG" ./gss_api_java_unit_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}
