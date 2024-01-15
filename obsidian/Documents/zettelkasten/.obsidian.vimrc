" Better up/down
nmap j gj
nmap k gk

" Togge fold
exmap togglefold obcommand editor:toggle-fold
nmap zo :togglefold
nmap zc :togglefold
nmap za :togglefold

" Unfold all
exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall

" Fold all
exmap foldall obcommand editor:fold-all
nmap zM :foldall

" system clipboard
set clipboard=unnamed

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back

exmap forward obcommand app:go-forward
nmap <C-i> :forward

unmap <Space>

exmap open_switcher obcommand switcher:open
nmap <Space>ff :open_switcher

exmap follow_link obcommand editor:follow-link
nmap gd :follow_link

" better scrolling and searching with centered always
noremap <c-d> <C-d>zz
noremap <c-u> <C-u>zz
noremap <n> nzzzv
noremap <N> Nzzzv

" NOTE: to show all obsidian commands, put in the obsidian console :obcomand
