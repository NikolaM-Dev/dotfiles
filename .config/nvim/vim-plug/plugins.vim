call plug#begin('~/.config/nvim/plugged')

" syntax
Plug 'sheerun/vim-polyglot'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'yuezk/vim-js'
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim' " TypeScript syntax
" Plug 'flowtype/vim-flow'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'        " GraphQL syntax

" CSS3
Plug 'norcalli/nvim-colorizer.lua'
Plug 'hail2u/vim-css3-syntax'

" Python
Plug 'dense-analysis/ale'
Plug 'Vimjas/vim-python-pep8-indent'

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Snippets
Plug 'honza/vim-snippets'
Plug 'sirver/ultisnips'

" Themes
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'lifepillar/gruvbox8'
Plug 'haishanh/night-owl.vim'
Plug 'dunstontc/vim-vscode-theme'
Plug 'glepnir/oceanic-material'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }

" Trees
" Chadtree
" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

" NERDTree
" Plug 'scrooloose/nerdtree'
" Plug 'PhilRunninger/nerdtree-visual-selection'
" Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'

" Fern
" Plug 'lambdalisue/fern.vim'
" Plug 'antoinemadec/FixCursorHold.nvim'
" Plug 'lambdalisue/fern-renderer-nerdfont.vim'
" Plug 'lambdalisue/nerdfont.vim'
" Plug 'lambdalisue/glyph-palette.vim'

" Icons
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" typing
Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'

" tmux
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'

" test
Plug 'tyewang/vimux-jest-test'
Plug 'janko-m/vim-test'

" IDE
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', " { 'do': { -> fzf#install() } }
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
