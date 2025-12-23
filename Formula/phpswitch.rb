# Homebrew Formula for phpswitch
class Phpswitch < Formula
  desc "Simple PHP version switcher for macOS"
  homepage "https://github.com/madusha98/phpswitch"
  url "https://github.com/madusha98/phpswitch/archive/v1.0.0.tar.gz"
  sha256 "7b38c4ae043ae5f53d6ca6544f62c8c17166f380541de4f7645cbe91c88a99e0"
  license "MIT"
  version "1.0.0"

  def install
    # Install the main script
    prefix.install "phpswitch.sh"
  end

  def caveats
    <<~EOS
      To activate phpswitch, add this to your shell configuration:

      For Zsh (~/.zshrc):
        source #{prefix}/phpswitch.sh

      For Bash (~/.bashrc or ~/.bash_profile):
        source #{prefix}/phpswitch.sh

      Then reload your shell:
        source ~/.zshrc  # or source ~/.bashrc

      Quick start:
        phpswitch 8.3              # Switch to PHP 8.3
        echo "8.2" > .php-version  # Auto-switch per project
    EOS
  end

  test do
    # Test that the file exists and is readable
    assert_predicate prefix/"phpswitch.sh", :exist?
    assert_predicate prefix/"phpswitch.sh", :readable?
  end
end
