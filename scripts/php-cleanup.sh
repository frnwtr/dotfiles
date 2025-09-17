#!/bin/bash

# PHP Configuration Cleanup Script
# Fixes conflicts between Homebrew PHP and asdf PHP configurations
# Usage: ./scripts/php-cleanup.sh

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[PHP-CLEANUP]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PHP-CLEANUP]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[PHP-CLEANUP]${NC} $1"
}

log_error() {
    echo -e "${RED}[PHP-CLEANUP]${NC} $1"
}

log_info "Starting PHP configuration cleanup..."

# Clear problematic environment variables
log_info "Clearing conflicting PHP environment variables..."
unset PHP_INI_SCAN_DIR 2>/dev/null || true

# Check for Homebrew PHP configuration directories
HOMEBREW_PHP_CONF_DIRS=(
    "/opt/homebrew/etc/php"
    "/usr/local/etc/php"
)

for conf_dir in "${HOMEBREW_PHP_CONF_DIRS[@]}"; do
    if [[ -d "$conf_dir" ]]; then
        log_warning "Found Homebrew PHP configuration directory: $conf_dir"
        
        if [[ "$1" == "--remove-homebrew-config" ]]; then
            log_info "Removing Homebrew PHP configuration directory..."
            rm -rf "$conf_dir" 2>/dev/null || log_warning "Could not remove $conf_dir (may require sudo)"
        else
            log_info "To remove this directory, run: $0 --remove-homebrew-config"
        fi
    fi
done

# Check if asdf PHP is properly configured
if command -v asdf >/dev/null 2>&1 && command -v php >/dev/null 2>&1; then
    PHP_PATH=$(which php)
    if [[ "$PHP_PATH" == *".asdf/shims/php" ]]; then
        log_success "✓ asdf PHP is properly configured"
        log_info "  PHP Path: $PHP_PATH"
        
        # Test PHP without stderr to avoid error messages during version check
        PHP_VERSION=$(php --version 2>/dev/null | head -1 || echo "Version check failed")
        log_info "  PHP Version: $PHP_VERSION"
        
        # Check PHP configuration
        ASDF_PHP_VERSION=$(asdf current php 2>/dev/null | awk '{print $2}' || echo "unknown")
        if [[ "$ASDF_PHP_VERSION" != "unknown" ]]; then
            ASDF_PHP_CONF_DIR="$HOME/.asdf/installs/php/$ASDF_PHP_VERSION/conf.d"
            if [[ -d "$ASDF_PHP_CONF_DIR" ]]; then
                log_success "✓ asdf PHP configuration directory found: $ASDF_PHP_CONF_DIR"
            else
                log_warning "asdf PHP configuration directory not found: $ASDF_PHP_CONF_DIR"
            fi
        fi
        
    else
        log_error "PHP is not using asdf shims. Current path: $PHP_PATH"
        log_info "Run: source ~/dotfiles/config/asdf-php.env"
    fi
else
    log_error "asdf or PHP not found in PATH"
fi

# Test key PHP functionality
log_info "Testing PHP functionality..."

# Test OpenSSL
if php -m 2>/dev/null | grep -q openssl; then
    log_success "✓ OpenSSL extension loaded"
else
    log_warning "OpenSSL extension not found"
fi

# Test HTTPS
if php -r "file_get_contents('https://httpbin.org/json');" >/dev/null 2>&1; then
    log_success "✓ HTTPS functionality working"
else
    log_warning "HTTPS functionality may not be working"
fi

# Test Composer
if command -v composer >/dev/null 2>&1; then
    COMPOSER_VERSION=$(composer --version 2>/dev/null | head -1 || echo "Version check failed")
    log_success "✓ Composer is available: $COMPOSER_VERSION"
else
    log_warning "Composer not found in PATH"
fi

log_success "PHP configuration cleanup completed!"

echo ""
log_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Load asdf PHP environment: source ~/dotfiles/config/asdf-php.env"
echo "  3. Test PHP: php --version && php -m | grep openssl"

if [[ "$1" != "--remove-homebrew-config" ]] && [[ -d "/opt/homebrew/etc/php" || -d "/usr/local/etc/php" ]]; then
    echo ""
    log_info "To completely remove Homebrew PHP configuration directories:"
    echo "  ./scripts/php-cleanup.sh --remove-homebrew-config"
fi