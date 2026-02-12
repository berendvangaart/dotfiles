#!/bin/bash
# =============================================================================
# ssh-setup.sh — Generate an SSH key and add it to GitHub in one go
# Usage: bash scripts/ssh-setup.sh
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}▶ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }

KEY_PATH="$HOME/.ssh/id_ed25519"
EMAIL="berendvangaart@gmail.com"

# -------------------------------------------------------
# 1. Generate SSH key (skip if already exists)
# -------------------------------------------------------
if [[ -f "$KEY_PATH" ]]; then
  warn "SSH key already exists at $KEY_PATH, skipping generation."
else
  log "Generating SSH key..."
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH"
fi

# -------------------------------------------------------
# 2. Add key to Apple Keychain
# -------------------------------------------------------
log "Adding key to Apple Keychain..."
ssh-add --apple-use-keychain "$KEY_PATH"

# -------------------------------------------------------
# 3. Log into GitHub CLI (skip if already authenticated)
# -------------------------------------------------------
if gh auth status &>/dev/null; then
  log "Already logged into GitHub CLI."
else
  log "Logging into GitHub CLI..."
  gh auth login -p ssh -w
fi

# -------------------------------------------------------
# 4. Add public key to GitHub
# -------------------------------------------------------
KEY_TITLE="$(hostname)"
log "Adding SSH key to GitHub as \"$KEY_TITLE\"..."
gh ssh-key add "${KEY_PATH}.pub" --title "$KEY_TITLE"

# -------------------------------------------------------
# 5. Verify
# -------------------------------------------------------
log "Verifying connection..."
ssh -T git@github.com 2>&1 || true

echo ""
echo -e "${GREEN}✓ SSH setup complete!${NC}"
