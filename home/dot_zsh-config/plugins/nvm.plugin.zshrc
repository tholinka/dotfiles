# set NVM location, unless already set
[[ -v NVM_DIR ]] || NVM_DIR="$HOME/.nvm"

# set version of nvm to use, only if it's not set
# because this is set, assuming that nvm is used nowhere in zshrc's, it can be redefined locally to switch the version (in ~/.zsh_local)
# without having to affect the version saved in git
## commented out, set locally if needed
#if [ -z ${NVM_USE_VERSION+x} ]; then
#    NVM_USE_VERSION="4.5.0"
#fi

# see if nvm is installed
if [[ -r $NVM_DIR/nvm.sh ]]; then
	NVM_SCRIPT_LOC="$NVM_DIR/nvm.sh";
elif  [[ -r /usr/local/opt/nvm/nvm.sh ]]; then
	NVM_SCRIPT_LOC="/usr/local/opt/nvm/nvm.sh"
fi

if [[ -v NVM_SCRIPT_LOC ]]; then
	# if it is, define a function to load it when needed, only do it when needed because it takes forever
	if ! (( $+commands[nvm] )) &> /dev/null ; then
		function _nvm_wrapper_source() {
			unset -f nvm
			unset -f node
			unset -f npm
			unset -f npx
			source "$NVM_SCRIPT_LOC"
			[[ -v NVM_USE_VERSION ]] && nvm use "v$NVM_USE_VERSION" 1> /dev/null
			unset -f _nvm_wrapper_source
		}
		function nvm() {
			_nvm_wrapper_source
			nvm "$@"
		}
		function node() {
			_nvm_wrapper_source
			node "$@"
		}
		function npm() {
			_nvm_wrapper_source
			npm "$@"
		}
		function npx() {
			_nvm_wrapper_source
			npx "$@"
		}
	fi
fi
