#!/bin/bash

# Shell Configuration Setup Script
# Sets up zsh with proper PATH and tool initialization

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[SHELL]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SHELL]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[SHELL]${NC} $1"
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    log_warning "Backing up existing .zshrc to .zshrc.backup"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

log_info "Setting up shell configuration..."

# Helper function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Helper function to check if cask is installed
cask_installed() {
    brew list --cask "$1" >/dev/null 2>&1
}

# Build dynamic plugin list based on installed tools
log_info "Detecting installed tools for plugin configuration..."
PLUGINS="git brew"

# Add plugins based on installed tools
if command_exists docker || cask_installed docker; then
    PLUGINS="$PLUGINS docker docker-compose"
fi

if command_exists node; then
    PLUGINS="$PLUGINS node npm"
    
    # Add package manager plugins
    if command_exists yarn; then
        PLUGINS="$PLUGINS yarn"
    fi
    
    if command_exists pnpm; then
        PLUGINS="$PLUGINS pnpm"
    fi
    
    if command_exists bun; then
        PLUGINS="$PLUGINS bun"
    fi
fi

if command_exists go; then
    PLUGINS="$PLUGINS golang"
fi

if command_exists asdf; then
    PLUGINS="$PLUGINS asdf"
fi

if cask_installed visual-studio-code; then
    PLUGINS="$PLUGINS vscode"
fi

if cask_installed github; then
    PLUGINS="$PLUGINS github"
fi

if command_exists python || command_exists python3; then
    PLUGINS="$PLUGINS python pip"
fi

if command_exists php; then
    PLUGINS="$PLUGINS php"
    
    if command_exists composer; then
        PLUGINS="$PLUGINS composer"
    fi
    
    if command_exists laravel; then
        PLUGINS="$PLUGINS laravel laravel5"
    fi
    
    if command_exists symfony; then
        PLUGINS="$PLUGINS symfony symfony2"
    fi
fi

# Always add these useful plugins
PLUGINS="$PLUGINS zsh-autosuggestions zsh-syntax-highlighting"

log_info "Configured plugins: $(echo $PLUGINS | tr ' ' '\n' | sort | tr '\n' ' ')"

# Install Oh My Zsh if not already installed (before generating .zshrc)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log_info "Oh My Zsh is already installed"
fi

# Create new .zshrc with our configuration
cat > "$HOME/.zshrc" << 'ZSHRC_EOF'
# Dotfiles ZSH Configuration
# Auto-generated - modify at your own risk

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh installation path
export ZSH="$HOME/.oh-my-zsh"

# Set theme (will be overridden by powerlevel10k if installed)
ZSH_THEME="robbyrussell"

# Plugins (dynamically configured based on installed tools)
plugins=(git brew)

