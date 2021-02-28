let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\ }


" Disable netrw.
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

function! AuCocNvimInit()
    if @% == '' || @% == '.'
      exe ':CocCommand explorer'
    endif
endfunction

augroup MyCocExplorer
  autocmd!
  " set window status line
  autocmd FileType coc-explorer setl statusline=File-Explorer
  "quit explorer whein it's the last
  autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
  " Make sure nothing opened in coc-explorer buffer
  autocmd BufEnter * if bufname('#') =~# "\[coc-explorer\]-." && winnr('$') > 1 | b# | endif
  "open if directory specified or if buffer empty
  autocmd User CocNvimInit call AuCocNvimInit()
  " cd after open
  autocmd User CocExplorerOpenPost let dir = getcwd() | call CocActionAsync("runCommand", "explorer.doAction", "closest", {"name": "cd", "args": [dir]})
augroup END

nnoremap <leader>n :CocCommand explorer<CR>
