#!/bin/bash
# =============================================================================
# bootstrap.sh — Mac setup script
# Run this on a fresh Mac:
# bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/bootstrap.sh)
# =============================================================================

set -e

DOTFILES_REPO="https://github.com/berendvangaart/dotfiles"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()   { echo -e "${GREEN}▶ $1${NC}"; }
warn()  { echo -e "${YELLOW}⚠ $1${NC}"; }
error() { echo -e "${RED}✗ $1${NC}"; exit 1; }

# -------------------------------------------------------
# 1. Xcode Command Line Tools
# -------------------------------------------------------
log "Checking Xcode CLI tools..."
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
  log "Xcode CLI tools installed."
else
  log "Xcode CLI tools already installed."
fi

# -------------------------------------------------------
# 2. Homebrew
# -------------------------------------------------------
log "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for Apple Silicon
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  log "Homebrew already installed."
fi

brew update

# -------------------------------------------------------
# 3. Install chezmoi and apply dotfiles
# -------------------------------------------------------
log "Installing chezmoi..."
brew install chezmoi

log "Applying dotfiles from $DOTFILES_REPO..."
chezmoi init --apply "$DOTFILES_REPO"

# -------------------------------------------------------
# 4. Install packages from Brewfile
# -------------------------------------------------------
BREWFILE="$HOME/.local/share/chezmoi/Brewfile"
if [[ -f "$BREWFILE" ]]; then
  log "Installing packages from Brewfile..."
  brew bundle install --file="$BREWFILE"
else
  warn "Brewfile not found at $BREWFILE, skipping."
fi

# -------------------------------------------------------
# 5. Oh My Zsh
# -------------------------------------------------------
log "Checking Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh already installed."
fi

# -------------------------------------------------------
# 6. macOS system preferences
# -------------------------------------------------------
log "Applying macOS defaults..."
bash "$HOME/.local/share/chezmoi/scripts/macos.sh"

# -------------------------------------------------------
# 7. Set default shell to zsh
# -------------------------------------------------------
log "Setting default shell to zsh..."
if [[ "$SHELL" != "$(which zsh)" ]]; then
  chsh -s "$(which zsh)"
fi

# -------------------------------------------------------
# Done
# -------------------------------------------------------
echo ""
echo -e "${GREEN}✓ Setup complete! Please restart your terminal.${NC}"
echo ""
echo "Next steps:"
echo "  1. Open iTerm2 and configure your profile"
echo "  2. Sign into NordVPN"
echo "  3. Sign into Chrome and sync your profile"
echo "  4. Open IntelliJ and restore settings sync"
echo "  5. Sign into Notion"