" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set backup		" keep a backup file (restore to previous version)
set undofile		" keep an undo file (undo changes after closing)

set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

filetype off

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
    set mouse=vnh
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

"set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz,ЁЭЖЪХ;\|\":}{,ъх;][,ЮБ;><,ю.,б\,,"№%:\,.\;;@#$%^&*,ё\\,э',ж\;,
" Позволяет работать с обычными переключениями клавиатуры. Уже привык к
" С-Пробел
let &langmap='йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;qwertyuiop[]asdfghjkl\;' . "'" . 'zxcvbnm\,.QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>,' . '№#,Ё|,ё\\'
set lbr

set keymap=russian-jcukenwin 
set iminsert=0
set imsearch=0
set iskeyword=@,48-57,_,192-255
set sw=4
set softtabstop=4
set expandtab
set fileencodings=utf-8,cp1251,koi8-r,cp866   "for linux

let g:solarized_italic=0    "default value is 1

set foldmethod=indent
set colorcolumn=80
set nu
set statusline=%<%t%h%m%r\ \ %a\ %{strftime(\"%c\")}%=0x%B\ line:%l,\ \ col:%c%V\ %P
let g:LargeFile=50
filetype plugin indent on

"let g:flake8_ignore = "E126,E128,E701,F403"
"let g:syntastic_python_flake8_quiet_messages = { "level": [],
"            \ "type": "",
"            \ "regex": [], 
"            \ "file": []}
"
"E101,E111,E12,E13,E2,E3,E4,E5,E7,W,F4,F81

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

set wildmenu
set laststatus=2
set backspace=indent,eol,start
set complete-=i
set showmatch
set smarttab

set nrformats-=octal
set shiftround

set ttimeout
set ttimeoutlen=50

" Make Y consistent with C and D.  See :help Y.
nnoremap Y y$

set autoread
"set autowriteall 
set history=1000

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
" Only in Linux
if has("unix")
    "set gfn=Terminus:h12:cRUSSIAN
    set bdir=~/tmp/vimbackups
    set undodir=~/tmp/vimbackups
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
    set iminsert=0
    set imsearch=0
   " if !has("gui_running")
   "     let g:solarized_termcolors=256
   "     colo lucario
   " endif
endif


" ========================================================================
" Common mappings

map <DOWN> gj
map <UP> gk
imap <UP> <ESC>gki
imap <DOWN> <ESC>gji
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nmap <Leader>\\ :resize<CR>:vertical resize 85<CR>
nmap <Leader>\ :resize 50<CR>:vertical resize 85<CR>
nnoremap <C-L> <C-W>l
noremap <Leader>s <ESC>:syntax sync fromstart<CR>
inoremap <Leader>s <C-o>:syntax sync fromstart<CR>
" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F10>
nnoremap <Leader>r :nohl<CR>:SyntasticReset<CR>:redraw!<CR>
nnoremap <silent> <Leader>t :TagbarToggle<CR>
noremap <Leader>n <ESC>:NERDTreeFind<CR>
noremap <Leader>N <ESC>:NERDTreeClose<CR>
noremap <Leader>h <ESC>:call NERDTreeHorizontal()<CR>
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

command IndentXML syn clear |%s/></>\r</g |exec "normal gg=G" |syn on

" =========================================================================
" Common funcs

function Flake8testCritical()
    let l:oldignore = g:flake8_ignore
    let g:flake8_ignore = "E101,E111,E12,E13,E2,E3,E4,E5,E7,W,F4,F81"
    call Flake8('')
    let g:flake8_ignore = l:oldignore
endfunction

let g:ycm_show_diagnostics_ui = 0
command ToggleYCMAutoSpell call ToggleYCMAutoSpell()
function! ToggleYCMAutoSpell()
    if (g:ycm_show_diagnostics_ui)
        let g:ycm_show_diagnostics_ui = 0
        echo "Its off"
    else
        let g:ycm_show_diagnostics_ui = 1
        echo "Its on"
    endif
endfunction

"autocmd BufWritePost *.py call Flake8testCritical()

function NERDTreeHorizontal()
    NERDTree " open NERDTree
    wincmd J " move NERDTree to the very bottom
    resize 15
endfunction

function ToggleKeymap()
    if &iminsert
        set iminsert=0
    else
        set iminsert=1
    endif
endfunction

