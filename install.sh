#!/bin/bash
# Install/update dotfiles. This script is incremental — safe to re-run at any time.

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: ./install.sh"
  echo ""
  echo "Install/update dotfiles. This script is incremental — safe to re-run at any time."
  echo "It will stow config files, update submodules, and configure Claude Code hooks."
  exit 0
fi

git submodule update --init --recursive
git submodule update --remote --merge
git submodule foreach --recursive git checkout master

chmod u+x binaries/.local/bin/*
stow -R binaries gdb nvim tmux zsh colordiff task
SOURCE_STR="source $HOME/.zsh_global.sh"
ZSH_FILE="$HOME/.zshrc"
grep -q "$SOURCE_STR" "$ZSH_FILE" || echo "$SOURCE_STR" >> "$ZSH_FILE"
SOURCE_STR="export PATH=\"\$PATH:\${HOME}/.local/bin\""
grep -q "$SOURCE_STR" "$ZSH_FILE" || echo "$SOURCE_STR" >> "$ZSH_FILE"

# Claude Code: add notify-send hook if not already present
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if command -v jq &>/dev/null && [ -f "$CLAUDE_SETTINGS" ]; then
  if ! jq -e '.hooks.Notification' "$CLAUDE_SETTINGS" &>/dev/null; then
    jq '.hooks.Notification = [{"matcher": "", "hooks": [{"type": "command", "command": "notify-send '\''Claude Code'\'' '\''Claude Code needs your attention'\''"}]}]' \
      "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp" && mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"
  fi
fi
