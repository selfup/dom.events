#!/usr/bin/env bash
# Serve the site baked into the image at http://localhost:4000
# Run scripts/build-image.sh first. Ctrl-C stops it.
set -euo pipefail
cd "$(dirname "$0")/.."

# Use podman if it's installed, otherwise docker.
# Force one with CONTAINER_ENGINE=docker (or podman).
ENGINE="${CONTAINER_ENGINE:-$(command -v podman >/dev/null 2>&1 && echo podman || echo docker)}"

"$ENGINE" run --rm -p 4000:4000 dom-events
