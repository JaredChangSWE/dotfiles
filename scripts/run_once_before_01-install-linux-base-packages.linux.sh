#!/bin/bash

#
# Install core dependencies required by the rest of the Linux setup
#

set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get was not found. Skipping base package installation."
    exit 0
fi

echo "📦 Installing base Linux packages via apt..."

sudo apt-get update
sudo apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    file \
    git \
    gnupg \
    lsb-release \
    software-properties-common \
    unzip \
    wget \
    xdg-utils \
    xz-utils

echo "✅ Core dependencies installed."
