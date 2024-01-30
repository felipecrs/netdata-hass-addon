#!/usr/bin/env bash

# shellcheck source=../../opt/netdata-hass-addon/common.bash
source /opt/netdata-hass-addon/common.bash

get_config netdata_healthcheck_target
# shellcheck disable=SC2154
export NETDATA_HEALTHCHECK_TARGET="${netdata_healthcheck_target}"

# Call the original Netdata docker health check
exec /usr/sbin/health.sh.orig
