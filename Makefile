.PHONY: all install brew dotfiles mise help brew-dump brew-update brew-clean macos git-config ssh-key directories

all: directories brew dotfiles mise macos git-config

help:
	@echo "Available targets:"
	@echo "  make install     - Run full setup"
	@echo "  make brew        - Install Homebrew and packages"
	@echo "  make dotfiles    - Create symlinks for dotfiles"
	@echo "  make mise        - Install mise and configure tools"
	@echo "  make macos       - Configure macOS system preferences"
	@echo "  make git-config  - Setup git configuration"
	@echo "  make ssh-key     - Generate SSH key"
	@echo "  make directories - Create development directories"
	@echo "  make brew-dump   - Save current brew packages to Brewfile"
	@echo "  make brew-update - Update all brew packages"
	@echo "  make brew-clean  - Clean up old versions"

install: all

brew:
	@echo "Installing Homebrew..."
	@if ! command -v brew >/dev/null 2>&1; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "Installing packages from Brewfile..."
	@if [ -f Brewfile ]; then \
		brew bundle; \
	fi

dotfiles:
	@echo "Setting up dotfiles..."
	@sh bin/install.sh

mise:
	@echo "Setting up mise..."
	@if ! command -v mise >/dev/null 2>&1; then \
		brew install mise; \
	fi
	@echo "Installing global tools via mise..."
	@mise use --global node@lts
	@mise use --global python@latest

brew-dump:
	@echo "Saving current brew packages to Brewfile..."
	@brew bundle dump --force --describe
	@echo "Brewfile updated successfully"

brew-update:
	@echo "Updating Homebrew..."
	@brew update
	@echo "Upgrading packages..."
	@brew upgrade
	@echo "Upgrading casks..."
	@brew upgrade --cask
	@echo "Cleaning up old versions..."
	@brew cleanup

brew-clean:
	@echo "Cleaning up Homebrew..."
	@brew cleanup --prune=all
	@echo "Removing cache..."
	@brew cleanup -s
	@echo "Cleanup complete"

directories:
	@echo "Creating development directories..."
	@# Create case-sensitive APFS volume for Git repositories
	@if [ ! -d /Volumes/Git ]; then \
		echo "Creating case-sensitive APFS volume for Git..."; \
		diskutil apfs addVolume disk1 "Case-sensitive APFS" Git; \
		echo "Waiting for Git volume to mount..."; \
		sleep 2; \
	else \
		echo "/Volumes/Git already exists"; \
	fi
	@mkdir -p ~/.config

macos:
	@echo "Configuring macOS settings..."
	@# Finder: show all filename extensions
	@defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	@# Finder: show hidden files
	@defaults write com.apple.finder AppleShowAllFiles -bool true
	@# Finder: show path bar
	@defaults write com.apple.finder ShowPathbar -bool true
	@# Dock: automatically hide and show
	@defaults write com.apple.dock autohide -bool true
	@# Enable tap to click
	@defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	@# Save screenshots to Downloads
	@defaults write com.apple.screencapture location -string "$${HOME}/Downloads"
	@# Disable press-and-hold for keys in favor of key repeat
	@defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@# Set a fast key repeat rate
	@defaults write NSGlobalDomain KeyRepeat -int 2
	@defaults write NSGlobalDomain InitialKeyRepeat -int 15
	@echo "macOS settings configured. Restart may be required."

git-config:
	@echo "Configuring git..."
	@read -p "Enter your git user name: " name; \
		git config --global user.name "$$name"
	@read -p "Enter your git email: " email; \
		git config --global user.email "$$email"
	@git config --global init.defaultBranch main
	@git config --global pull.rebase false
	@git config --global core.editor "vim"
	@git config --global core.ignorecase false
	@git config --global ghq.root /Volumes/Git
	@echo "Git configured"

ssh-key:
	@echo "Generating SSH key..."
	@if [ ! -f ~/.ssh/id_ed25519 ]; then \
		read -p "Enter your email for SSH key: " email; \
		ssh-keygen -t ed25519 -C "$$email" -f ~/.ssh/id_ed25519; \
		echo "SSH key generated at ~/.ssh/id_ed25519"; \
		echo "Public key:"; \
		cat ~/.ssh/id_ed25519.pub; \
	else \
		echo "SSH key already exists at ~/.ssh/id_ed25519"; \
	fi