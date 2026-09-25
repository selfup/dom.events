#!/usr/bin/env bash
# Generate the static site from the working tree into ./_site
# Extra args go to `jekyll build` (e.g. scripts/build-site.sh --drafts).
set -euo pipefail
cd "$(dirname "$0")/.."

# Use podman if it's installed, otherwise docker.
# Force one with CONTAINER_ENGINE=docker (or podman).
ENGINE="${CONTAINER_ENGINE:-$(command -v podman >/dev/null 2>&1 && echo podman || echo docker)}"

"$ENGINE" run --rm -v "$PWD:/srv/jekyll" dom-events bundle exec jekyll build "$@"
