
#!/bin/bash
set -euo pipefail

# Use the prebuilt assets from GitHub Actions.
mkdir -p /usr/src/app/build
cp -a /opt/nodebb-prebuilt-build/. /usr/src/app/build/

# Inject the Atlas connection URI into NodeBB's hidden
# Web Installer database URI field.
node <<'NODE'
const fs = require('fs');

const file = '/usr/src/app/setup.json';
const uri = process.env.mongo__uri;

if (!uri) {
    throw new Error('MongoDB URI environment variable is missing');
}

const setup = JSON.parse(fs.readFileSync(file, 'utf8'));

setup.defaults = setup.defaults || {};
setup.defaults.mongo = setup.defaults.mongo || {};
setup.defaults.mongo.uri = uri;

fs.writeFileSync(file, JSON.stringify(setup, null, 2));
NODE

# Launch the official NodeBB Web Installer.
export CONFIG_DIR="${CONFIG_DIR:-/opt/config}"
export NODEBB_INIT_VERB=install

exec /usr/local/bin/entrypoint.sh
