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
map <Leader>ag :Ag<CR>

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

nnoremap <Leader>x :!node %<cr>
:imap jj <Esc>

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

set splitright
function! OpenTerminal()
  " move to right most buffer
  execute "normal \<C-l>"
  execute "normal \<C-l>"
  execute "normal \<C-l>"
  execute "normal \<C-l>"

  let bufNum = bufnr("%")
  let bufType = getbufvar(bufNum, "&buftype", "not found")

  if bufType == "terminal"
    " close existing terminal
    execute "q"
  else
    " open terminal
    execute "vsp term://zsh"

    " turn off numbers
    execute "set nonu"
    execute "set nornu"

    " toggle insert on enter/exit
    silent au BufLeave <buffer> stopinsert!
    silent au BufWinEnter,WinEnter <buffer> startinsert!

    " set maps inside terminal buffer
    execute "tnoremap <buffer> <C-h> <C-\\><C-n><C-w><C-h>"
    execute "tnoremap <buffer> <C-t> <C-\\><C-n>:q<CR>"
    execute "tnoremap <buffer> <C-\\><C-\\> <C-\\><C-n>"

    startinsert!
  endif
endfunction

nnoremap <C-t> :call OpenTerminal()<CR>

nmap <leader>t :call TrimWhitespace()<CR>
