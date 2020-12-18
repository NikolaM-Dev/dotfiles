let g:coc_global_extensions = [
      \ 'coc-snippets',
      \ 'coc-pairs',
      \ 'coc-tsserver',
      \ 'coc-eslint',
      \ 'coc-emmet',
      \ 'coc-json',
      \ 'coc-discord-neovim',
      \ 'coc-marketplace',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-sql'
      \]

autocmd FileType python let b:coc_suggest_disable = 1
autocmd FileType javascript let b:coc_suggest_disable = 1
autocmd FileType scss setl iskeyword+=@-@
