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
stow binaries gdb nvim tmux zsh colordiff task agents
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

# Agent status hooks: drive the tmux status icons via agent-state.
# See tmux/.tmux.agents.conf. Additive and idempotent -- leaves any hooks you
# already have on these events alone.
#
# Deliberately not Notification: its permission_prompt path is gated behind a
# 6s user-idle check that never accumulates while the agent is thinking, so
# permission prompts raised mid-thought never fire it. PermissionRequest is
# the deterministic one.
if command -v jq &>/dev/null && [ -f "$CLAUDE_SETTINGS" ]; then
  for EVENT in SessionStart UserPromptSubmit PermissionRequest PostToolUse Stop SessionEnd; do
    if jq --arg e "$EVENT" -e \
      '[.hooks[$e][]?.hooks[]?.command] | any(startswith("agent-state hook"))' \
      "$CLAUDE_SETTINGS" &>/dev/null; then
      continue
    fi
    jq --arg e "$EVENT" \
      '.hooks[$e] = ((.hooks[$e] // []) + [{"hooks": [{"type": "command", "command": "agent-state hook claude"}]}])' \
      "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp" && mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"
  done
fi

# Codex: install the same agent status hooks in its native hooks file.
CODEX_HOOKS="$HOME/.codex/hooks.json"
if command -v jq &>/dev/null; then
  mkdir -p "$HOME/.codex"
  [ -f "$CODEX_HOOKS" ] || printf '{"hooks": {}}\n' > "$CODEX_HOOKS"
  for EVENT in SessionStart UserPromptSubmit PermissionRequest PostToolUse Stop SessionEnd; do
    if jq --arg e "$EVENT" -e \
      '[.hooks[$e][]?.hooks[]?.command] | any(. == "agent-state hook codex")' \
      "$CODEX_HOOKS" &>/dev/null; then
      continue
    fi
    jq --arg e "$EVENT" \
      '.hooks[$e] = ((.hooks[$e] // []) + [{"hooks": [{"type": "command", "command": "agent-state hook codex", "timeout": 3}]}])' \
      "$CODEX_HOOKS" > "$CODEX_HOOKS.tmp" &&
      mv "$CODEX_HOOKS.tmp" "$CODEX_HOOKS"
  done
fi

