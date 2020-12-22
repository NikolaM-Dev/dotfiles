" Python
let python_highlight_all=1

" ALE
let g:ale_linters = {
  \'python': ['flake8'],
  \'javascript': ['eslint']
  \}

" \'javascript': ['eslint']
let g:ale_fixers = {'python': ['black', 'isort']}
let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '

let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
" let g:ale_fix_on_save = 1

function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? '✨ all good ✨' : printf(
        \   '😞 %dW %dE',
        \   all_non_errors,
        \   all_errors
        \)
endfunction

set statusline=
set statusline+=%m
set statusline+=\ %f
set statusline+=%=
set statusline+=\ %{LinterStatus()}
