# MyDevTools - Chezmoi Edition

A comprehensive personal development environment setup using [chezmoi](https://chezmoi.io/) for managing dotfiles and system configuration, optimized for macOS with dedicated Linux (Debian/Ubuntu) support.

## Features

- **Automated Environment Setup**: Complete macOS and Linux development environment setup via chezmoi
- **Dotfile Management**: Version-controlled dotfiles with templating support
- **Tool Installation**: Automated installation of Homebrew packages (macOS) and apt-based tooling (Linux)
- **Shell Configuration**: Zsh with plugins, aliases, and custom functions via Zinit
- **Git Integration**: Comprehensive git aliases from GitAlias.com
- **Cross-Machine Sync**: Easy synchronization across multiple machines

## Quick Start

### Initial Setup (New Machine)

1. **Install chezmoi and initialize**:

   ```bash
   # macOS
   brew install chezmoi

   # Linux (Debian/Ubuntu)
   sudo apt install chezmoi

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
├── Brewfile.darwin                       # Homebrew package definitions (macOS only)
├── dot_gitconfig.tmpl                    # Git configuration (templated)
├── dot_gitignore                         # Global gitignore (Brewfile lock files, .DS_Store, etc.)
├── dot_zshrc                             # Zsh startup file with optimized loading order
├── dot_gitalias                          # Git aliases from GitAlias.com
├── dot_vimrc                             # Cross-platform Vim configuration with vim-plug
├── dot_zsh/                              # Zsh configuration modules
│   ├── path.zsh.darwin.tmpl              # PATH setup for macOS
│   ├── path.zsh.linux.tmpl               # PATH setup for Linux
│   ├── plugins.zsh                       # Zinit plugin manager (loads first)
│   ├── env.zsh                           # Environment initialization (loads third)
│   ├── aliases.zsh                       # Command aliases (loads fourth)
│   └── functions.zsh                     # Custom shell functions (loads last)
├── scripts/                              # Installation scripts with smart detection
│   ├── modify_Brewfile.sh.darwin.tmpl    # Automatically apply Brewfile.darwin changes
│   ├── run_once_before_00-setup-xcode.darwin.sh
│   ├── run_once_before_01-install-homebrew.darwin.sh
│   ├── run_once_before_01-install-linux-base-packages.linux.sh
│   ├── run_once_before_02-install-development-tools.sh.darwin.tmpl
│   ├── run_once_before_02-install-development-tools.linux.sh
│   ├── run_once_after_00-setup-shell.darwin.sh
│   ├── run_once_after_00-setup-shell.linux.sh
│   ├── run_once_after_99-verify-setup.darwin.sh
│   └── run_once_after_99-verify-setup.linux.sh
└── private_dot_ssh/                      # SSH configuration (templated per OS)

# Configuration (not tracked)
~/.config/chezmoi/chezmoi.toml            # User data (email, name, SSH key)
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
  - `dot_zsh/path.zsh.darwin.tmpl` / `dot_zsh/path.zsh.linux.tmpl`: PATH setup per platform (Homebrew vs. Linux paths)
- **Loading Order**: Optimized for proper plugin initialization (plugins → env → aliases → functions)

#### Vim Configuration

- **File**: `dot_vimrc` managed via chezmoi and sourced automatically by Vim
- **Plugin Manager**: Bootstraps [vim-plug](https://github.com/junegunn/vim-plug) on first launch (works on macOS & Linux)
- **Navigation Plugins**: Installs `easymotion/vim-easymotion` and `vim-scripts/ace_jump.vim` to provide EasyMotion / AceJump workflows
- **Quality-of-life Plugins**: Includes commentary, autopairs, gitgutter, and sensible defaults for indentation, clipboard, splits, and searching
- **Keymaps**: Leader-based shortcuts for EasyMotion (`<leader><leader>w/f/j/k`) and AceJump (`<leader>a`, `<leader>A`) shared across OSes

#### Development Tools

- **IDEs**: VS Code, JetBrains Toolbox, Warp terminal
- **Cloud Tools**: AWS CLI (with aws-vault), kubectl, helm
- **Containers**: Docker, Kubernetes tools
- **Languages**: Python, Node.js (via asdf)
- **Directory Navigation**: zoxide (smart `z` command) - note: conflicts with zinit's `zi`, use `z` for navigation
- **Package Automation**:
  - macOS uses `Brewfile.darwin` + `scripts/run_once_before_02-install-development-tools.sh.darwin.tmpl`
  - Linux uses apt-based scripts `run_once_before_01-install-linux-base-packages.linux.sh` and `run_once_before_02-install-development-tools.linux.sh`

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

Edit `Brewfile.darwin` to add or remove macOS packages:

```bash
chezmoi edit ~/.local/share/chezmoi/Brewfile.darwin

# Then install new packages
brew bundle install --file Brewfile.darwin
```

For the development tools installation scripts:

```bash
# macOS
chezmoi edit ~/.local/share/chezmoi/scripts/run_once_before_02-install-development-tools.sh.darwin.tmpl

# Linux
chezmoi edit ~/.local/share/chezmoi/scripts/run_once_before_02-install-development-tools.linux.sh
```

## Platform Support

- **macOS**: Apple Silicon and Intel Macs using Homebrew + Brewfile.darwin
- **Linux**: Debian/Ubuntu-based distributions using apt automation scripts
- **Optimized For**: Consistent Zsh experience across both platforms

## Commands Reference

| Command               | Description                   |
| --------------------- | ----------------------------- |
| `chezmoi init`        | Initialize chezmoi            |
| `chezmoi apply`       | Apply dotfile changes         |
| `chezmoi update`      | Pull and apply latest changes |
| `chezmoi diff`        | Show differences              |
| `chezmoi edit <file>` | Edit a managed file           |
| `chezmoi add <file>`  | Add a file to chezmoi         |
| `chezmoi status`      | Show status                   |
| `chezmoi re-add`      | Re-add modified files         |

## Troubleshooting

### Common Issues

1. **Permission denied on scripts**: Ensure scripts are executable

   ```bash
   chezmoi apply --force
   ```

2. **Template errors**: Check your `~/.config/chezmoi/chezmoi.toml`

3. **Homebrew/apt not found**:
   - macOS: Restart terminal or run `eval "$(/opt/homebrew/bin/brew shellenv)"`
   - Linux: Ensure `apt-get` is available and rerun the install scripts

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
