#!/usr/bin/env bash
# phpswitch - Simple PHP version management for Homebrew
# Source this file in your .zshrc or .bashrc

# Detect Homebrew prefix
if [[ -d "/opt/homebrew" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d "/usr/local" ]]; then
    HOMEBREW_PREFIX="/usr/local"
else
    echo "Error: Homebrew not found"
    return 1
fi

# Main phpswitch command
phpswitch() {
    local cmd="${1:-help}"

    case "$cmd" in
        use|switch)
            _phpswitch_use "$2"
            ;;
        install)
            _phpswitch_install "$2"
            ;;
        uninstall|remove)
            _phpswitch_uninstall "$2"
            ;;
        list|ls)
            _phpswitch_list
            ;;
        available)
            _phpswitch_available
            ;;
        current)
            _phpswitch_current
            ;;
        help|--help|-h)
            _phpswitch_help
            ;;
        *)
            # Default: treat as version to switch to
            _phpswitch_use "$1"
            ;;
    esac
}

# Switch to a specific PHP version
_phpswitch_use() {
    local version="$1"

    if [[ -z "$version" ]]; then
        echo "Usage: phpswitch <version>"
        echo "Example: phpswitch 8.3"
        return 1
    fi

    local php_path="$HOMEBREW_PREFIX/opt/php@$version"

    if [[ ! -d "$php_path" ]]; then
        echo "✗ PHP $version not installed"
        echo ""
        echo "Install it with:"
        echo "  phpswitch install $version"
        return 1
    fi

    # Remove old PHP paths
    export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v '/php@' | grep -v '/opt/php' | tr '\n' ':' | sed 's/:$//')

    # Add new PHP version to PATH
    export PATH="$php_path/bin:$php_path/sbin:$PATH"

    echo "✓ Switched to PHP $version"
    echo "→ $(php -v | head -n 1)"
}

# Install a PHP version
_phpswitch_install() {
    local version="$1"

    if [[ -z "$version" ]]; then
        echo "Usage: phpswitch install <version>"
        echo "Example: phpswitch install 8.3"
        return 1
    fi

    # Check if already installed
    if [[ -d "$HOMEBREW_PREFIX/opt/php@$version" ]]; then
        echo "✓ PHP $version is already installed"
        echo ""
        printf "Switch to it now? (y/n) "
        read -r REPLY
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            _phpswitch_use "$version"
        fi
        return 0
    fi

    echo "Installing PHP $version via Homebrew..."
    echo ""

    if brew install "php@$version"; then
        echo ""
        echo "✓ PHP $version installed successfully!"
        echo ""
        printf "Switch to it now? (y/n) "
        read -r REPLY
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            _phpswitch_use "$version"
        fi
    else
        echo ""
        echo "✗ Installation failed"
        return 1
    fi
}

# Uninstall a PHP version
_phpswitch_uninstall() {
    local version="$1"

    if [[ -z "$version" ]]; then
        echo "Usage: phpswitch uninstall <version>"
        echo "Example: phpswitch uninstall 8.2"
        return 1
    fi

    # Check if installed
    if [[ ! -d "$HOMEBREW_PREFIX/opt/php@$version" ]]; then
        echo "✗ PHP $version is not installed"
        return 1
    fi

    # Check if it's the current version
    local current_version=""
    if command -v php &> /dev/null; then
        current_version=$(php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;" 2>/dev/null)
    fi

    if [[ "$version" == "$current_version" ]]; then
        echo "⚠ PHP $version is currently active"
        echo ""
    fi

    # Confirm uninstall
    echo "This will uninstall PHP $version"
    printf "Are you sure? (y/n) "
    read -r REPLY

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled"
        return 0
    fi

    echo "Uninstalling PHP $version..."
    echo ""

    if brew uninstall "php@$version"; then
        echo ""
        echo "✓ PHP $version uninstalled successfully"
    else
        echo ""
        echo "✗ Uninstallation failed"
        return 1
    fi
}

# List installed PHP versions
_phpswitch_list() {
    local current_version=""

    # Try to get current version
    if command -v php &> /dev/null; then
        current_version=$(php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;" 2>/dev/null)
    fi

    echo "Installed PHP versions:"
    echo ""

    local found=false
    for dir in "$HOMEBREW_PREFIX/opt/php@"*; do
        if [[ -d "$dir" ]]; then
            local version=$(basename "$dir" | sed 's/php@//')
            if [[ "$version" == "$current_version" ]]; then
                echo "  ● $version (current)"
            else
                echo "  ○ $version"
            fi
            found=true
        fi
    done

    if [[ "$found" == false ]]; then
        echo "  No PHP versions installed via Homebrew"
        echo ""
        echo "Install one with:"
        echo "  phpswitch install 8.3"
    fi

    echo ""
    echo "To install more: phpswitch install <version>"
    echo "To see available: phpswitch available"
}

# Show available PHP versions from Homebrew
_phpswitch_available() {
    echo "Available PHP versions from Homebrew:"
    echo ""

    if command -v brew &> /dev/null; then
        brew search php@ | grep -E 'php@[0-9]' | sed 's/^/  /'
        echo ""
        echo "Install with: phpswitch install <version>"
    else
        echo "Homebrew not found"
        return 1
    fi
}

# Show current PHP version
_phpswitch_current() {
    if command -v php &> /dev/null; then
        echo "Current PHP:"
        echo "  Version: $(php -r "echo PHP_VERSION;")"
        echo "  Binary: $(which php)"
        echo "  Config: $(php --ini | grep "Loaded Configuration File" | cut -d: -f2 | xargs)"
    else
        echo "No PHP version active"
        echo ""
        echo "Switch to one with:"
        echo "  phpswitch 8.3"
    fi
}

# Show help
_phpswitch_help() {
    cat << 'EOF'
phpswitch - Simple PHP version management for Homebrew

USAGE:
    phpswitch <version>           Switch to PHP version
    phpswitch <command>

COMMANDS:
    install <version>   Install a PHP version
    uninstall <version> Uninstall a PHP version
    list                List installed versions
    available           Show available versions from Homebrew
    current             Show current PHP version info
    help                Show this help

EXAMPLES:
    phpswitch 8.3              # Switch to PHP 8.3
    phpswitch install 8.2      # Install PHP 8.2
    phpswitch uninstall 7.4    # Uninstall PHP 7.4
    phpswitch list             # List installed versions
    phpswitch available        # Show what's available

AUTO-SWITCHING:
    Create .php-version file in your project:
    echo "8.2" > .php-version

    Now phpswitch auto-switches when you cd into the directory!

EOF
}

# Auto-switch based on .php-version file
_php_auto_switch() {
    if [[ -f ".php-version" ]]; then
        local version=$(cat .php-version | tr -d '[:space:]')
        if [[ -n "$version" ]]; then
            _phpswitch_use "$version" 2>/dev/null
        fi
    fi
}

# Setup auto-switching on directory change
if [[ -n "$ZSH_VERSION" ]]; then
    # Zsh hook
    autoload -U add-zsh-hook
    add-zsh-hook chpwd _php_auto_switch
elif [[ -n "$BASH_VERSION" ]]; then
    # Bash hook
    _original_cd=$(declare -f cd)
    cd() {
        builtin cd "$@"
        _php_auto_switch
    }
fi

# Auto-switch on initial load
_php_auto_switch
