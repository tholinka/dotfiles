" set up vim-plug plugins
"" Git wrapper
Plug 'tpope/vim-fugitive'

"" NERD tree
Plug 'scrooloose/nerdtree'
"" Add support for git to NERD tree
Plug 'Xuyuanp/nerdtree-git-plugin'

" handle "surroundings", e.g. parentheses, brackets, etc.
Plug 'tpope/vim-surround'

" syntax checker
Plug 'scrooloose/syntastic'

" good statusline
Plug 'vim-airline/vim-airline'
" theme for statusline
Plug 'vim-airline/vim-airline-themes'

" handles comments
Plug 'scrooloose/nerdcommenter'

" use editorconfig
Plug 'editorconfig/editorconfig-vim'

" fuzzy finder
Plug 'junegunn/fzf'

" allow multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Monokai theme
Plug 'sickill/vim-monokai'

" JSON handler
Plug 'elzr/vim-json'

" Arm syntax handler
Plug 'arm9/arm-syntax-vim'

" completion
if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif
"" set deoplete to start at startup
let g:deoplete#enable_at_startup = 1

" plugins setup end
call plug#end()

" source plugins
"autocmd source %
" install plugins
"autocmd PlugInstall

" custom settings
colorscheme monokai

" vim-airline color settings
let g:airline_theme='base16_monokai'

" don't switch to visual mode on mouseclick
set mouse-=a

" set up arm syntax
au BufNewFile,BufRead *.s,*.S set filetype=arm " arm = armv6/7

" set up json syntax
au! BufRead,BufNewFile *.json set filetype=json
"" set up json indentation
augroup json_autocmd
	autocmd!
	autocmd FileType json set autoindent
	autocmd FileType json set formatoptions=tcq2l
	autocmd FileType json set textwidth=78 shiftwidth=2
	autocmd FileType json set softtabstop=2 tabstop=8
	autocmd FileType json set expandtab
	autocmd FileType json set foldmethod=syntax
augroup END

syntax enable

" add git status to statusline
"" handled by vim-airline
"set statusline+=%{FugitiveStatusline()}

" set up syntastic
"" handled by vim-airline
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" set up NERD commenter
"" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
"" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
"" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
"" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
"" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" set up editorconfig
"" don't mess with fugitive
"let g:EditorConfig_exclude_patterns = ['fugitive://.*']
"" don't load files over ssh
"let g:EditorConfig_exclude_patterns = ['scp://.*']
"" above two combined
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" open NERD tree if opened without arguments
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" open NERD tree if directory specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" close vim if NERD tree is the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
