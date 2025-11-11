#!/bin/bash

#
# Setup Zinit and post-installation tasks
#

set -euo pipefail

echo "Installing Zinit..."
sh -c "$(curl -fsSL https://git.io/zinit-install)" || true

echo "Setup completed successfully!"
