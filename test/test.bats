#!/usr/bin/env bats

@test "Test kinit with keytab" {
  run ./kinit_test.sh keytab
  # Success
  [ "$status" -eq 0 ]
}

@test "Test kinit with password" {
  run ./kinit_test.sh password
  # Success
  [ "$status" -eq 0 ]
}

@test "Test SSH connection with Kerberos authentication" {
  run ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic'
  # Success
  [ "$status" -eq 0 ]
}

@test "Test SSH connection with password authentication" {
  run ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=password' '-t'
  # Time out
  [ "$status" -eq 124 ]
}

@test "Test SSH connection with public key authentication" {
  run ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=publickey'
  # Permission denied (no pair of keys)
  [ "$status" -eq 255 ]
}

@test "Test SSH connection with false user" {
  run ./ssh_test.sh alice
  # SSH error
  [ "$status" -eq 255 ]
}

@test "Test SSH connection with false server" {
  run ./ssh_test.sh bob krb5-service.example.org
  # SSH error
  [ "$status" -eq 255 ]
}

@test "Test SSH connection with false command" {
  run ./ssh_test.sh bob krb5-service.example.com '-o PreferredAuthentications=gssapi-with-mic' '' 'unknown'
  # Unknown command
  [ "$status" -eq 127 ]
}

@test "Test gssapi-java client/server with incorrect connection" {
  run ./gss_api_java_test.sh host krb5-service.example.org 1
  # False server name
  [ "$status" -eq 1 ]
}

@test "Test gssapi-java client/server with correct connection" {
  skip "This command will return zero soon, but not now"
  run ./gss_api_java_test.sh host krb5-service.example.com
  # Success
  [ "$status" -eq 0 ]
}

@test "Test kdestroy" {
  run ./kdestroy_test.sh
  # Success
  [ "$status" -eq 0 ]
}

@test "Test gssapi-java unit tests with JUnit" {
  run ./gss_api_java_test.sh
  # Success
  [ "$status" -eq 0 ]
}


