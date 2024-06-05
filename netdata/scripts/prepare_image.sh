#!/usr/bin/env bash

set -euxo pipefail

apt-get update

# the upstream image may add/remove gpg in the future, this is a safeguard
if command -v gpg >/dev/null; then
    remove_gpg=false
else
    apt-get install -y --no-install-recommends gnupg
    remove_gpg=true
fi

# the upstream image may add/remove curl in the future, this is a safeguard
if command -v curl >/dev/null; then
    remove_curl=false
else
    apt-get install -y --no-install-recommends curl
    remove_curl=true
fi

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

if [[ "${remove_gpg}" == true ]]; then
    apt-get purge -y --auto-remove gnupg
fi
unset remove_gpg

if [[ "${remove_curl}" == true ]]; then
    apt-get purge -y --auto-remove curl
fi
unset remove_curl

arch="$(dpkg --print-architecture)"
version_codename="$(. /etc/os-release && echo "${VERSION_CODENAME}")"
echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian ${version_codename} stable" |
    tee /etc/apt/sources.list.d/docker.list
unset arch version_codename

apt-get update

# lm-sensors: useful enough for Home Assistant to have it as a default dependency
# docker-ce-cli: needed by the run.sh script
apt-get install -y --no-install-recommends lm-sensors docker-ce-cli

# clean up apt cache
rm -rf /var/lib/apt/lists/*

# relocate the original health check script so we can put ours in its place
mv -f /usr/sbin/health.sh /usr/sbin/health.sh.orig

# the upstream image may move the run.sh script in the future, this is a safeguard
stat /usr/sbin/run.sh
