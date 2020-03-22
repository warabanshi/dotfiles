if v:progname =~? "evim"
  finish
endif

set nocompatible
set backspace=indent,eol,start

if has("vms")
  set nobackup
else
  set backup
endif
set history=50
set ruler
set showcmd
set incsearch

map Q gq

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("autocmd")
  filetype plugin indent on
  augroup vimrcEx
  au!
  autocmd FileType text setlocal textwidth=78
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") | 
    \   exe "normal g`\"" |
    \ endif
  augroup END
else
  set autoindent
endif " has("autocmd")

if has ('iconv')
  set fileencodings&
  set fileencodings+=utf8
  set fileencodings+=ucs-2le,ucs-2
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp-3'

  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  let &fileencodings = &fileencodings.','.s:enc_jis.',utf-8'
  if &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    set fileencodings=+cp932
    let &encoding = s:enc_euc
  else
    let &fileencodings = &fileencodings.','.s:enc_euc
  endif

  unlet s:enc_euc
  unlet s:enc_jis
endif

colorscheme torte
set fenc=utf-8
set nu
set ts=4 sw=4
set expandtab
set fileformats=unix,dos,mac
set nobackup
set smartindent
set noswapfile

autocmd BufRead,BufNewFile *.py setfiletype python
autocmd BufRead,BufNewFile *.rb setfiletype ruby

"
" for syntastic (https://github.com/scrooloose/syntastic)
"
execute pathogen#infect()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"
" end syntastic
"
