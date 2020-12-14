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
" set nowrap
set encoding=utf-8
set fileencoding=utf-8
set ruler
set mouse=a
set cursorline
set splitbelow
set splitright
set background=dark
set autochdir
set sw=2
set showmatch
set noshowmode
set autoindent smartindent
set clipboard=unnamedplus
syntax enable
filetype on
filetype indent on
filetype plugin on

let g:ale_disable_lsp = 1

so ~/.vim/coc.vim
so ~/.vim/plugins.vim
so ~/.vim/maps.vim
so ~/.vim/themes/gruvbox.vim
so ~/.vim/plugin-config.vim

colorscheme gruvbox
" let g:gruvbox_contrast_dark = "hard"
let g:deoplete#enable_at_startup = 1
let g:jsx_ext_required = 0
let g:formatterpath = ['/some/path/to/a/folder', '/home/superman/formatters']
highlight Normal ctermbg=NONE

" Javascript
autocmd BufRead *.js set filetype=javascript.jsx
autocmd BufRead *.jsx set filetype=javascript.jsx
augroup filetype javascript syntax=javascript

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
