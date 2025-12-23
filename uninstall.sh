#!/usr/bin/env bash
# phpswitch - Uninstallation Script

set -e

INSTALL_DIR="$HOME/.phpswitch"

echo "╔══════════════════════════════════╗"
echo "║     phpswitch Uninstallation     ║"
echo "╚══════════════════════════════════╝"
echo ""

# Function to remove from config
remove_from_config() {
    local config_file="$1"

    if [[ -f "$config_file" ]]; then
        if grep -q "phpswitch.sh" "$config_file" 2>/dev/null; then
            # Create backup
            cp "$config_file" "$config_file.backup"

            # Remove the source line and comment
            sed -i.tmp '/# phpswitch/d' "$config_file"
            sed -i.tmp '/phpswitch\.sh/d' "$config_file"
            rm -f "$config_file.tmp"

            echo "✓ Removed from $config_file"
            echo "  Backup saved: $config_file.backup"
            return 0
        fi
    fi
    return 1
}

# Remove from shell configs
echo "→ Checking shell configurations..."
REMOVED=false

for config in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile"; do
    if remove_from_config "$config"; then
        REMOVED=true
    fi
done

if [[ "$REMOVED" == false ]]; then
    echo "⚠ No installation found in shell configs"
fi

echo ""
echo "→ Checking installation directory..."

# Remove installation directory
if [[ -d "$INSTALL_DIR" ]]; then
    read -p "Remove $INSTALL_DIR? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_DIR"
        echo "✓ Removed $INSTALL_DIR"
    else
        echo "⚠ Keeping $INSTALL_DIR"
    fi
else
    echo "⚠ Installation directory not found"
fi

echo ""
echo "╔══════════════════════════════════╗"
echo "║   Uninstallation Complete!       ║"
echo "╚══════════════════════════════════╝"
echo ""
echo "Restart your terminal for changes to take effect."
echo ""
