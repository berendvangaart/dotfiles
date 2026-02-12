# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Mac dotfiles repository managed with [chezmoi](https://www.chezmoi.io/). It automates the setup of a fresh Mac with system preferences, Homebrew packages, and shell configuration.

## Key Commands

### Fresh Mac Setup
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/berendvangaart/dotfiles/main/bootstrap.sh)
```

### Day-to-day chezmoi usage
```bash
chezmoi edit ~/.zshrc      # Edit a dotfile
chezmoi diff               # Preview changes
chezmoi apply              # Apply changes
chezmoi update             # Pull latest and apply
chezmoi add ~/.newfile     # Add a new file to management
```

### Homebrew
```bash
brew bundle install --file=Brewfile   # Install all packages
brew bundle dump --force              # Update Brewfile from current machine
```

## File Naming Convention

Chezmoi uses `dot_` prefix for dotfiles:
- `dot_zshrc` → `~/.zshrc`
- `dot_gitconfig` → `~/.gitconfig`

## Architecture

- **bootstrap.sh**: One-command setup script that installs Xcode CLI tools, Homebrew, chezmoi, packages, Oh My Zsh, and applies macOS defaults
- **Brewfile**: Homebrew packages and casks (CLI tools, apps, fonts)
- **macos.sh**: macOS system defaults (Finder, Dock, keyboard settings)
- **dot_zshrc**: Shell configuration with Oh My Zsh, aliases, and fnm (Node version manager)
- **dot_gitconfig**: Git configuration with VS Code as diff/merge tool

## Machine-Specific Configuration

Use `~/.zshrc.local` for machine-specific settings (not tracked in git). This file is sourced at the end of `.zshrc`.
