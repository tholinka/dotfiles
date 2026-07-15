# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

# this is copied directly from install.sh for zinit
source "$ZSH_CONFIG/zinit/zinit.zsh"
autoload -Uz _zinit

# start zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
#end install.sh section from zinit

# we want light and lucid added if not debugging
_ZLOAD_NON_DEBUG="lucid light-mode "
# Load these things immediatly
# we construct this in a way that the values of the variables are ran at run time, so we can change the "wait" on the fly
alias _zload="zinit blockf $_ZLOAD_NON_DEBUG"'depth"1" from"github"'

# https://github.com/zdharma-continuum/zinit/discussions/651#discussioncomment-11442498
_fix-omz-plugin() {
    [[ -f ./._zinit/teleid ]] || return 1
    local teleid="$(<./._zinit/teleid)"
    local pluginid
    for pluginid (${teleid#OMZ::plugins/} ${teleid#OMZP::}) {
        [[ $pluginid != $teleid ]] && break
    }
    (($?)) && return 1
    print "Fixing $teleid..."
    git clone --quiet --no-checkout --depth=1 --filter=tree:0 https://github.com/ohmyzsh/ohmyzsh
    cd ./ohmyzsh
    git sparse-checkout set --no-cone /plugins/$pluginid
    git checkout --quiet
    cd ..
    local file
    for file (./ohmyzsh/plugins/$pluginid/*~(.gitignore|*.plugin.zsh)(D)) {
        print "Copying ${file:t}..."
        cp -R $file ./${file:t}
    }
    rm -rf ./ohmyzsh
}

# Create cache and completions dir and add to $fpath
# some of the completions require this as the location they store their completions (e.g. flux)
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)$ZSH_CACHE_DIR/completions]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# oh-my-zsh plugins
_zload atpull"%atclone" atclone"_fix-omz-plugin" for \
wait"0c" OMZ::"plugins/command-not-found" \
wait"0c" if"(( $+commands[gradle] ))" OMZ::"plugins/gradle" \
wait"0b" if"(( $+_MAC ))" OMZ::"plugins/macos" \
wait"0b" if"(( $+commands[git] ))" OMZ::"plugins/git" \
wait"0b" if"(( $+commands[kubectl] ))" OMZ::"plugins/kubectl" \
wait"0b" if"(( $+commands[flux] ))" OMZ::"plugins/fluxcd" \
wait"0b" if"(( $+commands[mise] ))" OMZ::"plugins/mise"

# we use these annex's to load others
_zload for \
zdharma-continuum/zinit-annex-patch-dl \
zdharma-continuum/zinit-annex-bin-gem-node

### Theme note: if there is a "wait" present, it will fail to load on first prompt
### and will instead load after a command is entered
## Get theme from my fork
#_zload for "tholinka/agnoster-zsh-theme"
## Powerlevel10k
_zload for romkatv/powerlevel10k
# load full prompt
zinit ice $_ZLOAD_NON_DEBUG
zinit snippet "$ZSH_CONFIG/plugins/powerlevel10k.plugin.zshrc"

# other plugins (defer as much as possible to hopefully improve load times)
## git prompt info
#_zload wait"0a" for"tombh/zsh-git-prompt" # my theme handles this
## don't run anything pasted until I manually hit enter key
# _zload wait"0a" for "oz/safe-paste"
## additional syntax highlighting, zsh completions, command suggestion
_zload wait"0c" for \
atinit"ZINIT[COMPINIT_OPTS]=-C; zicdreplay" zdharma-continuum/fast-syntax-highlighting \
zsh-users/zsh-completions \
atload"!_zsh_autosuggest_start; _zsh_autosuggest_bind_widgets" zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
## 256color
#ZSH_256COLOR_DEBUG=true
_zload wait"0a" for "chrissicool/zsh-256color"

## automatically change terminal title based on location / task
_zload wait"0c" for "jreese/zsh-titles"
# note: if these fail to clone, try running the ice and load manually
# Only load these if the relevant program is installed
## adds clipboard helper functions to pipe into/out of clipboard
_zload wait"0c" if"(( $+commands[xclip] ))" for "zpm-zsh/clipboard"
## docker autocomplete
_zload wait"0c" if"(( $+commands[docker] ))" pick"contrib/completion/zsh/_docker" for "docker/cli"
## git flow
_zload wait"0c" if"git flow version &>/dev/null" for "petervanderdoes/git-flow-completion"
## python virtual environment
_zload wait"0c" if"(( $+commands[python] )) || (( $+commands[python3] ))" for "MichaelAquilina/zsh-autoswitch-virtualenv"

# zinit packages
zinit blockf $_ZLOAD_NON_DEBUG wait"0b" pack for dircolors-material

# shell history sync - ctrl-r history search
zinit blockf $_ZLOAD_NON_DEBUG \
	bpick"atuin-(X86_64|aarch64)*.tar.gz" \
	mv"atuin*/atuin -> atuin" \
	atclone"mkdir -p $ZPFX/bin && ./atuin init zsh --disable-up-arrow > key-bindings.zsh && ./atuin gen-completions --shell zsh > _atuin" \
	atpull"%atclone" \
	from"gh-r" \
	id-as"atuinsh/atuin" \
	nocompile \
	pick'/dev/null' \
	sbin'atuin' \
	src'key-bindings.zsh' \
	for atuinsh/atuin

# if this is jetbrains, we want a seperate author (for e.g. intellij copilot plugin)
if [[ $TERMINAL_EMULATOR == "JetBrains-JediTerm" ]]; then
	export ATUIN_HISTORY_AUTHOR="jetbrains"
fi

# FZF, hotkeys: ctrl-t file/dir search, alt-c dir search + cd
# add bin-gem-node entries to PATH. Only needed on the very first time, after that bgn auto sets this
# also, only add fzf on the very first run, or we get warnings about duplicate plugins
if ! [[ "$PATH" =~ "$ZPFX/bin" ]]; then
	zinit blockf $_ZLOAD_NON_DEBUG wait"1" pack"bgn-binary+keys" for fzf
	export PATH="$ZPFX/bin:$PATH"
fi
