
[[ -v _ZINIT_USE_SVN ]] || [[ -v ACK_NO_SVN ]] || echo "No svn installed, can fallback without it, but might want to install it.  To ignore this message, and not display it in the future, install svn, or add ACK_NO_SVN=y to your .zsh-local.zshrc"

[[ -v _ZINIT_USING_MODULE ]] || [[ -v ACK_NO_ZINIT_MODULE ]] || echo "zinit module not built. Build with \"cd ~/.local/share/zinit/module && git remote add aloxaf https://github.com/Aloxaf/zinit-module.git && git fetch aloxaf && git checkout -t aloxaf/fix_zsh_5.8.1 && cd - && zinit module build\". To ignore this message, and not display it in the future, run the build command, or add ACK_NO_ZINIT_MODULE=y to your .zsh-local.zshrc"
