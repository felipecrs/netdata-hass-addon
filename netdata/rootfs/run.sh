#!/usr/bin/env bash

set -euo pipefail

function get_config() {
    local -r name="$1"
    local value

    value=$(jq -r ".${name}" /data/options.json)

    if [[ "${value}" == "null" ]]; then
        value=""
    fi
    declare -g "${name}=${value}"
}

set -x

get_config netdata_claim_url
get_config netdata_claim_token
get_config netdata_claim_rooms
export NETDATA_CLAIM_URL="${netdata_claim_url}"
export NETDATA_CLAIM_TOKEN="${netdata_claim_token}"
export NETDATA_CLAIM_ROOMS="${netdata_claim_rooms}"

get_config hostname
hostname "${hostname}"

mkdir -p /config/netdata /etc/netdata
mount --bind /config/netdata /etc/netdata

mkdir -p /data/netdata-cache /var/cache/netdata
mount --bind /data/netdata-cache /var/cache/netdata

mkdir -p /data/netdata-lib /var/lib/netdata
mount --bind /data/netdata-lib /var/lib/netdata

exec /usr/sbin/run.sh
