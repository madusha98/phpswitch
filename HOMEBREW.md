# Homebrew Tap Setup

This guide explains how to set up the phpswitch Homebrew tap.

## For Repository Owners

### 1. Create the Tap Repository

```bash
# Create a new repository on GitHub named: homebrew-phpswitch
# The name MUST start with "homebrew-"
```

### 2. Push Formula

```bash
# Clone your tap repository
git clone https://github.com/yourusername/homebrew-phpswitch.git
cd homebrew-phpswitch

# Copy the Formula
cp /path/to/phpswitch/Formula/phpswitch.rb Formula/

# Create a release tarball from your main repo
cd /path/to/phpswitch
git tag v1.0.0
git push origin v1.0.0

# Generate SHA256 for the tarball
curl -L https://github.com/yourusername/phpswitch/archive/v1.0.0.tar.gz | shasum -a 256

# Update Formula/phpswitch.rb with:
# - Correct GitHub URL
# - Correct SHA256 hash
# - Correct version

# Commit and push
git add Formula/phpswitch.rb
git commit -m "Add phpswitch formula"
git push
```

### 3. Update Formula URLs

Edit `Formula/phpswitch.rb`:

```ruby
homepage "https://github.com/YOURUSERNAME/phpswitch"
url "https://github.com/YOURUSERNAME/phpswitch/archive/v1.0.0.tar.gz"
sha256 "ACTUAL_SHA256_HASH_HERE"
```

## For Users

### Install via Tap

```bash
# Add the tap
brew tap yourusername/phpswitch

# Install
brew install phpswitch

# Follow the post-install instructions
```

### Install via Formula URL (Alternative)

```bash
# Install directly from formula URL
brew install https://raw.githubusercontent.com/yourusername/homebrew-phpswitch/main/Formula/phpswitch.rb
```

## Post-Installation

After installing, add this to your shell config:

**Zsh** (`~/.zshrc`):
```bash
source $(brew --prefix phpswitch)/phpswitch.sh
```

**Bash** (`~/.bashrc`):
```bash
source $(brew --prefix phpswitch)/phpswitch.sh
```

Then reload:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

## Updating the Formula

### For New Releases

```bash
# In phpswitch repo
git tag v1.0.1
git push origin v1.0.1

# Generate new SHA256
curl -L https://github.com/yourusername/phpswitch/archive/v1.0.1.tar.gz | shasum -a 256

# Update Formula in tap repo
cd homebrew-phpswitch
# Edit Formula/phpswitch.rb with new version and SHA256
git commit -am "Update to v1.0.1"
git push
```

### Testing the Formula

```bash
# Audit the formula
brew audit --strict Formula/phpswitch.rb

# Test installation
brew install --build-from-source Formula/phpswitch.rb

# Test uninstall
brew uninstall phpswitch
```

## Tap Structure

```
homebrew-phpswitch/
├── Formula/
│   └── phpswitch.rb
└── README.md
```

## Notes

- Tap name MUST start with `homebrew-`
- Users tap with: `brew tap username/phpswitch` (without the `homebrew-` prefix)
- Formula name becomes the package name: `brew install phpswitch`
