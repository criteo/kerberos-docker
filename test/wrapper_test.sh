#!/usr/bin/env bash
#
# wrapper_test.sh
#
# usage: wrapper_test.sh log_file script args

BLUE='\033[1;34m'
NC='\033[0m'

info() {
  echo -e "${BLUE}*** ${@}${NC}"
}

log_file="$1"
script="$2"

stderr=$(mktemp)
stdout=$(mktemp)
start_time=$(date -u +"%s.%N")

("${script}" "${@:3}" 2> ${stderr} 1> ${stdout})
exit_status=$?

end_time=$(date -u +"%s.%N")
execution_time=$(echo ${end_time} - ${start_time} | bc)

stdin="''"
if [[ ! -t 0 ]]; then
  stdin="'$(cat /dev/stdin)'"
fi

trace() {
  info "pid"
  echo "$$"
  info "user"
  echo "$(id)"
  info "command name"
  echo "'${cmd}'"
  info "args/options"
  echo "'${args}'"
  info "exit status"
  echo "${exit_status}"
  info "stdin"
  echo "${stdin}"
  info "stdout"
  echo "'$(cat "${stdout}")'"
  info "stderr"
  echo "'$(cat "${stderr}")'"
  info "execution time"
  echo "${execution_time} seconds"
}

# log
trace >> "${log_file}"

# preserve stdout, stderr and exit status
echo -n "$(cat "${stdout}")"
>&2 echo -n "$(cat "${stderr}")"
exit ${exit_status}
