#!/bin/bash

# asdf Version Manager Setup Script
# Installs asdf and sets up programming languages: Node.js, Go, PHP, Python
# Also installs related tools: Composer, Yarn, pnpm, Bun

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

# Install basic asdf dependencies (shared across all languages)
log_info "Installing basic asdf dependencies..."
if command -v brew >/dev/null 2>&1; then
    # Basic dependencies for all asdf language installations
    BASIC_DEPENDENCIES=(
        "gawk" "xz" "tcl-tk" "gdbm" "libffi" "libtool" "unixodbc"
    )
    
    for dep in "${BASIC_DEPENDENCIES[@]}"; do
        if brew list "$dep" >/dev/null 2>&1; then
            log_info "$dep already installed"
        else
            log_info "Installing $dep..."
            brew install "$dep" --quiet || log_warning "Failed to install $dep"
        fi
    done
else
    log_error "Homebrew not available for dependencies"
    exit 1
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


# Initialize version variables
NODEJS_VERSION=""
YARN_VERSION=""
PNPM_VERSION=""
BUN_VERSION=""
GOLANG_VERSION=""
PHP_VERSION=""
COMPOSER_VERSION=""
PYTHON_VERSION=""

# Install Node.js (optional)
if ask_language_confirmation "Node.js" "INSTALL_NODE" "y"; then
    log_info "Setting up Node.js..."
    
    # Install Node.js
    install_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
    log_info "Installing Node.js LTS..."
    NODEJS_VERSION="lts"
    asdf install nodejs "$NODEJS_VERSION" || log_warning "Node.js installation may have failed"
    
    # Ask about package managers individually
    echo ""
    log_info "Node.js package managers (optional):"
    
    # Install Yarn (optional)
    if [[ "$INSTALL_YARN" == "yes" ]] || ([[ "$INSTALL_YARN" == "ask" ]] && [[ "$QUIET_MODE" != "true" ]] && { read -p "Do you want to install Yarn? (y/N) " -n 1 -r; echo ""; [[ $REPLY =~ ^[Yy]$ ]]; }); then
        log_info "Setting up Yarn..."
        install_plugin "yarn"
        YARN_VERSION=$(asdf latest yarn)
        asdf install yarn "$YARN_VERSION" || log_warning "Yarn installation may have failed"
    else
        log_info "Skipping Yarn installation"
    fi
    
    # Install pnpm (optional)
    if [[ "$INSTALL_PNPM" == "yes" ]] || ([[ "$INSTALL_PNPM" == "ask" ]] && [[ "$QUIET_MODE" != "true" ]] && { read -p "Do you want to install pnpm? (y/N) " -n 1 -r; echo ""; [[ $REPLY =~ ^[Yy]$ ]]; }); then
        log_info "Setting up pnpm..."
        install_plugin "pnpm" "https://github.com/jonathanmorley/asdf-pnpm.git"
        PNPM_VERSION=$(asdf latest pnpm)
        asdf install pnpm "$PNPM_VERSION" || log_warning "pnpm installation may have failed"
    else
        log_info "Skipping pnpm installation"
    fi
    
    # Install Bun (optional)
    if [[ "$INSTALL_BUN" == "yes" ]] || ([[ "$INSTALL_BUN" == "ask" ]] && [[ "$QUIET_MODE" != "true" ]] && { read -p "Do you want to install Bun? (y/N) " -n 1 -r; echo ""; [[ $REPLY =~ ^[Yy]$ ]]; }); then
        log_info "Setting up Bun..."
        install_plugin "bun" "https://github.com/cometkim/asdf-bun.git"
        BUN_VERSION=$(asdf latest bun)
        asdf install bun "$BUN_VERSION" || log_warning "Bun installation may have failed"
    else
        log_info "Skipping Bun installation"
    fi
else
    log_info "Skipping Node.js installation"
fi

# Install Go (optional)
if ask_language_confirmation "Go" "INSTALL_GO" "n"; then
    log_info "Setting up Go..."
    install_plugin "golang" "https://github.com/asdf-community/asdf-golang.git"
    
    # Install latest Go
    log_info "Installing latest Go..."
    GOLANG_VERSION=$(asdf latest golang)
    asdf install golang "$GOLANG_VERSION" || log_warning "Go installation may have failed"
