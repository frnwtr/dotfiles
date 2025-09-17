#!/bin/bash

# Homebrew Installation Script
# Installs Homebrew and essential packages for development

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[HOMEBREW]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[HOMEBREW]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[HOMEBREW]${NC} $1"
}

# Helper function to ask for confirmation
ask_confirmation() {
    local app_name="$1"
    local default_response="${2:-n}"
    
    if [[ "$QUIET_MODE" == "true" ]]; then
        [[ "$default_response" == "y" ]]
        return $?
    fi
    
    local prompt="Do you want to install $app_name? (y/N) "
    if [[ "$default_response" == "y" ]]; then
        prompt="Do you want to install $app_name? (Y/n) "
    fi
    
    read -p "$prompt" -n 1 -r
    echo ""
    
    if [[ "$default_response" == "y" ]]; then
        [[ $REPLY =~ ^[Nn]$ ]] && return 1 || return 0
    else
        [[ $REPLY =~ ^[Yy]$ ]] && return 0 || return 1
    fi
}

# Helper function to check if we should install an application
should_install() {
    local app_name="$1"
    local option_var="$2"
    local default_response="${3:-n}"
    
    case "${!option_var}" in
        "yes")
            return 0
            ;;
        "no")
            return 1
            ;;
        "ask")
            ask_confirmation "$app_name" "$default_response"
            return $?
            ;;
        *)
            ask_confirmation "$app_name" "$default_response"
            return $?
            ;;
    esac
}

# Check if Homebrew is already installed
if command -v brew >/dev/null 2>&1; then
    log_info "Homebrew is already installed, updating..."
    brew update
else
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

log_info "Installing essential packages..."

# Essential development tools
brew install --quiet git
brew install --quiet curl
brew install --quiet wget
brew install --quiet jq
brew install --quiet tree
brew install --quiet htop
brew install --quiet gh
brew install --quiet retry
brew install --quiet bc          # Calculator (required by passion theme)

# Prevent unwanted packages that might be installed as dependencies
log_info "Setting up package prevention list..."
if command -v brew >/dev/null 2>&1; then
    # Create a prevention list for unwanted packages
    UNWANTED_PACKAGES=("nginx" "php-fpm" "dnsmasq")
    
    for package in "${UNWANTED_PACKAGES[@]}"; do
        if brew list "$package" >/dev/null 2>&1; then
            log_warning "Found unwanted package: $package - considering removal"
            if [[ "$QUIET_MODE" != "true" ]]; then
                read -p "Do you want to remove $package? (y/N) " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    log_info "Removing $package..."
                    brew uninstall --ignore-dependencies "$package" || log_warning "Failed to remove $package"
                fi
            fi
        fi
    done
fi

# Modern CLI tools for better developer experience
log_info "Installing modern CLI tools..."
brew install --quiet bat          # Better cat with syntax highlighting
brew install --quiet fd           # Better find command
brew install --quiet ripgrep      # Better grep (rg command)
brew install --quiet fzf          # Fuzzy finder for command line
brew install --quiet lazygit      # Terminal UI for git commands
brew install --quiet neovim       # Modern vim alternative
brew install --quiet tmux         # Terminal multiplexer
brew install --quiet delta        # Better git diff viewer
brew install --quiet zoxide       # Better cd command (z command)
brew install --quiet httpie       # Better curl for APIs

# Install fonts (essential for terminal themes like Powerlevel10k)
log_info "Installing developer fonts..."
brew install --cask --quiet font-fira-code-nerd-font
brew install --cask --quiet font-hack-nerd-font
brew install --cask --quiet font-meslo-lg-nerd-font
brew install --cask --quiet font-source-code-pro

# Install Warp terminal (optional)
if should_install "Warp terminal" "INSTALL_GUI_APPS" "y"; then
    if ! brew list --cask warp >/dev/null 2>&1; then
        log_info "Installing Warp terminal..."
        brew install --cask --quiet warp
    else
        log_info "Warp terminal is already installed"
    fi
