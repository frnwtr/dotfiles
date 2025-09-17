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
INSTALL_TAILSCALE="ask"
INSTALL_CHATGPT="ask"
INSTALL_CLAUDE="ask"
# Programming languages
INSTALL_NODE="ask"
INSTALL_GO="ask"
INSTALL_PHP="ask"
INSTALL_PYTHON="ask"
# Node.js package managers
INSTALL_YARN="ask"
INSTALL_PNPM="ask"
INSTALL_BUN="ask"
# JetBrains IDEs
INSTALL_DATAGRIP="ask"
INSTALL_PHPSTORM="ask"
INSTALL_GOLAND="ask"
INSTALL_WEBSTORM="ask"
# Prevention options
CLEAN_PHP_ONLY=false
PREVENT_UNWANTED_PACKAGES=false
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
        --tailscale)
            INSTALL_TAILSCALE="yes"
            shift
            ;;
        --no-tailscale)
            INSTALL_TAILSCALE="no"
            shift
            ;;
        --chatgpt)
            INSTALL_CHATGPT="yes"
            shift
            ;;
        --no-chatgpt)
            INSTALL_CHATGPT="no"
            shift
            ;;
        --claude)
            INSTALL_CLAUDE="yes"
            shift
            ;;
        --no-claude)
            INSTALL_CLAUDE="no"
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
        --python)
            INSTALL_PYTHON="yes"
            shift
            ;;
        --no-python)
            INSTALL_PYTHON="no"
            shift
            ;;
        --yarn)
            INSTALL_YARN="yes"
            shift
            ;;
        --no-yarn)
            INSTALL_YARN="no"
            shift
            ;;
        --pnpm)
            INSTALL_PNPM="yes"
            shift
            ;;
        --no-pnpm)
            INSTALL_PNPM="no"
            shift
            ;;
        --bun)
            INSTALL_BUN="yes"
            shift
            ;;
        --no-bun)
            INSTALL_BUN="no"
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
        --clean-php-only)
            CLEAN_PHP_ONLY=true
            shift
            ;;
        --prevent-unwanted-packages)
            PREVENT_UNWANTED_PACKAGES=true
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
            echo "  --tailscale         Install Tailscale without asking"
            echo "  --no-tailscale      Skip Tailscale installation"
            echo "  --chatgpt           Install ChatGPT without asking"
            echo "  --no-chatgpt        Skip ChatGPT installation"
            echo "  --claude            Install Claude without asking"
            echo "  --no-claude         Skip Claude installation"
            echo "  --node              Install Node.js without asking"
            echo "  --no-node           Skip Node.js installation"
            echo "  --go                Install Go without asking"
            echo "  --no-go             Skip Go installation"
            echo "  --php               Install PHP without asking"
            echo "  --no-php            Skip PHP installation"
            echo "  --python            Install Python without asking"
            echo "  --no-python         Skip Python installation"
            echo "  --yarn              Install Yarn without asking"
            echo "  --no-yarn           Skip Yarn installation"
            echo "  --pnpm              Install pnpm without asking"
            echo "  --no-pnpm           Skip pnpm installation"
            echo "  --bun               Install Bun without asking"
            echo "  --no-bun            Skip Bun installation"
            echo "  --datagrip          Install DataGrip without asking"
            echo "  --no-datagrip       Skip DataGrip installation"
            echo "  --phpstorm          Install PHPStorm without asking"
            echo "  --no-phpstorm       Skip PHPStorm installation"
            echo "  --goland            Install GoLand without asking"
            echo "  --no-goland         Skip GoLand installation"
            echo "  --webstorm          Install WebStorm without asking"
            echo "  --no-webstorm       Skip WebStorm installation"
            echo "  --clean-php-only    Ensure PHP CLI only setup (remove FPM)"
            echo "  --prevent-unwanted-packages  Remove nginx, mysql, etc. (prefer Docker)"
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
echo ""
echo "📦 Core Tools:"
echo "  • Homebrew & essential CLI tools (git, curl, jq, tree, htop, gh, etc.)"
echo "  • asdf (version manager for programming languages)"
echo "  • Modern CLI tools (bat, fd, ripgrep, fzf, lazygit, etc.)"
echo "  • Oh My Zsh with Powerlevel10k theme"
echo ""
echo "💻 Programming Languages (optional):"
echo "  • Node.js (with optional package managers: Yarn, pnpm, Bun)"
echo "  • Go"
echo "  • PHP ecosystem (PHP, Composer)"
echo "  • Python"
echo ""
echo "🖥️  GUI Applications (optional):"
echo "  • Docker Desktop"
echo "  • Visual Studio Code"
echo "  • JetBrains IDEs (Toolbox, DataGrip, PHPStorm, GoLand, WebStorm)"
echo "  • Warp Terminal"
echo "  • Figma, GitHub Desktop, Tailscale"
echo "  • AI Assistants (ChatGPT, Claude)"
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
export INSTALL_GUI_APPS INSTALL_JETBRAINS INSTALL_DOCKER INSTALL_VSCODE INSTALL_FIGMA INSTALL_GITHUB_DESKTOP INSTALL_TAILSCALE INSTALL_CHATGPT INSTALL_CLAUDE QUIET_MODE
export INSTALL_NODE INSTALL_GO INSTALL_PHP INSTALL_PYTHON
export INSTALL_YARN INSTALL_PNPM INSTALL_BUN
export INSTALL_DATAGRIP INSTALL_PHPSTORM INSTALL_GOLAND INSTALL_WEBSTORM
export CLEAN_PHP_ONLY PREVENT_UNWANTED_PACKAGES
bash "$DOTFILES_DIR/scripts/homebrew.sh"

