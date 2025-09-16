# AI Agent Instructions for Dotfiles Management

This document provides instructions for AI agents on how to properly manage and modify this dotfiles repository.

## 📁 Repository Structure

```
dotfiles/
├── AGENTS.md             # This file - agent instructions
├── install.sh           # Main installation script
├── uninstall.sh         # Uninstallation script
├── test.sh              # Testing script for validation
├── README.md            # User documentation
├── .gitignore           # Git ignore rules
└── scripts/
    ├── homebrew.sh       # Homebrew package management
    ├── asdf.sh          # Programming language version management
    └── shell.sh         # Shell configuration setup
```

## 🚀 Command-Line Options

The installation script supports command-line options to control optional installations:

```bash
# Install everything without prompts
./install.sh --gui-apps --docker --vscode --figma --github-desktop --node --go --php --datagrip --phpstorm --goland --webstorm

# Skip all GUI applications and languages
./install.sh --no-gui-apps --no-node --no-go --no-php

# Install specific applications and languages
./install.sh --docker --vscode --node --php --phpstorm --datagrip

# Run in quiet mode with defaults
./install.sh --quiet

# Show help
./install.sh --help
```

**Available options:**
- `--gui-apps` / `--no-gui-apps` - Control Warp terminal installation
- `--docker` / `--no-docker` - Control Docker Desktop installation
- `--vscode` / `--no-vscode` - Control VS Code installation
- `--figma` / `--no-figma` - Control Figma installation
- `--github-desktop` / `--no-github-desktop` - Control GitHub Desktop installation
- `--node` / `--no-node` - Control Node.js installation
- `--go` / `--no-go` - Control Go installation
- `--php` / `--no-php` - Control PHP installation
- `--datagrip` / `--no-datagrip` - Control DataGrip installation
- `--phpstorm` / `--no-phpstorm` - Control PHPStorm installation
- `--goland` / `--no-goland` - Control GoLand installation
- `--webstorm` / `--no-webstorm` - Control WebStorm installation
- `--quiet` / `-q` - Skip prompts, use defaults
- `--help` / `-h` - Show help message

## 🗑️ Uninstall Script (uninstall.sh)

The uninstall script provides a safe way to remove tools and configurations installed by the dotfiles setup.

### Key Features
- **Selective removal** - Choose what to remove (GUI apps, languages, configs, etc.)
- **Dry run mode** - Preview what would be removed without actually removing it
- **Configuration backup** - Automatically backs up current configurations
- **Interactive mode** - Prompts for confirmation on destructive operations
- **Command-line options** - Full automation support for scripted usage

### Design Principles
- **Safety first** - Never remove files outside dotfiles scope
- **Preserve user data** - Backup configurations before removal
- **Clear warnings** - Prominent warnings for destructive operations (especially `--homebrew`)
- **Granular control** - Allow removal of specific categories without affecting others
- **Reversible where possible** - Restore from backups when available

### Command Structure
```bash
# Interactive mode (prompts for each category)
./uninstall.sh

# Specific removals
./uninstall.sh --gui-apps --jetbrains
./uninstall.sh --asdf --config-files

# Complete removal
./uninstall.sh --all

# Safe preview
./uninstall.sh --dry-run --all
```

### Uninstall Categories
1. **Configuration files** (`.zshrc`, etc.) - Restores from backups if available
2. **Global packages** - npm, yarn, pnpm, composer packages
3. **GUI applications** - Warp, VS Code, Docker, Figma, GitHub Desktop
4. **JetBrains IDEs** - All IDEs plus Toolbox, including config directories
5. **Oh My Zsh** - Framework, themes, plugins, Powerlevel10k config
6. **asdf & languages** - Version manager and all installed languages
7. **Homebrew** - ⚠️ **Most destructive** - removes ALL Homebrew packages

### Safety Features
- **Double confirmation** for Homebrew removal
- **Automatic backups** of shell configurations
- **Skip missing tools** gracefully (no errors for already-removed items)
- **Preserve project configs** (never touches `.tool-versions` in projects)
- **Clear logging** with colored output and summary

### When to Update
Update the uninstall script when:
- Adding new GUI applications to `homebrew.sh`
- Adding new global package managers or tools
- Changing configuration file locations
- Adding new programming languages or version managers
- Modifying shell configuration structure

