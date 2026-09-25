#!/usr/bin/env bash
# Serve the site baked into the image at http://localhost:4000
# Run scripts/build-image.sh first. Ctrl-C stops it.
set -euo pipefail
cd "$(dirname "$0")/.."

podman run --rm -p 4000:4000 dom-events
