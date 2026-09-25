# syntax=docker/dockerfile:1
#
# Wrapper scripts live in scripts/:
#   build-image.sh   podman build -t dom-events .
#   serve.sh         serve the baked-in site on http://localhost:4000
#   dev.sh           serve the working tree with live regeneration
#   build-site.sh    generate ./_site from the working tree

ARG RUBY_IMAGE=docker.io/library/ruby:4.0.7-slim-trixie

# ---------- stage 1: resolve and compile gems ----------
FROM ${RUBY_IMAGE} AS build

# Only eventmachine and http_parser.rb still compile from source; nokogiri,
# ffi and sass-embedded ship precompiled linux gems. libssl-dev is for
# eventmachine, libffi-dev is a fallback should ffi ever compile from source.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      libffi-dev \
      libssl-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/jekyll
COPY Gemfile Gemfile.lock ./

# After installing: drop the gem download cache, compiler leftovers, and the
# precompiled native libraries nokogiri/protobuf ship for Ruby ABIs other than
# the one in this image (each unused ABI dir is a few MB).
RUN bundle config set --local frozen true \
 && bundle install \
 && rm -rf /usr/local/bundle/cache \
 && find /usr/local/bundle/gems -name '*.o' -delete \
 && ABI="$(ruby -e 'print RUBY_VERSION[/\d+\.\d+/]')" \
 && find /usr/local/bundle/gems -regextype posix-extended -type d \
      -regex '.*/lib/[^/]+/[0-9]+\.[0-9]+' ! -name "$ABI" -exec rm -rf {} +

# ---------- stage 2: runtime ----------
FROM ${RUBY_IMAGE}

COPY --from=build /usr/local/bundle /usr/local/bundle

WORKDIR /srv/jekyll
COPY . .

EXPOSE 4000
# --host 0.0.0.0    reachable from outside the container
# --force_polling   inotify does not cross the podman-machine virtiofs mount
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--force_polling"]
