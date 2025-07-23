# MyDevTools - Chezmoi Edition

A comprehensive personal development environment setup using [chezmoi](https://chezmoi.io/) for managing dotfiles and system configuration optimized for macOS.

## Features

- **Automated Environment Setup**: Complete macOS development environment setup via chezmoi
- **Dotfile Management**: Version-controlled dotfiles with templating support
- **Tool Installation**: Automated installation of Homebrew packages and applications
- **Shell Configuration**: Zsh with plugins, aliases, and custom functions via Zinit
- **Git Integration**: Comprehensive git aliases from GitAlias.com
- **Cross-Machine Sync**: Easy synchronization across multiple machines

## Quick Start

### Initial Setup (New Machine)

1. **Install chezmoi and initialize**:
   ```bash
   # Install chezmoi
   brew install chezmoi
   
   # Initialize from your dotfiles repository
   chezmoi init --apply https://github.com/yourusername/dotfiles.git
   ```

2. **Or use one-line setup**:
   ```bash 
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername
   ```

### Daily Usage

```bash
# Update dotfiles from repository
chezmoi update

# Edit a dotfile
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Check differences
chezmoi diff

# Add a new dotfile
chezmoi add ~/.newfile
```

## Structure

```
~/.local/share/chezmoi/
├── Brewfile                        # Homebrew package definitions
├── dot_gitconfig.tmpl              # Git configuration (templated)
├── dot_gitignore                   # Global gitignore (Brewfile.lock.json, .DS_Store, etc.)
├── dot_zshrc                       # Zsh startup file with optimized loading order
├── dot_gitalias                    # Git aliases from GitAlias.com
├── dot_zsh/                        # Zsh configuration modules
│   ├── path.zsh.tmpl               # PATH setup (templated, loads first)
│   ├── plugins.zsh                 # Zinit plugin manager (loads second)
│   ├── env.zsh                     # Environment initialization (loads third)
│   ├── aliases.zsh                 # Command aliases (loads fourth)
│   └── functions.zsh               # Custom shell functions (loads last)
└── scripts/                        # Installation scripts with smart detection
    ├── run_once_before_00-setup-xcode.sh      # Xcode Command Line Tools
    ├── run_once_before_01-install-homebrew.sh # Homebrew (checks existing installation)
    ├── run_once_before_02-install-development-tools.sh.tmpl # Brewfile + AWS Session Manager
    ├── run_once_after_00-setup-shell.sh       # Shell environment setup
    └── run_once_after_99-verify-setup.sh      # Comprehensive verification

# Configuration (not tracked)
~/.config/chezmoi/chezmoi.toml      # User data (email, name, SSH key)
```

## Configuration

### User Data Variables

Create `~/.config/chezmoi/chezmoi.toml` to customize your setup:

```toml
[data]
    email = "your.email@example.com"
    name = "Your Name"
    signing_key = "your-ssh-signing-key"
```

This file is not tracked in the repository to keep your sensitive information secure.

### Key Components

#### Zsh Configuration
- **Modular Structure**: Organized into separate files for maintainability
  - `dot_zsh/aliases.zsh`: Git, Docker, Kubernetes, AWS shortcuts
  - `dot_zsh/functions.zsh`: Custom functions for proxy setup, AWS operations
  - `dot_zsh/plugins.zsh`: Zinit plugin manager with syntax highlighting, autosuggestions, zoxide
  - `dot_zsh/env.zsh`: Environment initialization and key bindings
  - `dot_zsh/path.zsh.tmpl`: PATH setup with Homebrew integration
- **Loading Order**: Optimized for proper plugin initialization (plugins → env → aliases → functions)

#### Development Tools
- **IDEs**: VS Code, JetBrains Toolbox, Warp terminal
- **Cloud Tools**: AWS CLI (with aws-vault), kubectl, helm
- **Containers**: Docker, Kubernetes tools
- **Languages**: Python, Node.js (via asdf)\n- **Directory Navigation**: zoxide (smart `z` command) - note: conflicts with zinit's `zi`, use `z` for navigation

#### Productivity Apps
- **Essential**: 1Password, Alfred, CleanShot, Rectangle
- **Communication**: Slack, Discord, Zoom
- **Browsers**: Brave, Arc
- **Utilities**: Various system utilities and tools

## Migration from Old System

If you're migrating from the original symlink-based MyDevTools:

1. **Backup existing dotfiles**:
   ```bash
   cp ~/.zshrc ~/.zshrc.backup
   cp ~/.gitconfig ~/.gitconfig.backup
   ```

2. **Remove old symlinks**:
   ```bash
   rm ~/.zshrc ~/.gitconfig ~/.gitalias
   rm -rf ~/.myzsh
   ```

3. **Initialize chezmoi**:
   ```bash
   chezmoi init --apply
   ```

## Customization

### Adding New Dotfiles
```bash
# Add a new dotfile to chezmoi
chezmoi add ~/.newconfig

# Edit it
chezmoi edit ~/.newconfig

# Apply changes
chezmoi apply
```

### Adding New Scripts
- **Before scripts**: `run_once_before_*.sh` for installation tasks (with smart detection)
- **After scripts**: `run_once_after_*.sh` for post-installation setup
- **Templates**: Use `.tmpl` extension for OS-specific or user-specific content
- **Smart Detection**: Scripts check for existing installations to avoid redundancy

### Modifying Installation
Edit the Brewfile to add/remove packages:
```bash
chezmoi edit ~/.local/share/chezmoi/Brewfile

# Then install new packages
brew bundle install
```

For development tools installation script:
```bash
chezmoi edit ~/.local/share/chezmoi/scripts/run_once_before_02-install-development-tools.sh.tmpl
```

## Platform Support

- **Target Platform**: macOS (Apple Silicon and Intel)
- **Optimized For**: Modern macOS development workflows

## Commands Reference

| Command | Description |
|---------|-------------|
| `chezmoi init` | Initialize chezmoi |
| `chezmoi apply` | Apply dotfile changes |
| `chezmoi update` | Pull and apply latest changes |
| `chezmoi diff` | Show differences |
| `chezmoi edit <file>` | Edit a managed file |
| `chezmoi add <file>` | Add a file to chezmoi |
| `chezmoi status` | Show status |
| `chezmoi re-add` | Re-add modified files |

## Troubleshooting

### Common Issues

1. **Permission denied on scripts**: Ensure scripts are executable
   ```bash
   chezmoi apply --force
   ```

2. **Template errors**: Check your `~/.config/chezmoi/chezmoi.toml`

3. **Homebrew not found**: Restart terminal or source the shell profile

### Getting Help

- [Chezmoi Documentation](https://chezmoi.io/)
- [GitAlias Documentation](https://github.com/gitalias/gitalias)
- Check the repository issues for common problems

## Contributing

This is a personal dotfiles repository, but feel free to:
- Fork for your own use
- Submit issues for bugs
- Suggest improvements via pull requests

## License

This configuration is provided as-is for personal use. Individual tools and applications have their own licenses.