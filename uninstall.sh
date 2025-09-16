#!/bin/bash

# Dotfiles Uninstallation Script
# This script helps remove tools and configurations managed by dotfiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default options
REMOVE_HOMEBREW=false
REMOVE_ASDF=false
REMOVE_OH_MY_ZSH=false
REMOVE_CONFIG_FILES=false
REMOVE_GLOBAL_PACKAGES=false
REMOVE_GUI_APPS=false
REMOVE_JETBRAINS=false
QUIET_MODE=false
DRY_RUN=false

# Logging functions
log_info() {
    echo -e "${BLUE}[UNINSTALL]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[UNINSTALL]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[UNINSTALL]${NC} $1"
}

log_error() {
    echo -e "${RED}[UNINSTALL]${NC} $1"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --homebrew)
            REMOVE_HOMEBREW=true
            shift
            ;;
        --asdf)
            REMOVE_ASDF=true
            shift
            ;;
        --oh-my-zsh)
            REMOVE_OH_MY_ZSH=true
            shift
            ;;
        --config-files)
            REMOVE_CONFIG_FILES=true
            shift
            ;;
        --global-packages)
            REMOVE_GLOBAL_PACKAGES=true
            shift
            ;;
        --gui-apps)
            REMOVE_GUI_APPS=true
            shift
            ;;
        --jetbrains)
            REMOVE_JETBRAINS=true
            shift
            ;;
        --all)
            REMOVE_HOMEBREW=true
            REMOVE_ASDF=true
            REMOVE_OH_MY_ZSH=true
            REMOVE_CONFIG_FILES=true
            REMOVE_GLOBAL_PACKAGES=true
            REMOVE_GUI_APPS=true
            REMOVE_JETBRAINS=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --quiet|-q)
            QUIET_MODE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --homebrew          Remove Homebrew and all its packages"
            echo "  --asdf              Remove asdf and installed languages"
            echo "  --oh-my-zsh         Remove Oh My Zsh and related configurations"
            echo "  --config-files      Remove dotfiles-generated configuration files"
            echo "  --global-packages   Remove global packages (npm, composer, etc.)"
            echo "  --gui-apps          Remove GUI applications (Warp, VS Code, etc.)"
            echo "  --jetbrains         Remove JetBrains IDEs and Toolbox"
            echo "  --all               Remove everything managed by dotfiles"
            echo "  --dry-run           Show what would be removed without actually removing"
            echo "  --quiet, -q         Run in quiet mode (minimal output)"
            echo "  --help, -h          Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 --all                    # Remove everything"
            echo "  $0 --homebrew --asdf       # Remove only Homebrew and asdf"
            echo "  $0 --gui-apps --jetbrains  # Remove only GUI applications"
            echo "  $0 --dry-run --all         # See what would be removed"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Function to execute or show command based on dry-run mode
execute_or_show() {
    local command="$1"
    local description="$2"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would execute: $description"
        echo "  Command: $command"
    else
        log_info "$description"
        if [[ "$QUIET_MODE" != "true" ]]; then
            echo "  Executing: $command"
        fi
        eval "$command" 2>/dev/null || log_warning "Command failed (this might be expected)"
    fi
}

# Function to ask for confirmation
ask_confirmation() {
    local message="$1"
    
    if [[ "$QUIET_MODE" == "true" ]] || [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi
    
    read -p "$message (y/N): " -n 1 -r
    echo ""
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Welcome message
echo "🗑️  Dotfiles Uninstallation Script"
echo ""
if [[ "$DRY_RUN" == "true" ]]; then
    log_info "Running in DRY RUN mode - nothing will actually be removed"
    echo ""
fi

# Check if any options were provided
if [[ "$REMOVE_HOMEBREW" == "false" ]] && [[ "$REMOVE_ASDF" == "false" ]] && \
   [[ "$REMOVE_OH_MY_ZSH" == "false" ]] && [[ "$REMOVE_CONFIG_FILES" == "false" ]] && \
   [[ "$REMOVE_GLOBAL_PACKAGES" == "false" ]] && [[ "$REMOVE_GUI_APPS" == "false" ]] && \
   [[ "$REMOVE_JETBRAINS" == "false" ]]; then
    
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo "What would you like to remove?"
        echo ""
        echo "1. Configuration files only (.zshrc, etc.)"
        echo "2. Global packages (npm, composer packages)"
        echo "3. GUI applications (Warp, VS Code, etc.)"
        echo "4. JetBrains IDEs and Toolbox"
        echo "5. Oh My Zsh and shell configurations"
        echo "6. asdf and programming languages"
        echo "7. Homebrew and all packages (WARNING: This removes everything)"
        echo "8. Everything (complete removal)"
        echo ""
        read -p "Enter your choice (1-8): " -n 1 -r
        echo ""
        
        case $REPLY in
            1) REMOVE_CONFIG_FILES=true ;;
            2) REMOVE_GLOBAL_PACKAGES=true ;;
            3) REMOVE_GUI_APPS=true ;;
            4) REMOVE_JETBRAINS=true ;;
            5) REMOVE_OH_MY_ZSH=true ;;
            6) REMOVE_ASDF=true ;;
            7) REMOVE_HOMEBREW=true ;;
            8) 
                REMOVE_HOMEBREW=true
                REMOVE_ASDF=true
                REMOVE_OH_MY_ZSH=true
                REMOVE_CONFIG_FILES=true
                REMOVE_GLOBAL_PACKAGES=true
                REMOVE_GUI_APPS=true
                REMOVE_JETBRAINS=true
                ;;
            *)
                log_error "Invalid choice. Exiting."
                exit 1
                ;;
        esac
    else
        log_error "No removal options specified. Use --help for options or run without --quiet for interactive mode."
        exit 1
    fi
