#!/bin/bash

# Dotfiles Installation Script
# This script sets up a complete development environment on macOS

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Welcome message
echo "🚀 Welcome to the Dotfiles Setup!"
echo "This will install and configure:"
echo "  • Homebrew"
echo "  • Warp Terminal"
echo "  • Docker"
echo "  • asdf (version manager)"
echo "  • Node.js"
echo "  • Go"
echo "  • PHP"
echo "  • Shell configurations"
echo ""

# Ask for confirmation
read -p "Do you want to continue? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installation cancelled."
    exit 0
fi

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only."
    exit 1
fi

# Install Homebrew and packages
log_info "Installing Homebrew and packages..."
bash "$DOTFILES_DIR/scripts/homebrew.sh"

# Setup asdf and programming languages
log_info "Setting up asdf and programming languages..."
bash "$DOTFILES_DIR/scripts/asdf.sh"

# Setup shell configurations
log_info "Setting up shell configurations..."
bash "$DOTFILES_DIR/scripts/shell.sh"

# Final message
echo ""
log_success "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Open Warp terminal for the best experience"
echo "3. Start Docker Desktop if needed"
echo ""
echo "Verify installations with:"
echo "  • node --version"
echo "  • go version" 
echo "  • php --version"
echo "  • docker --version"
echo ""
log_info "Happy coding! 🎯"