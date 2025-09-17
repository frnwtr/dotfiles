# PHP Configuration for Dotfiles

This document explains the PHP setup using asdf version manager with custom build configuration.

## Overview

- **PHP Version**: 8.3.16 (managed by asdf)
- **Installation Method**: Custom build with OpenSSL 3.x and iconv support
- **Composer**: Automatically installed with PHP
- **Build Configuration**: Optimized for macOS with Homebrew dependencies

## Features

✅ **OpenSSL 3.x Support**: Full HTTPS functionality  
✅ **iconv Support**: Character encoding conversion  
✅ **Composer Integration**: Automatically installed with PHP via asdf  
✅ **Kerberos Support**: Enhanced authentication capabilities  
✅ **Media Libraries**: ImageMagick and FFmpeg support  
✅ **Cryptography**: GMP and libsodium for advanced crypto operations  
✅ **Extensions**: bcmath, calendar, curl, exif, fpm, gd, intl, mbstring, mysql, opcache, pdo, zip, and more  
✅ **Homebrew PHP Cleanup**: Automatically removes conflicting Homebrew PHP installation  
✅ **Performance Optimized**: Built with enhanced compiler flags and dependencies

## Quick Start

### Option 1: Automatic Environment Loading (Default)

The PHP environment is now **automatically configured** when:
- You enter a directory with a `composer.json` file
- You enter a directory with `.tool-versions` containing `php`
- You enter a directory with `.php` files

**No manual setup required!** Just use PHP normally:

```bash
# Just change to any PHP project directory
cd ~/my-php-project

# PHP environment is automatically configured
php --version
composer install
```

### Option 2: Manual Environment Loading

For manual control or troubleshooting:

```bash
# Load the asdf PHP environment manually
source ~/dotfiles/config/asdf-php.env

# Verify PHP version
php --version
# Should show: PHP 8.3.16 (cli) (built: Sep 17 2025...)

# Test HTTPS support
php -r "echo file_get_contents('https://httpbin.org/json') ? 'HTTPS works!' : 'HTTPS failed';"
```

### Option 3: Manual PATH Adjustment

```bash
# Add to your shell configuration (~/.zshrc, ~/.bashrc, etc.)
export PATH="$HOME/.asdf/shims:$PATH"
```

## Installation

The PHP installation is handled by the `scripts/asdf.sh` script with these key components:

### Build Environment Variables

```bash
export PHP_WITHOUT_PEAR=yes
export PHP_CONFIGURE_OPTIONS="--with-openssl=/opt/homebrew/opt/openssl@3 --with-iconv=/opt/homebrew/opt/libiconv --with-kerberos=/opt/homebrew/opt/krb5"
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:/opt/homebrew/share/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-L/opt/homebrew/lib -L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/opt/icu4c/lib -L/opt/homebrew/opt/libedit/lib -L/opt/homebrew/opt/bison/lib -L/opt/homebrew/opt/libiconv/lib -L/opt/homebrew/opt/krb5/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/include -I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/opt/icu4c/include -I/opt/homebrew/opt/libedit/include -I/opt/homebrew/opt/bison/include -I/opt/homebrew/opt/libiconv/include -I/opt/homebrew/opt/krb5/include $CPPFLAGS"
```

### Required Dependencies

Automatically installed by `scripts/asdf.sh`:

**Core PHP Dependencies:**
- autoconf, automake, bison, freetype, gd, gettext
- icu4c, krb5, libedit, libiconv, libjpeg, libpng
- libxml2, libzip, pkg-config, re2c, zlib

**Enhanced Features:**
- openssl@3 (HTTPS support)
- gmp, libsodium (cryptography)
- imagemagick, ffmpeg (media processing)
- oniguruma, sqlite (additional functionality)

**Note:** Homebrew PHP will be automatically uninstalled if present to avoid conflicts.

## Usage

### Basic Commands

```bash
# Check PHP version
php --version

# List installed extensions
php -m

# Check specific extension
php -m | grep openssl

# Run PHP's built-in server
php -S localhost:8000

# Use Composer (automatically installed with PHP)
composer --version
composer install
composer require vendor/package

# Note: Composer is installed automatically by the asdf-php plugin
# No separate installation needed
```

### Development Tools

The following PHP development tools are available (installed during setup):

- **Laravel Installer**: `laravel new project-name`
- **Symfony CLI**: `symfony new project-name`
- **PHPUnit**: `phpunit`
- **PHP_CodeSniffer**: `phpcs`, `phpcbf`
- **Psalm**: `psalm`

## Troubleshooting

### PHP Not Found or Wrong Version

```bash
# Check which PHP is being used
which php
# Should return: /Users/yourusername/.asdf/shims/php

# If it shows Homebrew PHP, load the asdf environment
source ~/dotfiles/config/asdf-php.env
```

### HTTPS/OpenSSL Issues

```bash
# Check if OpenSSL extension is loaded
php -m | grep openssl

# Test HTTPS connectivity
php -r "var_dump(file_get_contents('https://httpbin.org/json'));"
```

### Extension Loading Errors

If you see warnings about failed extension loading (e.g., opcache.so), this usually happens when there are conflicting PHP configurations between Homebrew and asdf PHP installations.

**Quick Fix:**
```bash
# Run the automated cleanup script
./scripts/php-cleanup.sh

# Or manually fix the issue
unset PHP_INI_SCAN_DIR
source ~/dotfiles/config/asdf-php.env
```

**Manual Steps:**
1. Clear the conflicting environment variable: `unset PHP_INI_SCAN_DIR`
2. Ensure only asdf PHP is in your PATH
3. Check PHP configuration files: `php --ini`
4. Remove conflicting Homebrew PHP configuration directories if needed

### Rebuilding PHP

If you need to rebuild PHP with different options:

```bash
# Remove current installation
asdf uninstall php 8.3.16

# Set environment variables
source ~/dotfiles/config/asdf-php.env

# Reinstall
asdf install php 8.3.16
```

## File Locations

- **PHP Installation**: `~/.asdf/installs/php/8.3.16/`
- **PHP Binary**: `~/.asdf/installs/php/8.3.16/bin/php`
- **Composer**: `~/.asdf/installs/php/8.3.16/bin/composer`
- **PHP Configuration**: `~/.asdf/installs/php/8.3.16/etc/php.ini`
- **Extension Directory**: `~/.asdf/installs/php/8.3.16/lib/php/extensions/`

## Integration with Dotfiles

- **Tool Versions**: `.tool-versions` specifies `php 8.3.16`
- **Installation Script**: `scripts/asdf.sh` handles PHP installation
- **Shell Configuration**: `scripts/shell.sh` sets up PHP environment
- **Environment Setup**: `config/asdf-php.env` ensures proper PATH ordering

## Advanced Configuration

### Custom PHP.ini Settings

```bash
# Location of php.ini
php --ini

# Edit PHP configuration
vim ~/.asdf/installs/php/8.3.16/etc/php.ini
```

### Performance Tuning

The installation includes several performance optimizations:

- **OPcache**: Enabled by default
- **JIT**: Available (disable if needed)
- **Memory Limit**: Set for CLI operations
- **Worker Processes**: Configured for built-in server

### Extension Management

To add new extensions, you typically need to rebuild PHP with the extension included, or use PECL (if available).

## Support

This configuration has been tested on:
- macOS (Apple Silicon)
- Homebrew package manager
- asdf version manager
- PHP 8.3.16

For issues or questions, refer to the main dotfiles documentation or check the asdf-php plugin documentation.