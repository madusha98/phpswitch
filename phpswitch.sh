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

# Switch to a specific PHP version
phpswitch() {
    local version="$1"

    if [[ -z "$version" ]]; then
        echo "Usage: phpswitch <version>"
        echo "Example: phpswitch 8.3"
        return 1
    fi

    local php_path="$HOMEBREW_PREFIX/opt/php@$version"

    if [[ ! -d "$php_path" ]]; then
        echo "Error: PHP $version not found at $php_path"
        echo "Install with: brew install php@$version"
        return 1
    fi

    # Remove old PHP paths
    export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v '/php@' | grep -v '/opt/php' | tr '\n' ':' | sed 's/:$//')

    # Add new PHP version to PATH
    export PATH="$php_path/bin:$php_path/sbin:$PATH"

    echo "✓ Switched to PHP $version"
    echo "→ $(php -v | head -n 1)"
}

# Auto-switch based on .php-version file
_php_auto_switch() {
    if [[ -f ".php-version" ]]; then
        local version=$(cat .php-version | tr -d '[:space:]')
        if [[ -n "$version" ]]; then
            phpswitch "$version"
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
