#!/bin/bash

# asdf Version Manager Setup Script
# Installs asdf and sets up Node.js, Go, and PHP

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[ASDF]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[ASDF]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[ASDF]${NC} $1"
}

log_error() {
    echo -e "${RED}[ASDF]${NC} $1"
}

# Install asdf if not already installed
if [ ! -d "$HOME/.asdf" ]; then
    log_info "Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.18.0
else
    log_info "asdf is already installed"
fi

# Source asdf in current shell
export PATH="$HOME/.asdf/bin:$PATH"
source "$HOME/.asdf/asdf.sh"

# Function to install asdf plugin if not already installed
install_plugin() {
    local plugin_name=$1
    local plugin_url=$2
    
    if ! asdf plugin list | grep -q "^${plugin_name}$"; then
        log_info "Adding ${plugin_name} plugin..."
        if [ -n "$plugin_url" ]; then
            asdf plugin add "$plugin_name" "$plugin_url"
        else
            asdf plugin add "$plugin_name"
        fi
    else
        log_info "${plugin_name} plugin already installed"
    fi
}

# Install Node.js
log_info "Setting up Node.js..."
install_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

# Install latest LTS Node.js
log_info "Installing latest LTS Node.js..."
NODEJS_VERSION=$(asdf latest nodejs)
asdf install nodejs "$NODEJS_VERSION" || log_warning "Node.js installation may have failed"
asdf set nodejs "$NODEJS_VERSION" || log_warning "Failed to set Node.js version"

# Install Go
log_info "Setting up Go..."
install_plugin "golang" "https://github.com/asdf-community/asdf-golang.git"

# Install latest Go
log_info "Installing latest Go..."
GOLANG_VERSION=$(asdf latest golang)
asdf install golang "$GOLANG_VERSION" || log_warning "Go installation may have failed"
asdf set golang "$GOLANG_VERSION" || log_warning "Failed to set Go version"

# Install PHP
log_info "Setting up PHP..."
install_plugin "php" "https://github.com/asdf-community/asdf-php.git"

# For PHP, we'll install via Homebrew first for dependencies, then try asdf
if ! command -v php >/dev/null 2>&1; then
    log_info "Installing PHP via Homebrew (fallback)..."
    if command -v brew >/dev/null 2>&1; then
        brew install php
    else
        log_error "Neither asdf PHP nor Homebrew available for PHP installation"
    fi
fi

# Try to install PHP via asdf (this may take a while)
log_info "Attempting to install PHP via asdf..."
PHP_VERSION=$(asdf latest php 2>/dev/null || echo "8.3.15")
log_info "Installing PHP ${PHP_VERSION}..."

# Set up environment for PHP compilation
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-L/opt/homebrew/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/include $CPPFLAGS"

# This might take a long time, so we'll run it in the background
if asdf list php | grep -q "$PHP_VERSION"; then
    log_info "PHP $PHP_VERSION already installed via asdf"
else
    log_warning "PHP installation via asdf can take 30+ minutes. Skipping for now."
    log_info "You can install PHP later with: asdf install php $PHP_VERSION"
fi

# Reshim to update shims
log_info "Updating asdf shims..."
asdf reshim

log_success "asdf setup complete!"

# Show installed versions
echo ""
log_info "Installed versions:"
if command -v node >/dev/null 2>&1; then
    echo "  Node.js: $(node --version)"
    echo "  npm: $(npm --version)"
else
    echo "  Node.js: Installation may have failed"
fi

if command -v go >/dev/null 2>&1; then
    echo "  Go: $(go version | cut -d' ' -f3-4)"
else
    echo "  Go: Installation may have failed"
fi

if command -v php >/dev/null 2>&1; then
    echo "  PHP: $(php --version | head -1)"
else
    echo "  PHP: Not available"
fi

# Create .tool-versions file in home directory
log_info "Creating global .tool-versions file..."
cat > "$HOME/.tool-versions" << EOF
nodejs $NODEJS_VERSION
golang $GOLANG_VERSION
EOF

log_success "Programming languages setup complete!"