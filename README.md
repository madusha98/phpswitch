# phpswitch

A simple, lightweight PHP version manager for macOS. Switch between multiple PHP versions instantly with a single command or automatically per project.

## Why phpswitch?

- ⚡ **Instant switching** - Change PHP versions in milliseconds
- 🎯 **Simple** - Just one command: `phpswitch 8.3`
- 📁 **Project-aware** - Auto-switch with `.php-version` files
- 📦 **Built-in management** - Install, uninstall, and list PHP versions
- 🔄 **Smart PATH management** - No conflicts with other tools
- 🍺 **Homebrew native** - Uses your existing PHP installations
- 🪶 **Lightweight** - Pure Bash, no dependencies

## phpswitch vs phpbrew

phpswitch is **not** a replacement for phpbrew - they serve different needs:

### phpbrew
- **Builds PHP from source** - Compiles each version (10-30 minutes per install)
- **Full control** - Custom configurations, variants, and extensions
- **Comprehensive** - Manages PHP builds, extensions, and configurations
- **Best for:** Developers who need custom PHP builds with specific compile options

```bash
# phpbrew workflow
phpbrew install 8.3 +default +mysql +gd  # 20+ minutes
phpbrew switch 8.3
```

### phpswitch (this tool)
- **Uses Homebrew** - Pre-built binaries (30 seconds to install)
- **Simple switching** - Just manages PATH and version switching
- **Lightweight** - ~240 lines of Bash, no compilation needed
- **Best for:** Homebrew users who want instant switching between versions

```bash
# phpswitch workflow
phpswitch install 8.3  # 30 seconds via Homebrew
phpswitch 8.3          # Instant
```

### Quick Comparison

| Feature | phpbrew | phpswitch |
|---------|---------|-----------|
| Installation time | 10-30 min/version | 30 seconds |
| Build from source | ✅ Yes | ❌ No (Homebrew) |
| Extension management | ✅ Full control | ⚠️ Via Homebrew/PECL |
| Switching speed | Fast | Instant |
| .php-version support | ✅ Yes | ✅ Yes |
| Custom builds | ✅ Yes | ❌ No |
| Complexity | High | Low |

**Use phpswitch if:** You use Homebrew and want simple, instant version switching.
**Use phpbrew if:** You need custom PHP builds with specific compile-time options.

## Prerequisites

