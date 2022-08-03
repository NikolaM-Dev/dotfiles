let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:_fzf_file_preview_options = '--ansi --preview "bat --theme="gruvbox-material" --style full --decorations always --color always {}"'
let g:_fzf_find_preview_options = '--delimiter : --nth 4..' . ' ' . g:_fzf_file_preview_options
let g:_fzf_preview_size = 'down:80%'

function! Fuzzy_Files()
    call fzf#vim#files('', fzf#vim#with_preview({ 'options': g:_fzf_file_preview_options}, g:_fzf_preview_size))
endfunction

function! Fuzzy_Find()
  call fzf#vim#ag('', fzf#vim#with_preview({'options': g:_fzf_find_preview_options }, g:_fzf_preview_size))
endfunction

let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'FzfBackground'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'FzfBackground'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-b': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': {lines -> setreg('*', join(lines, "\n"))}}

" finder files
nnoremap <leader>f :call Fuzzy_Files()<cr>
" finder global
nnoremap <leader>a :call Fuzzy_Find()<cr>
" Rg
nnoremap <leader>rg :Rg<cr>
" buffers
map <Leader>b :Buffers<cr>
" Search for lines
nnoremap <Leader>l :BLines<cr>
