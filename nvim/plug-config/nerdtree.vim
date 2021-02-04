"  nerdtree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeShowLineNumbers=1
let NERDTreeMapOpenInTab='\t'
let g:NERDTreeIgnore = ['.git$', 'node_modules']
let g:javascript_plugin_flow = 1
" let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:webdevicons_enable_nerdtree = 0
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif

map <Leader>n :NERDTreeFind<CR>
