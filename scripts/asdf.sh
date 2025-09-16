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

# Helper function to ask for confirmation
ask_language_confirmation() {
    local language="$1"
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
            if [[ "$QUIET_MODE" == "true" ]]; then
                [[ "$default_response" == "y" ]]
                return $?
            fi
            
            local prompt="Do you want to install $language? (y/N) "
            if [[ "$default_response" == "y" ]]; then
                prompt="Do you want to install $language? (Y/n) "
            fi
            
            read -p "$prompt" -n 1 -r
            echo ""
            
            if [[ "$default_response" == "y" ]]; then
                [[ $REPLY =~ ^[Nn]$ ]] && return 1 || return 0
            else
                [[ $REPLY =~ ^[Yy]$ ]] && return 0 || return 1
            fi
            ;;
        *)
            if [[ "$default_response" == "y" ]]; then
                return 0
            else
                return 1
            fi
            ;;
    esac
}

# Install asdf if not already installed
if [ ! -d "$HOME/.asdf" ]; then
    log_info "Installing asdf..."
    brew install asdf
else
    log_info "asdf is already installed"
fi

# Source asdf in current shell - try Homebrew first, then git installation
if [ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]; then
    source "/opt/homebrew/opt/asdf/libexec/asdf.sh"
elif [ -f "$HOME/.asdf/asdf.sh" ]; then
    export PATH="$HOME/.asdf/bin:$PATH"
    source "$HOME/.asdf/asdf.sh"
else
    log_error "asdf not found in expected locations"
    exit 1
fi

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

# Install Node.js (optional)
if ask_language_confirmation "Node.js" "INSTALL_NODE" "y"; then
    log_info "Setting up Node.js..."
    install_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
    
    # Install latest LTS Node.js
    log_info "Installing latest LTS Node.js..."
    NODEJS_VERSION=$(asdf latest nodejs)
    asdf install nodejs "$NODEJS_VERSION" || log_warning "Node.js installation may have failed"
    asdf set nodejs "$NODEJS_VERSION" || log_warning "Failed to set Node.js version"
else
    log_info "Skipping Node.js installation"
    NODEJS_VERSION=""
fi

# Install Go (optional)
if ask_language_confirmation "Go" "INSTALL_GO" "y"; then
    log_info "Setting up Go..."
    install_plugin "golang" "https://github.com/asdf-community/asdf-golang.git"
    
    # Install latest Go
    log_info "Installing latest Go..."
    GOLANG_VERSION=$(asdf latest golang)
    asdf install golang "$GOLANG_VERSION" || log_warning "Go installation may have failed"
    asdf set golang "$GOLANG_VERSION" || log_warning "Failed to set Go version"
else
    log_info "Skipping Go installation"
    GOLANG_VERSION=""
fi

# Install PHP (optional)
if ask_language_confirmation "PHP" "INSTALL_PHP" "y"; then
    log_info "Setting up PHP..."
    install_plugin "php" "https://github.com/asdf-community/asdf-php.git"

# Install PHP build dependencies via Homebrew
log_info "Installing PHP build dependencies via Homebrew..."
if command -v brew >/dev/null 2>&1; then
    # Core dependencies for PHP compilation on macOS
    HOMEBREW_DEPENDENCIES=(
        "autoconf"
        "bison"
        "re2c"
        "pkg-config"
        "libxml2"
        "openssl@3"
        "icu4c"
        "libzip"
        "oniguruma"
        "zlib"
        "libjpeg"
        "libpng"
        "freetype"
        "libgd"
        "gettext"
        "curl"
        "libedit"
        "libsodium"
        "gmp"
    )
    
    for dep in "${HOMEBREW_DEPENDENCIES[@]}"; do
        if brew list "$dep" >/dev/null 2>&1; then
            log_info "$dep already installed"
        else
            log_info "Installing $dep..."
            brew install "$dep" || log_warning "Failed to install $dep"
        fi
    done
else
    log_error "Homebrew not available for PHP dependencies"
    exit 1
fi

# Set up comprehensive environment for PHP compilation
log_info "Setting up compilation environment..."
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:/opt/homebrew/share/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-L/opt/homebrew/lib -L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/opt/icu4c/lib -L/opt/homebrew/opt/libedit/lib -L/opt/homebrew/opt/bison/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/include -I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/opt/icu4c/include -I/opt/homebrew/opt/libedit/include -I/opt/homebrew/opt/bison/include $CPPFLAGS"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"

# Try to install PHP via asdf
log_info "Installing PHP via asdf..."
PHP_VERSION=$(asdf latest php 2>/dev/null || echo "8.3.15")
log_info "Installing PHP ${PHP_VERSION}..."

if asdf list php 2>/dev/null | grep -q "$PHP_VERSION"; then
    log_info "PHP $PHP_VERSION already installed via asdf"
    asdf set php "$PHP_VERSION" || log_warning "Failed to set PHP version"
else
    log_info "This may take 20-30 minutes. Installing PHP $PHP_VERSION..."
    if asdf install php "$PHP_VERSION"; then
        log_success "PHP $PHP_VERSION installed successfully"
        asdf set php "$PHP_VERSION" || log_warning "Failed to set PHP version"
    else
        log_error "PHP installation via asdf failed"
        log_info "Falling back to Homebrew PHP installation..."
        brew install php || log_error "Homebrew PHP installation also failed"
    fi
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
TOOL_VERSIONS_CONTENT=""

# Add installed languages to .tool-versions
if [[ -n "$NODEJS_VERSION" ]]; then
    TOOL_VERSIONS_CONTENT="nodejs $NODEJS_VERSION"
fi

if [[ -n "$GOLANG_VERSION" ]]; then
    if [[ -n "$TOOL_VERSIONS_CONTENT" ]]; then
        TOOL_VERSIONS_CONTENT="$TOOL_VERSIONS_CONTENT\ngolang $GOLANG_VERSION"
    else
        TOOL_VERSIONS_CONTENT="golang $GOLANG_VERSION"
    fi
fi

# Add PHP to .tool-versions if installed via asdf
if [[ -n "$PHP_VERSION" ]] && asdf list php 2>/dev/null | grep -q "$PHP_VERSION"; then
    if [[ -n "$TOOL_VERSIONS_CONTENT" ]]; then
        TOOL_VERSIONS_CONTENT="$TOOL_VERSIONS_CONTENT\nphp $PHP_VERSION"
    else
        TOOL_VERSIONS_CONTENT="php $PHP_VERSION"
    fi
fi

# Only create .tool-versions if we have content
if [[ -n "$TOOL_VERSIONS_CONTENT" ]]; then
    printf "$TOOL_VERSIONS_CONTENT" > "$HOME/.tool-versions"
else
    log_info "No languages installed, skipping .tool-versions creation"
fi

log_success "Programming languages setup complete!"
fi