#!/bin/bash

#
# Setup Zinit and post-installation tasks
#

set -euo pipefail

echo "Installing Rosetta 2..."
softwareupdate --install-rosetta --agree-to-license || true

echo "Installing Zinit..."
sh -c "$(curl -fsSL https://git.io/zinit-install)" || true

echo "Setup completed successfully!"