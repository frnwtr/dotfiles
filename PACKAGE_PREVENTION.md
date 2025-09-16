# Package Prevention Guide

This dotfiles setup is configured to prevent installation of nginx and php-fmp, maintaining a clean CLI-only development environment.

## What's Prevented

### Web Servers
- **nginx** - Use Docker instead: `docker run -p 80:80 nginx`
- **apache2/httpd** - Use Docker instead: `docker run -p 80:80 httpd`

### PHP-FPM
- **php-fpm** - Only PHP CLI is installed
- Configuration files are automatically removed
- Service is prevented from starting

### Laravel Valet
- **Laravel Valet** - Local development environment (installs nginx + php-fpm + dnsmasq)
- Prevented to maintain clean CLI-only setup
- Use PHP built-in server or Docker alternatives instead

### DNS Services
- **dnsmasq** - Often installed by Laravel Valet for .test domains
- Use system DNS or Docker networks instead
- Avoid local domain resolution services

### Databases (Optional Prevention)
- **mysql** - Use Docker instead: `docker run -p 3306:3306 mysql`
- **postgresql** - Use Docker instead: `docker run -p 5432:5432 postgres`
- **redis** - Use Docker instead: `docker run -p 6379:6379 redis`
- **mongodb** - Use Docker instead: `docker run -p 27017:27017 mongo`

## Prevention Mechanisms

### 1. Installation Script Checks
The `homebrew.sh` script actively checks for and can remove unwanted packages during setup.

### 2. Post-Installation Cleanup
The `asdf.sh` script automatically removes PHP-FPM configuration after PHP installation.

### 3. Shell Aliases
Prevention aliases are added to your shell configuration:
```bash
# These commands will show Docker alternatives instead
nginx
mysql
php-fpm
dnsmasq
valet
```

### 4. Prevention Script
Run the prevention script manually:
```bash
# Check and optionally remove unwanted packages
./scripts/prevent-packages.sh check

# Automatically remove unwanted packages  
./scripts/prevent-packages.sh auto

# Add prevention aliases to shell
./scripts/prevent-packages.sh aliases

# Do everything
./scripts/prevent-packages.sh all
```

### 5. Installation Flags
Use these flags when running the installer:
```bash
# Clean PHP-only setup (removes FPM configuration)
./install.sh --clean-php-only

# Remove unwanted packages like nginx, mysql, etc.
./install.sh --prevent-unwanted-packages

# Both options together
./install.sh --clean-php-only --prevent-unwanted-packages
```

## Why This Setup?

### Clean Development Environment
- Avoids system service conflicts
- Reduces resource usage
- Eliminates port conflicts

### Docker-First Approach
- Consistent environments across machines
- Easy to start/stop services
- No system-level configuration required

### PHP CLI Only
- Perfect for command-line scripts
- Works with built-in PHP server: `php -S localhost:8000`
- Avoids complex FPM configuration

## Verification

After setup, verify the prevention is working:

```bash
# These should show prevention messages
nginx
mysql
php-fpm
dnsmasq
valet

# These should work normally
php -v
php -S localhost:8000  # Built-in web server
docker --version
```

## Docker Alternatives

Instead of system services, use Docker:

```bash
# Web servers
docker run -d -p 80:80 --name nginx nginx
docker run -d -p 80:80 --name apache httpd

# Databases
docker run -d -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=password mysql
docker run -d -p 5432:5432 --name postgres -e POSTGRES_PASSWORD=password postgres
docker run -d -p 6379:6379 --name redis redis
docker run -d -p 27017:27017 --name mongo mongo

# PHP with FPM (if needed for specific projects)
docker run -d -p 9000:9000 --name php-fpm php:fpm

# Laravel development (instead of Valet)
docker run -d -p 80:80 -v $(pwd):/var/www --name laravel php:apache
# Or use Laravel Sail
laravel new myapp --sail
cd myapp && sail up
```

## Troubleshooting

### If unwanted packages are installed
Run the prevention script:
```bash
./scripts/prevent-packages.sh auto
```

### If PHP-FPM starts accidentally
```bash
brew services stop php
rm -f /opt/homebrew/etc/php/*/php-fpm.conf
```

### Re-enable prevention aliases
```bash
./scripts/prevent-packages.sh aliases
source ~/.zshrc
```