echo "This installs this repository into the home directory."
echo "Do you wish to run the script? "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) return 0;;
    esac
done
INSTALL_DIR=~/test_dotfiles


git submodule update --init --recursive
mkdir -p "$INSTALL_DIR/.config"
link_strings=(".config/pudb" ".config/nvim" ".emacs.d" ".gdbinit" ".spacemacs" ".tmux.conf" ".vim" ".zsh_defaults.sh")
for link_name in ${link_strings[@]}; do
	link_path="$PWD/$link_name"
	if [ ! -e $link_path ]; then
		echo "$link_path not found!"
		continue
	fi
	ln -fs $link_path "$INSTALL_DIR/$link_name"
done

# zsh extra setup
echo "Adding zsh defaults should be executed only once and after oh-my-zsh in installed"
echo "Proceed with adding zsh defaults? "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) return 0;;
    esac
done
echo "source $PWD/.zsh_defaults.sh" >> "$INSTALL_DIR/.zshrc"
