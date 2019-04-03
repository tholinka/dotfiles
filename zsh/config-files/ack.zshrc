
[[ -v _ZPLUGIN_USE_SVN ]] || [[ -v ACK_NO_SVN ]] || echo "No svn installed, can fallback without it, but might want to install it.  To ignore this message, and not display it in the future, install svn, or add ACK_NO_SVN=y to your .zsh-local.zshrc"

[[ -v _ZPLUGIN_USING_MODULE ]] || [[ -v ACK_NO_ZPLUGIN_MODULE ]] || echo "zplugin module not built.  Build with \"zplugin module build\".  To ignore this message, and not display it in the future, run the build command, or add ACK_NO_ZPLUGIN_MODULE=y to your .zsh-local.zshrc"