else
    log_info "Skipping Warp terminal installation"
fi

# Install Docker Desktop (optional)
if should_install "Docker Desktop" "INSTALL_DOCKER" "n"; then
    if ! brew list --cask docker >/dev/null 2>&1; then
        log_info "Installing Docker Desktop..."
        brew install --cask --quiet docker
    else
        log_info "Docker Desktop is already installed"
    fi
else
    log_info "Skipping Docker Desktop installation"
fi

# Install Visual Studio Code (optional)
if should_install "Visual Studio Code" "INSTALL_VSCODE" "n"; then
    log_info "Installing Visual Studio Code..."
    brew install --cask --quiet visual-studio-code || log_warning "VS Code installation failed or already installed"
else
    log_info "Skipping Visual Studio Code installation"
fi

# Install Figma (optional)
if should_install "Figma" "INSTALL_FIGMA" "n"; then
    if ! brew list --cask figma >/dev/null 2>&1; then
        log_info "Installing Figma..."
        brew install --cask --quiet figma
    else
        log_info "Figma is already installed"
    fi
else
    log_info "Skipping Figma installation"
fi

# Install GitHub Desktop (optional)
if should_install "GitHub Desktop" "INSTALL_GITHUB_DESKTOP" "n"; then
    if ! brew list --cask github >/dev/null 2>&1; then
        log_info "Installing GitHub Desktop..."
        brew install --cask --quiet github
    else
        log_info "GitHub Desktop is already installed"
    fi
else
    log_info "Skipping GitHub Desktop installation"
fi

# Install Tailscale (optional)
if should_install "Tailscale (VPN mesh networking)" "INSTALL_TAILSCALE" "n"; then
    if ! brew list --cask tailscale >/dev/null 2>&1; then
        log_info "Installing Tailscale..."
        brew install --cask --quiet tailscale
    else
        log_info "Tailscale is already installed"
    fi
else
    log_info "Skipping Tailscale installation"
fi

# Install ChatGPT (optional)
if should_install "ChatGPT (AI Assistant)" "INSTALL_CHATGPT" "n"; then
    if ! brew list --cask chatgpt >/dev/null 2>&1; then
        log_info "Installing ChatGPT..."
        brew install --cask --quiet chatgpt
    else
        log_info "ChatGPT is already installed"
    fi
else
    log_info "Skipping ChatGPT installation"
fi

# Install Claude (optional)
if should_install "Claude (AI Assistant)" "INSTALL_CLAUDE" "n"; then
    if ! brew list --cask claude >/dev/null 2>&1; then
        log_info "Installing Claude..."
        brew install --cask --quiet claude
    else
        log_info "Claude is already installed"
    fi
else
    log_info "Skipping Claude installation"
fi

# Install JetBrains Toolbox (if any IDE is selected)
INSTALL_ANY_JETBRAINS=false
if [[ "$INSTALL_DATAGRIP" == "yes" ]] || [[ "$INSTALL_PHPSTORM" == "yes" ]] || [[ "$INSTALL_GOLAND" == "yes" ]] || [[ "$INSTALL_WEBSTORM" == "yes" ]]; then
    INSTALL_ANY_JETBRAINS=true
elif [[ "$INSTALL_DATAGRIP" == "ask" ]] || [[ "$INSTALL_PHPSTORM" == "ask" ]] || [[ "$INSTALL_GOLAND" == "ask" ]] || [[ "$INSTALL_WEBSTORM" == "ask" ]]; then
    if [[ "$QUIET_MODE" != "true" ]]; then
        INSTALL_ANY_JETBRAINS=true
    fi
fi

if [[ "$INSTALL_ANY_JETBRAINS" == "true" ]]; then
    # Install JetBrains Toolbox (recommended way to manage JetBrains IDEs)
    if ! brew list --cask jetbrains-toolbox >/dev/null 2>&1; then
        log_info "Installing JetBrains Toolbox..."
        brew install --cask --quiet jetbrains-toolbox
    else
        log_info "JetBrains Toolbox is already installed"
    fi
