# 🚀 Dotfiles - Development Environment Setup

This repository contains scripts to automatically set up a complete development environment on macOS. It installs and configures all the essential tools needed for modern software development.

## ✨ What Gets Installed

### 🍺 Package Manager (Always Installed)
- **Homebrew** - The missing package manager for macOS

### 🛠 Essential Development Tools (Always Installed)
- **Git** - Version control system
- **GitHub CLI (gh)** - Official GitHub command line tool
- **Essential CLI tools** - curl, wget, jq, tree, htop, retry

### 🖥 GUI Applications (Optional - Will Prompt)
- **Warp Terminal** - Modern, fast terminal with AI features *(default: yes)*
- **Docker Desktop** - Containerization platform *(default: no)*
- **Visual Studio Code** - Code editor *(default: no)*
- **Figma** - Design and prototyping tool *(default: no)*
- **GitHub Desktop** - Git GUI client *(default: no)*
- **Tailscale** - VPN mesh networking tool *(default: no)*

### 🧰 JetBrains IDEs (Optional - Individual Selection)
- **JetBrains Toolbox** - Automatically installed if any IDE is selected
- **DataGrip** - Database IDE *(individual prompt, default: no)*
- **PHPStorm** - PHP development IDE *(individual prompt, default: no)*
- **GoLand** - Go development IDE *(individual prompt, default: no)*
- **WebStorm** - JavaScript/TypeScript development IDE *(individual prompt, default: no)*

### 📰 Language Version Manager  
- **asdf** - Manage multiple runtime versions with a single CLI tool

### 🔧 Programming Languages (Optional - Individual Selection)
- **Node.js** (latest LTS) - JavaScript runtime *(individual prompt, default: yes)*
- **Go** (latest) - Systems programming language *(individual prompt, default: yes)*
- **PHP** (latest) - Web development language *(individual prompt, default: yes)*

### 🐚 Shell Enhancement
- **Oh My Zsh** - Framework for managing zsh configuration
- **Powerlevel10k** - Beautiful and functional theme
- **Dynamic plugins** - Automatically configures plugins based on installed tools (git, docker, node, python, etc.)
- **Syntax highlighting & autosuggestions** - Enhanced terminal experience
- **Helpful aliases** - git shortcuts, docker commands, navigation helpers

### 🚫 Package Prevention
- **Clean PHP CLI setup** - Removes php-fpm, keeps only PHP CLI
- **nginx prevention** - Prevents system nginx, promotes Docker usage
- **Service prevention** - Avoids system databases/services, promotes containerization
- **Shell protection** - Aliases prevent accidental service installations

## 🚀 Quick Start

### One-Line Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/frnwtr/dotfiles/main/install.sh)
```

### Manual Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/frnwtr/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installation script:**
   ```bash
   ./install.sh
   ```

### Installation Options

The installation script supports command-line options to control what gets installed:

```bash
# Install everything without prompts
./install.sh --gui-apps --docker --vscode --figma --github-desktop --tailscale --node --go --php --datagrip --phpstorm --goland --webstorm

# Install only essential tools (skip GUI applications and languages)
./install.sh --no-gui-apps --no-node --no-go --no-php

# Install specific applications and languages
./install.sh --docker --vscode --node --php --phpstorm --datagrip

# Run in quiet mode (use defaults)
./install.sh --quiet

# Show all available options
./install.sh --help
```

**Available options:**
- `--gui-apps` / `--no-gui-apps` - Control Warp terminal installation
- `--docker` / `--no-docker` - Control Docker Desktop installation
- `--vscode` / `--no-vscode` - Control VS Code installation
- `--figma` / `--no-figma` - Control Figma installation
- `--github-desktop` / `--no-github-desktop` - Control GitHub Desktop installation
- `--tailscale` / `--no-tailscale` - Control Tailscale installation
- `--node` / `--no-node` - Control Node.js installation
- `--go` / `--no-go` - Control Go installation
- `--php` / `--no-php` - Control PHP installation
- `--datagrip` / `--no-datagrip` - Control DataGrip installation
- `--phpstorm` / `--no-phpstorm` - Control PHPStorm installation
- `--goland` / `--no-goland` - Control GoLand installation
- `--webstorm` / `--no-webstorm` - Control WebStorm installation
- `--clean-php-only` - Ensure PHP CLI only setup (remove FPM)
- `--prevent-unwanted-packages` - Remove nginx, mysql, etc. (prefer Docker)
- `--quiet` / `-q` - Skip prompts, use defaults
- `--help` / `-h` - Show help message

3. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

## 🔐 Authentication & Setup

After installation, the script will help you set up authentication for installed services:

### GitHub CLI Authentication
If GitHub CLI is installed, you'll be prompted to authenticate:
```bash
# The script will ask if you want to authenticate now
# Or you can run this command later:
gh auth login
```

### Docker Desktop Setup
If Docker Desktop is installed, the script will:
- Check if Docker is running
- Offer to open Docker Desktop if it's not running
- Remind you to accept the license agreement

### Manual Authentication Commands
```bash
# GitHub CLI authentication
gh auth login

