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
export LIBGL_ALWAYS_INDIRECT=1
alias emacs="setsid emacs"
alias python=python3
alias pt="python -m unittest"
export FLASK_ENV=development
alias rser=flask run --host=0.0.0.0
