# Dotfiles

Personal shell, editor, tmux, Taskwarrior, and global agent preferences. The
bootstrap deploys tracked files into real directories and preserves unrelated
machine files and intentional redirects such as a scratch-backed `~/.codex`.

## Prerequisites

- Git
- `jq` on Linux
- One of: Ansible Core 2.21.2, `uvx`, `pipx`, or Python 3.12+ with `venv`

The installation runs entirely as the current user and does not use `sudo`.
Pinned user-space tools are installed automatically. The `primary-linux` voice
profile expects its local Kokoro and TTS runtimes to exist already; the remote
and macOS profiles do not install or start that audio stack.

## Install

From this checkout, inspect the changes, apply them, and verify that the second
run has nothing left to change:

```sh
./bootstrap --profile primary-linux --check --diff
./bootstrap --profile primary-linux
./bootstrap --profile primary-linux --check --diff
```

Use `remote-worker` on remote or build machines and `mac` on macOS. To keep the
selection locally, put just the profile name in `.workstation-profile`; that
file is ignored by Git.

Audio capabilities require an additional ignored `.workstation-local.yml`
safety gate. For example:

```yaml
workstation_allow_voice_playback: true
workstation_allow_desktop_voice: false
```

For a machine that still has directories folded into this checkout by GNU
Stow, run the guarded one-time migration before the normal install:

```sh
./bootstrap --profile primary-linux --migrate-stow --check --diff
./bootstrap --profile primary-linux --migrate-stow
./bootstrap --profile primary-linux
```

## Boundaries

Only personal configuration belongs here. Downloads, models, environments,
caches, runtime state, and secrets stay in machine-local locations.
Taskwarrior's private settings belong in `~/.config/task/taskrc.local`; the
bootstrap creates that file with mode `0600` but never tracks its contents.
