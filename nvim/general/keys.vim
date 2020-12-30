let mapleader=" "

" testing
nnoremap <Leader>t :TestNearest<CR>
nnoremap <Leader>T :TestFile<CR>
nnoremap <Leader>TT :TestSuite<CR>

" split resize
nnoremap <Leader>> 10<C-w>>
nnoremap <Leader>< 10<C-w><

" quick semi
nnoremap <Leader>; $a;<Esc>
nnoremap <Leader>, $a,<Esc>
inoremap LL <Esc>la
inoremap HH <Esc>ha

" Exit
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <leader>z :wq<CR>

"CoC
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" plugs
map <Leader>n :NERDTreeFind<CR>
map <Leader>f :Files<CR>

" diagnostics
nnoremap <Leader>dia  :<C-u>CocList diagnostics<CR>
nnoremap <leader>kp :let @*=expand("%")<CR>

" tabs navigation
map <Leader>h :tabprevious<CR>
map <Leader>l :tabnext<CR>

" TAB in general mode will move to next buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go to prev buffer
nnoremap <S-TAB> :bprevious<CR>

" buffers
map <Leader>b :Buffers<cr>

" faster scrolling
nnoremap <silent> <C-e> 10<C-e>
nnoremap <silent> <C-y> 10<C-y>

nmap <Leader>s <Plug>(easymotion-s2)

" Comment code
nnoremap <space>/ :Commentary<CR>
vnoremap <space>/ :Commentary<CR>

" Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
noremap <C-s> :Autoformat<CR>

nnoremap <Leader>G :G<cr>
nnoremap <Leader>gp :Gpush<cr>
nnoremap <Leader>gl :Gpull<cr>

" NodeJs
nnoremap <Leader>x :!node %<cr>

" Esc
:inoremap jk <Esc>
:inoremap kj <Esc>
:inoremap jj <Esc>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Move selected line / block of text in visual mode
" shift + k to move up
" shift + j to move down
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Use alt + hjkl to resize windows
nnoremap <M-k> :resize -2<CR>
nnoremap <M-j> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

" Close current buffer
nnoremap <C-b> :bd<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Open Terminal
set splitright
nnoremap <C-t> :call OpenTerminal()<CR>

" Trim white spaces
nmap <leader>t :call TrimWhitespace()<CR>

" Ale
" nmap <leader>p :ALEFix<CR>

" RunCode-Python
nnoremap <Leader>P :!python3 %<cr>

" Prettier
nmap <C-p> :CocCommand prettier.formatFile<cr>
