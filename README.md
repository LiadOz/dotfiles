# Dotfiles

Personal shell, editor, tmux, Taskwarrior, and global agent preferences. The
files are deployed by the separate
[Agent Toolkit](https://github.com/LiadOz/agent-toolkit) repository as regular
files—not directory links into this checkout.

## Prerequisites

- Clone this repository to `~/dotfiles`.
- Clone Agent Toolkit to `~/projects/agent-toolkit`.
- Have Git and `jq` on Linux.
- Have one of: Ansible Core 2.21.2, `uvx`, `pipx`, or Python 3.12+ with `venv`.

The bootstrap does not use `sudo`. It installs pinned fzf and Bun binaries in
the current user's home when the selected profile needs them. The
`primary-linux` voice profile additionally expects its existing local Kokoro
and TTS runtimes; remote workers and macOS do not install or start that audio
stack.

## Install

Choose the machine profile and inspect the changes first:

```sh
cd ~/projects/agent-toolkit
./bootstrap --profile primary-linux --check --diff
./bootstrap --profile primary-linux
./bootstrap --profile primary-linux --check --diff
```

Use `remote-worker` on TLV, farm, or build machines and `mac` on macOS. Put the
profile name in `workstation-config/.workstation-profile` to avoid passing it
on every run; that file is ignored by Git.

For a machine that still has directories folded into `~/dotfiles` by GNU Stow,
run the guarded one-time migration before the normal install:

```sh
./bootstrap --profile primary-linux --migrate-stow --check --diff
./bootstrap --profile primary-linux --migrate-stow
./bootstrap --profile primary-linux
```

## Repository boundary

This repository contains only personal configuration. Agent voice programs,
the talk skill, ccmux, the tmux agent extension, provisioning, and machine
profiles live in Agent Toolkit. Downloads, models, environments, caches,
runtime state, and secrets belong in machine-local locations.

Taskwarrior reads `~/.config/task/taskrc.local`; Ansible creates it with mode
`0600` but never tracks its contents. Existing redirects such as a
scratch-backed `~/.codex` are preserved, with only named files installed below
them.
