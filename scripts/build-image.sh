#!/usr/bin/env bash
# Build the dom-events container image. Extra args go to the build command
# (e.g. scripts/build-image.sh --no-cache).
set -euo pipefail
cd "$(dirname "$0")/.."

# Use podman if it's installed, otherwise docker.
# Force one with CONTAINER_ENGINE=docker (or podman).
ENGINE="${CONTAINER_ENGINE:-$(command -v podman >/dev/null 2>&1 && echo podman || echo docker)}"

"$ENGINE" build -t dom-events "$@" .
