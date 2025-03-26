#!/usr/bin/env bash

set -euxo pipefail

# the upstream image may add/remove curl in the future, this is a safeguard
if command -v curl >/dev/null; then
    remove_curl=false
else
    apt-get update
    apt-get install -y --no-install-recommends curl
    remove_curl=true
fi

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

if [[ "${remove_curl}" == true ]]; then
    apt-get purge -y --auto-remove curl
fi
unset remove_curl

arch="$(dpkg --print-architecture)"
# shellcheck disable=SC2153
version_codename="$(. /etc/os-release && echo "${VERSION_CODENAME}")"
echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${version_codename} stable" |
    tee /etc/apt/sources.list.d/docker.list
unset arch version_codename

apt-get update

# docker-ce-cli: needed by the run.sh script
# smartmontools: useful enough for Home Assistant to have it as a default dependency
# nvme-cli: useful enough for Home Assistant to have it as a default dependency
# apcupsd: useful enough for Home Assistant to have it as a default dependency
apt-get install -y --no-install-recommends docker-ce-cli smartmontools nvme-cli apcupsd

# clean up apt cache
rm -rf /var/lib/apt/lists/*

# relocate the original health check script so we can put ours in its place
mv -f /usr/sbin/health.sh /opt/netdata-hass-addon/original_health.sh

# the upstream image may move the run.sh script in the future, this is a safeguard
stat /usr/sbin/run.sh
