call plug#begin('~/.config/nvim/plugged')

    " syntax
    Plug 'sheerun/vim-polyglot'
    " Plug 'HerringtonDarkholme/yats.vim'
    " Plug 'yuezk/vim-js'
    " Plug 'flowtype/vim-flow'
    " Plug 'yuezk/vim-js'
    " Plug 'maxmellon/vim-jsx-pretty'

    " javascript & typescript
    Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }
    Plug 'styled-components/vim-styled-components', { 'branch': 'main', 'for': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx']}
    Plug 'peitalin/vim-jsx-typescript', { 'for': ['typescript.tsx'] }
    Plug 'jparise/vim-graphql'        " GraphQL syntax

    " rainbow_parentheses
    " Plug 'kien/rainbow_parentheses.vim'
    Plug 'luochen1990/rainbow'

    " markdown
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

    " CSS3
    Plug 'norcalli/nvim-colorizer.lua'
    " Plug 'hail2u/vim-css3-syntax'

    " Python
    Plug 'dense-analysis/ale'
    Plug 'Vimjas/vim-python-pep8-indent'

   "Golang
    " Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

    " status bar
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " Snippets
    " Plug 'honza/vim-snippets'
    Plug 'sirver/ultisnips'

    " Themes
    Plug 'phanviet/vim-monokai-pro'
    Plug 'morhetz/gruvbox'
    Plug 'sainnhe/gruvbox-material'
    Plug 'joshdick/onedark.vim'
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'lifepillar/gruvbox8'
    Plug 'haishanh/night-owl.vim'
    Plug 'dunstontc/vim-vscode-theme'
    Plug 'glepnir/oceanic-material'
    Plug 'kaicataldo/material.vim', { 'branch': 'main' }
    Plug 'ayu-theme/ayu-vim'

    " Trees
    " Chadtree
    " Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

    " NERDTree
    " Plug 'preservim/nerdtree'
    " " git-nerdtree
    " Plug 'Xuyuanp/nerdtree-git-plugin'
    " " seccions
    " " Plug 'scrooloose/nerdtree-project-plugin'
    " " Multi selection
    " Plug 'PhilRunninger/nerdtree-visual-selection'

    " Fern
    " Plug 'lambdalisue/fern.vim'
    " Plug 'lambdalisue/nerdfont.vim'
    " Plug 'lambdalisue/glyph-palette.vim'
    " " Plug 'lambdalisue/fern-git-status.vim'
    " Plug 'antoinemadec/FixCursorHold.nvim'
    " Plug 'lambdalisue/fern-renderer-nerdfont.vim'

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
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'easymotion/vim-easymotion'
    Plug 'mhinz/vim-signify'
    Plug 'yggdroot/indentline'

    " Comment code
    Plug 'tpope/vim-commentary'

    " Prettier
    Plug 'prettier/vim-prettier', { 'do': 'yarn install'  }
    " Plug 'Chiel92/vim-autoformat'

    " git
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-repeat'

    " Intellisense
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Automatically clear search highlights after you move your cursor.
    Plug 'haya14busa/is.vim'

    " Better display unwanted whitespace.
    " Plug 'ntpeters/vim-better-whitespace'
call plug#end()
