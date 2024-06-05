#!/usr/bin/env bash

set -ex

script_dir=$(dirname "$0")
readonly script_dir

cd "${script_dir}"

# HAOS apparently doesn't use buildkit
DOCKER_BUILDKIT=0 docker compose build

trap 'docker compose down' EXIT

if docker compose up --wait; then
    echo "Test passed" >&2
    result=0
else
    docker compose logs --no-log-prefix
    echo "Test failed, see logs above" >&2
    result=1
fi

exit "${result}"
