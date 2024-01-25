#!/usr/bin/env bash

set -euxo pipefail
shopt -s inherit_errexit

# We cannot specify regular bind mounts for add-ons, so we have to use this trick.

# These functions were taken from
# https://github.com/felipecrs/docker-on-docker-shim/blob/90185d4391fb8863e1152098f07a95febbe79dba/dond#L158

function echo_error() {
  echo "ERROR:" "${@}" >&2
}

function error() {
  echo_error "${@}"
  exit 1
}

# Gets the current/parent container id on the host.
function set_container_id() {
  local result

  local mount_info_lines=()
  readarray -t mount_info_lines </proc/self/mountinfo
  for line in "${mount_info_lines[@]}"; do
    if [[ "${line}" =~ /([a-z0-9]{12,128})/resolv.conf" " ]]; then
      result="${BASH_REMATCH[1]}"
    fi
  done
  unset mount_info_lines

  # Sanity check
  if [[ "${result}" =~ ^[a-z0-9]{12,128}$ ]]; then
    readonly container_id="${result}"
  else
    error "Could not get parent container id"
  fi
}

# Gets the root directory of the current/parent container on the host
# filesystem.
function set_container_root_on_host() {
  local result

  result="$(
    docker inspect --format '{{.GraphDriver.Data.MergedDir}}' "${container_id}"
  )"

  # Sanity check
  if [[ "${result}" =~ ^(/[^/]+)+$ ]]; then
    readonly container_root_on_host="${result}"
  else
    error "Could not get parent container root on host"
  fi
}

set_container_id
set_container_root_on_host

# Mount /proc from host to /host/proc as readonly with nsenter
mkdir -p /host/proc
nsenter --target 1 --mount -- \
  mount --bind -o ro /proc "${container_root_on_host}/host/proc"

# Same for /sys
mkdir -p /host/sys
nsenter --target 1 --mount -- \
  mount --bind -o ro /sys "${container_root_on_host}/host/sys"

# Same for /etc/os-release
mkdir -p /host/etc
touch /host/etc/os-release
nsenter --target 1 --mount -- \
  mount --bind -o ro /etc/os-release "${container_root_on_host}/host/etc/os-release"

# Same for /etc/passwd
mkdir -p /host/etc
touch /host/etc/passwd
nsenter --target 1 --mount -- \
  mount --bind -o ro /etc/passwd "${container_root_on_host}/host/etc/passwd"

# Same for /etc/group
mkdir -p /host/etc
touch /host/etc/group
nsenter --target 1 --mount -- \
  mount --bind -o ro /etc/group "${container_root_on_host}/host/etc/group"

function get_config() {
  local -r name="$1"
  local value

  value=$(jq -r ".${name}" /data/options.json)

  if [[ "${value}" == "null" ]]; then
    value=""
  fi
  declare -g "${name}=${value}"
}

get_config netdata_claim_url
get_config netdata_claim_token
get_config netdata_claim_rooms
get_config netdata_extra_deb_packages
get_config netdata_healthcheck_target
export NETDATA_CLAIM_URL="${netdata_claim_url}"
export NETDATA_CLAIM_TOKEN="${netdata_claim_token}"
export NETDATA_CLAIM_ROOMS="${netdata_claim_rooms}"
export NETDATA_EXTRA_DEB_PACKAGES="${netdata_extra_deb_packages}"
export NETDATA_HEALTHCHECK_TARGET="${netdata_healthcheck_target}"

get_config hostname
hostname "${hostname}"

mkdir -p /config/netdata /etc/netdata
mount --bind /config/netdata /etc/netdata

mkdir -p /data/netdata-cache /var/cache/netdata
mount --bind /data/netdata-cache /var/cache/netdata

mkdir -p /data/netdata-lib /var/lib/netdata
mount --bind /data/netdata-lib /var/lib/netdata

exec /usr/sbin/run.sh
