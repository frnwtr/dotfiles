#!/bin/bash

# Package Prevention Script
# Prevents installation of unwanted packages and removes them if found

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[PREVENT]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PREVENT]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[PREVENT]${NC} $1"
}

log_error() {
    echo -e "${RED}[PREVENT]${NC} $1"
}

# List of packages that should NOT be installed
UNWANTED_PACKAGES=(
    "nginx"
    "apache2" 
    "httpd"
    "mysql"
    "postgresql"
    "redis"
    "mongodb"
    "elasticsearch"
    "rabbitmq"
    "memcached"
    "dnsmasq"
)

# Function to check and remove unwanted packages
check_and_remove_packages() {
    local found_packages=()
    
    log_info "Checking for unwanted packages..."
    
    for package in "${UNWANTED_PACKAGES[@]}"; do
        if brew list "$package" >/dev/null 2>&1; then
            found_packages+=("$package")
        fi
    done
    
    if [ ${#found_packages[@]} -eq 0 ]; then
        log_success "No unwanted packages found!"
        return 0
    fi
    
    log_warning "Found unwanted packages: ${found_packages[*]}"
    echo "These packages should be removed for a clean CLI-only development environment."
    
    if [[ "$1" == "--auto" ]]; then
        local remove_packages=true
    else
        read -p "Do you want to remove these packages? (y/N) " -n 1 -r
        echo ""
        [[ $REPLY =~ ^[Yy]$ ]] && local remove_packages=true || local remove_packages=false
    fi
    
    if [[ "$remove_packages" == "true" ]]; then
        for package in "${found_packages[@]}"; do
            log_info "Removing $package..."
            if brew uninstall --ignore-dependencies "$package" 2>/dev/null; then
                log_success "Removed $package"
            else
                log_warning "Failed to remove $package (may not be installed via brew)"
            fi
        done
    fi
}

# Function to disable PHP-FPM if PHP is installed
disable_php_fpm() {
    if command -v php-fpm >/dev/null 2>&1; then
        log_info "PHP-FPM found, disabling it..."
        
        # Stop FPM service if running
        if brew services list | grep -q "php.*started"; then
            log_info "Stopping PHP-FPM service..."
            sudo brew services stop php 2>/dev/null || true
        fi
        
        # Remove FPM configuration files
        local php_version=$(php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;")
        local fpm_conf="/opt/homebrew/etc/php/$php_version/php-fpm.conf"
        local fpm_dir="/opt/homebrew/etc/php/$php_version/php-fpm.d"
        
        if [[ -f "$fpm_conf" ]]; then
            log_info "Removing PHP-FPM configuration..."
            rm -f "$fpm_conf"
            rm -rf "$fpm_dir"
            log_success "PHP-FPM configuration removed"
        fi
        
        # Remove FPM log file
        rm -f "/opt/homebrew/var/log/php-fpm.log" 2>/dev/null || true
        
        log_success "PHP-FPM disabled (binary still exists but cannot start)"
    fi
    
    # Check for Laravel Valet in Composer global packages
    if command -v composer >/dev/null 2>&1; then
        if composer global show laravel/valet >/dev/null 2>&1; then
            log_warning "Laravel Valet found in Composer global packages"
            if [[ "$1" == "--auto" ]]; then
                log_info "Removing Laravel Valet..."
                composer global remove laravel/valet || log_warning "Failed to remove Valet"
                # Clean up Valet files
                rm -rf ~/.config/valet 2>/dev/null || true
                rm -f /opt/homebrew/bin/valet 2>/dev/null || true
                log_success "Laravel Valet removed"
            else
                read -p "Do you want to remove Laravel Valet? (y/N) " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    log_info "Removing Laravel Valet..."
                    composer global remove laravel/valet || log_warning "Failed to remove Valet"
                    # Clean up Valet files
                    rm -rf ~/.config/valet 2>/dev/null || true
                    rm -f /opt/homebrew/bin/valet 2>/dev/null || true
                    log_success "Laravel Valet removed"
                fi
            fi
        fi
    fi
}

# Function to create brew prevention aliases
create_prevention_aliases() {
    local shell_config
    
    # Determine shell config file
    if [[ "$SHELL" == */zsh ]]; then
        shell_config="$HOME/.zshrc"
    elif [[ "$SHELL" == */bash ]]; then
        shell_config="$HOME/.bashrc"
    else
        log_warning "Unknown shell, skipping alias creation"
        return 1
    fi
    
    log_info "Adding prevention aliases to $shell_config..."
    
    # Create prevention aliases
    cat >> "$shell_config" << 'EOF'

# Package Prevention Aliases
# Prevent accidental installation of unwanted packages
alias brew-install-nginx='echo "❌ nginx installation prevented. Use Docker instead: docker run -p 80:80 nginx"'
alias brew-install-apache='echo "❌ apache installation prevented. Use Docker instead: docker run -p 80:80 httpd"'
alias brew-install-mysql='echo "❌ mysql installation prevented. Use Docker instead: docker run -p 3306:3306 mysql"'
alias brew-install-postgresql='echo "❌ postgresql installation prevented. Use Docker instead: docker run -p 5432:5432 postgres"'
alias brew-install-dnsmasq='echo "❌ dnsmasq installation prevented. Use system DNS or Docker containers with custom networks."'

# Override common installation commands
nginx() {
    echo "❌ nginx command prevented. Use Docker instead:"
    echo "  docker run -d -p 80:80 --name nginx nginx"
    return 1
}

mysql() {
    echo "❌ mysql command prevented. Use Docker instead:"
    echo "  docker run -d -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=password mysql"
    return 1
}

dnsmasq() {
    echo "❌ dnsmasq command prevented. This environment avoids local DNS services."
    echo "i️  For local development:"
    echo "  • Use system DNS resolution"
    echo "  • Docker containers with custom networks"
    echo "  • Avoid .test/.local domains that require custom DNS"
    return 1
}

# PHP-FPM prevention
php-fpm() {
    echo "❌ PHP-FPM prevented. This environment uses PHP CLI only."
    echo "ℹ️  For web development, use:"
    echo "  • Built-in PHP server: php -S localhost:8000"
    echo "  • Docker with PHP-FPM: docker run -p 9000:9000 php:fpm"
    return 1
}

# Laravel Valet prevention
valet() {
    echo "❌ Laravel Valet prevented. This environment maintains clean CLI-only setup."
    echo "ℹ️  For local PHP development, use:"
    echo "  • Built-in PHP server: php -S localhost:8000"
    echo "  • Laravel Sail (Docker): laravel new myapp --sail"
    echo "  • Docker Compose with nginx/php-fpm containers"
    echo "  • Local Docker: docker run -p 80:80 -v \$(pwd):/var/www php:apache"
    return 1
}

EOF
    
    log_success "Prevention aliases added to $shell_config"
    log_info "Restart your terminal or run: source $shell_config"
}

# Main execution
main() {
    case "${1:-check}" in
        "check")
            check_and_remove_packages
            disable_php_fpm
            ;;
        "auto")
            check_and_remove_packages --auto
            disable_php_fpm --auto
            ;;
        "aliases")
            create_prevention_aliases
            ;;
        "all")
            check_and_remove_packages --auto
            disable_php_fpm --auto
            create_prevention_aliases
            ;;
        *)
            echo "Usage: $0 [check|auto|aliases|all]"
            echo "  check   - Check for unwanted packages and prompt for removal"
            echo "  auto    - Automatically remove unwanted packages"
            echo "  aliases - Create prevention aliases in shell config"
            echo "  all     - Do everything automatically"
            exit 1
            ;;
    esac
}

main "$@"