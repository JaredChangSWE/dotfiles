#!/bin/bash

#
# Verify Linux development environment setup
#

set -euo pipefail

echo "🔍 Verifying Linux development environment..."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

success_count=0
total_checks=0

check_command() {
    local cmd="$1"
    local description="$2"
    total_checks=$((total_checks + 1))

    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ $description${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}❌ $description - $cmd not found${NC}"
    fi
}

check_path() {
    local path="$1"
    local description="$2"
    total_checks=$((total_checks + 1))

    if [[ -e "$path" ]]; then
        echo -e "${GREEN}✅ $description${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}❌ $description - $path not found${NC}"
    fi
}

check_group_membership() {
    local group="$1"
    local description="$2"
    total_checks=$((total_checks + 1))

    if id -nG "$USER" | grep -qw "$group"; then
        echo -e "${GREEN}✅ $description${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${YELLOW}⚠️  $description - re-login may be required${NC}"
    fi
}

echo ""
echo "📦 Core Development Tools:"
check_command "git" "Git version control"
check_command "python3" "Python 3"
check_command "zsh" "Zsh shell"
check_command "aws" "AWS CLI"
check_command "aws-vault" "aws-vault credential helper"
check_command "kubectl" "Kubernetes CLI"
check_command "helm" "Helm package manager"
check_command "docker" "Docker CLI"
check_command "session-manager-plugin" "AWS Session Manager plugin"

echo ""
echo "🛠️ Command Line Utilities:"
check_command "tmux" "tmux"
check_command "jq" "jq JSON processor"
check_command "htop" "htop system monitor"
check_command "fd" "fd modern find (or symlink)"
check_command "rg" "ripgrep search"
check_command "fzf" "fzf fuzzy finder"
check_command "eza" "eza modern ls (optional)"
check_command "bat" "bat pager"

echo ""
echo "🐚 Shell Environment:"
check_path "$HOME/.zsh" "Zsh configuration directory"
check_command "zoxide" "zoxide directory jumper"
if [[ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    echo -e "${GREEN}✅ Zinit plugin manager${NC}"
    success_count=$((success_count + 1))
else
    echo -e "${RED}❌ Zinit plugin manager not found${NC}"
fi
total_checks=$((total_checks + 1))

echo ""
echo "🐳 Container Runtime:"
check_group_membership "docker" "User added to docker group"

echo ""
echo "📂 Paths & Directories:"
check_path "$HOME/.local/bin" "~/.local/bin exists"
check_path "$HOME/.config/chezmoi" "chezmoi config directory"

echo ""
echo "📊 Verification Summary:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ $success_count -eq $total_checks ]]; then
    echo -e "${GREEN}🎉 All checks passed! ($success_count/$total_checks)${NC}"
elif [[ $success_count -gt $((total_checks * 3 / 4)) ]]; then
    echo -e "${YELLOW}⚠️  Most checks passed ($success_count/$total_checks)${NC}"
else
    echo -e "${RED}❌ Several checks failed ($success_count/$total_checks)${NC}"
fi

echo ""
echo "💡 Next steps:"
echo "   • Restart your session or run 'newgrp docker' if Docker group check failed"
echo "   • Run 'chezmoi apply' after adjusting any missing tools"
echo "   • Install optional GUI apps manually as needed"
