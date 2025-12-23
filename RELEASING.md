# Release Guide

How to publish a new version of phpswitch.

## Prerequisites

1. GitHub repository: `yourusername/phpswitch`
2. Homebrew tap repository: `yourusername/homebrew-phpswitch`

## Creating a New Release

### 1. Update Version

No version file needed - version is in the Homebrew formula.

### 2. Create Git Tag

```bash
# In the main phpswitch repository
git tag v1.0.0
git push origin v1.0.0
```

### 3. Generate SHA256 Hash

```bash
# Get the archive SHA256
curl -L https://github.com/yourusername/phpswitch/archive/v1.0.0.tar.gz | shasum -a 256

# Copy the output hash
```

### 4. Update Homebrew Formula

```bash
# Clone or navigate to your tap repository
cd ~/homebrew-phpswitch

# Edit Formula/phpswitch.rb
# Update these fields:
# - version "1.0.0"
# - url "https://github.com/yourusername/phpswitch/archive/v1.0.0.tar.gz"
# - sha256 "THE_SHA256_HASH_FROM_STEP_3"

git add Formula/phpswitch.rb
git commit -m "Release v1.0.0"
git push
```

### 5. Test the Installation

```bash
# Uninstall if already installed
brew uninstall phpswitch 2>/dev/null || true

# Update tap
brew update

# Install
brew install yourusername/phpswitch/phpswitch

# Test
source $(brew --prefix phpswitch)/phpswitch.sh
phpswitch --help
```

## Setting Up Homebrew Tap (First Time)

### 1. Create Tap Repository

On GitHub, create a new repository:
- Name: `homebrew-phpswitch` (MUST start with `homebrew-`)
- Description: "Homebrew tap for phpswitch"
- Public repository

### 2. Clone and Setup

```bash
# Clone the tap repository
git clone https://github.com/yourusername/homebrew-phpswitch.git
cd homebrew-phpswitch

# Create Formula directory
mkdir -p Formula

# Copy the formula from phpswitch repo
cp /path/to/phpswitch/Formula/phpswitch.rb Formula/

# Update URLs in the formula to point to your repository
# Edit Formula/phpswitch.rb

# Commit and push
git add Formula/phpswitch.rb
git commit -m "Initial formula"
git push
```

### 3. Update Formula URLs

Edit `Formula/phpswitch.rb`:

```ruby
class PhpSwitcher < Formula
  desc "Simple PHP version switcher for macOS"
  homepage "https://github.com/YOURUSERNAME/phpswitch"
  url "https://github.com/YOURUSERNAME/phpswitch/archive/v1.0.0.tar.gz"
  sha256 "ACTUAL_SHA256_HASH"
  version "1.0.0"
  # ... rest of formula
end
```

### 4. Test the Tap

```bash
# Add your tap
brew tap yourusername/phpswitch

# Install from tap
brew install phpswitch

# Verify
brew info phpswitch
```

## Formula Checklist

Before releasing, verify:

- [ ] Version number is correct
- [ ] URL points to correct tag
- [ ] SHA256 hash matches the archive
- [ ] Homepage URL is correct
- [ ] License is specified
- [ ] Caveats message is helpful
- [ ] Formula passes audit: `brew audit --strict Formula/phpswitch.rb`

## Publishing Checklist

- [ ] Main repo has new tag pushed
- [ ] Tap formula is updated with correct version and SHA256
- [ ] Installation tested locally
- [ ] Uninstall tested
- [ ] README updated with new version
- [ ] CHANGELOG updated

## Version Numbering

Follow semantic versioning:
- `1.0.0` - Initial release
- `1.0.1` - Bug fixes
- `1.1.0` - New features (backward compatible)
- `2.0.0` - Breaking changes

## Common Issues

### SHA256 Mismatch

```bash
# Regenerate the hash
curl -L https://github.com/yourusername/phpswitch/archive/v1.0.0.tar.gz | shasum -a 256

# Update Formula/phpswitch.rb with new hash
```

### Formula Not Found

```bash
# Update tap
brew update
brew tap --repair

# Or remove and re-add
brew untap yourusername/phpswitch
brew tap yourusername/phpswitch
```

### Testing During Development

```bash
# Install from local formula
brew install --build-from-source Formula/phpswitch.rb

# Test changes
brew reinstall --build-from-source Formula/phpswitch.rb
```
