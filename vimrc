" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set backup		" keep a backup file (restore to previous version)
set undofile		" keep an undo file (undo changes after closing)

set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

filetype off            " need to be off before Vundle

"=====================================================
" Vundle settings
"=====================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

    Plugin 'gmarik/Vundle.vim'		" let Vundle manage Vundle, required

    "---------=== Code/project navigation ===-------------
    Plugin 'scrooloose/nerdtree' 	    	" Project and file navigation
    Plugin 'majutsushi/tagbar'          	" Class/module browser

    "------------------=== Other ===----------------------
    Plugin 'bling/vim-airline'   	    	" Lean & mean status/tabline for vim
    Plugin 'fisadev/FixedTaskList.vim'  	" Pending tasks list
    Plugin 'rosenfeld/conque-term'      	" Consoles as buffers
    Plugin 'tpope/vim-surround'	   	" Parentheses, brackets, quotes, XML tags, and more
    Plugin 'altercation/vim-colors-solarized' " Solarized colorscheme
    Plugin 'nathanaelkane/vim-indent-guides.git'    "Indent guides in vim

    "--------------=== Snippets support ===---------------
    "Plugin 'MarcWeber/vim-addon-mw-utils'	" dependencies #1
    "Plugin 'tomtom/tlib_vim'		" dependencies #2
    "Plugin 'garbas/vim-snipmate'		" Snippets manager
    Plugin 'SirVer/ultisnips'               " Unltra snippet manager compatible with YCM
    Plugin 'honza/vim-snippets'		" snippets repo

    "---------------=== Languages support ===-------------
    "---- General ---
    Plugin 'scrooloose/syntastic.git'       "Syntax checking tool for a lot of langs
    Plugin 'Valloric/YouCompleteMe'         "  C/C++/Objective-C and Python code completion

    " --- Python ---
    Plugin 'hynek/vim-python-pep8-indent'   "modifies vim_’s indentation behavior to comply with PEP8
    "Plugin 'klen/python-mode'	        " Python mode (docs, refactor, lints, highlighting, run and ipdb and more)
    "Plugin 'davidhalter/jedi-vim' 		" Jedi-vim autocomplete plugin
    "Plugin 'mitsuhiko/vim-jinja'		" Jinja support for vim
    "Plugin 'mitsuhiko/vim-python-combined'  " Combined Python 2/3 for Vim


    " --- HTML/CSS -----
    Plugin 'mattn/emmet-vim'                "Emmet aka ZEN-coding
    Plugin 'skammer/vim-css-color'
    Plugin 'hail2u/vim-css3-syntax'
    Plugin 'groenewege/vim-less'            " syntax highlighting, indenting and autocompletion for LESS

    " --- Javascript ---
    "Plugin 'pangloss/vim-javascript'        "this bundle provides syntax and indent plugins for js
    Plugin 'jelera/vim-javascript-syntax'   " Enhanced JavaScript Syntax for Vim
    Plugin 'marijnh/tern_for_vim'           "js autocomplete basic
    Plugin 'othree/javascript-libraries-syntax.vim' "Js autocomplete libs (jQuery)

call vundle#end()            		" required


"execute pathogen#infect()

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    " set mouse=a
    set mouse=vnh "use mouse for everything except in insert mode
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the default
        " position when opening a file.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

else

    set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif
" =======================================================================

"--------------------------------- UltSnip
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:snips_author="Artem Putilov"

"-------------------------- YCM -------------
let g:ycm_confirm_extra_conf = 0

"--------- tema ------------------

" Позволяет работать с обычными переключениями клавиатуры.
let &langmap='йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;qwertyuiop[]asdfghjkl\;' . "'" . 'zxcvbnm\,.QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>,' . '№#,Ё|,ё\\'
set lbr

" Добавляет собственное переключение (С-Пробел)
set keymap=russian-jcukenwin
set sw=4
set softtabstop=4
set expandtab
set fileencodings=utf-8,cp1251,koi8-r,cp866   "for linux

" let g:solarized_italic=0    "default value is 1

