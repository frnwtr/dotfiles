# 🚀 Dotfiles - Development Environment Setup

This repository contains scripts to automatically set up a complete development environment on macOS. It installs and configures all the essential tools needed for modern software development.

## ✨ What Gets Installed

### 🍺 Package Manager
- **Homebrew** - The missing package manager for macOS

### 🛠 Development Tools
- **Warp Terminal** - Modern, fast terminal with AI features
- **Docker Desktop** - Containerization platform
- **Visual Studio Code** - Code editor
- **Git** - Version control system
- **Essential CLI tools** - curl, wget, jq, tree, htop

### 📦 Language Version Manager  
- **asdf** - Manage multiple runtime versions with a single CLI tool

### 🔧 Programming Languages
- **Node.js** (latest LTS) - JavaScript runtime
- **Go** (latest) - Systems programming language  
- **PHP** (latest) - Web development language

### 🐚 Shell Enhancement
- **Oh My Zsh** - Framework for managing zsh configuration
- **Powerlevel10k** - Beautiful and functional theme
- **Useful plugins** - autosuggestions, syntax highlighting, git, docker, etc.
- **Helpful aliases** - git shortcuts, docker commands, navigation helpers

## 🚀 Quick Start

### One-Line Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh)
```

### Manual Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installation script:**
   ```bash
   ./install.sh
   ```

3. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

## 📋 Requirements

- macOS (tested on macOS 12+)
- Internet connection
- Administrator privileges for some installations

## 🔧 Manual Component Installation

You can also run individual setup scripts:

### Install Homebrew and packages:
```bash
./scripts/homebrew.sh
```

### Setup asdf and programming languages:
```bash
./scripts/asdf.sh  
```

### Configure shell:
```bash
./scripts/shell.sh
```

## 📁 Project Structure

```
dotfiles/
├── install.sh              # Main installation script
├── scripts/
│   ├── homebrew.sh         # Homebrew and packages setup
│   ├── asdf.sh            # asdf and programming languages
│   └── shell.sh           # Shell configuration
├── config/                # Configuration files (future)
├── shell/                 # Additional shell scripts (future)  
└── README.md              # This file
```

## ⚙️ Customization

### Shell Configuration
The installation creates a comprehensive `.zshrc` file. For personal customizations:

1. **Create a local customization file:**
   ```bash
   touch ~/.zshrc.local
   ```

2. **Add your personal aliases and functions:**
   ```bash
   # ~/.zshrc.local
   alias myalias="echo 'Hello World'"
   export MY_CUSTOM_VAR="value"
   ```

### Programming Language Versions

After installation, you can manage language versions with asdf:

```bash
# List available versions
asdf list all nodejs
asdf list all golang
asdf list all php

# Install specific versions
asdf install nodejs 18.19.0
asdf install golang 1.21.5

# Set global versions  
asdf set nodejs 18.19.0
asdf set golang 1.21.5

# Set project-specific versions
echo "nodejs 18.19.0" >> .tool-versions
echo "golang 1.21.5" >> .tool-versions
```

## 🔍 Verification

After installation, verify everything is working:

```bash
# Check tool versions
node --version
npm --version
go version
php --version
docker --version

# Check asdf
asdf current

# Check shell configuration
echo $PATH
which node
which go
which php
```

## 🐛 Troubleshooting

### Common Issues

**1. Command not found after installation**
- Restart your terminal or run `source ~/.zshrc`
- Check if the tool's directory is in your PATH: `echo $PATH`

**2. asdf command not found**
- Make sure asdf is sourced in your shell: `source ~/.asdf/asdf.sh`
- Restart your terminal

**3. PHP installation takes too long**
- The script may fallback to Homebrew for PHP installation
- You can manually install PHP via asdf later: `asdf install php 8.3.15`

**4. Permission denied errors**
- Make sure you have administrator privileges
- Some Homebrew installations may require password input

**5. Docker not working**
- Make sure Docker Desktop is running
- You may need to accept Docker's license agreement in the GUI

### Getting Help

1. **Check installation logs** - The scripts provide detailed output
2. **Verify prerequisites** - Ensure you're on macOS with admin rights
3. **Run individual scripts** - Test components separately
4. **Reset and retry** - Delete installed components and re-run

## 🔄 Updating

To update your development environment:

```bash
cd ~/dotfiles
git pull origin main
./install.sh
```

## 🎯 Available Aliases

After installation, you'll have access to useful aliases:

### Git Shortcuts
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gl` - git log --oneline --graph --decorate
- `gd` - git diff
- `gb` - git branch
- `gco` - git checkout

### Docker Shortcuts  
- `dc` - docker-compose
- `dcu` - docker-compose up
- `dcd` - docker-compose down
- `dcb` - docker-compose build
- `dps` - docker ps
- `di` - docker images

### Navigation
- `ll` - ls -alF
- `la` - ls -A  
- `..` - cd ..
- `...` - cd ../..
- `mkcd` - mkdir and cd into directory

## 🤝 Contributing

Feel free to customize this setup for your needs:

1. Fork this repository
2. Make your changes
3. Test the installation on a fresh macOS system
4. Submit a pull request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Homebrew](https://brew.sh/) - Package management
- [asdf](https://asdf-vm.com/) - Version management
- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [Warp](https://www.warp.dev/) - Modern terminal

---

**Happy coding!** 🎉

If you find this useful, please ⭐ star this repository!