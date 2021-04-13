let mapleader=" "

" testing
nnoremap <Leader>t :TestNearest<CR>
nnoremap <Leader>T :TestFile<CR>
nnoremap <Leader>TT :TestSuite<CR>

" format
nnoremap <Leader>> 10<C-w>>
nnoremap <Leader>< 10<C-w><

" quick
nnoremap <Leader>; $a;<Esc>
nnoremap <Leader>, $a,<Esc>
inoremap LL <Esc>la
inoremap HH <Esc>ha

" Exit
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>z :q!<CR>

" TAB in general mode will move to next buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go to prev buffer
nnoremap <S-TAB> :bprevious<CR>

" faster scrolling
nnoremap <silent> <C-e> }
nnoremap <silent> <C-y> {

" Prettier
" command! -nargs=0 Prettier :CocCommand prettier.formatFile
" noremap <C-s> :Autoformat<CR>

nnoremap <Leader>G :G<cr>
nnoremap <Leader>gp :Gpush<cr>
nnoremap <Leader>gl :Gpull<cr>

" NodeJs
nnoremap <Leader>x :!node %<cr>
" Deno
nnoremap <Leader>X :!deno run %<cr>

" Esc
:inoremap ii <Esc>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Move selected line / block of text in visual mode
" alt + k to move up
" alt + j to move down
nnoremap <M-k> :m .-2<CR>==
nnoremap <M-j> :m .+1<CR>==
vnoremap <M-k> :move '<-2<CR>gv-gv
vnoremap <M-j> :move '>+1<CR>gv-gv

" Use directional arrows to resize windows
nnoremap <M-K> :resize -2<CR>
nnoremap <M-J> :resize +2<CR>
nnoremap <M-H> :vertical resize -2<CR>
nnoremap <M-L> :vertical resize +2<CR>

" Close current buffer
nnoremap <C-b> :bd<CR>

" RunCode-Python
nnoremap <Leader>p :!python3 %<cr>

" Prettier
nmap <leader>P :CocCommand prettier.formatFile<cr>

" Reload
nnoremap <M-r> :source %<cr>