fi

# Install DataGrip (optional)
if should_install "DataGrip (Database IDE)" "INSTALL_DATAGRIP" "n"; then
    if ! brew list --cask datagrip >/dev/null 2>&1; then
        log_info "Installing DataGrip..."
        brew install --cask --quiet datagrip
    else
        log_info "DataGrip is already installed"
    fi
else
    log_info "Skipping DataGrip installation"
fi

# Install PHPStorm (optional)
if should_install "PHPStorm (PHP IDE)" "INSTALL_PHPSTORM" "n"; then
    if ! brew list --cask phpstorm >/dev/null 2>&1; then
        log_info "Installing PHPStorm..."
        brew install --cask --quiet phpstorm
    else
        log_info "PHPStorm is already installed"
    fi
else
    log_info "Skipping PHPStorm installation"
fi

# Install GoLand (optional)
if should_install "GoLand (Go IDE)" "INSTALL_GOLAND" "n"; then
    if ! brew list --cask goland >/dev/null 2>&1; then
        log_info "Installing GoLand..."
        brew install --cask --quiet goland
    else
        log_info "GoLand is already installed"
    fi
else
    log_info "Skipping GoLand installation"
fi

# Install WebStorm (optional)
if should_install "WebStorm (JavaScript IDE)" "INSTALL_WEBSTORM" "n"; then
    if ! brew list --cask webstorm >/dev/null 2>&1; then
        log_info "Installing WebStorm..."
        brew install --cask --quiet webstorm
    else
        log_info "WebStorm is already installed"
    fi
else
    log_info "Skipping WebStorm installation"
fi

# Install core asdf dependencies
log_info "Installing core asdf dependencies..."
brew install --quiet coreutils
brew install --quiet gpg
brew install --quiet autoconf
brew install --quiet openssl@3
brew install --quiet libyaml
brew install --quiet readline
# Note: Additional asdf dependencies are installed by asdf.sh script

log_success "Homebrew setup complete!"

# Post-installation setup and login flows
log_info "Setting up authentication and services..."

# GitHub CLI authentication
if command -v gh >/dev/null 2>&1; then
    if ! gh auth status >/dev/null 2>&1; then
        echo ""
        log_info "GitHub CLI is installed but not authenticated."
        if [[ "$QUIET_MODE" != "true" ]]; then
            read -p "Would you like to authenticate with GitHub now? (y/N) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Starting GitHub authentication..."
                gh auth login
            else
                log_info "You can authenticate later with: gh auth login"
            fi
        else
            log_info "Run 'gh auth login' to authenticate with GitHub later"
        fi
    else
        log_info "GitHub CLI is already authenticated"
    fi
fi

# Docker Desktop setup
if brew list --cask docker >/dev/null 2>&1; then
    if ! docker info >/dev/null 2>&1; then
        echo ""
        log_info "Docker Desktop is installed but not running."
        log_info "Please start Docker Desktop from Applications or Launchpad."
        log_info "After starting Docker, you may need to accept the license agreement."
        if [[ "$QUIET_MODE" != "true" ]]; then
            read -p "Would you like to open Docker Desktop now? (y/N) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Opening Docker Desktop..."
                open -a "Docker Desktop"
            fi
        else
            log_info "You can start Docker Desktop manually from Applications"
        fi
    else
        log_info "Docker is running and ready to use"
    fi
fi

# Show installed versions
echo ""
log_info "Installed versions:"
echo "  Git: $(git --version | head -1)"
echo "  Curl: $(curl --version | head -1)"
if command -v docker >/dev/null 2>&1; then
    echo "  Docker: $(docker --version)"
else
    echo "  Docker: Not in PATH yet (restart terminal)"
fi

log_info "Homebrew packages installed successfully!"