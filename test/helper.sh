# usage: source helper.sh
#
# helper functions

source config.sh

message() {
  echo -e "${1}${@:1}${NC}"
}

info() {
  message "${BLUE}" "$@"
}

die() {
  >&2 echo "$@"
  exit 1
}


