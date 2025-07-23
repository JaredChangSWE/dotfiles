# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **chezmoi-managed dotfiles repository** for macOS development environment setup. It uses [chezmoi](https://chezmoi.io/) to manage and version control dotfiles, system configuration, and automated tool installation optimized specifically for Mac systems.

## Key Commands

### Chezmoi Operations
```bash
# Apply all dotfile changes
chezmoi apply

# Check differences between managed files and actual files
chezmoi diff

# Edit a managed dotfile (automatically opens in editor)
chezmoi edit ~/.zshrc

# Add a new file to chezmoi management
chezmoi add ~/.newfile

# Re-add all managed files (useful after manual edits)
chezmoi re-add

# Update from remote repository and apply changes
chezmoi update

# Check status of managed files
chezmoi status

# Force apply (useful for permission issues)
chezmoi apply --force
```

### Development Environment Setup
```bash
# Initial setup on new machine (from repository)
chezmoi init --apply https://github.com/username/dotfiles.git

# One-line setup (replace 'username' with actual GitHub username)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply username
```

## Architecture and Structure

### File Naming Conventions
- `dot_*` → Maps to `.*` (e.g., `dot_zshrc` → `~/.zshrc`)
- `*.tmpl` → Template files using Go templating with user data from configuration
- `scripts/run_once_before_*` → Scripts that run once before applying dotfiles
- `scripts/run_once_after_*` → Scripts that run once after applying dotfiles

### Key Components

#### Configuration Management
- **User Data**: Stored in `~/.config/chezmoi/chezmoi.toml` (not tracked in repository)
  - Contains: email, name, SSH signing key
  - Keeps sensitive information secure and out of version control

#### Zsh Environment (`dot_zsh/`)
- **Modular Structure**: Split into organized files for maintainability
- **Loading Order**: Optimized for proper plugin initialization
  1. `path.zsh.tmpl`: PATH setup with Homebrew and development tools
  2. `plugins.zsh`: Zinit plugin manager and plugin loading (loads first to install tools like zoxide)
  3. `env.zsh`: Environment initialization, key bindings, and tool initialization (including zoxide)
  4. `aliases.zsh`: Command aliases (Git, Docker, Kubernetes, AWS)
  5. `functions.zsh`: Custom shell functions for development workflows

#### Installation Pipeline (`scripts/`)
- **Organized Scripts**: Clear naming and execution order with smart detection
  - `run_once_before_00-setup-xcode.sh`: Xcode Command Line Tools installation
  - `run_once_before_01-install-homebrew.sh`: Homebrew installation (checks if already installed)
  - `run_once_before_02-install-development-tools.sh.tmpl`: Package installation via `brew bundle` + AWS Session Manager
  - `run_once_after_00-setup-shell.sh`: Shell environment setup
  - `run_once_after_99-verify-setup.sh`: Comprehensive installation verification with colored output
- **Smart Detection**: Scripts check for existing installations to avoid redundant operations

#### Package Management
- **Brewfile**: Uses `Brewfile` for declarative package management (no longer templated)
  - Optimized for macOS with Homebrew and cask applications
  - Organized by categories: CLI tools, GUI apps, productivity applications
  - Supports `brew bundle` commands for efficient installation
  - Includes development tools (VS Code, JetBrains), productivity apps (1Password, Alfred), and system utilities
  - Special handling for AWS Session Manager plugin installation outside of Homebrew

#### Plugin Management (Zinit)
- **Performance-Oriented**: Lazy-loading plugins with `lucid wait='0'`
- **Essential Plugins**: 
  - Syntax highlighting (`zdharma/fast-syntax-highlighting`)
  - Autosuggestions (`zsh-users/zsh-autosuggestions`)
  - Completions (`zsh-users/zsh-completions`)
  - Directory navigation (`ajeetdsouza/zoxide`) - smart directory jumper with `z` command
  - Theme (`romkatv/powerlevel10k`)
  - Tab completion enhancement (`Aloxaf/fzf-tab`)
  - Command completions for AWS, kubectl, and other tools
- **Important**: zoxide conflicts with zinit's `zi` command - use `z` for directory navigation, `zi` for zinit commands


### Development Tools Stack

#### Core Development
- **Version Managers**: asdf (Node.js, Python, etc.)
- **IDEs**: VS Code, JetBrains Toolbox, Warp terminal
- **Version Control**: Git with comprehensive aliases from GitAlias.com

