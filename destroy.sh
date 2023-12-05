#! /usr/env/bin bash
set -o nounset

# Declare home directory
declare -r SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"


cd "${SCRIPT_DIR}"/infrastructure/infra || exit 1


terraform destroy -auto-approve

cd ../backend_setup

terraform destroy -auto-approve

echo "Infrastructure Deleted"