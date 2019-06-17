psgrep() {
    ps auxww | grep -i "$1"
}
export -f psgrep

alias fixres="xrandr --newmode \"1920x1080\"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync && xrandr --addmode Virtual1 1920x1080 && xrandr --output Virtual1 --mode 1920x1080"

alias c="clear"
alias get="git"
alias aptupdateall="sudo apt update ; sudo apt upgrade -y ; sudo apt dist-upgrade -y"
alias gitk="gitk &>/dev/null & "
alias gitgui="git gui &>/dev/null &"

function findhere()
{
    # echo "findhere pattern exclude include e.g. findhere \"hello world\" \"*.o\" \"*.{c,h}\""
    if [ -z "$2" ]; then
        exclude=""
    else
        exclude="--exclude=$2 "
    fi

    if [ -z "$3" ]; then
        include=""
    else
        include="--include=$3 "
    fi

    echo "searching for \"$1\" with include of \"$2\" and exclude of \"$3\""

    grep "$include""$exclude"-Rnwi . -e \""$1"\" || echo "nothing found"
}
export -f findhere
