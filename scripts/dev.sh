#!/usr/bin/env bash
# Serve the working tree at http://localhost:4000 with live regeneration.
# Edits on the host are picked up through the bind mount. Ctrl-C stops it.
set -euo pipefail
cd "$(dirname "$0")/.."

podman run --rm -p 4000:4000 -v "$PWD:/srv/jekyll" dom-events