fi

# Warning for destructive operations
if [[ "$REMOVE_HOMEBREW" == "true" ]] && [[ "$DRY_RUN" == "false" ]]; then
    log_warning "WARNING: Removing Homebrew will uninstall ALL Homebrew packages and Homebrew itself!"
    log_warning "This includes packages not installed by dotfiles!"
    if ! ask_confirmation "Are you SURE you want to continue?"; then
        log_info "Cancelled."
        exit 0
    fi
fi

# Final confirmation (except for dry run)
if [[ "$DRY_RUN" == "false" ]] && [[ "$QUIET_MODE" != "true" ]]; then
    if ! ask_confirmation "Proceed with uninstallation?"; then
        log_info "Cancelled."
        exit 0
    fi
fi

echo ""
log_info "Starting uninstallation process..."
echo ""

# Remove global packages
if [[ "$REMOVE_GLOBAL_PACKAGES" == "true" ]]; then
    log_info "Removing global packages..."
    
    # Node.js global packages
    if command -v npm >/dev/null 2>&1; then
        execute_or_show "npm list -g --depth=0 | grep -v npm | awk 'NF>1{print \$2}' | awk -F@ '{print \$1}' | xargs npm uninstall -g" "Remove npm global packages"
        execute_or_show "rm -rf ~/.npm-global" "Remove npm global directory"
    fi
    
    # Yarn global packages
    if command -v yarn >/dev/null 2>&1; then
        execute_or_show "yarn global list | grep info | awk '{print \$2}' | grep -v '@' | xargs yarn global remove" "Remove yarn global packages"
    fi
    
    # Composer global packages
    if command -v composer >/dev/null 2>&1; then
        execute_or_show "composer global show | awk '{print \$1}' | xargs composer global remove" "Remove composer global packages"
        execute_or_show "rm -rf ~/.composer" "Remove composer directory"
        execute_or_show "rm -rf ~/.config/composer" "Remove composer config directory"
    fi
    
    # Bun
    if [[ -d "$HOME/.bun" ]]; then
        execute_or_show "rm -rf ~/.bun" "Remove Bun installation"
    fi
    
    echo ""
fi

# Remove GUI applications
if [[ "$REMOVE_GUI_APPS" == "true" ]]; then
    log_info "Removing GUI applications..."
    
    GUI_APPS=("warp" "docker" "visual-studio-code" "figma" "github" "tailscale")
    
    for app in "${GUI_APPS[@]}"; do
        if brew list --cask "$app" >/dev/null 2>&1; then
            execute_or_show "brew uninstall --cask $app" "Remove $app"
        fi
    done
    
    echo ""
fi

# Remove JetBrains IDEs
if [[ "$REMOVE_JETBRAINS" == "true" ]]; then
    log_info "Removing JetBrains IDEs..."
    
    JETBRAINS_APPS=("jetbrains-toolbox" "datagrip" "phpstorm" "goland" "webstorm")
    
    for app in "${JETBRAINS_APPS[@]}"; do
        if brew list --cask "$app" >/dev/null 2>&1; then
            execute_or_show "brew uninstall --cask $app" "Remove $app"
        fi
    done
    
    # Remove JetBrains config directories
    execute_or_show "rm -rf ~/Library/Application\\ Support/JetBrains" "Remove JetBrains config directory"
    execute_or_show "rm -rf ~/Library/Preferences/com.jetbrains.*" "Remove JetBrains preferences"
    execute_or_show "rm -rf ~/Library/Logs/JetBrains" "Remove JetBrains logs"
    
    echo ""
fi

# Remove Oh My Zsh
if [[ "$REMOVE_OH_MY_ZSH" == "true" ]]; then
    log_info "Removing Oh My Zsh..."
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        execute_or_show "rm -rf ~/.oh-my-zsh" "Remove Oh My Zsh directory"
    fi
    
    # Remove Powerlevel10k config
    execute_or_show "rm -f ~/.p10k.zsh" "Remove Powerlevel10k configuration"
    
    echo ""
fi

