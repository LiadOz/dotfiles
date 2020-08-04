# export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe"
ZSH_THEME="robbyrussell"
plugins=(
    git
    fzf
    tmux
    vi-mode
)
echo " ..|''||   |'''''||   ..|''||   '|.   '|' |'''''||   ..|''||   '|.   '|'  ..|''||  "
echo ".|'    ||      .|'   .|'    ||   |'|   |      .|'   .|'    ||   |'|   |  .|'    || "
echo "||      ||    ||     ||      ||  | '|. |     ||     ||      ||  | '|. |  ||      ||"
echo "'|.     ||  .|'      '|.     ||  |   |||   .|'      '|.     ||  |   |||  '|.     ||"
echo " ''|...|'  ||......|  ''|...|'  .|.   '|  ||......|  ''|...|'  .|.   '|   ''|...|' "

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# for emacs gui
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1
alias emacs="setsid emacs"
source .user_defaults.sh
