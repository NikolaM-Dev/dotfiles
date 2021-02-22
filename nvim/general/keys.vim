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

"CoC
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" diagnostics
nnoremap <Leader>dia  :<C-u>CocList diagnostics<CR>
nnoremap <leader>kp :let @*=expand("%")<CR>

" TAB in general mode will move to next buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go to prev buffer
nnoremap <S-TAB> :bprevious<CR>

" buffers
map <Leader>b :Buffers<cr>
map <Leader>f :Files<CR>
noremap <C-f> :CocSearch

" faster scrolling
nnoremap <silent> <C-e> 10<C-e>
nnoremap <silent> <C-y> 10<C-y>

nmap <Leader>s <Plug>(easymotion-s2)

" Comment code
nnoremap <C-/> gcap
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
nnoremap <Leader>X :!deno run %<cr>

" Esc
:inoremap ii <Esc>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Move selected line / block of text in visual mode
" shift + k to move up
" shift + j to move down
nnoremap K :m .-2<CR>==
nnoremap J :m .+1<CR>==
vnoremap K :move '<-2<CR>gv-gv
vnoremap J :move '>+1<CR>gv-gv

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
nmap <M-t> :call TrimWhitespace()<CR>

" Ale
" nmap <leader>p :ALEFix<CR>

" RunCode-Python
nnoremap <Leader>P :!python3 %<cr>

" Prettier
nmap <leader>p :CocCommand prettier.formatFile<cr>

" Search for lines
nnoremap <Leader>l :BLines<cr>

" Reload
nnoremap <M-r> :source ~/.config/nvim/init.vim<cr>
