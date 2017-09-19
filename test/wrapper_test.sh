#!/usr/bin/env bash
#
# wrapper_test.sh
#
# usage: wrapper_test.sh log_file script args
#
# Wrap script to capture persisting traces for debugging.

cd "$(dirname "$0")"

source helper.sh

# check parameters

usage() {
  cat << EOF
usage: wrapper_test.sh log_file script [args]

  log_file : log file to write traces (create it if does not exist else
             append traces).
  script   : executable script to wrap.
  args     : script arguments (optional).
EOF
}

if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi

if [[ $# -lt 2 ]]; then
  die "ERROR: required at least 2 arguments!"
fi

log_file="$1"
script="$2"

if [[ -f "${log_file}" ]] && [[ ! -w "${log_file}" ]]; then
  die "ERROR: ${log_file} should exist with write permission!"
fi

if [[ ! -f "${script}" ]] || [[ ! -x "${script}" ]]; then
  die "ERROR: ${script} should exist with executable permission!"
fi

if [[ ! -f "${log_file}" ]]; then
  echo "${log_file} will be created"
fi

# script

stderr=$(mktemp)
stdout=$(mktemp)
start_time=$(date -u +"%s.%N")

("${script}" "${@:3}" 2> ${stderr} 1> ${stdout})
exit_status=$?

end_time=$(date -u +"%s.%N")
execution_time=$(echo ${end_time} - ${start_time} | bc)
cmd="${script} ${@:3}"

stdin="''"
if [[ ! -t 0 ]]; then
  stdin="'$(cat /dev/stdin)'"
fi

trace() {
  info "*** pid"
  echo "$$"
  info "*** user"
  echo "$(id)"
  info "*** command"
  echo "'${cmd}'"
  info "*** exit status"
  echo "${exit_status}"
  info "*** stdin"
  echo "${stdin}"
  info "*** stdout"
  echo "'$(cat "${stdout}")'"
  info "*** stderr"
  echo "'$(cat "${stderr}")'"
  info "*** execution time"
  echo "${execution_time} seconds"
}

# log
trace >> "${log_file}"

# preserve stdout, stderr and exit status
echo -n "$(cat "${stdout}")"
>&2 echo -n "$(cat "${stderr}")"
exit ${exit_status}
