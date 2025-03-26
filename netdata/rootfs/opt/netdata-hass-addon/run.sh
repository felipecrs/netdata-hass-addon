#!/usr/bin/env bash

# shellcheck source=./common.bash
source /opt/netdata-hass-addon/common.bash

# We cannot specify regular bind mounts for add-ons, so we have to use this trick.

# These functions were taken from
# https://github.com/felipecrs/docker-on-docker-shim/blob/90185d4391fb8863e1152098f07a95febbe79dba/dond#L158

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

if [[ ! -d /config/netdata && -d /homeassistant/netdata ]]; then
  echo "Migrating Netdata configuration files out of Home Assistant config directory..." >&2
  mv -fv /homeassistant/netdata /config/
fi

# This is a trick to mount host directories and files inside the container,
# given HA add-ons cannot specify bind mounts.
if ! mountpoint --quiet /host/etc/os-release; then
  set_container_id
  set_container_root_on_host

  # Mount /proc from host to /host/proc as readonly with nsenter
  mkdir -p /host/proc
  nsenter --target 1 --mount -- \
    mount --bind --read-only /proc "${container_root_on_host}/host/proc"

  # Same for /sys
  mkdir -p /host/sys
  nsenter --target 1 --mount -- \
    mount --bind --read-only /sys "${container_root_on_host}/host/sys"

  # Same for /etc/passwd
  mkdir -p /host/etc
  touch /host/etc/passwd
  nsenter --target 1 --mount -- \
    mount --bind --read-only /etc/passwd "${container_root_on_host}/host/etc/passwd"

  # Same for /etc/group
  mkdir -p /host/etc
  touch /host/etc/group
  nsenter --target 1 --mount -- \
    mount --bind --read-only /etc/group "${container_root_on_host}/host/etc/group"

  # Same for /etc/localtime
  mkdir -p /host/etc
  touch /host/etc/localtime
  nsenter --target 1 --mount -- \
    mount --bind --read-only /etc/localtime "${container_root_on_host}/host/etc/localtime"

  # Same for /etc/os-release
  mkdir -p /host/etc
  touch /host/etc/os-release
  nsenter --target 1 --mount -- \
    mount --bind --read-only /etc/os-release "${container_root_on_host}/host/etc/os-release"

  docker restart "${container_id}"
  exit 143
fi

get_config netdata_claim_url
get_config netdata_claim_token
get_config netdata_claim_rooms
get_config netdata_extra_deb_packages
# shellcheck disable=SC2154
export NETDATA_CLAIM_URL="${netdata_claim_url}"
# shellcheck disable=SC2154
export NETDATA_CLAIM_TOKEN="${netdata_claim_token}"
# shellcheck disable=SC2154
export NETDATA_CLAIM_ROOMS="${netdata_claim_rooms}"
# shellcheck disable=SC2154
export NETDATA_EXTRA_DEB_PACKAGES="${netdata_extra_deb_packages}"

get_config hostname
# shellcheck disable=SC2154
hostname "${hostname}"

mkdir -p /config/netdata /etc/netdata
mount --bind /config/netdata /etc/netdata

mkdir -p /data/netdata-cache /var/cache/netdata
mount --bind /data/netdata-cache /var/cache/netdata

mkdir -p /data/netdata-lib /var/lib/netdata
mount --bind /data/netdata-lib /var/lib/netdata

exec /usr/sbin/run.sh
