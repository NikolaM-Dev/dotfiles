" Disables autocommenting on new line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Comment code
nnoremap <leader>/ :Commentary<CR>
vnoremap <leader>/ :Commentary<CR>