# Check GitHub authentication status
gh auth status

# Docker status check
docker info
```

## 📋 Requirements

- macOS (tested on macOS 12+)
- Internet connection
- Administrator privileges for some installations

## 🔧 Manual Component Installation

You can also run individual setup scripts:

### Install Homebrew and packages:
```bash
./scripts/homebrew.sh
```

### Setup asdf and programming languages:
```bash
./scripts/asdf.sh  
```

### Configure shell:
```bash
./scripts/shell.sh
```

### Package prevention (optional):
```bash
./scripts/prevent-packages.sh [check|auto|aliases|all]
```

## 📁 Project Structure

```
dotfiles/
├── AGENTS.md               # AI agent instructions
├── PACKAGE_PREVENTION.md   # Package prevention guide
├── install.sh              # Main installation script
├── uninstall.sh            # Uninstallation script
├── Brewfile.exclude        # Packages to avoid
├── scripts/
│   ├── homebrew.sh         # Homebrew and packages setup
│   ├── asdf.sh            # asdf and programming languages
│   ├── shell.sh           # Shell configuration
│   └── prevent-packages.sh # Package prevention script
├── config/                # Configuration files (future)
├── shell/                 # Additional shell scripts (future)  
└── README.md              # This file
```

## ⚙️ Customization

### Shell Configuration
The installation creates a comprehensive `.zshrc` file. For personal customizations:

1. **Create a local customization file:**
   ```bash
   touch ~/.zshrc.local
   ```

2. **Add your personal aliases and functions:**
   ```bash
   # ~/.zshrc.local
   alias myalias="echo 'Hello World'"
   export MY_CUSTOM_VAR="value"
   ```

### Node.js Package Managers

When Node.js is installed, you'll be prompted to choose additional package managers:

```bash
# Available options during installation:
# 1) npm (default - always installed)
# 2) yarn - Fast, reliable dependency management
# 3) pnpm - Fast, disk space efficient package manager  
# 4) bun - All-in-one JavaScript runtime & toolkit

# You can also install them manually:
npm install -g yarn
npm install -g pnpm
curl -fsSL https://bun.sh/install | bash

# Turborepo for monorepo management
npm install -g turbo
```

### PHP Development Tools

When PHP is installed, you'll be prompted to choose development tools:

```bash
# Available options during installation:
# 1) Laravel Installer - Create Laravel projects
# 2) Symfony CLI - Symfony development tools
# 3) PHPUnit - PHP testing framework
# 4) PHP_CodeSniffer - Code style checker
# 5) Psalm - Static analysis tool

# Composer (PHP dependency manager) is always installed
# You can also install tools manually:
composer global require laravel/installer
composer global require phpunit/phpunit
curl -sS https://get.symfony.com/cli/installer | bash

# Note: Laravel Valet is excluded from this setup
# For local development, use:
php -S localhost:8000  # Built-in PHP server
# Or use Docker for more complex setups
```

### Programming Language Versions

After installation, you can manage language versions with asdf:

```bash
# List available versions
asdf list all nodejs
asdf list all golang
asdf list all php

# Install specific versions
asdf install nodejs 18.19.0
asdf install golang 1.21.5

# Set global versions  
asdf set nodejs 18.19.0
asdf set golang 1.21.5

