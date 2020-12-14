call plug#begin('~/.vim/plugged')

" syntax
Plug 'sheerun/vim-polyglot'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'flowtype/vim-flow'
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'norcalli/nvim-colorizer.lua'

" Python
Plug 'dense-analysis/ale'
Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'psf/black', { 'branch': 'stable' }

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Themes
Plug 'morhetz/gruvbox'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'joshdick/onedark.vim'

" Tree
Plug 'scrooloose/nerdtree'

" typing
Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'

" tmux
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'

" Icons
Plug 'ryanoasis/vim-devicons'

" autocomplete
Plug 'sirver/ultisnips'

" test
Plug 'tyewang/vimux-jest-test'
Plug 'janko-m/vim-test'

" IDE
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'mhinz/vim-signify'
Plug 'yggdroot/indentline'
Plug 'scrooloose/nerdcommenter'

" Prettier
Plug 'prettier/vim-prettier', { 'do': 'yarn install'  }
Plug 'Chiel92/vim-autoformat'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

" Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Comment code
Plug 'tpope/vim-commentary'

" Automatically clear search highlights after you move your cursor.
Plug 'haya14busa/is.vim'

" Better display unwanted whitespace.
Plug 'ntpeters/vim-better-whitespace'

call plug#end()
