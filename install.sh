#!/bin/bash

# Dotfiles Installation Script
# This script sets up a complete development environment on macOS

set -e  # Exit on any error

# Default options
INSTALL_GUI_APPS="ask"
INSTALL_JETBRAINS="ask"
INSTALL_DOCKER="ask"
INSTALL_VSCODE="ask"
INSTALL_FIGMA="ask"
INSTALL_GITHUB_DESKTOP="ask"
# Programming languages
INSTALL_NODE="ask"
INSTALL_GO="ask"
INSTALL_PHP="ask"
# JetBrains IDEs
INSTALL_DATAGRIP="ask"
INSTALL_PHPSTORM="ask"
INSTALL_GOLAND="ask"
INSTALL_WEBSTORM="ask"
QUIET_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --gui-apps)
            INSTALL_GUI_APPS="yes"
            shift
            ;;
        --no-gui-apps)
            INSTALL_GUI_APPS="no"
            shift
            ;;
        --jetbrains)
            INSTALL_JETBRAINS="yes"
            shift
            ;;
        --no-jetbrains)
            INSTALL_JETBRAINS="no"
            shift
            ;;
        --docker)
            INSTALL_DOCKER="yes"
            shift
            ;;
        --no-docker)
            INSTALL_DOCKER="no"
            shift
            ;;
        --vscode)
            INSTALL_VSCODE="yes"
            shift
            ;;
        --no-vscode)
            INSTALL_VSCODE="no"
            shift
            ;;
        --figma)
            INSTALL_FIGMA="yes"
            shift
            ;;
        --no-figma)
            INSTALL_FIGMA="no"
            shift
            ;;
        --github-desktop)
            INSTALL_GITHUB_DESKTOP="yes"
            shift
            ;;
        --no-github-desktop)
            INSTALL_GITHUB_DESKTOP="no"
            shift
            ;;
        --node)
            INSTALL_NODE="yes"
            shift
            ;;
        --no-node)
            INSTALL_NODE="no"
            shift
            ;;
        --go)
            INSTALL_GO="yes"
            shift
            ;;
        --no-go)
            INSTALL_GO="no"
            shift
            ;;
        --php)
            INSTALL_PHP="yes"
            shift
            ;;
        --no-php)
            INSTALL_PHP="no"
            shift
            ;;
        --datagrip)
            INSTALL_DATAGRIP="yes"
            shift
            ;;
        --no-datagrip)
            INSTALL_DATAGRIP="no"
            shift
            ;;
        --phpstorm)
            INSTALL_PHPSTORM="yes"
            shift
            ;;
        --no-phpstorm)
            INSTALL_PHPSTORM="no"
            shift
            ;;
        --goland)
            INSTALL_GOLAND="yes"
            shift
            ;;
        --no-goland)
            INSTALL_GOLAND="no"
            shift
            ;;
        --webstorm)
            INSTALL_WEBSTORM="yes"
            shift
            ;;
        --no-webstorm)
            INSTALL_WEBSTORM="no"
            shift
            ;;
        --quiet|-q)
            QUIET_MODE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --gui-apps          Install all GUI applications without asking"
            echo "  --no-gui-apps       Skip all GUI applications"
            echo "  --jetbrains         Install JetBrains tools without asking"
            echo "  --no-jetbrains      Skip JetBrains tools"
            echo "  --docker            Install Docker without asking"
            echo "  --no-docker         Skip Docker installation"
            echo "  --vscode            Install VS Code without asking"
            echo "  --no-vscode         Skip VS Code installation"
            echo "  --figma             Install Figma without asking"
            echo "  --no-figma          Skip Figma installation"
            echo "  --github-desktop    Install GitHub Desktop without asking"
            echo "  --no-github-desktop Skip GitHub Desktop installation"
            echo "  --node              Install Node.js without asking"
            echo "  --no-node           Skip Node.js installation"
            echo "  --go                Install Go without asking"
            echo "  --no-go             Skip Go installation"
            echo "  --php               Install PHP without asking"
            echo "  --no-php            Skip PHP installation"
            echo "  --datagrip          Install DataGrip without asking"
            echo "  --no-datagrip       Skip DataGrip installation"
            echo "  --phpstorm          Install PHPStorm without asking"
            echo "  --no-phpstorm       Skip PHPStorm installation"
            echo "  --goland            Install GoLand without asking"
            echo "  --no-goland         Skip GoLand installation"
            echo "  --webstorm          Install WebStorm without asking"
            echo "  --no-webstorm       Skip WebStorm installation"
            echo "  --quiet, -q         Run in quiet mode (use defaults where possible)"
            echo "  --help, -h          Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

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
echo "  • Homebrew & essential tools (git, curl, wget, jq, tree, htop, gh, retry)"
echo "  • asdf (version manager)"
echo "  • Node.js, Go, PHP"
echo "  • Shell configurations"
echo ""
echo "Optional applications (will prompt or use flags):"
echo "  • Docker Desktop"
echo "  • Visual Studio Code"
echo "  • JetBrains IDEs (Toolbox, DataGrip, PHPStorm, GoLand, WebStorm)"
echo "  • Warp Terminal"
echo "  • Figma (Design tool)"
echo "  • GitHub Desktop"
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
export INSTALL_GUI_APPS INSTALL_JETBRAINS INSTALL_DOCKER INSTALL_VSCODE INSTALL_FIGMA INSTALL_GITHUB_DESKTOP QUIET_MODE
export INSTALL_NODE INSTALL_GO INSTALL_PHP
export INSTALL_DATAGRIP INSTALL_PHPSTORM INSTALL_GOLAND INSTALL_WEBSTORM
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