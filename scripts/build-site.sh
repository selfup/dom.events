#!/usr/bin/env bash
# Generate the static site from the working tree into ./_site
# Extra args go to `jekyll build` (e.g. scripts/build-site.sh --drafts).
set -euo pipefail
cd "$(dirname "$0")/.."

podman run --rm -v "$PWD:/srv/jekyll" dom-events bundle exec jekyll build "$@"