# Setup asdf and programming languages
log_info "Setting up asdf and programming languages..."
bash "$DOTFILES_DIR/scripts/asdf.sh"

# Setup shell configurations
log_info "Setting up shell configurations..."
bash "$DOTFILES_DIR/scripts/shell.sh"

# Run prevention script if requested
if [[ "$CLEAN_PHP_ONLY" == "true" ]] || [[ "$PREVENT_UNWANTED_PACKAGES" == "true" ]]; then
    log_info "Running package prevention cleanup..."
    if [[ "$CLEAN_PHP_ONLY" == "true" ]] && [[ "$PREVENT_UNWANTED_PACKAGES" == "true" ]]; then
        bash "$DOTFILES_DIR/scripts/prevent-packages.sh" all
    elif [[ "$PREVENT_UNWANTED_PACKAGES" == "true" ]]; then
        bash "$DOTFILES_DIR/scripts/prevent-packages.sh" auto
    elif [[ "$CLEAN_PHP_ONLY" == "true" ]]; then
        bash "$DOTFILES_DIR/scripts/prevent-packages.sh" check
    fi
fi

# Final message
echo ""
log_success "🎉 Dotfiles Setup Complete!"
echo ""
echo "📝 Next Steps:"
echo "1. 🔄 Restart your terminal or run: source ~/.zshrc"
echo "2. 🚀 Open Warp terminal for the enhanced experience"
echo "3. 🐳 Start Docker Desktop if you installed it"
echo "4. 🔑 Authenticate with GitHub: gh auth login (if needed)"
echo ""
echo "✅ Verify installations:"
echo "  • asdf list        # See installed language versions"
echo "  • node --version   # Node.js"
echo "  • yarn --version   # Yarn (if installed)"
echo "  • pnpm --version   # pnpm (if installed)"
echo "  • bun --version    # Bun (if installed)"
echo "  • go version       # Go"
echo "  • php --version    # PHP"
echo "  • python --version # Python"
echo "  • docker --version # Docker"
echo ""
echo "🎯 Pro Tips:"
echo "  • Your terminal uses the Passion theme with real-time clock & command timing"
echo "  • Switch to Powerlevel10k by uncommenting ZSH_THEME line in ~/.zshrc"
echo "  • Use 'p10k configure' if you switch to Powerlevel10k"
echo "  • Edit ~/.zshrc.local for personal customizations"
echo "  • Run 'asdf list-all <plugin>' to see available versions"
echo ""
log_info "Happy coding! 🚀🎉"