set foldmethod=indent
set colorcolumn=80
set nu
set statusline=%<%t%h%m%r\ \ %a\ %{strftime(\"%c\")}%=0x%B\ line:%l,\ \ col:%c%V\ %P
" filetype plugin indent on

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_

" Disable error bells
set noerrorbells

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
set laststatus=2  " always show status line
" Allow backspace in insert mode
set backspace=indent,eol,start
" Show matching bracket
set showmatch
" Expand tabs (fill with spaces) only at the begining of line
set smarttab
" Show the filename in the window titlebar
set title
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Always indent to multiple of sw
set shiftround
" Add the g flag to search/replace by default
set gdefault
"
" Make Y consistent with C and D.  See :help Y. Y yanks from cursor to the
" end of line. Like C and D
nnoremap Y y$

" Reload file changed outside vim
set autoread
set history=1000

" change the bg according to the time of day
if strftime("%H")+0 > 16 || strftime("%H")+0 < 6
    "dark supposed to be here
    set background=dark
else
    set background=light
endif

"
" =======================================================================
" Only in MS Windows
if has("win32")
    set gfn=Terminus:h12:cRUSSIAN
    source $HOME/vimfiles/mymswin.vim  " Load standart windows hotkeys
    set fileencodings=ucs-bom,utf-8,cp1251,koi8-r,cp866
    set encoding=utf-8
    " set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    setglobal bomb
    set bdir=$VIM\\backups,.,c:\\tmp,c:\\temp
    set undodir=$VIM\\backups,.,c:\\tmp,c:\\temp
    set dir=c:\\tmp,c:\\temp,.,
    colorscheme vividchalk


    " only in gui (in win)
    if has("gui_running")
        colorscheme solarized
        set guioptions=egmt
        set lines=55
        set columns=150
        imap <C-Space> 
        cmap <C-Space> 
    else
        set bg=dark "only dark if not in gui
    endif
endif "win32 only =======================================================

" =======================================================================
" Only in Linux and mac
if has("unix")
    "set gfn=Terminus:h12:cRUSSIAN
    " Centralize backups, swapfiles and undo history
    set backupdir=~/.vim/backups
    set directory=~/.vim/swaps
    if exists("&undodir")
            set undodir=~/.vim/undo
    endif

    " Don’t create backups when editing files in certain directories
    set backupskip=/tmp/*,/private/tmp/*,~/tmp/*

    colorscheme solarized
    if &term =~ '^xterm'
        " solid underscore
        let &t_SI .= "\<Esc>[4 q"
        " solid block
        let &t_EI .= "\<Esc>[2 q"
        " 1 or 0 -> blinking block
        " 3 -> blinking underscore
        " Recent versions of xterm (282 or above) also support
        " 5 -> blinking vertical bar
        " 6 -> solid vertical bar
    endif
    set t_Co=16
endif "linux only =======================================================

"========================================
"only on mac not on macvim
if has("mac")
    set keymap=russian-jcukenmac
   " if !has("gui_running")
   "     let g:solarized_termcolors=256
   "     colo lucario
   " endif
endif

" default langmap off in normal and search (= default english)
set iminsert=0
set imsearch=0
"
" Change mapleader
let mapleader=","

" ========================================================================
" Common mappings

    " Save a file as root (,W)
    noremap <leader>W :w !sudo tee % > /dev/null<CR>
    map <DOWN> gj
    map <UP> gk
    imap <UP> <ESC>gki
    imap <DOWN> <ESC>gji
    nnoremap <C-H> <C-W>h
    nnoremap <C-J> <C-W>j
    nnoremap <C-K> <C-W>k
    nnoremap <C-L> <C-W>l
    noremap <Leader>s <ESC>:syntax sync fromstart<CR> :nohl<CR>:SyntasticReset<CR>:redraw!<CR>
    inoremap <Leader>s <C-o>:syntax sync fromstart<CR>
    " Use <F10> to toggle between 'paste' and 'nopaste'
    set pastetoggle=<F10>
    nnoremap <silent> <Leader>t :TagbarToggle<CR>
    noremap <Leader>n <ESC>:NERDTreeFind<CR>
    noremap <Leader>N <ESC>:NERDTreeClose<CR>
    imap <C-@> 
    cmap <C-@> 
    nmap <silent> <C-@> :call ToggleKeymap()<CR>
    imap <C-Space> 
    cmap <C-Space> 
    nmap <silent> <C-Space> :call ToggleKeymap()<CR>
    let g:NERDTreeMapJumpNextSibling=''
    let g:NERDTreeMapJumpPrevSibling=''

" mappings end ============================================================

" =========================================================================
" YCM settings
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_key_invoke_completion = '<leader>c'
" User commands ===========================================================

command! IndentXML syn clear |%s/></>\r</g |exec "normal gg=G" |syn on
command! ToggleYCMAutoSpell call ToggleYCMAutoSpell()
command! StripWhitespace call StripWhitespace()

" =========================================================================
" Common funcs

function! Flake8testCritical()
    let l:oldignore = g:flake8_ignore
    let g:flake8_ignore = "E101,E111,E12,E13,E2,E3,E4,E5,E7,W,F4,F81"
    call Flake8('')
    let g:flake8_ignore = l:oldignore
endfunction

let g:ycm_show_diagnostics_ui = 0
function! ToggleYCMAutoSpell()
    if (g:ycm_show_diagnostics_ui)
        let g:ycm_show_diagnostics_ui = 0
        echo "Its off"
    else
        let g:ycm_show_diagnostics_ui = 1
        echo "Its on"
    endif
endfunction


function! ToggleKeymap()
    if &iminsert
        set iminsert=0
    else
        set iminsert=1
    endif
endfunction


" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
