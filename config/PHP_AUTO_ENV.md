# Automatic PHP Environment Loading

## 🔄 **How It Works**

Your dotfiles now **automatically configure the PHP environment** when you enter PHP project directories. No manual sourcing required!

## ✅ **What Triggers Automatic Loading**

The PHP environment is automatically configured when you `cd` into a directory containing:

1. **`composer.json`** - PHP Composer project
2. **`.tool-versions` with `php`** - asdf-managed PHP project  
3. **`.php` files** - Any directory with PHP files

## 🛠 **What Gets Configured Automatically**

When triggered, the system automatically sets:

```bash
# Clears conflicting configurations
unset PHP_INI_SCAN_DIR

# Sets build configuration
export PHP_WITHOUT_PEAR=yes
export PHP_CONFIGURE_OPTIONS="--with-openssl=/opt/homebrew/opt/openssl@3 --with-iconv=/opt/homebrew/opt/libiconv --with-kerberos=/opt/homebrew/opt/krb5"
```

## 🎯 **How asdf Integration Works**

### **Automatic (asdf + .tool-versions):**
- ✅ **Version switching**: Changes PHP version based on `.tool-versions`
- ✅ **PATH management**: Updates PATH to correct PHP version
- ✅ **Shim routing**: Routes `php`/`composer` to correct version
- ✅ **Environment setup**: Now automatically configures build environment

### **Manual Override Available:**
```bash
# For full control or troubleshooting
source ~/dotfiles/config/asdf-php.env
```

## 📝 **Example Workflow**

```bash
# 1. Navigate to any PHP project
cd ~/my-laravel-app

# 2. Environment is automatically configured (no manual steps!)
# - PHP version switches based on .tool-versions
# - Build environment is set up
# - Configuration conflicts are cleared

# 3. Use PHP normally
php --version           # ✅ Uses correct asdf PHP version
composer install        # ✅ Uses asdf Composer
php artisan serve       # ✅ Runs with proper configuration
```

## 🔍 **Debugging Automatic Loading**

### **Check if automatic loading is working:**
```bash
# Enter a PHP directory
cd ~/php-project

# Check environment
echo $PHP_CONFIGURE_OPTIONS
# Should show: --with-openssl=/opt/homebrew/opt/openssl@3 ...

# Check PHP path
which php
# Should show: /Users/yourusername/.asdf/shims/php
```

### **Force reload if needed:**
```bash
# Manually trigger the auto-load function
auto_load_php_env

# Or source the environment manually
source ~/dotfiles/config/asdf-php.env
```

## ⚡ **Performance Notes**

- **Lightweight**: Only runs when entering directories with PHP projects
- **Smart detection**: Uses fast file system checks
- **Cached**: Environment variables persist until shell restart
- **No overhead**: Doesn't affect non-PHP directories

## 🎛 **Customization Options**

### **Disable automatic loading:**
```bash
# Add to ~/.zshrc.local
unset -f auto_load_php_env
```

### **Add custom triggers:**
Edit the detection logic in `scripts/shell.sh`:
```bash
# Current triggers (around line 277)
if [[ -f "composer.json" ]] || 
   [[ -f ".tool-versions" && -n "$(grep '^php ' .tool-versions 2>/dev/null)" ]] || 
   [[ -n "$(find . -maxdepth 1 -name '*.php' 2>/dev/null | head -1)" ]]; then
```

### **Add custom environment variables:**
```bash
# In the auto_load_php_env function, add:
export MY_PHP_VAR="custom_value"
```

## 🔧 **Technical Implementation**

The automatic loading is implemented through:

1. **Shell hook**: `add-zsh-hook chpwd auto_load_php_env`
2. **Detection function**: `auto_load_php_env()` in `.zshrc`
3. **Smart triggers**: File-based project detection
4. **Environment management**: Automatic variable setting/clearing

## 🆚 **Comparison: Manual vs Automatic**

| Aspect | Manual (`source asdf-php.env`) | Automatic (New) |
|--------|--------------------------------|-----------------|
| **Setup** | Manual command each time | Automatic on `cd` |
| **Triggers** | User-initiated | Directory-based |
| **Performance** | One-time load | Smart detection |
| **Convenience** | Requires remembering | Transparent |
| **Control** | Full manual control | Automatic + override |

## 🎉 **Benefits**

✅ **Zero friction**: Just `cd` and start coding  
✅ **No forgotten setup**: Environment always ready  
✅ **Version-aware**: Works with different PHP versions  
✅ **Project-specific**: Only loads when needed  
✅ **Override-friendly**: Manual control still available  

The automatic PHP environment loading makes working with multiple PHP projects seamless while maintaining all the benefits of the custom asdf PHP build configuration!