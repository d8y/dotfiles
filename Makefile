.PHONY: all install brew dotfiles mise help brew-dump brew-update brew-clean git-config directories

all: directories brew dotfiles mise git-config

help:
	@echo "Available targets:"
	@echo "  make install     - Run full setup"
	@echo "  make brew        - Install Homebrew and packages"
	@echo "  make dotfiles    - Create symlinks for dotfiles"
	@echo "  make mise        - Install mise and configure tools"
	@echo "  make git-config  - Setup git configuration"
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