## 🎯 Core Principles

### 1. **Idempotent Operations**
- All scripts should be safe to run multiple times
- Check if tools/packages are already installed before attempting installation
- Use appropriate flags like `--quiet` for Homebrew to reduce output

### 2. **Cross-Platform Compatibility**
- Primary target: **macOS** (Apple Silicon and Intel)
- Use Homebrew as the primary package manager
- Prefer `asdf` for programming language version management over direct installations

### 3. **Error Handling**
- Always use `set -e` for strict error handling in bash scripts
- Provide meaningful error messages with colored output
- Include fallback options where appropriate (e.g., Homebrew PHP if asdf fails)

## 🛠 Script Management Guidelines

### homebrew.sh
**Purpose:** Install and manage system packages and applications

**Key sections:**
- Essential development tools (git, curl, wget, jq, tree, htop, gh, retry) - always installed
- GUI applications via casks (Warp, Docker, VS Code, JetBrains tools) - optional with prompts
- asdf build dependencies - always installed
- Version verification at the end

**Optional Installation System:**
The script uses environment variables set by `install.sh` to control optional installations:
- `INSTALL_GUI_APPS` - Controls Warp terminal (default: ask, defaults to yes)
- `INSTALL_DOCKER` - Controls Docker Desktop (default: ask, defaults to no)
- `INSTALL_VSCODE` - Controls VS Code (default: ask, defaults to no) 
- `INSTALL_FIGMA` - Controls Figma (default: ask, defaults to no)
- `INSTALL_GITHUB_DESKTOP` - Controls GitHub Desktop (default: ask, defaults to no)
- `INSTALL_DATAGRIP` - Controls DataGrip (default: ask, defaults to no)
- `INSTALL_PHPSTORM` - Controls PHPStorm (default: ask, defaults to no)
- `INSTALL_GOLAND` - Controls GoLand (default: ask, defaults to no)
- `INSTALL_WEBSTORM` - Controls WebStorm (default: ask, defaults to no)
- `QUIET_MODE` - Skip prompts and use defaults (default: false)

**When adding essential packages:**
```bash
# Check if already installed first
if ! brew list package-name >/dev/null 2>&1; then
    log_info "Installing package-name..."
    brew install --quiet package-name
else
    log_info "package-name already installed"
fi
```

**When adding optional GUI applications:**
```bash
# Use the should_install helper function
if should_install "Application Name" "INSTALL_OPTION_VAR" "default_response"; then
    if ! brew list --cask app-name >/dev/null 2>&1; then
        log_info "Installing Application Name..."
        brew install --cask --quiet app-name
    else
        log_info "Application Name is already installed"
    fi
else
    log_info "Skipping Application Name installation"
fi
```

### asdf.sh
**Purpose:** Manage programming language versions

**Current languages:** Node.js, Go, PHP (each individually optional)

**Individual Language Selection:**
The script uses environment variables to control individual language installation:
- `INSTALL_NODE` - Controls Node.js installation (default: ask, defaults to yes)
- `INSTALL_GO` - Controls Go installation (default: ask, defaults to yes)
- `INSTALL_PHP` - Controls PHP installation (default: ask, defaults to yes)

**Important notes:**
- Sources asdf from Homebrew installation path: `/opt/homebrew/opt/asdf/libexec/asdf.sh`
- Falls back to git installation if Homebrew version not found
- PHP compilation requires extensive Homebrew dependencies
- Creates global `.tool-versions` file with only installed languages

**Adding new languages:**
1. Add plugin installation with `install_plugin` function
2. Install latest version with `asdf install`
3. Set global version with `asdf set`
4. Add to `.tool-versions` generation
5. Add version check in verification section

### shell.sh
**Purpose:** Configure shell environment and dotfiles

**Responsibilities:**
- Install and configure Zsh with Oh My Zsh
- Set up Powerlevel10k theme with zsh-autosuggestions and zsh-syntax-highlighting
- **Dynamic plugin detection** - Automatically configures Oh My Zsh plugins based on installed tools
- **Node.js package manager selection** - Prompts for yarn, pnpm, bun installation when Node.js is detected
- **Turborepo option** - Offers monorepo build system installation
- **PHP development tools** - Installs Composer and prompts for Laravel Valet, Symfony CLI, testing tools
- Create comprehensive `.zshrc` with aliases and functions
- Configure shell environment for all installed tools

