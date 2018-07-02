FUNCTIONS_FILE_LOC="${(%):-%N}" # hacky workaround to replace bash's export

# following ~4 functions attempt to let you do a git command on multiple subdirs - easy enough, but then it also tries to color errors, which is a bit harder
function color_err()
{
    # Execute command
    "$@" 2> >(while read line; do echo -e "\e[01;31m$line\e[0m" | tee --append $TMP_ERRS; done)
    EXIT_CODE=$?

    # Finish
    return $EXIT_CODE
}

function git_step()
{
    # $1 is directory
    echoAble="$1: $(color_err git -C $1 ${@:2})"
    echo "$echoAble"

    return 0
}

function gitsubdirs()
{
    command ls -R --directory --color=never */.git | sed 's/\/.git//'
}

function gitall()
{
    git_step . pull
    gitsubdirs |
     xargs -P10 -I{} zsh -c "source $FUNCTIONS_FILE_LOC ; git_step {} pull"; # hacky workaround to get around the fact that zsh doesn't have export -f
}

function gitcheckall()
{
    if [ -z "$1" ]; then
        branch="master"
    else
        branch="$1"
    fi

    git_step . checkout $branch
    gitsubdirs |
     xargs -P10 -I{} zsh -c "source $FUNCTIONS_FILE_LOC ; git_step {} checkout $branch"; # see gitall for hacky workaround reason
}

# grep wrapper (even though it's called findhere) that does grep --include "..." --exclude "..." -Rnwi . -e "[pattern]" in an easy function of findhere [pattern] [exclude] [include]
function findhere()
{
    # echo "findhere pattern exclude include e.g. findhere \"hello world\" \"*.o\" \"*.{c,h}\""
    if [ -z "$2" ]; then
        exclude=""
    else
        exclude="--exclude=\"$2\ "
    fi

    if [ -z "$3" ]; then
        include=""
    else
        include="--include=$3"
    fi

    echo "searching for \"$1\" with include of \"$2\" and exclude of \"$3\""

    grep $include $exclude -Rnwi . -e $1 || echo "nothing found"
}

# from https://stackoverflow.com/a/14728706
function git-gc-all()
{
    git reflog expire --expire-unreachable=now --all

    git -c gc.reflogExpire=0 -c gc.reflogExpireUnreachable=0 -c gc.rerereresolved=0 \
    -c gc.rerereunresolved=0 -c gc.pruneExpire=now gc "$@"
}
