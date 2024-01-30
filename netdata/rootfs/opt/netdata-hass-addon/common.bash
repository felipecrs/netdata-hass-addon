set -euxo pipefail
shopt -s inherit_errexit

function echo_error() {
  echo "ERROR:" "${@}" >&2
}

function error() {
  echo_error "${@}"
  exit 1
}

function get_config() {
  local -r name="$1"
  local value

  value=$(jq -r ".${name}" /data/options.json)

  if [[ "${value}" == "null" ]]; then
    value=""
  fi
  declare -g "${name}=${value}"
}
