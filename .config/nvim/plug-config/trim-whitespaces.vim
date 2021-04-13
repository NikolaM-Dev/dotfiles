" Trim Whitespaces
function! TrimWhitespace()
  let l:save = winsaveview()
  %s/\\\@<!\s\+$//e
  call winrestview(l:save)
endfunction

autocmd BufWritePre * call TrimWhitespace()

" Trim white spaces
nmap <M-t> :call TrimWhitespace()<CR>
