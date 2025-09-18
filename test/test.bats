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

# HELPER

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

run_test_failure() {
  bats_require_minimum_version 1.5.0
  failure_code=$1
  run -$1 ./wrapper_test.sh "${LOG}" "$2" "${@:3}"
}

# SETUP AND TEARDOWN

setup() {
  message ${YELLOW} "=== ${BATS_TEST_NUMBER}) ${BATS_TEST_DESCRIPTION} ===" \
     >> "$LOG"
  # force to start the docker clusters
  ./docker_start.sh
}

teardown() {
  # nothing to do
  :
}

# SET OF TESTS

# TEST: operation system

@test "Test if correct os on kerberos cluster of docker containers: ${OS_CONTAINER}" {
  run_test ./os_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

# TEST: kerberos features

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

@test "Test kvno" {
  run_test ./kvno_test.sh
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

# TEST: ssh with kerberos

@test "Test SSH connection with Kerberos authentication" {
  ./kinit_test.sh keytab
  run_test ./ssh_test.sh bob krb5-service-example-com.example.com '-o PreferredAuthentications=gssapi-with-mic'
  # Success
  [[ "$status" -eq 0 ]] || failure
  ./kdestroy_test.sh
  success
}

@test "Test SSH connection with password authentication" {
  run_test ./ssh_test.sh bob krb5-service-example-com.example.com '-o PreferredAuthentications=password' '-t'
  # Time out
  [[ "$status" -eq 124 ]] || failure
  success
}

@test "Test SSH connection with public key authentication" {
  run_test ./ssh_test.sh bob krb5-service-example-com.example.com '-o PreferredAuthentications=publickey'
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
  ./kinit_test.sh keytab
  run_test ./ssh_test.sh bob krb5-service-example-com.example.org
  # SSH error
  [[ "$status" -eq 255 ]] || failure
  ./kdestroy_test.sh
  success
}

@test "Test SSH connection with false command" {
  ./kinit_test.sh keytab
  # shellcheck disable=SC2086
  run_test_failure 127 ./ssh_test.sh bob krb5-service-example-com.example.com '-o PreferredAuthentications=gssapi-with-mic' '' 'unknown'
  # Unknown command
  [[ "$status" -eq 127 ]] || failure
  ./kdestroy_test.sh
  success
}

# TEST: gssapi with kerberos in java

@test "Test gssapi-java client/server with incorrect connection" {
  skip
  run_test ./gss_api_java_test.sh host krb5-service-example-org 1
  # False server name
  [[ "$status" -eq 1 ]] || failure
  success
}

@test "Test gssapi-java client/server with correct connection" {
  skip
  run_test ./gss_api_java_test.sh host krb5-service-example-com
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test gssapi-java unit tests with JUnit" {
  skip
  run_test ./gss_api_java_unit_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

# TEST: makefile

@test "Test make targets: status start stop restart usage" {
  run_test ./make_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

# TEST: docker with kerberos

@test "Test service is running after restarting docker containers" {
  skip
  run_test ./restart_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test interaction with kerberos docker cluster via host machine directly" {
  if [[ "${TEST_ON_HOST_MACHINE}" != "yes" ]]; then
    skip
  fi
  run_test ./dev_local_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}

@test "Test build other kdc" {
  skip
  run_test ./build_other_kdc_test.sh
  # Success
  [[ "$status" -eq 0 ]] || failure
  success
}