ZSH_THEME="robbyrussell"
# plugins=(
#     git
#     fzf
#     tmux
#     vi-mode
# )
echo " ..|''||   |'''''||   ..|''||   '|.   '|' |'''''||   ..|''||   '|.   '|'  ..|''||  "
echo ".|'    ||      .|'   .|'    ||   |'|   |      .|'   .|'    ||   |'|   |  .|'    || "
echo "||      ||    ||     ||      ||  | '|. |     ||     ||      ||  | '|. |  ||      ||"
echo "'|.     ||  .|'      '|.     ||  |   |||   .|'      '|.     ||  |   |||  '|.     ||"
echo " ''|...|'  ||......|  ''|...|'  .|.   '|  ||......|  ''|...|'  .|.   '|   ''|...|' "


# for emacs gui
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1
alias emacs="setsid emacs"
