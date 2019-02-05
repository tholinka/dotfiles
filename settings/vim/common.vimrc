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
" zsh completion for deoplete
Plug 'zchee/deoplete-zsh'

" plugins setup end
call plug#end()

" source plugins
"autocmd source %
" install plugins
"autocmd PlugInstall

" don't switch to visual mode on mouseclick
set mouse-=a

" General configs
"" set lines of history to remember
set history=500
"" enable filetype plugin
filetype plugin on
filetype indent on
"" read when a file is changed on the outside
set autoread
"" With a map leader it's possible to do extra key combinations
"" like <leader>w saves the current file
let mapleader = ","
"" Fast saving
nmap <leader>w :w!<cr>
"" :W sudo saves the file
"" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" UI setup
"" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim
""Turn on Wild menu
set wildmenu
""Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
	set wildignore+=.git\*,.hg\*,.svn\*
else
	set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
"" always show current position
set ruler
"" Set buffer to hidden when it's abandoned
set hid
"" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
"" Ignore case when searching
set ignorecase
"" Try to be smart about case when searching
set smartcase
"" Highlight search results
set hlsearch
"" Makes search act like modern browsers
set incsearch
"" don't redraw while executing macros (good for performance)
set lazyredraw
"" enable regex
set magic
"" show matching brackets when text indicator is over them
set showmatch
"" How often to blink (in tenths of a sec) when matching brackets
set mat=2
"" disable sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
""" and for mac
if has("gui_macvim")
	autocmd GUIEnter * set vb t_vb=
endif

" Colors and fonts
"" Enable syntax highlighting
syntax enable
"" enable 256 colors in gnome-terminal
if $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif

"" set up colors
try
	colorscheme monokai
	" vim-airline color settings
	let g:airline_theme='base16_monokai'
catch
endtry

set background=dark
"" extra options when in gui mode
if has ("gui_running")
	set guioptions-=T
	set guioptions-=e
	set t_Co=256
	set guitablabel=%M\ %t
endif
"" set up default encoding and lagnuage
set encoding=utf8
""default to unix style
set ffs=unix,dos,mac

" Files
"" turn off backup, stuff is in git anyway normally
set nobackup
set nowb
set noswapfile

" Tab vs spaces
"" use tabs not spaces
set noexpandtab
"" use smartab
set smarttab
"" 1 tab = 4 spaces by default
set shiftwidth=4
set tabstop=4
"" line break at 500 characters
set lbr
set tw=500
"" auto indent, smart indent, wrap lines
set ai
set si
set wrap

" Statusline
"" always show it
set laststatus=2
"" everything else is handled by airline

" Mapping changes
"" remap VIM 0 to non-blank
map 0 ^
"" move a line of text using alt+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
"" handle mac mappings
if has("mac") || has("macunix")
	nmap <D-j> <M-j>
	nmap <D-k> <M-k>
	vmap <D-j> <M-j>
	vmap <D-k> <M-k>
endif

" delete whitespace on save
fun! CleanExtraSpaces()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	silent! %s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfun
if has("autocmd")
	autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" spell checking
"" ,ss will toggle/untoggle spellcheck
map <leader>ss :setlocal spell!<cr>

" MISC
"" Fix encoding messup on windows
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
"" turn on persistent undo
try
	set undodir=~/.cache/vim/undodir
	set undofile
catch
endtry

" set up syntastic
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

" source filetype info
source ~/.vim/filetypes.vimrc
