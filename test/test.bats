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

source helper.sh

# helper

success() {
  message ${GREEN} "✓" >> "${LOG}"
  true
} >> "$LOG"

failure() {
  message ${RED} "✗" >> "${LOG}"
  false
}

run_test() {
  run ./wrapper_test.sh "${LOG}" "$1" "${@:2}"
}

# setup and teardown

setup() {
  message ${YELLOW} "=== ${BATS_TEST_NUMBER}) ${BATS_TEST_DESCRIPTION} ===" \
     >> "$LOG"
}

teardown() {
  # nothing to do
  :
}

# set of tests

@test "Test kinit with keytab" {
  run_test ./kinit_test.sh keytab
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test kinit with password" {
  run_test ./kinit_test.sh password
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test SSH connection with Kerberos authentication" {
  run_test ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic'
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test SSH connection with password authentication" {
  run_test ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=password' '-t'
  # Time out
  [[ "$status" -eq 124 ]] || failure
  success
}

@test "Test SSH connection with public key authentication" {
  run_test ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=publickey'
  # Permission denied (no pair of keys)
  [[ "$status" -eq 255 ]] || failure
  success
}

@test "Test SSH connection with false user" {
  run_test ./ssh_test.sh alice
  # SSH error
  [[ "$status" -eq 255 ]] || failure
  success
}

@test "Test SSH connection with false server" {
  run_test ./ssh_test.sh bob krb5-service.example.org
  # SSH error
  [[ "$status" -eq 255 ]] || failure
  success
}

@test "Test SSH connection with false command" {
  run_test ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic' '' 'unknown'
  # Unknown command
  [[ "$status" -eq 127 ]] || failure
  success
}

@test "Test gssapi-java client/server with incorrect connection" {
  run_test ./gss_api_java_test.sh host krb5-service.example.org 1
  # False server name
  [[ "$status" -eq 1 ]] || failure
  success
}

@test "Test gssapi-java client/server with correct connection" {
  run_test ./gss_api_java_test.sh host krb5-service.example.com
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test kdestroy" {
  run_test ./kdestroy_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test gssapi-java unit tests with JUnit" {
  run_test ./gss_api_java_unit_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test make targets: status start stop restart usage" {
  run_test ./make_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test service is running after restarting docker containers" {
  run_test ./restart_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test interaction with kerberos docker cluster via host machine directly" {
  run_test ./dev_local_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}
