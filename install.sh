#!/bin/bash
echo "This installs this repository into the home directory."
echo "Do you wish to run the script? "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done
INSTALL_DIR=~


git submodule update --init --recursive
mkdir -p "$INSTALL_DIR/.config"
link_strings=(".config/pudb" ".config/nvim" ".emacs.d" ".gdbinit" ".spacemacs" ".tmux.conf" ".vim" ".zsh_defaults.sh")
for link_name in ${link_strings[@]}; do
	link_path="$PWD/$link_name"
	if [ ! -e $link_path ]; then
		echo "$link_path not found!"
		continue
	fi
	PREV=""
	FOLDER=""
	# Parse path
	IFS="/" read -ra FILE_PATH <<< "$link_name"
	for CURR in "${FILE_PATH[@]}"; do
		if [ -n "$PREV" ]; then
			if [ -n "$FOLDER" ]; then
				FOLDER="$FOLDER/$PREV"
			else
				FOLDER="$PREV"
			fi
		fi
		PREV="$CURR"
	done
	ln -fvs $link_path "$INSTALL_DIR/$FOLDER"
done

# zsh extra setup
echo "Adding zsh defaults should be executed only once and after oh-my-zsh in installed"
echo "Proceed with adding zsh defaults? "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done
echo "source $PWD/.zsh_defaults.sh" >> "$INSTALL_DIR/.zshrc"
