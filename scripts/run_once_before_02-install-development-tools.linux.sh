#!/bin/bash

#
# Install development tooling for Linux environments
#

set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get was not found. Skipping tool installation."
    exit 0
fi

echo "🔧 Setting up Linux development environment..."

sudo apt-get update
sudo apt-get install -y \
    bat \
    fd-find \
    fzf \
    git \
    htop \
    btop \
    jq \
    vim \
    python-is-python3 \
    ripgrep \
    tmux \
    unzip \
    xclip \
    zoxide \
    zsh

# Provide fd under the expected binary name if necessary
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
fi

# Provide bat under expected name on Debian-based systems
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    sudo ln -sf "$(command -v batcat)" /usr/local/bin/bat
fi

install_eza() {
    if command -v eza >/dev/null 2>&1; then
        return
    fi

    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza

    echo "✅ Installed eza from the latest GitHub release."
}

install_eza

echo "🎉 Linux development tools installation completed!"
echo ""
echo "💡 Next steps:"
echo "   • Restart your shell to pick up group membership changes (Docker)"
echo "   • Verify tooling with scripts/run_once_after_99-verify-setup.linux.sh"
