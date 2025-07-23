#!/bin/bash

#
# Install Homebrew and basic setup
#

set -euo pipefail

# Check if Homebrew is already installed
if command -v brew >/dev/null 2>&1; then
    echo "🍺 Homebrew is already installed, skipping installation..."
    echo "📦 Current Homebrew version: $(brew --version | head -n1)"
else
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    echo "✅ Homebrew installation completed!"
fi

echo ""
echo "💡 Next steps:"
echo "   • Taps and packages will be configured via Brewfile"
echo "   • Run 'brew bundle install' to install all packages"
