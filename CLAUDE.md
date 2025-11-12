# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **chezmoi-managed dotfiles repository** for macOS and Linux development environment setup. It uses [chezmoi](https://chezmoi.io/) to manage and version control dotfiles, system configuration, and automated tool installation optimized for Apple Silicon/Intel Macs and Debian/Ubuntu-based systems.

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
  1. `path.zsh.tmpl`: PATH setup tuned per OS (Homebrew paths vs Linux paths) using templated sections
  2. `plugins.zsh`: Zinit plugin manager and plugin loading (loads first to install tools like zoxide)
  3. `env.zsh.tmpl`: Environment initialization, key bindings, and tool initialization (including zoxide) via templating
  4. `aliases.zsh`: Command aliases (Git, Docker, Kubernetes, AWS)
  5. `functions.zsh`: Custom shell functions for development workflows

#### Installation Pipeline (`scripts/`)
- **Organized Scripts**: Clear naming and execution order with smart detection
  - macOS sections live at the top of the templated scripts (`run_once_before_00-setup-xcode.sh.tmpl`, `run_once_before_01-install-base-packages.sh.tmpl`, `run_once_before_02-install-development-tools.sh.tmpl`)
  - Linux sections live at the bottom of the same templates to keep numbering/order consistent
  - Post-install: `run_once_after_00-setup-shell.sh.tmpl`, `run_once_after_99-verify-setup.sh.tmpl`
- **Smart Detection**: Scripts check for existing installations to avoid redundant operations

#### Package Management
- **macOS Brewfile**: `Brewfile.tmpl` drives declarative package management through templated macOS sections
  - Optimized for macOS with Homebrew and cask applications
  - Supports `brew bundle` commands for efficient installation with `--file Brewfile`
  - Includes development tools (VS Code, JetBrains), productivity apps (1Password, Alfred), and system utilities
  - Special handling for AWS Session Manager plugin installation outside of Homebrew
- **Linux Scripts**: apt-based automation now lives in the Linux sections of `run_once_before_01-install-base-packages.sh.tmpl` and `run_once_before_02-install-development-tools.sh.tmpl`, covering CLI packages, kubectl/helm repos, Docker group membership, aws-vault, eza, and the AWS Session Manager plugin

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
1. **macOS Homebrew Packages**: Add to the macOS section inside `Brewfile.tmpl`
   - CLI tools: `brew "package-name"`
   - GUI applications: `cask "app-name"`
   - No templating needed for simple package additions
2. **Linux Packages**: Extend the Linux section in `scripts/run_once_before_02-install-development-tools.sh.tmpl`
   - Add apt packages to the install list
   - Add custom install functions for binaries fetched from releases if needed
3. **Shell Integration**: Add aliases/functions to appropriate `dot_zsh/` files
   - Aliases: Add to `dot_zsh/aliases.zsh`
   - Functions: Add to `dot_zsh/functions.zsh`
   - PATH modifications: Add to the appropriate section inside `dot_zsh/path.zsh.tmpl`
4. **Install & Verify**: 
   - macOS: Run `brew bundle install --file Brewfile` / `brew bundle check --file Brewfile`
   - Linux: Re-run the apt automation sections via `chezmoi apply` or execute the templated scripts directly
   - Add completions to `dot_zsh/plugins.zsh` if needed

### Modifying Dotfiles
1. Use `chezmoi edit <file>` rather than editing files directly
2. For templated files, ensure user data variables are available in `~/.config/chezmoi/chezmoi.toml`
3. Test changes with `chezmoi diff` before applying
4. Apply with `chezmoi apply`

### Platform Considerations
- **macOS**: Apple Silicon and Intel via Homebrew (`/opt/homebrew`) and the macOS section within Brewfile.tmpl
- **Linux**: Debian/Ubuntu via the templated apt scripts (handles kubectl/helm repos, Docker, aws-vault, eza, Session Manager plugin)
- **macOS-Specific Features**: Warp integration, AWS Vault keychain setup, 1Password SSH signing, macOS-native apps
- **Linux-Specific Notes**: Adds Docker group membership, xclip clipboard alias, Brave replaced with `xdg-open` for aws-vault login helper

## Security Features
- **Git Signing**: Configured for SSH signing via 1Password
- **Credential Management**: aws-vault integration for AWS credentials
- **Keychain Integration**: Automatic keychain setup for secure credential storage

## Testing and Verification
- Always test dotfile changes in a new shell session
- Use `chezmoi diff` to preview changes before applying
- Run `scripts/run_once_after_99-verify-setup.sh.tmpl` (per-OS sections) to verify installation
- Keep backups of critical configurations before major updates
- Test installation scripts in isolated environments when possible

## Repository Structure
```
~/.local/share/chezmoi/
├── Brewfile.tmpl                           # Homebrew package definitions (templated per OS)
├── CLAUDE.md                               # AI assistant guidance
├── README.md                               # User documentation
├── dot_gitconfig.tmpl                      # Git configuration template
├── dot_gitalias                            # Git aliases from GitAlias.com
├── dot_gitignore                           # Global gitignore (Brewfile lock files, .DS_Store, etc.)
├── dot_zshrc                               # Zsh main configuration with optimized loading order
├── dot_zsh/                                # Modular zsh configuration
│   ├── path.zsh.tmpl                       # PATH setup with templated OS sections
│   ├── plugins.zsh                         # Zinit plugin manager (loads first)
│   ├── env.zsh.tmpl                        # Environment initialization and tool setup
│   ├── aliases.zsh                         # Command aliases (Git, Docker, K8s, AWS)
│   └── functions.zsh                       # Custom shell functions
└── scripts/                                # Installation scripts with smart detection
    ├── modify_Brewfile.sh.tmpl             # Watches Brewfile changes per OS
    ├── run_once_before_00-setup-xcode.sh.tmpl
    ├── run_once_before_01-install-base-packages.sh.tmpl
    ├── run_once_before_02-install-development-tools.sh.tmpl
    ├── run_once_after_00-setup-shell.sh.tmpl
    └── run_once_after_99-verify-setup.sh.tmpl

# Configuration (not in repository)
~/.config/chezmoi/chezmoi.toml              # User data (email, name, SSH key)
```

## Brewfile Commands (macOS)
```bash
# Install all packages from Brewfile
brew bundle install --file Brewfile

# Check if all packages are installed
brew bundle check --verbose --file Brewfile

# Update Brewfile with currently installed packages
brew bundle dump --file Brewfile --force

# Clean up packages not in Brewfile
brew bundle cleanup --force --file Brewfile

# Install only specific categories
brew bundle install --file Brewfile --only=casks
```