# Load Oh My Zsh if available
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# Homebrew PATH (Apple Silicon)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrew PATH (Intel)
if [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# asdf version manager
if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
    source "$HOME/.asdf/asdf.sh"
    # asdf completions
    if [[ -f "$HOME/.asdf/completions/asdf.bash" ]]; then
        source "$HOME/.asdf/completions/asdf.bash"
    fi
fi

# Go environment
if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# Node.js global modules
if command -v npm >/dev/null 2>&1; then
    export PATH="$HOME/.npm-global/bin:$PATH"
fi

# Bun
if [[ -d "$HOME/.bun" ]]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Composer global packages
if [[ -d "$HOME/.composer/vendor/bin" ]]; then
    export PATH="$HOME/.composer/vendor/bin:$PATH"
elif [[ -d "$HOME/.config/composer/vendor/bin" ]]; then
    export PATH="$HOME/.config/composer/vendor/bin:$PATH"
fi

# Python local binaries
export PATH="$HOME/.local/bin:$PATH"

# Custom aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Development aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Docker aliases
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dps='docker ps'
alias di='docker images'

# Utility functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Load local customizations if they exist
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion system
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Load powerlevel10k theme if available
if [[ -f "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH
ZSHRC_EOF

# Replace the plugins line with dynamic plugins
sed -i.bak "s/plugins=(git brew)/plugins=($PLUGINS)/" "$HOME/.zshrc"
rm -f "$HOME/.zshrc.bak"

# Oh My Zsh is already installed above

# Install zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    log_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions
else
    log_info "zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    log_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
    log_info "zsh-syntax-highlighting already installed"
fi

# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    log_info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
else
    log_info "Powerlevel10k theme already installed"
fi

# Create npm global directory
if command -v npm >/dev/null 2>&1; then
    log_info "Setting up npm global directory..."
    mkdir -p "$HOME/.npm-global"
    npm config set prefix "$HOME/.npm-global"
    
    # Ask about additional package managers
    log_info "Node.js is installed. Setting up package managers..."
    
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo ""
        echo "Available Node.js package managers:"
        echo "  1) npm (default - already installed)"
        echo "  2) yarn - Fast, reliable dependency management"
        echo "  3) pnpm - Fast, disk space efficient package manager"
        echo "  4) bun - All-in-one JavaScript runtime & toolkit"
        echo ""
        read -p "Which additional package managers would you like to install? (1-4, multiple: 2,3): " -r PACKAGE_MANAGERS
        echo ""
        
        # Parse selections
        if [[ $PACKAGE_MANAGERS == *"2"* ]] || [[ $PACKAGE_MANAGERS == *"yarn"* ]]; then
            if ! command -v yarn >/dev/null 2>&1; then
                log_info "Installing Yarn..."
                npm install -g yarn
            else
                log_info "Yarn is already installed"
            fi
        fi
        
        if [[ $PACKAGE_MANAGERS == *"3"* ]] || [[ $PACKAGE_MANAGERS == *"pnpm"* ]]; then
            if ! command -v pnpm >/dev/null 2>&1; then
                log_info "Installing pnpm..."
                npm install -g pnpm
            else
                log_info "pnpm is already installed"
            fi
        fi
        
        if [[ $PACKAGE_MANAGERS == *"4"* ]] || [[ $PACKAGE_MANAGERS == *"bun"* ]]; then
            if ! command -v bun >/dev/null 2>&1; then
                log_info "Installing Bun..."
                curl -fsSL https://bun.sh/install | bash
                # Add bun to PATH for current session
                export PATH="$HOME/.bun/bin:$PATH"
            else
                log_info "Bun is already installed"
            fi
        fi
        
        # Ask about Turborepo
        echo ""
        read -p "Would you like to install Turborepo (monorepo build system)? (y/N): " -n 1 -r INSTALL_TURBO
        echo ""
        if [[ $INSTALL_TURBO =~ ^[Yy]$ ]]; then
            if ! command -v turbo >/dev/null 2>&1; then
                log_info "Installing Turborepo..."
                npm install -g turbo
            else
                log_info "Turborepo is already installed"
            fi
        fi
    else
        log_info "Skipping package manager selection (quiet mode)"
        log_info "You can install additional package managers manually:"
        log_info "  - Yarn: npm install -g yarn"
        log_info "  - pnpm: npm install -g pnpm"
        log_info "  - Bun: curl -fsSL https://bun.sh/install | bash"
        log_info "  - Turborepo: npm install -g turbo"
    fi
fi

# PHP Composer and server tools setup
if command -v php >/dev/null 2>&1; then
    log_info "PHP is installed. Setting up PHP tools..."
    
    # Install Composer if not already installed
    if ! command -v composer >/dev/null 2>&1; then
        log_info "Installing Composer (PHP dependency manager)..."
        curl -sS https://getcomposer.org/installer | php
        mv composer.phar /usr/local/bin/composer 2>/dev/null || sudo mv composer.phar /usr/local/bin/composer
        chmod +x /usr/local/bin/composer 2>/dev/null || sudo chmod +x /usr/local/bin/composer
    else
        log_info "Composer is already installed"
    fi
    
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo ""
        echo "Popular PHP development servers and tools:"
        echo "  1) Laravel Valet - Local development environment for Mac"
        echo "  2) Laravel Installer - Create Laravel projects"
        echo "  3) Symfony CLI - Symfony development tools"
        echo "  4) PHPUnit - PHP testing framework"
        echo "  5) PHP_CodeSniffer - Code style checker"
        echo "  6) Psalm - Static analysis tool"
        echo ""
        read -p "Which PHP tools would you like to install? (1-6, multiple: 1,2,4): " -r PHP_TOOLS
        echo ""
        
        # Parse selections
        if [[ $PHP_TOOLS == *"1"* ]] || [[ $PHP_TOOLS == *"valet"* ]]; then
            if ! command -v valet >/dev/null 2>&1; then
                log_info "Installing Laravel Valet..."
                composer global require laravel/valet
                valet install 2>/dev/null || echo "Run 'valet install' manually after adding Composer to PATH"
            else
                log_info "Laravel Valet is already installed"
            fi
        fi
        
        if [[ $PHP_TOOLS == *"2"* ]] || [[ $PHP_TOOLS == *"laravel"* ]]; then
            if ! command -v laravel >/dev/null 2>&1; then
                log_info "Installing Laravel Installer..."
                composer global require laravel/installer
            else
                log_info "Laravel Installer is already installed"
            fi
        fi
        
        if [[ $PHP_TOOLS == *"3"* ]] || [[ $PHP_TOOLS == *"symfony"* ]]; then
            if ! command -v symfony >/dev/null 2>&1; then
                log_info "Installing Symfony CLI..."
                curl -sS https://get.symfony.com/cli/installer | bash
                # Move to a directory in PATH
                mv ~/.symfony*/bin/symfony /usr/local/bin/symfony 2>/dev/null || sudo mv ~/.symfony*/bin/symfony /usr/local/bin/symfony
            else
                log_info "Symfony CLI is already installed"
            fi
        fi
        
        if [[ $PHP_TOOLS == *"4"* ]] || [[ $PHP_TOOLS == *"phpunit"* ]]; then
            log_info "Installing PHPUnit..."
            composer global require phpunit/phpunit
        fi
        
        if [[ $PHP_TOOLS == *"5"* ]] || [[ $PHP_TOOLS == *"codesniffer"* ]]; then
            log_info "Installing PHP_CodeSniffer..."
            composer global require squizlabs/php_codesniffer
        fi
        
        if [[ $PHP_TOOLS == *"6"* ]] || [[ $PHP_TOOLS == *"psalm"* ]]; then
            log_info "Installing Psalm..."
            composer global require vimeo/psalm
        fi
        
        # Ensure Composer global bin is in PATH
        COMPOSER_PATH="$HOME/.composer/vendor/bin"
        if [[ -d "$COMPOSER_PATH" ]]; then
            log_info "Adding Composer global bin directory to PATH"
        fi
    else
        log_info "Skipping PHP tools selection (quiet mode)"
        log_info "You can install PHP tools manually:"
        log_info "  - Composer: curl -sS https://getcomposer.org/installer | php"
        log_info "  - Laravel Valet: composer global require laravel/valet"
        log_info "  - Laravel Installer: composer global require laravel/installer"
        log_info "  - Symfony CLI: curl -sS https://get.symfony.com/cli/installer | bash"
        log_info "  - PHPUnit: composer global require phpunit/phpunit"
        log_info "  - PHP_CodeSniffer: composer global require squizlabs/php_codesniffer"
        log_info "  - Psalm: composer global require vimeo/psalm"
    fi
fi

# Git configuration setup
log_info "Setting up Git configuration..."
if [[ ! -f "$HOME/.gitconfig" ]]; then
    log_info "Installing Git configuration template..."
    cp "$(dirname "$0")/../config/.gitconfig" "$HOME/.gitconfig"
    cp "$(dirname "$0")/../config/.gitignore_global" "$HOME/.gitignore_global"
    
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo ""
        log_info "Git configuration installed! Please update your name and email:"
        read -p "Enter your full name: " GIT_NAME
        read -p "Enter your email address: " GIT_EMAIL
        
        if [[ -n "$GIT_NAME" ]]; then
            git config --global user.name "$GIT_NAME"
        fi
        
        if [[ -n "$GIT_EMAIL" ]]; then
            git config --global user.email "$GIT_EMAIL"
        fi
        
        echo ""
        log_info "Git configuration updated!"
    else
        log_info "Git config template installed. Update user.name and user.email manually:"
        log_info "  git config --global user.name 'Your Name'"
        log_info "  git config --global user.email 'your.email@example.com'"
    fi
else
    log_info "Git configuration already exists"
fi

# SSH key setup
log_info "Checking SSH keys..."
if [[ ! -f "$HOME/.ssh/id_ed25519" ]] && [[ ! -f "$HOME/.ssh/id_rsa" ]]; then
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo ""
        log_info "No SSH keys found. Would you like to generate a new SSH key for GitHub/GitLab?"
        read -p "Generate SSH key? (Y/n): " -n 1 -r GENERATE_SSH
        echo ""
        
        if [[ $GENERATE_SSH =~ ^[Nn]$ ]]; then
            log_info "Skipping SSH key generation"
        else
            read -p "Enter your email address for SSH key: " SSH_EMAIL
            if [[ -n "$SSH_EMAIL" ]]; then
                log_info "Generating SSH key..."
                ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
                
                # Start ssh-agent and add key
                eval "$(ssh-agent -s)"
                ssh-add "$HOME/.ssh/id_ed25519"
                
                # Create SSH config
                log_info "Creating SSH config..."
                cat > "$HOME/.ssh/config" << EOF
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519

Host gitlab.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
                
                chmod 600 "$HOME/.ssh/config"
                
                echo ""
                log_success "SSH key generated and configured!"
                log_info "Your public key (copy this to GitHub/GitLab):"
                echo ""
                cat "$HOME/.ssh/id_ed25519.pub"
                echo ""
                log_info "Add this key to GitHub: https://github.com/settings/keys"
                log_info "Add this key to GitLab: https://gitlab.com/profile/keys"
                
                if command -v pbcopy >/dev/null 2>&1; then
                    pbcopy < "$HOME/.ssh/id_ed25519.pub"
                    log_info "SSH key copied to clipboard!"
                fi
            else
                log_warning "No email provided, skipping SSH key generation"
            fi
        fi
    else
        log_info "No SSH keys found. Generate manually with:"
        log_info "  ssh-keygen -t ed25519 -C 'your.email@example.com'"
    fi
else
    log_info "SSH keys already exist"
fi

log_success "Shell configuration complete!"

echo ""
log_info "Shell setup summary:"
echo "  • Oh My Zsh installed with useful plugins"
echo "  • Powerlevel10k theme for better prompt"
echo "  • Aliases for git, docker, and common commands"
echo "  • Proper PATH setup for all tools"
echo "  • History and completion improvements"
echo ""
log_warning "Restart your terminal or run 'source ~/.zshrc' to apply changes"