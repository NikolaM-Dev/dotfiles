" Remap escape
nnoremap <C-c> <Esc>
inoremap ii <Esc>
inoremap kj <Esc>
inoremap jj <Esc>
inoremap kk <Esc>

" Use alt + hjkl to resize windows
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

nnoremap <C-b> :bd<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Move selected line / block of text in visual mode
" shift + k to move up
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv
nmap <Leader>s <Plug>(easymotion-s2)

" shift + j to move down
if !exists('g:vscode')
    " TAB in general mode will move to next buffer
    nnoremap <TAB> :bnext<CR>
    " SHIFT-TAB will go to prev buffer
    nnoremap <S-TAB> :bprevious<CR>
endif