- macOS (Intel or Apple Silicon)
- [Homebrew](https://brew.sh)

## Quick Start

### 1. Install phpswitch

**Option A: Via Homebrew (Recommended)**

```bash
# Add the tap
brew tap madusha98/phpswitch

# Install
brew install phpswitch
```

**Option B: Via Install Script**

```bash
# Clone the repository
git clone https://github.com/madusha98/phpswitch.git
cd phpswitch

# Run the installer
./install.sh
```

### 3. Activate

Add to your shell configuration:

**For Zsh** (`~/.zshrc`):
```bash
# If installed via Homebrew
source $(brew --prefix phpswitch)/phpswitch.sh

# If installed via install script
source ~/.phpswitch/phpswitch.sh
```

**For Bash** (`~/.bashrc` or `~/.bash_profile`):
```bash
# If installed via Homebrew
source $(brew --prefix phpswitch)/phpswitch.sh

# If installed via install script
source ~/.phpswitch/phpswitch.sh
```

Then reload:
```bash
source ~/.zshrc    # for Zsh
# or
source ~/.bashrc   # for Bash

# Or simply restart your terminal
```

### 4. Install and use PHP versions

```bash
# Install a PHP version
phpswitch install 8.3

# Or switch if already installed
phpswitch 8.3

# Verify
php -v
# PHP 8.3.x (cli) ✓
```

## Usage

### Quick Reference

```bash
phpswitch 8.3              # Switch to PHP 8.3
phpswitch install 8.2      # Install PHP 8.2
phpswitch uninstall 7.4    # Uninstall PHP 7.4
phpswitch list             # List installed versions
phpswitch available        # Show available versions
phpswitch current          # Show current version info
```

### Installing PHP Versions

Install PHP versions directly through phpswitch:

```bash
# See what's available
phpswitch available
# Available PHP versions from Homebrew:
#   php@7.4
#   php@8.1
#   php@8.2
#   php@8.3

# Install a version
phpswitch install 8.3
# Installing PHP 8.3 via Homebrew...
# ✓ PHP 8.3 installed successfully!
# Switch to it now? (y/n)
```

### Switching Versions

Switch PHP version for your current terminal session:

```bash
# Switch to different versions
phpswitch 8.3
# ✓ Switched to PHP 8.3
# → PHP 8.3.0 (cli)

phpswitch 8.2
phpswitch 8.1
phpswitch 7.4
```

### Managing Versions

```bash
# List installed versions
phpswitch list
# Installed PHP versions:
#   ● 8.3 (current)
#   ○ 8.2
#   ○ 8.1

# Check current version details
phpswitch current
# Current PHP:
#   Version: 8.3.0
#   Binary: /opt/homebrew/opt/php@8.3/bin/php
#   Config: /opt/homebrew/etc/php/8.3/php.ini

# Uninstall a version
phpswitch uninstall 7.4
# This will uninstall PHP 7.4
# Are you sure? (y/n)
```

### Auto-Switching (Per Project)

Set a PHP version for a specific project:

```bash
# Navigate to your project
cd ~/projects/my-app

# Create .php-version file
echo "8.2" > .php-version

# Now whenever you cd into this directory, PHP auto-switches!
cd ..
cd my-app
# ✓ Switched to PHP 8.2
# → PHP 8.2.x (cli)
```

**Example project structure:**

```
my-app/
├── .php-version    # Contains: 8.2
├── composer.json
└── src/
```

### Workflow Example

```bash
# Modern project uses PHP 8.3
cd ~/projects/new-project
echo "8.3" > .php-version

# Legacy project uses PHP 7.4
cd ~/projects/legacy-app
echo "7.4" > .php-version

# Switching between projects auto-switches PHP!
cd ~/projects/new-project
php -v  # PHP 8.3.x ✓

cd ~/projects/legacy-app
php -v  # PHP 7.4.x ✓
```

## Installation Methods

### Method 1: Homebrew (Recommended)

```bash
# Add the tap
brew tap madusha98/phpswitch

# Install
brew install phpswitch

# Add to shell config
echo 'source $(brew --prefix phpswitch)/phpswitch.sh' >> ~/.zshrc

# Reload
source ~/.zshrc
```

**Benefits:**
- ✅ Easy to install and update
- ✅ Managed by Homebrew
- ✅ Easy to uninstall
- ✅ No manual file management

**Update:**
```bash
brew update
brew upgrade phpswitch
```

**Uninstall:**
```bash
brew uninstall phpswitch
brew untap madusha98/phpswitch
```

### Method 2: Install Script

```bash
git clone https://github.com/madusha98/phpswitch.git
cd phpswitch
./install.sh
source ~/.zshrc  # or ~/.bashrc
```

**What the installer does:**
- Copies `phpswitch.sh` to `~/.phpswitch/`
- Detects your shell (Zsh/Bash) automatically
- Adds `source ~/.phpswitch/phpswitch.sh` to your config
- Creates backup before modifying files

### Method 3: Manual

**Step 1:** Clone to install location
```bash
git clone https://github.com/madusha98/phpswitch.git ~/.phpswitch
```

**Step 2:** Add to shell configuration

For **Zsh** (add to `~/.zshrc`):
```bash
# phpswitch
source ~/.phpswitch/phpswitch.sh
```

For **Bash** (add to `~/.bashrc` or `~/.bash_profile`):
```bash
# phpswitch
source ~/.phpswitch/phpswitch.sh
```

**Step 3:** Reload shell
```bash
source ~/.zshrc    # for Zsh
source ~/.bashrc   # for Bash
```

## Managing PHP Versions

### Using phpswitch (Recommended)

```bash
# See what's available
phpswitch available

# Install a version
phpswitch install 8.3

# List installed versions
phpswitch list

# Uninstall a version
phpswitch uninstall 7.4
```

### Using Homebrew Directly (Alternative)

You can still use Homebrew commands if you prefer:

```bash
# Install
brew install php@8.3

# Uninstall
brew uninstall php@7.4

# List all PHP packages
brew list | grep php

# Upgrade
brew upgrade php@8.3
```

## How It Works

### PATH Manipulation

When you run `phpswitch 8.3`:

1. **Removes** old PHP paths from `$PATH`
2. **Adds** new PHP version path at the beginning
3. **Updates** environment in current shell

```bash
# Before
/usr/local/bin:/opt/homebrew/bin:/usr/bin

# After phpswitch 8.3
/opt/homebrew/opt/php@8.3/bin:/opt/homebrew/opt/php@8.3/sbin:/usr/local/bin:/usr/bin
```

### Auto-Detection

When you `cd` into a directory:

1. Checks for `.php-version` file in current directory
2. If not found, checks parent directories (up to root)
3. If found, automatically runs `phpswitch <version>`
4. Caches last switch to avoid redundant operations

### Shell Integration

- **Zsh**: Uses `chpwd` hook (native Zsh feature)
- **Bash**: Wraps `cd` command with custom function

## Troubleshooting

### "PHP version not found"

```bash
$ phpswitch 8.3
Error: PHP 8.3 not found at /opt/homebrew/opt/php@8.3
Install with: brew install php@8.3
```

**Solution:** Install the PHP version with Homebrew:
```bash
brew install php@8.3
```

### "Homebrew not found"

**Solution:** Install Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Command not found: phpswitch

**Solution:** Make sure you've sourced the script:
```bash
source ~/.zshrc    # or ~/.bashrc
```

Or check if the line is in your config:
```bash
grep phpswitch ~/.zshrc
```

### Auto-switch not working

**Solution:** Make sure the shell hook is active:
```bash
# Check if function exists
type _php_auto_switch

# Re-source the config
source ~/.zshrc
```

## Uninstallation

### Automated

```bash
cd ~/.phpswitch
./uninstall.sh
```

The uninstaller will:
- Remove source lines from shell configs
- Create backups (`.backup` files)
- Optionally delete `~/.phpswitch/` directory
- Show what was removed

### Manual

1. Remove from shell config:

```bash
# Edit ~/.zshrc or ~/.bashrc and remove these lines:
# phpswitch
source ~/.phpswitch/phpswitch.sh
```

2. Delete installation:

```bash
rm -rf ~/.phpswitch
```

3. Restart terminal

## Advanced Usage

### Checking Current Setup

```bash
# Show current PHP
which php
php -v

# Show PATH
echo $PATH | tr ':' '\n' | grep php

# Find all PHP installations
brew list | grep php
```

### Multiple Projects Example

```bash
# Setup
cd ~/projects/api-v2 && echo "8.3" > .php-version
cd ~/projects/api-v1 && echo "8.1" > .php-version
cd ~/projects/legacy && echo "7.4" > .php-version

# Use
cd ~/projects/api-v2   # Auto: PHP 8.3
cd ~/projects/api-v1   # Auto: PHP 8.1
cd ~/projects/legacy   # Auto: PHP 7.4
```

### Team Collaboration

Commit `.php-version` to your repository:

```bash
# In your project
echo "8.2" > .php-version
git add .php-version
git commit -m "Add PHP version requirement"
git push
```

Now all team members with phpswitch will automatically use the correct version!

## Project Structure

```
phpswitch/
├── phpswitch.sh    # Main script (source this)
├── install.sh         # Automated installer
├── uninstall.sh       # Automated uninstaller
├── .php-version       # Example version file
└── README.md          # This file
```

## Requirements

- **OS**: macOS (tested on 12.0+)
- **Shell**: Zsh or Bash
- **Package Manager**: Homebrew
- **PHP**: Install via `brew install php@X.X`

## Credits

Inspired by:
- [rbenv](https://github.com/rbenv/rbenv) - Ruby version management
- [nvm](https://github.com/nvm-sh/nvm) - Node version management
- [phpbrew](https://github.com/phpbrew/phpbrew) - PHP environment manager

## License

MIT License - feel free to use and modify!

## Contributing

Issues and pull requests welcome! Keep it simple.

---

**Made with ❤️ for PHP developers who juggle multiple projects**
