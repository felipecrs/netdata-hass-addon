#!/usr/bin/env bash

set -euxo pipefail

apt-get update

# curl: needeed by run.sh
# smartmontools: useful enough for Home Assistant to have it as a default dependency
# nvme-cli: useful enough for Home Assistant to have it as a default dependency
# apcupsd: useful enough for Home Assistant to have it as a default dependency
apt-get install -y --no-install-recommends curl smartmontools nvme-cli apcupsd

# clean up apt cache
rm -rf /var/lib/apt/lists/*

# relocate the original health check script so we can put ours in its place
mv -f /usr/sbin/health.sh /opt/netdata-hass-addon/original_health.sh

# the upstream image may move the run.sh script in the future, this is a safeguard
stat /usr/sbin/run.sh
