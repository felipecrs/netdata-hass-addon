#!/usr/bin/env bash

function get_config() {
  local -r name="$1"
  local value

  value=$(jq -r ".${name}" /data/options.json)

  if [[ "${value}" == "null" ]]; then
    value=""
  fi
  declare -g "${name}=${value}"
}

get_config netdata_healthcheck_target
export NETDATA_HEALTHCHECK_TARGET="${netdata_healthcheck_target}"

# Call netdata docker health check
exec /usr/sbin/health.sh