else
    log_info "Skipping Go installation"
fi

# Install PHP via asdf (optional)
if ask_language_confirmation "PHP ecosystem (PHP with asdf)" "INSTALL_PHP" "n"; then
    log_info "Setting up PHP ecosystem with asdf..."
    
    # Check and remove Homebrew PHP if present
    if command -v brew >/dev/null 2>&1; then
        if brew list php >/dev/null 2>&1; then
            log_info "Removing existing Homebrew PHP installation..."
            # Stop PHP-FPM service if running
            if brew services list | grep -q "php.*started"; then
                log_info "Stopping PHP-FPM service..."
                brew services stop php 2>/dev/null || true
            fi
            # Uninstall Homebrew PHP
            brew uninstall --ignore-dependencies php || log_warning "Failed to uninstall Homebrew PHP"
        fi
        
        # Install PHP build dependencies
        log_info "Installing PHP build dependencies..."
        PHP_DEPENDENCIES=(
            "autoconf" "automake" "bison" "freetype" "gd" "gettext" 
            "icu4c" "krb5" "libedit" "libiconv" "libjpeg" "libpng" 
            "libxml2" "libzip" "pkg-config" "re2c" "zlib"
            "gmp" "libsodium" "imagemagick" "ffmpeg" "oniguruma" "sqlite"
        )
        
        for dep in "${PHP_DEPENDENCIES[@]}"; do
            if brew list "$dep" >/dev/null 2>&1; then
                log_info "$dep already installed"
            else
                log_info "Installing $dep..."
                brew install "$dep" --quiet || log_warning "Failed to install $dep"
            fi
        done
    else
        log_error "Homebrew not available for PHP dependencies"
        exit 1
    fi
    
    # Set up compilation environment for PHP
    export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:/opt/homebrew/share/pkgconfig:$PKG_CONFIG_PATH"
    export LDFLAGS="-L/opt/homebrew/lib -L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/opt/icu4c/lib -L/opt/homebrew/opt/libedit/lib -L/opt/homebrew/opt/bison/lib -L/opt/homebrew/opt/libiconv/lib -L/opt/homebrew/opt/krb5/lib $LDFLAGS"
    export CPPFLAGS="-I/opt/homebrew/include -I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/opt/icu4c/include -I/opt/homebrew/opt/libedit/include -I/opt/homebrew/opt/bison/include -I/opt/homebrew/opt/libiconv/include -I/opt/homebrew/opt/krb5/include $CPPFLAGS"
    export PATH="/opt/homebrew/opt/bison/bin:$PATH"
    
    # PHP compilation configuration - required for successful PHP build
    export PHP_WITHOUT_PEAR=yes
    export PHP_CONFIGURE_OPTIONS="--with-openssl=/opt/homebrew/opt/openssl@3 --with-iconv=/opt/homebrew/opt/libiconv --with-kerberos=/opt/homebrew/opt/krb5"
    
    # Install PHP with custom build configuration
    install_plugin "php" "https://github.com/asdf-community/asdf-php.git"
    log_info "Installing latest PHP with enhanced build configuration (this may take 20-30 minutes)..."
    log_info "Build features: OpenSSL 3.x, iconv, Kerberos, GMP, libsodium, ImageMagick, FFmpeg support"
    PHP_VERSION=$(asdf latest php)
    asdf install php "$PHP_VERSION" || log_warning "PHP installation may have failed"
    
    # Note: Composer is installed automatically by asdf-php plugin
    log_info "Composer is installed automatically with asdf PHP"
    COMPOSER_VERSION="asdf-managed"
    
else
    log_info "Skipping PHP ecosystem installation"
fi

# Install Python (optional)
if ask_language_confirmation "Python" "INSTALL_PYTHON" "n"; then
    log_info "Setting up Python..."
    install_plugin "python"
    
    log_info "Installing latest Python..."
    PYTHON_VERSION=$(asdf latest python)
    asdf install python "$PYTHON_VERSION" || log_warning "Python installation may have failed"
else
    log_info "Skipping Python installation"
fi


# Reshim to update all shims
log_info "Updating asdf shims..."
asdf reshim

log_success "asdf setup complete!"