#### Cloud & DevOps
- **AWS**: CLI, aws-vault for credential management, Session Manager plugin
- **Containers**: Docker, kubectl, helm
- **Infrastructure**: Support for Terraform and other IaC tools

#### Productivity Applications
- **Essential**: 1Password (with CLI), Alfred, CleanShot, Rectangle
- **Communication**: Slack, Discord, Zoom
- **Browsers**: Brave, Arc
- **Organization**: Obsidian, Notion, Todoist

## Common Workflows

### Adding New Tools
1. **Homebrew Packages**: Add to `Brewfile`
   - CLI tools: `brew "package-name"`
   - GUI applications: `cask "app-name"` (macOS only)
   - No templating needed for simple package additions
2. **Shell Integration**: Add aliases/functions to appropriate `dot_zsh/` files
   - Aliases: Add to `dot_zsh/aliases.zsh`
   - Functions: Add to `dot_zsh/functions.zsh`
   - PATH modifications: Add to `dot_zsh/path.zsh.tmpl` (uses templating)
3. **Install & Verify**: 
   - Run `brew bundle install` to install new packages
   - Use `brew bundle check` to verify installation
   - Add completions to `dot_zsh/plugins.zsh` if needed

### Modifying Dotfiles
1. Use `chezmoi edit <file>` rather than editing files directly
2. For templated files, ensure user data variables are available in `~/.config/chezmoi/chezmoi.toml`
3. Test changes with `chezmoi diff` before applying
4. Apply with `chezmoi apply`

### Platform Considerations
- **Target Platform**: macOS (Apple Silicon and Intel)
- **Homebrew Integration**: Uses `/opt/homebrew` path (modern Homebrew installation)
- **macOS-Specific Features**: 
  - Warp terminal integration
  - AWS Vault keychain setup
  - 1Password SSH signing
  - macOS-native applications and utilities

## Security Features
- **Git Signing**: Configured for SSH signing via 1Password
- **Credential Management**: aws-vault integration for AWS credentials
- **Keychain Integration**: Automatic keychain setup for secure credential storage

## Testing and Verification
- Always test dotfile changes in a new shell session
- Use `chezmoi diff` to preview changes before applying
- Run `scripts/run_once_after_99-verify-setup.sh` to verify installation
- Keep backups of critical configurations before major updates
- Test installation scripts in isolated environments when possible

## Repository Structure
```
~/.local/share/chezmoi/
├── Brewfile                                # Homebrew package definitions (no longer templated)
├── CLAUDE.md                               # AI assistant guidance
├── README.md                               # User documentation
├── dot_gitconfig.tmpl                      # Git configuration template
├── dot_gitalias                            # Git aliases from GitAlias.com
├── dot_gitignore                           # Global gitignore (Brewfile.lock.json, .DS_Store, etc.)
├── dot_zshrc                               # Zsh main configuration with optimized loading order
├── dot_zsh/                                # Modular zsh configuration
│   ├── path.zsh.tmpl                       # PATH setup for macOS (templated)
│   ├── plugins.zsh                         # Zinit plugin manager (loads first)
│   ├── env.zsh                             # Environment initialization and tool setup
│   ├── aliases.zsh                         # Command aliases (Git, Docker, K8s, AWS)
│   └── functions.zsh                       # Custom shell functions
└── scripts/                                # Installation scripts with smart detection
    ├── run_once_before_00-setup-xcode.sh   # Xcode Command Line Tools
    ├── run_once_before_01-install-homebrew.sh # Homebrew (with existing installation check)
    ├── run_once_before_02-install-development-tools.sh.tmpl # Brewfile + AWS Session Manager
    ├── run_once_after_00-setup-shell.sh    # Shell environment setup
    └── run_once_after_99-verify-setup.sh   # Comprehensive verification with colored output

# Configuration (not in repository)
~/.config/chezmoi/chezmoi.toml              # User data (email, name, SSH key)
```

## Brewfile Commands
```bash
# Install all packages from Brewfile
brew bundle install

# Check if all packages are installed
brew bundle check --verbose

# Update Brewfile with currently installed packages
brew bundle dump --force

# Clean up packages not in Brewfile
brew bundle cleanup --force

# Install only specific categories
brew bundle install --file=Brewfile
```
