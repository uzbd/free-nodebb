#!/bin/bash
set -euo pipefail

CONFIG_DIR="${CONFIG_DIR:-/opt/config}"
CONFIG="${CONFIG_DIR}/config.json"

# Copy precompiled assets into the official image's build volume.
mkdir -p /usr/src/app/build
cp -a /opt/nodebb-prebuilt-build/. /usr/src/app/build/

mkdir -p "$CONFIG_DIR"

# Render's filesystem is ephemeral. If the config is absent after a restart
# or redeploy, recreate it from the Render environment variables, but skip
# NodeBB's expensive asset compilation.
if [ ! -f "$CONFIG" ]; then
  echo "NodeBB config not found; running setup without rebuilding assets..."
  /usr/src/app/nodebb --config="$CONFIG" setup --skip-build
fi

# Mark the package set as built so the official upgrade check does not
# trigger a second asset build during startup.
PACKAGE_HASH="$(md5sum /usr/src/app/install/package.json | cut -d' ' -f1)"
printf '%s' "$PACKAGE_HASH" > "$CONFIG_DIR/install_hash.md5"

exec npm start -- --config="$CONFIG" --no-silent --no-daemon
