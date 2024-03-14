#!/usr/bin/env bash

set -e

architecture=

if [ "$(uname -m)" = "aarch64" ]; then
  architecture="arm64"
else
  architecture="x64"
fi

# Fetch the latest Bicep CLI binary
curl -Lo bicep "https://github.com/Azure/bicep/releases/latest/download/bicep-linux-$architecture"

# Mark it as executable
chmod +x ./bicep
# Add bicep to your PATH (requires admin)
sudo mv ./bicep /usr/local/bin/bicep
# Verify you can now access the 'bicep' command
bicep --help
