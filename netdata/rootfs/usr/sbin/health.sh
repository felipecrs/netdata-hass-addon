#!/usr/bin/env bash

# shellcheck source=../../opt/netdata-hass-addon/common.bash
source /opt/netdata-hass-addon/common.bash

get_config netdata_healthcheck_target
if [[ -n "${netdata_healthcheck_target}" ]]; then
    export NETDATA_HEALTHCHECK_TARGET="${netdata_healthcheck_target}"
fi

# Call the original Netdata docker health check
exec /opt/netdata-hass-addon/health.sh.orig "${@}"
