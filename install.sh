#!/bin/bash
git submodule update --init --recursive
git submodule update --remote --merge
git submodule foreach --recursive git checkout master

chmod u+x binaries/.local/bin/*
stow binaries gdb nvim tmux zsh colordiff
SOURCE_STR="source $HOME/.zsh_global.sh"
ZSH_FILE="$HOME/.zshrc"
grep -q "$SOURCE_STR" "$ZSH_FILE" || echo "$SOURCE_STR" >> "$ZSH_FILE"
SOURCE_STR="export PATH=\"\$PATH:\${HOME}/.local/bin\""
grep -q "$SOURCE_STR" "$ZSH_FILE" || echo "$SOURCE_STR" >> "$ZSH_FILE"
