#!/usr/bin/env bash

# shellcheck source=./common.bash
source /opt/netdata-hass-addon/common.bash

# the upstream image may move these scripts in the future, this is a safeguard
if [[ -x /usr/sbin/health.sh ]]; then
  # relocate the original health check script so we can put ours in its place
  mv -fv /usr/sbin/health.sh /opt/netdata-hass-addon/health.sh.orig
else
  error 'Could not find Netdata health check script at /usr/sbin/health.sh'
fi

if [[ ! -x /usr/sbin/run.sh ]]; then
  error 'Could not find find Netdata entrypoint script at /usr/sbin/run.sh'
fi

set -x

apt-get update

# curl: needeed by run.sh
# smartmontools: useful enough for Home Assistant to have it as a default dependency
# nvme-cli: useful enough for Home Assistant to have it as a default dependency
# apcupsd: useful enough for Home Assistant to have it as a default dependency
apt-get install -y --no-install-recommends curl smartmontools nvme-cli apcupsd

# clean up apt cache
rm -rf /var/lib/apt/lists/*
