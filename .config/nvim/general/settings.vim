if !exists('g:vscode')
    let g:mapleader = "\<Space>"
endif

set number relativenumber
set colorcolumn=81
set laststatus=0
set smartindent
set autoindent
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set showtabline=4
set formatoptions-=cro
set hidden
set encoding=utf-8
set fileencoding=utf-8
set ruler
set mouse=a
set cursorline
set splitbelow
set splitright
set background=dark
set sw=2
set showmatch
set noshowmode
set autoindent smartindent
set clipboard=unnamedplus
set noswapfile
set nobackup
set nowb
" highlight Normal ctermbg=NONE

" wrapping / line length
set linebreak
set wrap
autocmd VimResized * | set columns=80
set textwidth=80
set colorcolumn=+1

syntax on
filetype on
filetype indent on
filetype plugin on

" Javascript
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
" autocmd BufRead *.js set filetype=javascript.jsx
" autocmd BufRead *.jsx set filetype=javascript.jsx
" augroup filetype javascript syntax=javascript

" Searching;
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" python
let g:python_host_prog  = '/usr/bin/python3.9'
