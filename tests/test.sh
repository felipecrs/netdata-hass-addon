#!/usr/bin/env bash

set -ex

script_dir=$(dirname "$0")
readonly script_dir

cd "${script_dir}"

# HAOS apparently doesn't use buildkit
DOCKER_BUILDKIT=0 docker compose build

trap 'docker compose down' EXIT

if docker compose up --wait; then
    echo "Container started healthily" >&2
else
    docker compose logs --no-log-prefix
    echo "Container failed to start healthily, see logs above" >&2
    exit 1
fi

if container_os_release=$(docker compose exec -T netdata cat /host/etc/os-release); then
    echo "File /host/etc/os-release exists in the container" >&2
else
    echo "File /host/etc/os-release does not exist in the container" >&2
    exit 1
fi

host_os_release=$(cat /etc/os-release)
if [[ "${container_os_release}" == "${host_os_release}" ]]; then
    echo "File /host/etc/os-release in the container matches the host" >&2
else
    echo "File /host/etc/os-release in the container does not match the host" >&2
    exit 1
fi

if container_cgroup_max_depth=$(docker compose exec -T netdata cat /host/sys/fs/cgroup/cgroup.max.depth); then
    echo "File /host/sys/fs/cgroup/cgroup.max.depth exists in the container" >&2
else
    echo "File /host/sys/fs/cgroup/cgroup.max.depth does not exist in the container" >&2
    exit 1
fi

host_cgroup_max_depth=$(cat /sys/fs/cgroup/cgroup.max.depth)
if [[ "${container_cgroup_max_depth}" == "${host_cgroup_max_depth}" ]]; then
    echo "File /host/sys/fs/cgroup/cgroup.max.depth in the container matches the host" >&2
else
    echo "File /host/sys/fs/cgroup/cgroup.max.depth in the container does not match the host" >&2
    exit 1
fi

if docker compose down; then
    echo "Container stopped and removed successfully" >&2
else
    echo "Container failed to stop and remove" >&2
    exit 1
fi

# There is a bug where the container can mess with the host cgroups upon removal,
# this should help catch it
if new_host_cgroup_max_depth=$(cat /sys/fs/cgroup/cgroup.max.depth) && [[ "${new_host_cgroup_max_depth}" == "${host_cgroup_max_depth}" ]]; then
    echo "Host cgroup max depth is unchanged after container removal" >&2
else
    echo "Host cgroup max depth is changed after container removal" >&2
    exit 1
fi
