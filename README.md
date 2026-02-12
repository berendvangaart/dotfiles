# dotfiles

My personal Mac setup, managed with [chezmoi](https://www.chezmoi.io/).

## Quick start

### Option 1: One-liner (recommended for a fresh Mac)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/berendvangaart/dotfiles/main/bootstrap.sh)
```

This handles everything automatically: Xcode CLI tools, Homebrew, chezmoi, packages, Oh My Zsh, and macOS defaults.

### Option 2: Clone the repo manually

If you already have Git and Homebrew installed, or prefer to do things step by step:

```bash
# 1. Clone the repo
git clone https://github.com/berendvangaart/dotfiles.git
cd dotfiles

# 2. Install chezmoi if you don't have it
brew install chezmoi

# 3. Tell chezmoi to use this repo and apply all dotfiles
chezmoi init --apply --source .

# 4. Install Homebrew packages
brew bundle install --file=Brewfile

# 5. Install Oh My Zsh (if not installed)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 6. Apply macOS system defaults (optional)
bash macos.sh

# 7. Restart your terminal
```

> After `chezmoi init --apply`, all `dot_*` files are deployed to your home directory (e.g. `dot_zshrc` → `~/.zshrc`). The chezmoi source directory is set to `~/.local/share/chezmoi` — future edits should go through `chezmoi edit`.

## What's in here

```
dotfiles/
├── bootstrap.sh            # One-command setup for a fresh Mac
├── Brewfile                # All Homebrew packages and casks
├── dot_zshrc               # Zsh config (becomes ~/.zshrc)
├── dot_gitconfig           # Git config (becomes ~/.gitconfig)
├── dot_gitignore_global    # Global gitignore (becomes ~/.gitignore_global)
├── dot_zprofile            # Zsh profile (becomes ~/.zprofile)
├── scripts/
│   └── macos.sh            # macOS system defaults
└── dot_config/
    └── iterm2/             # iTerm2 profile (optional)
```

> **chezmoi naming**: files prefixed with `dot_` become dotfiles (e.g. `dot_zshrc` → `~/.zshrc`).

## Day-to-day usage

```bash
# Edit a dotfile
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Pull latest from this repo and apply
chezmoi update
```

## After setup — manual steps

These can't be automated (require GUI or account login):

- [ ] Open **iTerm2** → Preferences → Load profile from `~/.config/iterm2/`
- [ ] Sign into **NordVPN**
- [ ] Sign into **Chrome** and sync your profile
- [ ] Open **IntelliJ** → enable Settings Sync
- [ ] Sign into **Notion**
- [ ] Set up SSH keys (see below)

## Adding a new dotfile

```bash
# Tell chezmoi to manage a file
chezmoi add ~/.your-new-config

# Edit it
chezmoi edit ~/.your-new-config

# Commit
cd ~/.local/share/chezmoi && git add . && git commit -m "Add your-new-config"
```

## SSH keys

The SSH **config** is managed by chezmoi (`~/.ssh/config`), but private keys are **never** stored in this repo.

### One-command setup

```bash
bash scripts/ssh-setup.sh
```

This will:
1. Generate a new ed25519 SSH key (or skip if one exists)
2. Add it to your Apple Keychain
3. Log into the GitHub CLI (opens browser)
4. Upload the public key to GitHub with your hostname as title
5. Verify the connection

> **Tip:** The SSH config already includes `AddKeysToAgent` and `UseKeychain`, so you only need to enter your passphrase once after a reboot.

## Switching Java versions

Java 8, 11, and 21 are installed via Homebrew (Eclipse Temurin). Use the `jdk` helper to switch:

```bash
jdk 21    # Switch to Java 21 (default)
jdk 11    # Switch to Java 11
jdk 8     # Switch to Java 8
```

This sets `JAVA_HOME` for the current shell session. To change the default, edit the `JAVA_HOME` export in `.zshrc`.

## Machine-specific config

For settings that differ per machine (work vs personal), create a local override file that is **not** tracked in this repo:

```bash
# ~/.zshrc.local — sourced at end of .zshrc, gitignored
export WORK_API_KEY="..."
export JAVA_HOME="..."
```