#!/bin/bash

# Static parameters
WORKSPACE=$(
  cd $(dirname "$0")
  pwd
)

BOX_PLAYBOOK=$WORKSPACE/box.yml
BOX_NAME=${BOX_NAME:-unnamed_oops_box}
BOX_ADDRESS=$REMOTE_HOST
BOX_USER=${BOX_DEPLOY_USER:-ubuntu}
BOX_PWD=$BOX_DEPLOY_PASS
BOX_PROVIDER=${BOX_PROVIDER:-}
ENVIRONMENT=${ENVIRONMENT:-default}
BOX_TARGET=${BOX_TARGET:-$(grep "hosts:" $BOX_PLAYBOOK | head -1 | awk {'print $3'})}

################################################################################

# Write safe shell scripts
set -euf -o pipefail
# Keep environment clean
export LC_ALL="C"
# Set variables
readonly TMP_DIR="/tmp"
readonly TMP_OUTPUT="${TMP_DIR}/$$.out"
readonly TMP_INVENTORY="${TMP_DIR}/$$.inventory"
readonly BASE_DIR="$(dirname "$(realpath "$0")")"
readonly MY_NAME="${0##*/}"
# Colours
readonly C_NOC="\\033[0m"    # No colour
readonly C_RED="\\033[0;31m" # Red
readonly C_GRN="\\033[0;32m" # Green
readonly C_BLU="\\033[0;34m" # Blue
readonly C_PUR="\\033[0;35m" # Purple
readonly C_CYA="\\033[0;36m" # Cyan
readonly C_WHI="\\033[0;37m" # White
### Helper functions
print_red () { local i; for i in "$@"; do echo -e "${C_RED}${i}${C_NOC}"; done }
print_grn () { local i; for i in "$@"; do echo -e "${C_GRN}${i}${C_NOC}"; done }
print_blu () { local i; for i in "$@"; do echo -e "${C_BLU}${i}${C_NOC}"; done }
print_pur () { local i; for i in "$@"; do echo -e "${C_PUR}${i}${C_NOC}"; done }
print_cya () { local i; for i in "$@"; do echo -e "${C_CYA}${i}${C_NOC}"; done }
print_whi () { local i; for i in "$@"; do echo -e "${C_WHI}${i}${C_NOC}"; done }

# Cleanup on exit
trap 'rm -rf ${TMP_OUTPUT} ${TMP_INVENTORY}' \
  EXIT SIGHUP SIGINT SIGQUIT SIGPIPE SIGTERM


if [[ -d $BOX_ADDRESS ]]; then
    echo "$BOX_ADDRESS supposed to be directory based inventory"
                BOX_INVENTORY=$BOX_ADDRESS
elif [[ -f $BOX_ADDRESS ]]; then
    echo "$BOX_ADDRESS supposed to be file based inventory"
                BOX_INVENTORY=$BOX_ADDRESS
else
    echo "$BOX_ADDRESS supposed to be direct address of the host, generating temporary inventory"
    BOX_INVENTORY=$TMP_INVENTORY
    echo "[${BOX_TARGET}]" > $TMP_INVENTORY
    echo "${BOX_ADDRESS} ansible_user=${BOX_USER} ansible_password=${BOX_PWD}" >> $TMP_INVENTORY
    cat $TMP_INVENTORY
fi

ansible-playbook $BOX_PLAYBOOK \
-v \
-i $BOX_INVENTORY \
-e box_address="${BOX_ADDRESS}" \
-e box_provider=$BOX_PROVIDER \
-e env=$ENVIRONMENT

# --tags "configuration,packages"
# --skip-tags "packages"