# Show installed versions
echo ""
log_info "Installed versions:"

# Node.js ecosystem
if command -v node >/dev/null 2>&1; then
    echo "  Node.js: $(node --version)"
    echo "  npm: $(npm --version)"
else
    echo "  Node.js: Not installed"
fi

if command -v yarn >/dev/null 2>&1; then
    echo "  Yarn: $(yarn --version)"
fi

if command -v pnpm >/dev/null 2>&1; then
    echo "  pnpm: $(pnpm --version)"
fi

if command -v bun >/dev/null 2>&1; then
    echo "  Bun: $(bun --version)"
fi

# Other languages
if command -v go >/dev/null 2>&1; then
    echo "  Go: $(go version | cut -d' ' -f3-4)"
else
    echo "  Go: Not installed"
fi

if command -v php >/dev/null 2>&1; then
    echo "  PHP: $(php --version | head -1)"
else
    echo "  PHP: Not installed"
fi

if command -v composer >/dev/null 2>&1; then
    echo "  Composer: $(composer --version --no-ansi | cut -d' ' -f1-3)"
fi

if command -v python >/dev/null 2>&1; then
    echo "  Python: $(python --version)"
else
    echo "  Python: Not installed"
fi


# Create .tool-versions file in home directory
log_info "Creating global .tool-versions file..."
TOOL_VERSIONS_CONTENT=""

# Helper function to add to tool-versions
add_to_tool_versions() {
    local tool="$1"
    local version="$2"
    if [[ -n "$version" ]]; then
        if [[ -n "$TOOL_VERSIONS_CONTENT" ]]; then
            TOOL_VERSIONS_CONTENT="$TOOL_VERSIONS_CONTENT\n$tool $version"
        else
            TOOL_VERSIONS_CONTENT="$tool $version"
        fi
    fi
}

# Add installed tools to .tool-versions (only asdf-managed tools with actual versions)
add_to_tool_versions "php" "$PHP_VERSION"
# Note: composer is not managed by asdf, installed globally in ~/.local/bin
add_to_tool_versions "nodejs" "$NODEJS_VERSION"
# Only add package managers if they were actually installed
add_to_tool_versions "yarn" "$YARN_VERSION"
add_to_tool_versions "pnpm" "$PNPM_VERSION"
add_to_tool_versions "bun" "$BUN_VERSION"
add_to_tool_versions "golang" "$GOLANG_VERSION"
add_to_tool_versions "python" "$PYTHON_VERSION"
# Write .tool-versions files
if [[ -n "$TOOL_VERSIONS_CONTENT" ]]; then
    # Create in home directory
    printf "$TOOL_VERSIONS_CONTENT" > "$HOME/.tool-versions"
    log_success "Global .tool-versions file created in $HOME"
    
    # Also create in dotfiles directory for reference
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    printf "$TOOL_VERSIONS_CONTENT" > "$DOTFILES_DIR/.tool-versions"
    log_info "Reference .tool-versions file updated in $DOTFILES_DIR"
    
    # Set global versions explicitly (using modern asdf syntax)
    log_info "Setting global asdf versions..."
    [[ -n "$PHP_VERSION" ]] && asdf set -p php "$PHP_VERSION" 2>/dev/null || true
    [[ -n "$NODEJS_VERSION" ]] && asdf set -p nodejs "$NODEJS_VERSION" 2>/dev/null || true
    [[ -n "$YARN_VERSION" ]] && asdf set -p yarn "$YARN_VERSION" 2>/dev/null || true
    [[ -n "$PNPM_VERSION" ]] && asdf set -p pnpm "$PNPM_VERSION" 2>/dev/null || true
    [[ -n "$BUN_VERSION" ]] && asdf set -p bun "$BUN_VERSION" 2>/dev/null || true
    [[ -n "$GOLANG_VERSION" ]] && asdf set -p golang "$GOLANG_VERSION" 2>/dev/null || true
    [[ -n "$PYTHON_VERSION" ]] && asdf set -p python "$PYTHON_VERSION" 2>/dev/null || true
    
    # Final reshim to ensure all shims are updated
    asdf reshim
    
    log_success "All global versions set successfully"
else
    log_info "No languages installed, skipping .tool-versions creation"
fi

log_success "Programming languages setup complete!"