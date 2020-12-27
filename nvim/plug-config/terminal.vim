" function! OpenTerminal()
"   " move to right most buffer
"   execute "normal \<C-l>"
"   execute "normal \<C-l>"
"   execute "normal \<C-l>"
"   execute "normal \<C-l>"

"   let bufNum = bufnr("%")
"   let bufType = getbufvar(bufNum, "&buftype", "not found")

"   if bufType == "terminal"
"     " close existing terminal
"     execute "q"
"   else
"     " open terminal
"     execute "vsp term://zsh"

"     " turn off numbers
"     execute "set nonu"
"     execute "set nornu"

"     " toggle insert on enter/exit
"     silent au BufLeave <buffer> stopinsert!
"     silent au BufWinEnter,WinEnter <buffer> startinsert!

"     " set maps inside terminal buffer
"     execute "tnoremap <buffer> <C-h> <C-\\><C-n><C-w><C-h>"
"     execute "tnoremap <buffer> <C-t> <C-\\><C-n>:q<CR>"
"     execute "tnoremap <buffer> <C-\\><C-\\> <C-\\><C-n>"

"     startinsert!
"   endif
" endfunction

" Abrir terminal con Ctrl+t
" nnoremap <C-t> :call OpenTerminal()<CR>

" Función para abrir el terminal
function! OpenTerminal()
  let buf_num = bufnr('%')
  let buf_type = getbufvar(buf_num, '&buftype', 'not found')

  if buf_type == 'terminal'
    execute 'q'
  else
    let terminal_height = winheight(0) / 4

    execute terminal_height"sp term://zsh"

    execute "set nonu"
    execute "set nornu"
    execute "set nocursorline"

    execute "set signcolumn=no"

    silent au BufLeave <buffer> stopinsert!
    silent au BufWinEnter,WinEnter <buffer> startinsert!

    execute "tnoremap <buffer> <C-w><Up> <C-\\><C-n><C-w><C-k>"
    execute "tnoremap <buffer> <C-t> <C-\\><C-n>:q<CR>"
    execute "tnoremap <buffer> <C-n> <C-\\><C-n>"
    execute "tnoremap <buffer> <C-\\><C-\\> <C-\\><C-n>"

    execute "setlocal nobuflisted"

    startinsert!
  endif
endfunction

" Cerrar terminal inmediatamente (sin mostrar código de salida)
augroup terminal_settings
  autocmd!

  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert

  autocmd TermClose term://*
    \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
    \   call nvim_input('<CR>') |
    \ endif
augroup END
