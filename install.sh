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
# One package at a time: `stow a b c` is atomic, so a single conflict aborts
# every package and nothing at all gets installed.
#
# --no-folding keeps target directories real instead of letting stow replace
# one with a symlink into this repo. That is what lets ~/.local/bin and
# ~/.codex stay yours, holding machine-specific links alongside the ones
# this repo provides, on every machine.
for PKG in binaries gdb nvim tmux zsh colordiff task agents numen systemd; do
  if stow --no-folding "$PKG" 2>/tmp/stow-$PKG.err; then
    echo "stow: $PKG"
  else
    echo "stow: $PKG SKIPPED"
    sed 's/^/  /' /tmp/stow-$PKG.err
  fi
  rm -f /tmp/stow-$PKG.err
done
# taskwarrior errors on an include it cannot read, so guarantee the file
# exists. Secrets live here and never in the tracked taskrc.
TASKRC_LOCAL="$HOME/.config/task/taskrc.local"
[ -f "$TASKRC_LOCAL" ] || : > "$TASKRC_LOCAL"
chmod 600 "$TASKRC_LOCAL"

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

# Spoken notifications: say out loud when an agent is blocked on you or has
# finished, naming the session so you can tell several agents apart by ear.
# Needs the kokoro-tts service above; agent-say is silent if it is not running.
#
# Only the two events worth interrupting you for. Adding UserPromptSubmit or
# PostToolUse here would narrate every tool call.
if command -v jq &>/dev/null; then
  for EVENT in PermissionRequest Stop; do
    for TARGET in "claude:$CLAUDE_SETTINGS" "codex:$CODEX_HOOKS"; do
      KIND=${TARGET%%:*}
      FILE=${TARGET#*:}
      [ -f "$FILE" ] || continue
      if jq --arg e "$EVENT" --arg c "agent-say hook $KIND" -e \
        '[.hooks[$e][]?.hooks[]?.command] | any(. == $c)' "$FILE" &>/dev/null; then
        continue
      fi
      jq --arg e "$EVENT" --arg c "agent-say hook $KIND" \
        '.hooks[$e] = ((.hooks[$e] // []) + [{"hooks": [{"type": "command", "command": $c, "timeout": 5}]}])' \
        "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"
    done
  done
fi

# Speech is two user units: the server that synthesises, and the daemon that
# reads the spool aloud. Both survive a reboot; enabling is a no-op once done.
if [ -d "$HOME/.local/share/kokoro-fastapi" ]; then
  systemctl --user daemon-reload
  systemctl --user enable --now kokoro-tts.service agent-say.service &>/dev/null &&
    echo "kokoro-tts, agent-say: enabled"
  # Without this the units die when you log out, which is exactly when you
  # most want an agent to be able to shout.
  loginctl enable-linger "$USER" &>/dev/null
fi

# Numen itself is installed user-locally because Ubuntu does not package it.
# Once its runtime is present, keep whole-machine voice commands available.
if [ -x "$HOME/.local/libexec/numen/numen" ]; then
  "$HOME/.local/bin/numen-tune-model"
  systemctl --user daemon-reload
  systemctl --user enable --now voice-echo-cancel.service numen.service &>/dev/null &&
    echo "voice echo cancellation, numen: enabled"
fi
