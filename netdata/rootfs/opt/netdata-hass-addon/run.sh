#!/usr/bin/env bash

# shellcheck source=./common.bash
source /opt/netdata-hass-addon/common.bash

docker_sock='/var/run/docker.sock'

# Gets the current/parent container id on the host.
# Originally taken from https://github.com/felipecrs/docker-on-docker-shim/blob/90185d4391fb8863e1152098f07a95febbe79dba/dond
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

# Gets the root directory of the current/parent container on the host filesystem.
# Originally taken from https://github.com/felipecrs/docker-on-docker-shim/blob/90185d4391fb8863e1152098f07a95febbe79dba/dond
function set_container_root_on_host() {
  local result

  result="$(
    curl --fail-with-body --silent --show-error --unix-socket "${docker_sock}" "http://localhost/containers/${container_id}/json" |
      jq --exit-status --raw-output '.GraphDriver.Data.MergedDir'
  )"

  # Sanity check
  if [[ "${result}" =~ ^(/[^/]+)+$ ]]; then
    readonly container_root_on_host="${result}"
  else
    error "Could not get parent container root on host"
  fi
}

echo "Setting up Netdata add-on..." >&2

if [[ ! -S "${docker_sock}" ]]; then
  error "This add-on needs 'Protection mode' to be disabled in the add-on page"
fi

# We cannot specify arbitrary volume mounts for add-ons, so we have to use this trick.
if ! mountpoint --quiet /host/etc/os-release; then
  echo "Setting up /host mounts..." >&2

  set_container_id
  set_container_root_on_host

  set -x

  # Mount /proc from host to /host/proc as readonly with nsenter
  mkdir -p /host/proc
  nsenter --target 1 --mount -- \
    mount --bind --read-only /proc "${container_root_on_host}/host/proc"

  # Same for /sys and /sys/fs/cgroup
  mkdir -p /host/sys
  nsenter --target 1 --mount -- \
    mount --bind --read-only /sys "${container_root_on_host}/host/sys"
  nsenter --target 1 --mount -- \
    mount --bind --read-only /sys/fs/cgroup "${container_root_on_host}/host/sys/fs/cgroup"

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

  set +x

  # Restart this container
  echo "Restarting this container so that the new mounts take effect..." >&2
  curl --fail-with-body --silent --show-error --unix-socket "${docker_sock}" -X POST "http://localhost/containers/${container_id}/restart"
  exit 143
fi

if [[ ! -d /config/netdata && -d /homeassistant/netdata ]]; then
  echo "Migrating Netdata configuration files out of Home Assistant config directory..." >&2
  mv -fv /homeassistant/netdata /config/
fi

# https://github.com/home-assistant/supervisor/issues/3223
echo "Cleaning up old Netdata images if any..." >&2
curl --fail-with-body --silent --show-error --unix-socket "${docker_sock}" http://localhost/images/json |
  jq --raw-output '.[] | select(.RepoTags != null) | select(.RepoTags[] | test("netdata/netdata|ghcr.io/netdata/netdata")) | .Id' |
  xargs -r -I {} -t -- curl --silent --show-error --unix-socket "${docker_sock}" -X DELETE "http://localhost/images/{}"

echo "Setting up Netdata directories..." >&2
set -x
mkdir -p /config/netdata /etc/netdata
mount --bind /config/netdata /etc/netdata

mkdir -p /data/netdata-cache /var/cache/netdata
mount --bind /data/netdata-cache /var/cache/netdata

mkdir -p /data/netdata-lib /var/lib/netdata
mount --bind /data/netdata-lib /var/lib/netdata
set +x

echo "Handling Netdata add-on configuration..." >&2
get_config hostname
hostname "${hostname:?}"

get_config netdata_claim_url
if [[ -n "${netdata_claim_url}" ]]; then
  export NETDATA_CLAIM_URL="${netdata_claim_url}"
fi

get_config netdata_claim_token
if [[ -n "${netdata_claim_token}" ]]; then
  export NETDATA_CLAIM_TOKEN="${netdata_claim_token}"
fi

get_config netdata_claim_rooms
if [[ -n "${netdata_claim_rooms}" ]]; then
  export NETDATA_CLAIM_ROOMS="${netdata_claim_rooms}"
fi

get_config netdata_extra_deb_packages
if [[ -n "${netdata_extra_deb_packages}" ]]; then
  export NETDATA_EXTRA_DEB_PACKAGES="${netdata_extra_deb_packages}"
fi

echo "Starting Netdata..." >&2
exec /usr/sbin/run.sh