# Set project-specific versions
echo "nodejs 18.19.0" >> .tool-versions
echo "golang 1.21.5" >> .tool-versions
```

## 🔍 Verification

After installation, verify everything is working:

```bash
# Check tool versions
node --version
npm --version
go version
php --version
docker --version

# Check asdf
asdf current

# Check shell configuration
echo $PATH
which node
which go
which php
```

## 🐛 Troubleshooting

### Common Issues

**1. Command not found after installation**
- Restart your terminal or run `source ~/.zshrc`
- Check if the tool's directory is in your PATH: `echo $PATH`

**2. asdf command not found**
- Make sure asdf is sourced in your shell: `source ~/.asdf/asdf.sh`
- Restart your terminal

**3. PHP installation takes too long**
- The script may fallback to Homebrew for PHP installation
- You can manually install PHP via asdf later: `asdf install php 8.3.15`

**4. Permission denied errors**
- Make sure you have administrator privileges
- Some Homebrew installations may require password input

**5. Docker not working**
- Make sure Docker Desktop is running
- You may need to accept Docker's license agreement in the GUI

### Getting Help

1. **Check installation logs** - The scripts provide detailed output
2. **Verify prerequisites** - Ensure you're on macOS with admin rights
3. **Run individual scripts** - Test components separately
4. **Reset and retry** - Delete installed components and re-run

## 🔄 Updating

To update your development environment:

```bash
cd ~/dotfiles
git pull origin main
./install.sh
```

## 🗑️ Uninstallation

If you need to remove tools or configurations installed by dotfiles, use the uninstall script:

### Quick Uninstall Options

```bash
# Remove everything (complete uninstallation)
./uninstall.sh --all

# Remove only GUI applications
./uninstall.sh --gui-apps --jetbrains

# Remove only programming languages and asdf
./uninstall.sh --asdf

# Remove only shell configurations (keeps tools installed)
./uninstall.sh --config-files --oh-my-zsh

# See what would be removed without actually removing (dry run)
./uninstall.sh --dry-run --all

# Interactive mode (prompts for each category)
./uninstall.sh
```

### Uninstall Options

- `--homebrew` - Remove Homebrew and all its packages ⚠️ **WARNING: Very destructive**
- `--asdf` - Remove asdf and all installed programming languages
- `--oh-my-zsh` - Remove Oh My Zsh and related shell configurations
- `--config-files` - Remove dotfiles-generated configuration files (.zshrc, etc.)
- `--global-packages` - Remove global packages (npm, composer, yarn, etc.)
- `--gui-apps` - Remove GUI applications (Warp, VS Code, Docker, etc.)
- `--jetbrains` - Remove JetBrains IDEs and Toolbox
- `--all` - Remove everything managed by dotfiles
- `--dry-run` - Show what would be removed without actually removing
- `--quiet` - Skip prompts and use defaults
- `--help` - Show detailed help message

### What Gets Preserved

- **Configuration backups** are created before removal
- **Personal files** outside the dotfiles scope are never touched
- **Project-specific configurations** (like `.tool-versions` files in your projects)
- **Application data** that isn't part of the installation

**Important:** The uninstall script will create backups of your current configurations before removing them. Check `~/.zshrc.pre-dotfiles-uninstall` for your previous shell configuration.

## 🎯 Available Aliases

After installation, you'll have access to useful aliases:

### Git Shortcuts
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gl` - git log --oneline --graph --decorate
- `gd` - git diff
- `gb` - git branch
- `gco` - git checkout

### Docker Shortcuts  
- `dc` - docker-compose
- `dcu` - docker-compose up
- `dcd` - docker-compose down
- `dcb` - docker-compose build
- `dps` - docker ps
- `di` - docker images

### Navigation
- `ll` - ls -alF
- `la` - ls -A  
- `..` - cd ..
- `...` - cd ../..
- `mkcd` - mkdir and cd into directory

## 🤝 Contributing

Feel free to customize this setup for your needs:

1. Fork this repository
2. Make your changes
3. Test the installation on a fresh macOS system
4. Submit a pull request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Homebrew](https://brew.sh/) - Package management
- [asdf](https://asdf-vm.com/) - Version management
- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [Warp](https://www.warp.dev/) - Modern terminal

---

**Happy coding!** 🎉

If you find this useful, please ⭐ star this repository!