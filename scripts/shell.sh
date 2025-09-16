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

# Create new .zshrc with our configuration
cat > "$HOME/.zshrc" << 'EOF'
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

# Plugins
plugins=(
    git
    brew
    docker
    node
    npm
    golang
    asdf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

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
EOF

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log_info "Oh My Zsh is already installed"
fi

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