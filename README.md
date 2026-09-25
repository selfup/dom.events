[![Netlify Status](https://api.netlify.com/api/v1/badges/20ea67c8-078e-4e47-9656-702ed08bbaa7/deploy-status)](https://app.netlify.com/projects/competent-rosalind-92e02c/deploys)

# dom.events

Blog for [dom.events](https://dom.events)

### Development

All you need is [podman](https://podman.io) or [docker](https://www.docker.com). Ruby and Jekyll run inside the container. The scripts use podman when it's installed, otherwise docker. Set `CONTAINER_ENGINE=docker` to force docker.

Build the image (rerun after changing the `Gemfile`):

`scripts/build-image.sh`

---

Run the Jekyll server at http://localhost:4000. It rebuilds when you save a file, then refresh the browser to see the change:

`scripts/dev.sh`

---

Build the site into `_site`:

`scripts/build-site.sh`

---

Serve the site as baked into the image (rebuild the image to pick up changes):

`scripts/serve.sh`
