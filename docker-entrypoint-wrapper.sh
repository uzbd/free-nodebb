
#!/bin/bash
set -euo pipefail

# Use the prebuilt assets from GitHub Actions.
mkdir -p /usr/src/app/build
cp -a /opt/nodebb-prebuilt-build/. /usr/src/app/build/

# Use the official NodeBB Docker entrypoint.
# This launches the browser-based installer when config.json is absent.
export CONFIG_DIR="${CONFIG_DIR:-/opt/config}"
export NODEBB_INIT_VERB=install

exec /usr/local/bin/entrypoint.sh
