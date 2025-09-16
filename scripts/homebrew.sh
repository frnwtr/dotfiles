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

# Install Warp terminal
if ! brew list --cask warp >/dev/null 2>&1; then
    log_info "Installing Warp terminal..."
    brew install --cask --quiet warp
else
    log_info "Warp terminal is already installed"
fi

# Install Docker Desktop
if ! brew list --cask docker >/dev/null 2>&1; then
    log_info "Installing Docker Desktop..."
    brew install --cask --quiet docker
else
    log_info "Docker Desktop is already installed"
fi

# Install other useful casks
log_info "Installing additional development tools..."
brew install --cask --quiet visual-studio-code || log_warning "VS Code installation failed or already installed"

# Install asdf dependencies
log_info "Installing asdf dependencies..."
brew install --quiet coreutils
brew install --quiet curl
brew install --quiet git
brew install --quiet gpg
brew install --quiet autoconf
brew install --quiet openssl
brew install --quiet libyaml
brew install --quiet readline
brew install --quiet libxslt
brew install --quiet libtool
brew install --quiet unixodbc

log_success "Homebrew setup complete!"

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