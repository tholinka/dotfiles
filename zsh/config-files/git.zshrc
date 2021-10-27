alias get="git"
alias gitk="gitk &>/dev/null &"
alias gitgui="git gui &>/dev/null &"

alias gitupdatesubmodules="git submodule update --jobs _PROCESSORS --recursive --remote"

# alias to list all commits since newest tag
alias glotags="git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'' --date=short' \$(git describe --tags | cut -d'-' -f1)..HEAD"

# from https://stackoverflow.com/a/14728706
function git-gc-all()
{
	git reflog expire --expire-unreachable=now --all

	git -c gc.reflogExpire=0 -c gc.reflogExpireUnreachable=now -c gc.rerereResolved=0 -c gc.rerereUnresolved=0 -c gc.worktreePruneExpire=now -c gc.pruneExpire=now gc --prune=now --aggressive "$@"
}
