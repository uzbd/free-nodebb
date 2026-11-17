
#!/bin/bash
set -euo pipefail

CONFIG_DIR="${CONFIG_DIR:-/opt/config}"
CONFIG="${CONFIG_DIR}/config.json"

# Copy precompiled assets into the official image's build volume.
mkdir -p /usr/src/app/build
cp -a /opt/nodebb-prebuilt-build/. /usr/src/app/build/

mkdir -p "$CONFIG_DIR"

# Recreate config if it does not exist, without rebuilding assets.
if [ ! -f "$CONFIG" ]; then
  echo "NodeBB config not found; running setup without rebuilding assets..."
  /usr/src/app/nodebb setup --config="$CONFIG" --skip-build
fi

# Mark the package set as built.
PACKAGE_HASH="$(md5sum /usr/src/app/install/package.json | cut -d' ' -f1)"
printf '%s' "$PACKAGE_HASH" > "$CONFIG_DIR/install_hash.md5"

exec npm start -- --config="$CONFIG" --no-silent --no-daemon
