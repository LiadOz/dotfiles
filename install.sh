#!/bin/bash
git submodule update --init --recursive

chmod u+x binaries/.local/bin/*
stow binaries gdb nvim tmux zsh
SOURCE_STR="source $HOME/.zsh_global.sh"
ZSH_FILE="$HOME/.zshrc"
grep -q "$SOURCE_STR" "$ZSH_FILE" || echo "$SOURCE_STR" >> "$ZSH_FILE"
