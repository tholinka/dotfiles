# set NVM location, unless already set
[[ -v NVM_LOCATION ]] || NVM_LOCATION="$HOME/.nvm"

# set version of nvm to use, only if it's not set
# because this is set, assuming that nvm is used nowhere in zshrc's, it can be redefined locally to switch the version (in ~/.zsh_local)
# without having to affect the version saved in git
## commented out, set locally if needed
#if [ -z ${NVM_USE_VERSION+x} ]; then
#    NVM_USE_VERSION="4.5.0"
#fi

# see if nvm is installed
if [[ -r $NVM_LOCATION/nvm.sh ]]; then
	# if it is, define a function to load it when needed, only do it when needed because it takes forever
	if ! (( $+commands[nvm] )) &> /dev/null ; then
		function nvm() {
			source  "$NVM_LOCATION/nvm.sh"
			[[ -v NVM_USE_VERSION ]] && nvm use "v$NVM_USE_VERSION" 1> /dev/null
			nvm "$@"
		}
	fi
fi
