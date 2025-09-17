# Recent Dotfiles Updates - PHP Configuration

## Summary of Changes (September 17, 2025)

### 🔥 **Major PHP Configuration Updates**

The PHP setup in your dotfiles has been significantly enhanced to provide a cleaner, more robust installation process.

### ✅ **Key Changes Made**

#### 1. **Homebrew PHP Auto-Removal**
- **Before**: Manual cleanup required for conflicting Homebrew PHP
- **After**: Automatic detection and removal of Homebrew PHP before asdf installation
- **Benefit**: Eliminates PATH conflicts and ensures clean asdf PHP setup

#### 2. **Composer Auto-Installation**
- **Before**: Separate manual Composer installation via curl
- **After**: Composer is automatically installed by the asdf-php plugin
- **Benefit**: Simplified setup process, better integration

#### 3. **Enhanced Build Dependencies**
**Optimized dependency list for PHP via asdf:**

**Core Dependencies:**
- autoconf, automake, bison, freetype, gd, gettext
- icu4c, krb5, libedit, libiconv, libjpeg, libpng
- libxml2, libzip, pkg-config, re2c, zlib

**Enhanced Features Added:**
- `gmp` - Enhanced math operations
- `libsodium` - Modern cryptography
- `imagemagick` - Image processing
- `ffmpeg` - Video/audio processing
- `krb5` - Kerberos authentication support

#### 4. **Build Configuration Enhancements**
- Added Kerberos support: `--with-kerberos=/opt/homebrew/opt/krb5`
- Enhanced LDFLAGS and CPPFLAGS with krb5 paths
- Better compiler flag organization

#### 5. **Simplified Dependency Management**
- **Before**: Large generic dependency list for all languages
- **After**: Language-specific dependency installation only when needed
- **Benefit**: Cleaner installs, faster setup for non-PHP users

### 📁 **Files Updated**

1. **`scripts/asdf.sh`**
   - Homebrew PHP detection and removal
   - PHP-specific dependency installation
   - Enhanced build environment
   - Removed manual Composer installation

2. **`config/asdf-php.env`**
   - Added Kerberos configuration
   - Enhanced build flags
   - Updated documentation

3. **`config/PHP_SETUP.md`**
   - Updated feature list
   - New dependency information
   - Enhanced troubleshooting
   - Composer auto-install notes

4. **`README.md`**
   - Updated PHP configuration references
   - Enhanced quick start guide

5. **`.tool-versions`**
   - Updated comments to reflect asdf management

### 🚀 **Usage Changes**

#### For New Installations:
```bash
# Run the setup (will auto-handle Homebrew PHP removal)
./scripts/asdf.sh

# Or use the main installer
./install.sh --php
```

#### For Existing Users:
```bash
# Load enhanced PHP environment
source ~/dotfiles/config/asdf-php.env

# Check new features
php --version
php -m | grep -E "(gmp|sodium|imagick)"
```

### 🔧 **Technical Improvements**

#### Build Quality:
- **More Extensions**: Better support for crypto, media, auth
- **Cleaner Build**: Fewer conflicts, better dependency resolution
- **Enhanced Features**: ImageMagick, FFmpeg, Kerberos support

#### User Experience:
- **Automatic Cleanup**: No manual Homebrew PHP removal needed
- **Faster Setup**: No separate Composer installation
- **Better Docs**: Comprehensive troubleshooting guide

#### Maintenance:
- **Cleaner Code**: Language-specific dependency management
- **Better Testing**: Enhanced detection and validation
- **Future-Proof**: Easier to add new PHP features

### ⚡ **Performance Benefits**

1. **Faster Installs**: Only install dependencies when PHP is chosen
2. **Cleaner Environment**: Automatic conflict resolution
3. **Better Performance**: Enhanced crypto and media processing capabilities
4. **Simplified Maintenance**: Self-managing Composer installation

### 🎯 **Next Steps**

1. **Test the new configuration** if installing PHP fresh
2. **Use `source ~/dotfiles/config/asdf-php.env`** for existing installations
3. **Check `config/PHP_SETUP.md`** for detailed documentation
4. **Report any issues** with the new dependency list

### 🔧 **Configuration Conflict Fix**

If you encounter errors like:
```
Failed loading /opt/homebrew/opt/php/lib/php/.../opcache.so
```

This is caused by conflicting PHP configuration directories. **Quick fix:**

```bash
# Run the automated cleanup script
./scripts/php-cleanup.sh

# Or manually fix
unset PHP_INI_SCAN_DIR
source ~/dotfiles/config/asdf-php.env
```

### 🔗 **Related Documentation**

- **Detailed Setup**: `config/PHP_SETUP.md`
- **Environment Config**: `config/asdf-php.env`
- **Cleanup Script**: `scripts/php-cleanup.sh`
- **Main Installation**: `README.md`

---

*These changes make your dotfiles PHP setup more robust, cleaner, and feature-rich while reducing manual intervention required during installation.*
