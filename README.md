# dotfiles

My personal Mac setup, managed with [chezmoi](https://www.chezmoi.io/).

## Fresh Mac setup

Run this single command on a new machine:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/berendvangaart/dotfiles/main/bootstrap.sh)
```

This will:
1. Install Xcode CLI tools
2. Install Homebrew
3. Install chezmoi and apply dotfiles
4. Install all packages from `Brewfile`
5. Install Oh My Zsh
6. Apply macOS system defaults

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

### Generate a new key on a fresh machine

```bash
ssh-keygen -t ed25519 -C "berendvangaart@gmail.com"
```

Press Enter to accept the default path (`~/.ssh/id_ed25519`) and set a passphrase.

### Add the key to your Apple Keychain

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

### Add the public key to GitHub

```bash
gh auth login                    # If not already logged in
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)"
```

Or manually: copy the output of `cat ~/.ssh/id_ed25519.pub` and add it at [github.com/settings/keys](https://github.com/settings/keys).

### Verify

```bash
ssh -T git@github.com
# Hi berendvangaart! You've successfully authenticated...
```

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