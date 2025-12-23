#!/usr/bin/env bash
# phpswitch - Installation Script

set -e

INSTALL_DIR="$HOME/.phpswitch"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔══════════════════════════════════╗"
echo "║     phpswitch Installation       ║"
echo "╚══════════════════════════════════╝"
echo ""

# Create install directory if it doesn't exist
if [[ "$SCRIPT_DIR" != "$INSTALL_DIR" ]]; then
    echo "→ Copying to $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
    cp "$SCRIPT_DIR/phpswitch.sh" "$INSTALL_DIR/phpswitch.sh"
    echo "✓ Files copied"
else
    echo "→ Already in install location"
fi

# Detect shell
SHELL_NAME=$(basename "$SHELL")
echo ""
echo "→ Detected shell: $SHELL_NAME"
echo ""

# Function to add source line to config
add_to_config() {
    local config_file="$1"
    local source_line="source $INSTALL_DIR/phpswitch.sh"

    if [[ -f "$config_file" ]]; then
        # Check if already installed
        if grep -q "phpswitch.sh" "$config_file" 2>/dev/null; then
            echo "⚠ Already installed in $config_file"
            return 0
        fi

        # Add source line
        echo "" >> "$config_file"
        echo "# phpswitch" >> "$config_file"
        echo "$source_line" >> "$config_file"
        echo "✓ Added to $config_file"
        return 0
    fi
    return 1
}

# Install for detected shell
INSTALLED=false

if [[ "$SHELL_NAME" == "zsh" ]]; then
    if add_to_config "$HOME/.zshrc"; then
        INSTALLED=true
        RELOAD_CMD="source ~/.zshrc"
    fi
elif [[ "$SHELL_NAME" == "bash" ]]; then
    if add_to_config "$HOME/.bashrc"; then
        INSTALLED=true
        RELOAD_CMD="source ~/.bashrc"
    elif add_to_config "$HOME/.bash_profile"; then
        INSTALLED=true
        RELOAD_CMD="source ~/.bash_profile"
    fi
fi

echo ""
echo "╔══════════════════════════════════╗"
echo "║   Installation Complete!         ║"
echo "╚══════════════════════════════════╝"
echo ""

if [[ "$INSTALLED" == true ]]; then
    echo "To activate, run:"
    echo "  $RELOAD_CMD"
else
    echo "Add this line to your shell config:"
    echo "  source $INSTALL_DIR/phpswitch.sh"
fi

echo ""
echo "Quick Start:"
echo "  phpswitch 8.3              # Switch to PHP 8.3"
echo "  echo '8.2' > .php-version  # Set version for project"
echo ""
