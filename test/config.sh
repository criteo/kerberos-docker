# usage: source config.sh
#
# environment variables

\pushd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null
\pushd .. > /dev/null
\source .env.values
\popd > /dev/null
\popd > /dev/null

\readonly LOG="/tmp/krb5-test-${OS_CONTAINER}.log"

# color

\readonly BLUE='\033[1;34m'
\readonly YELLOW="\033[1;33m"
\readonly GREEN="\033[1;32m"
\readonly RED="\033[1;31m"
\readonly NC="\033[0m"
