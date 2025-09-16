#!/bin/bash

# Test Script for Dotfiles Installation
# Verifies that all components are properly installed and configured

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Test functions
test_passed() {
    echo -e "${GREEN}✓${NC} $1"
    ((TESTS_PASSED++))
}

test_failed() {
    echo -e "${RED}✗${NC} $1"
    ((TESTS_FAILED++))
}

test_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

test_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

echo "🧪 Testing Dotfiles Installation"
echo "================================"
echo ""

# Test Homebrew
test_info "Testing Homebrew..."
if command -v brew >/dev/null 2>&1; then
    test_passed "Homebrew is installed"
    BREW_VERSION=$(brew --version | head -1)
    test_info "  Version: $BREW_VERSION"
else
    test_failed "Homebrew is not installed"
fi

# Test Git
test_info "Testing Git..."
if command -v git >/dev/null 2>&1; then
    test_passed "Git is installed"
    GIT_VERSION=$(git --version)
    test_info "  Version: $GIT_VERSION"
else
    test_failed "Git is not installed"
fi

# Test asdf
test_info "Testing asdf..."
if command -v asdf >/dev/null 2>&1; then
    test_passed "asdf is installed"
    ASDF_VERSION=$(asdf version)
    test_info "  Version: $ASDF_VERSION"
else
    if [ -f "$HOME/.asdf/bin/asdf" ]; then
        test_warning "asdf is installed but not in PATH (restart terminal)"
    else
        test_failed "asdf is not installed"
    fi
fi

# Test Node.js
test_info "Testing Node.js..."
if command -v node >/dev/null 2>&1; then
    test_passed "Node.js is installed"
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    test_info "  Node.js: $NODE_VERSION"
    test_info "  npm: $NPM_VERSION"
else
    test_failed "Node.js is not installed or not in PATH"
fi

# Test Go
test_info "Testing Go..."
if command -v go >/dev/null 2>&1; then
    test_passed "Go is installed"
    GO_VERSION=$(go version)
    test_info "  Version: $GO_VERSION"
    
    # Test GOPATH
    if [ -n "$GOPATH" ]; then
        test_passed "GOPATH is set: $GOPATH"
    else
        test_warning "GOPATH is not set"
    fi
else
    test_failed "Go is not installed or not in PATH"
fi

# Test PHP
test_info "Testing PHP..."
if command -v php >/dev/null 2>&1; then
    test_passed "PHP is installed"
    PHP_VERSION=$(php --version | head -1)
    test_info "  Version: $PHP_VERSION"
else
    test_failed "PHP is not installed or not in PATH"
fi

# Test Docker
test_info "Testing Docker..."
if command -v docker >/dev/null 2>&1; then
    test_passed "Docker is installed"
    if docker version >/dev/null 2>&1; then
        DOCKER_VERSION=$(docker --version)
        test_passed "Docker daemon is running"
        test_info "  Version: $DOCKER_VERSION"
    else
        test_warning "Docker is installed but daemon is not running"
    fi
else
    test_failed "Docker is not installed or not in PATH"
fi

# Test Warp
test_info "Testing Warp terminal..."
if [ -d "/Applications/Warp.app" ]; then
    test_passed "Warp terminal is installed"
else
    test_failed "Warp terminal is not installed"
fi

# Test VS Code
test_info "Testing Visual Studio Code..."
if [ -d "/Applications/Visual Studio Code.app" ] || command -v code >/dev/null 2>&1; then
    test_passed "Visual Studio Code is installed"
else
    test_warning "Visual Studio Code is not installed (optional)"
fi

# Test Shell Configuration
test_info "Testing shell configuration..."
if [ -f "$HOME/.zshrc" ]; then
    test_passed ".zshrc exists"
    
    # Check for Oh My Zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        test_passed "Oh My Zsh is installed"
    else
        test_failed "Oh My Zsh is not installed"
    fi
    
    # Check for Powerlevel10k
    if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        test_passed "Powerlevel10k theme is installed"
    else
        test_warning "Powerlevel10k theme is not installed"
    fi
    
    # Check for plugins
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        test_passed "zsh-autosuggestions plugin is installed"
    else
        test_warning "zsh-autosuggestions plugin is not installed"
    fi
    
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        test_passed "zsh-syntax-highlighting plugin is installed"
    else
        test_warning "zsh-syntax-highlighting plugin is not installed"
    fi
else
    test_failed ".zshrc does not exist"
fi

# Test PATH configuration
test_info "Testing PATH configuration..."
if echo "$PATH" | grep -q "/opt/homebrew/bin"; then
    test_passed "Homebrew is in PATH"
elif echo "$PATH" | grep -q "/usr/local/bin"; then
    test_passed "Homebrew is in PATH (Intel Mac)"
else
    test_failed "Homebrew is not in PATH"
fi

if echo "$PATH" | grep -q ".asdf"; then
    test_passed "asdf is in PATH"
else
    test_warning "asdf is not in PATH (restart terminal may be needed)"
fi

# Test .tool-versions file
test_info "Testing .tool-versions file..."
if [ -f "$HOME/.tool-versions" ]; then
    test_passed ".tool-versions file exists"
    test_info "  Contents:"
    cat "$HOME/.tool-versions" | sed 's/^/    /'
else
    test_warning ".tool-versions file does not exist"
fi

# Test aliases
test_info "Testing aliases..."
if alias gs >/dev/null 2>&1; then
    test_passed "Git aliases are configured"
else
    test_warning "Git aliases may not be loaded (restart terminal)"
fi

# Summary
echo ""
echo "🏆 Test Results Summary"
echo "======================"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All critical tests passed!${NC}"
    echo "Your development environment is ready to use."
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc"  
    echo "2. Open Warp terminal for the best experience"
    echo "3. Start Docker Desktop if you plan to use containers"
    echo "4. Run 'p10k configure' to customize your prompt"
else
    echo -e "${YELLOW}⚠️  Some tests failed.${NC}"
    echo "Please check the output above and:"
    echo "1. Restart your terminal"
    echo "2. Run the installation script again if needed"
    echo "3. Check the troubleshooting section in README.md"
fi

echo ""
echo "Happy coding! 🚀"