# Remove asdf
if [[ "$REMOVE_ASDF" == "true" ]]; then
    log_info "Removing asdf and programming languages..."

    if brew list "asdf" >/dev/null 2>&1; then
        execute_or_show "brew uninstall asdf" "Remove asdf"
    fi
    
    if [[ -d "$HOME/.asdf" ]]; then
        execute_or_show "rm -rf ~/.asdf" "Remove asdf directory"
    fi
    
    execute_or_show "rm -f ~/.tool-versions" "Remove global .tool-versions file"
    
    # Remove language-specific directories
    execute_or_show "rm -rf ~/go" "Remove Go workspace"
    execute_or_show "rm -rf ~/.cache/go-build" "Remove Go build cache"
    
    echo ""
fi

# Remove configuration files
if [[ "$REMOVE_CONFIG_FILES" == "true" ]]; then
    log_info "Removing configuration files..."
    
    # Backup existing files first (in dry run, just show what would be backed up)
    if [[ "$DRY_RUN" == "false" ]]; then
        if [[ -f "$HOME/.zshrc" ]]; then
            log_info "Backing up current .zshrc to .zshrc.pre-dotfiles-uninstall"
            cp ~/.zshrc ~/.zshrc.pre-dotfiles-uninstall
        fi
    fi
    
    # Restore from backup if available
    if [[ -f "$HOME/.zshrc.backup" ]]; then
        execute_or_show "mv ~/.zshrc.backup ~/.zshrc" "Restore .zshrc from backup"
    elif [[ -f "$HOME/.zshrc.pre-oh-my-zsh" ]]; then
        execute_or_show "mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc" "Restore .zshrc from Oh My Zsh backup"
    else
        execute_or_show "rm -f ~/.zshrc" "Remove .zshrc (no backup found)"
    fi
    
    # Remove other dotfiles-created files
    execute_or_show "rm -f ~/.zshrc.local" "Remove local customizations file"
    
    echo ""
fi

# Remove Homebrew (most destructive - done last)
if [[ "$REMOVE_HOMEBREW" == "true" ]]; then
    log_info "Removing Homebrew..."
    
    if command -v brew >/dev/null 2>&1; then
        # Official Homebrew uninstall script
        execute_or_show "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\"" "Run official Homebrew uninstaller"
        
        # Clean up remaining directories
        execute_or_show "sudo rm -rf /opt/homebrew" "Remove Homebrew directory (Apple Silicon)"
        execute_or_show "sudo rm -rf /usr/local/Homebrew" "Remove Homebrew directory (Intel)"
        execute_or_show "sudo rm -rf /usr/local/Caskroom" "Remove Caskroom directory"
        execute_or_show "sudo rm -rf /usr/local/Cellar" "Remove Cellar directory"

	execute_or_show "rm -rf ~/Library/Fonts/Fira*.*" "Remove Fira Font"
	execute_or_show "rm -rf ~/Library/Fonts/HackNerd*.*" "Remove HackNerd Font"
	execute_or_show "rm -rf ~/Library/Fonts/Meslo*.*" "Remove Meslo Font"
	execute_or_show "rm -rf ~/Library/Fonts/SourceCodePro*.*" "Remove SourceCodePro Font"
        
        # Remove from shell profile
        if [[ -f "$HOME/.zprofile" ]]; then
            execute_or_show "sed -i.bak '/homebrew/d' ~/.zprofile" "Remove Homebrew from .zprofile"
        fi
    else
        log_info "Homebrew not found, skipping..."
    fi
    
    echo ""
fi

# Final cleanup
log_info "Performing final cleanup..."

# Remove empty directories
execute_or_show "rmdir ~/.config 2>/dev/null || true" "Remove empty .config directory"
execute_or_show "rmdir ~/.cache 2>/dev/null || true" "Remove empty .cache directory"

# Clear shell hash
execute_or_show "hash -r" "Clear shell command hash"

echo ""

if [[ "$DRY_RUN" == "true" ]]; then
    log_success "Dry run complete! No changes were made."
    log_info "Run without --dry-run to actually perform the uninstallation."
else
    log_success "Uninstallation complete!"
    
    echo ""
    log_info "Summary of what was removed:"
    [[ "$REMOVE_CONFIG_FILES" == "true" ]] && echo "  ✓ Configuration files (.zshrc, etc.)"
    [[ "$REMOVE_GLOBAL_PACKAGES" == "true" ]] && echo "  ✓ Global packages (npm, composer, etc.)"
    [[ "$REMOVE_GUI_APPS" == "true" ]] && echo "  ✓ GUI applications"
    [[ "$REMOVE_JETBRAINS" == "true" ]] && echo "  ✓ JetBrains IDEs"
    [[ "$REMOVE_OH_MY_ZSH" == "true" ]] && echo "  ✓ Oh My Zsh and shell configurations"
    [[ "$REMOVE_ASDF" == "true" ]] && echo "  ✓ asdf and programming languages"
    [[ "$REMOVE_HOMEBREW" == "true" ]] && echo "  ✓ Homebrew and all packages"
    
    echo ""
    log_warning "Important notes:"
    echo "  • Restart your terminal to see changes"
    echo "  • Some applications may leave preferences in ~/Library"
    echo "  • Configuration backups were created where possible"
    echo "  • Check ~/.zshrc.pre-dotfiles-uninstall for your previous config"
fi