**Dynamic Plugin System:**
The script detects installed tools and automatically configures relevant Oh My Zsh plugins:
- `git, brew` - Always included
- `docker, docker-compose` - If Docker is installed
- `node, npm` - If Node.js is installed
- `yarn, pnpm, bun` - If respective package managers are installed
- `golang` - If Go is installed
- `asdf` - If asdf version manager is installed
- `vscode` - If Visual Studio Code is installed
- `github` - If GitHub Desktop is installed
- `python, pip` - If Python is installed
- `php` - If PHP is installed
- `composer` - If Composer is installed
- `laravel, laravel5` - If Laravel CLI is installed
- `symfony, symfony2` - If Symfony CLI is installed

### Post-Installation Flows
**Purpose:** Set up authentication and service configuration

**GitHub CLI Authentication:**
- Automatically detects if `gh` is installed but not authenticated
- Prompts user to authenticate interactively (unless in quiet mode)
- Uses `gh auth login` for authentication flow
- Skips if already authenticated

**Docker Desktop Setup:**
- Checks if Docker Desktop is installed but not running
- Offers to open Docker Desktop application
- Provides guidance about license agreement acceptance
- Uses `docker info` to check Docker daemon status

## 📝 Adding New Tools

### For System Tools (via Homebrew)
1. Add to `homebrew.sh` in the appropriate section
2. Follow the existing pattern with availability checks
3. Add version verification in the summary section
4. Update main `README.md` if it's a significant addition

### For Programming Languages (via asdf)
1. Add plugin installation to `asdf.sh`
2. Handle any special build dependencies via Homebrew
3. Add to global `.tool-versions` generation
4. Include in verification output
5. Document in `README.md` customization section

### For Configuration Files
1. Add generation logic to `shell.sh`
2. Ensure backup of existing files
3. Use templating for dynamic content
4. Test with both fresh installs and updates

## 🧪 Testing Requirements

### Before Modifying Scripts
1. Run `./test.sh` to validate current state
2. Test individual scripts: `./scripts/script-name.sh`
3. Verify idempotency by running scripts multiple times

### After Modifications
1. Test on a fresh macOS environment if possible
2. Verify all tools are accessible after installation
3. Check that existing installations aren't broken
4. Update `README.md` if functionality changes

## 🚨 Important Constraints

### What NOT to do:
- **Never remove existing tool installations** without explicit user request
- **Don't modify user's personal files** outside of dotfiles scope
- **Avoid breaking changes** to existing script interfaces
- **Don't install tools globally** that should be project-specific

### Always consider:
- **Backward compatibility** with existing installations
- **User customization** - support for `.local` override files
- **Security** - only install from trusted sources
- **Performance** - use quiet flags and parallel operations where safe

## 🔍 Common Troubleshooting

### asdf Issues
- Check if sourced correctly in shell environment
- Verify Homebrew vs git installation paths
- Ensure build dependencies are installed for compiled languages

### Homebrew Issues
- Update Homebrew before installing new packages
- Check for architecture-specific paths (Apple Silicon vs Intel)
- Use `--quiet` flag to reduce verbose output

### Shell Configuration
- Always backup existing configurations
- Test new aliases and functions before committing
- Ensure compatibility with both interactive and non-interactive shells

## 📋 Change Log Format

When modifying scripts, document changes clearly:

```markdown
## Changes Made
- **Added:** retry CLI to essential tools in homebrew.sh
- **Fixed:** asdf sourcing to work with Homebrew installation
- **Updated:** PHP build dependencies for macOS compatibility
```

## 🎓 Best Practices

1. **Read the existing code** before making changes
2. **Follow established patterns** for consistency
3. **Test incrementally** rather than making large changes
4. **Document significant changes** in commit messages
5. **Consider the user experience** - minimize required interaction
6. **Maintain the logging style** with colored output for clarity

---

This repository is designed to be **self-contained**, **reliable**, and **easy to maintain**. When in doubt, prioritize stability over new features, and always test changes thoroughly before committing.