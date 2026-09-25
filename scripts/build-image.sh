#!/usr/bin/env bash
# Build the dom-events container image. Extra args go to `podman build`
# (e.g. scripts/build-image.sh --no-cache).
set -euo pipefail
cd "$(dirname "$0")/.."

podman build -t dom-events "$@" .
