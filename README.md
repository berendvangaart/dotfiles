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
- [ ] Set up SSH keys (`ssh-keygen` and add to GitHub)

## Adding a new dotfile

```bash
# Tell chezmoi to manage a file
chezmoi add ~/.your-new-config

# Edit it
chezmoi edit ~/.your-new-config

# Commit
cd ~/.local/share/chezmoi && git add . && git commit -m "Add your-new-config"
```

## Machine-specific config

For settings that differ per machine (work vs personal), create a local override file that is **not** tracked in this repo:

```bash
# ~/.zshrc.local — sourced at end of .zshrc, gitignored
export WORK_API_KEY="..."
export JAVA_HOME="..."
```