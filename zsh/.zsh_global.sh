RED='\033[0;31m'
echo $RED
echo " ██████╗ ███████╗ ██████╗ ███╗   ██╗███████╗ ██████╗ ███████╗██╗  ██╗"
echo "██╔═══██╗╚══███╔╝██╔═══██╗████╗  ██║╚══███╔╝██╔═══██╗██╔════╝██║  ██║"
echo "██║   ██║  ███╔╝ ██║   ██║██╔██╗ ██║  ███╔╝ ██║   ██║███████╗███████║"
echo "██║   ██║ ███╔╝  ██║   ██║██║╚██╗██║ ███╔╝  ██║   ██║╚════██║██╔══██║"
echo "╚██████╔╝███████╗╚██████╔╝██║ ╚████║███████╗╚██████╔╝███████║██║  ██║"
echo " ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝"

PATH="$HOME/.local/bin:$PATH"

# GTD stuff (taskwarrior)
if command -v task &> /dev/null && [ -f "$HOME/.config/task/taskrc" ]; then
    alias in='task add +in'
    export PS1='$(c=$(task +in +PENDING count 2>/dev/null); [ "$c" -gt 0 ] && printf "%s " "$c")'"$PS1"
    tickle () {
        deadline=$1
        shift
        in +tickle wait:$deadline $@
    }
    alias tick=tickle
    alias think='tickle +1d'

    taskb() {
        if [ -z "$1" ]; then
            echo "Usage: taskb <task-id>"
            return 1
        fi

        task_id="$1"
        branch=$(git branch --show-current 2>/dev/null)
        if [ -z "$branch" ]; then
            echo "Not inside a Git repo."
            return 1
        fi

        task "$task_id" modify branch:$branch
    }

    wtom () {
        task "$1" modify wait:tomorrow
    }

    wsun () {
        if next_sunday=$(date -d 'next sunday' +%F 2>/dev/null); then
            :
        elif next_sunday=$(date -v+sunday +%F 2>/dev/null); then
            :
        else
            echo "Could not calculate next Sunday with this date command."
            return 1
        fi
        task "$1" modify wait:"$next_sunday"
    }

    wday () {
        task "$1" modify wait:"+${2}d"
    }

    rnext () {
        task "$1" modify -next +review
    }

    notify () {
        task "$1" modify -review +notify
    }
fi
